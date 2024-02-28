CREATE EXTERNAL TABLE IF NOT EXISTS fastly_logs (
  host STRING,
  service_id STRING,
  epoch_time_start INT,
  time_start TIMESTAMP,
  time_end TIMESTAMP,
  time_elapsed INT,
  client_ip STRING,
  client_as_name STRING,
  client_as_number STRING,
  client_connection_speed STRING,
  request STRING,
  protocol STRING,
  origin_host STRING,
  url STRING,
  is_ipv6 BOOLEAN,
  is_tls BOOLEAN,
  tls_client_protocol STRING,
  tls_client_servername STRING,
  tls_client_cipher STRING,
  tls_client_cipher_sha STRING,
  tls_client_tlsexts_sha STRING,
  is_h2 BOOLEAN,
  is_h2_push BOOLEAN,
  h2_stream_id STRING,
  request_referer STRING,
  request_user_agent STRING,
  request_accept_content STRING,
  request_accept_language STRING,
  request_accept_encoding STRING,
  request_accept_charset STRING,
  request_connection STRING,
  request_dnt STRING,
  request_forwarded STRING,
  request_via STRING,
  request_cache_control STRING,
  request_x_requested_with STRING,
  request_x_att_device_id STRING,
  request_x_forwarded_for STRING,
  status STRING,
  content_type STRING,
  cache_status STRING,
  is_cacheable BOOLEAN,
  response_age STRING,
  response_cache_control STRING,
  response_expires STRING,
  response_last_modified STRING,
  response_tsv STRING,
  server_datacenter STRING,
  server_ip STRING,
  geo_city STRING,
  geo_country_code STRING,
  geo_continent_code STRING,
  geo_region STRING,
  req_header_size INT,
  req_body_size INT,
  resp_header_size INT,
  resp_body_size INT,
  socket_cwnd INT,
  socket_nexthop STRING,
  socket_tcpi_rcv_mss INT,
  socket_tcpi_snd_mss INT,
  socket_tcpi_rtt INT,
  socket_tcpi_rttvar INT,
  socket_tcpi_rcv_rtt INT,
  socket_tcpi_rcv_space INT,
  socket_tcpi_last_data_sent INT,
  socket_tcpi_total_retrans INT,
  socket_tcpi_delta_retrans INT,
  socket_ploss STRING
)
PARTITIONED BY (
  domain STRING,
  year INT,
  month INT,
  day INT
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION 's3://${bucket-log-location}';