-- adapt this to your desired schema
-- this is based on the schema on
-- https://amplitude.zendesk.com/hc/en-us/articles/205406637-Export-API-Export-Your-App-s-Event-Data


DROP TABLE IF EXISTS events;
CREATE table events AS
SELECT
data->>'app' as app,
data->>'amplitude_id' as amplitude_id,
data->>'user_id' as user_id,
data->>'device_id' as device_id,
data->>'event_time' as event_time,
data->>'server_upload_time' as server_upload_time,
data->>'client_event_time' as client_event_time,
data->>'client_upload_time' as client_upload_time,
data->>'event_id' as event_id,
data->>'session_id' as session_id,
data->>'event_type' as event_type,
data->>'amplitude_event_type' as amplitude_event_type,
data->>'version_name' as version_name,
data->>'schema' as schema,
data->>'adid' as adid,
data->>'groups' as groups,
data->>'idfa' as idfa,
data->>'library' as library,
data->>'processed_time' as processed_time,
data->>'user_creation_time' as user_creation_time,
data->>'platform' as platform,
data->>'os_name' as os_name,
data->>'os_version' as os_version,
data->>'device_brand' as device_brand,
data->>'device_manufacturer' as device_manufacturer,
data->>'device_model' as device_model,
data->>'device_carrier' as device_carrier,
data->>'device_type' as device_type,
data->>'device_family' as device_family,
data->>'location_lat' as location_lat,
data->>'location_lng' as location_lng,
data->>'country' as country,
data->>'language' as language,
data->>'city' as city,
data->>'region' as region,
data->>'dma' as dma,
data->>'revenue' as revenue,
data->>'ip_address' as ip_address,
data->>'paying' as paying,
data->>'start_version' as start_version,
data->>'event_properties' as event_properties,
data->>'user_properties' as user_properties,
data->>'data' as data,
data->>'uuid' as uuid,
data->>'insert_id' as insert_id
FROM amplitude_json_raw
;
