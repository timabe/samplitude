```
                       * *
                     *     *
                    *       *
   ______/ \-.   _*          *   *
.-/     (    o\_//             *
 |  ___  \_/\---'
 |_||  |_||
```
# samplitude
🔌 Pull Amplitude data into Postgres for fun and profit.

## What is this?
You can use this as a friendly wrapper for the Amplitude data export API, or go all out and load your Amplitude data into your very own Postgres database with all the data nicely flattened out.

## How do I use it?
### Basic
If you just want to suck your data out of amplitude and have the files locally, it's as simple as running

```
sh samplitude.sh -s <secret_key> -a <api_key> -b <start_date: YYYYMMDD>
```
It will ask you if you want to store the data in Postgres. You'll say no.

Once the script finishes, it will tell you the directory where your files are stored

### Standard
You probably want this data in a database, where you can query and analyze it, right?

Run the same command as above, but when it asks you if you want it stored in Postgres, say yes.

Enter the connection information for your database.

**ProTip Create a `.pgpass` file in your home directory with lines of the following format**
```
hostname:port:database:username:password
```
That way you won't get prompted for your password each time. Trust me, you want to do this.

Once the script finishes, it will tell you the directory where your files are stored, as well as the postgres table names that were just created.
