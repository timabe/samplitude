#!/bin/bash

# request data
API_KEY=""
SECRET_KEY=""
PREFIX=""
BEGINNING=""
ENDING=""
usage() { echo "Usage: $0 -s <secret key> -a <api key> -b <start date: YYYYMMDD> [-e <end date: YYYYMMDD>]" 1>&2; exit 1; }

while getopts "a:s:b:e:p:" opt; do
    case "$opt" in
        a)  API_KEY=${OPTARG}
            ;;
        s)  SECRET_KEY=${OPTARG}
            ;;
        b)  BEGINNING=${OPTARG}
            ;;
        e)  ENDING=${OPTARG}
            ;;
        p)  PREFIX=${OPTARG}
            ;;
        *)  usage
            ;;
    esac
done
shift $((OPTIND-1))


if [[ -z $API_KEY ]]; then
    usage
fi

if [[ -z $SECRET_KEY ]]; then
    usage
fi

if [[ -z $BEGINNING ]]; then
    usage
fi

if [[ -z $ENDING ]]; then
    ENDING="$(date '+%Y%m%d')T01"
fi

# ask the user if they want to store the data in postgres or just dump it to a file

read -r -p "Store data in Postgres? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    sql_store=1
else
    sql_store=0
fi



# prepare url with the date parameters
AMP_URL="https://amplitude.com/api/2/export?start=${BEGINNING}T0&end=${ENDING}";

if [[ $sql_store -eq 1 ]]; then
    # create postgres table.
    read -p 'Database name : ' dbvar
    read -p 'Database user: ' uservar
    read -p 'Database host (default: "local socket"): ' hostvar
    hostvar=${hostvar:-local socket}
    read -p 'Database port (default: "5432"): ' portvar
    portvar=${portvar:-5432}
    echo "Creating amplitude_json_raw table..."
    psql -f ./create_events_json_table.sql -d $dbvar -U $uservar -h $hostvar -p $portvar
fi

WORKDIR=$(mktemp -d)

cd $WORKDIR
wget $AMP_URL --http-user=${API_KEY} --http-password=${SECRET_KEY} -O results.zip

echo "Working in $WORKDIR..."

echo -n "Unzipping API export results file..."
unzip -oqj results.zip
echo "done unzipping files."

echo -n "Unzipping the gzip'd json files..."
gunzip -qf *.gz

if [[ $sql_store -eq 1 ]]; then
    for f in $WORKDIR/*.json
    do
        echo -n "Processing $f..."
        psql -qc "COPY amplitude_json_raw(DATA) FROM STDIN csv quote e'\x01' delimiter e'\x02' ;" \
        -d $dbvar -U $uservar -h $hostvar -p $portvar < $f
        echo "done."
    done
fi

# remove zip files, keep json
rm *.zip

cd -

# uncomment if you want to flatten out the json in your postgres db.
# edit the file flatten_json.sql to customize your flattened events schema
if [[ $sql_store -eq 1 ]]; then
    echo "Flatting json..."
    psql -f ./flatten_json.sql -d $dbvar -U $uservar -h $hostvar -p $portvar
fi

echo "

                       * *
                     *     *
                    *       *
   ______/ \-.   _*          *   *
.-/     (    o\_//             *
 |  ___  \_/\---'
 |_||  |_|| DONE!



 "

echo "JSON files are stored in $WORKDIR"
if [[ $sql_store -eq 1 ]]; then
    echo "Raw JSON data in the amplitude_json_raw Postgres table \nFlattened data is in the events Postgres table"
fi
