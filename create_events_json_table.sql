DROP table if exists amplitude_json_raw;
CREATE TABLE amplitude_json_raw
(
ROW_ID  SERIAL PRIMARY KEY
,DATA  JSON
);
