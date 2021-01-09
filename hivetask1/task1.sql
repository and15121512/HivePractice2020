ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-serde.jar;
USE suharnikovan;

DROP TABLE IF EXISTS LogsUnpart;
CREATE TABLE LogsUnpart (
	ip STRING,
	time BIGINT,
	query STRING,
	page_size SMALLINT,
	status SMALLINT,
	browser STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
	"input.regex" = '^(\\S+)\\t\\t\\t(\\d+)\\s+(\\S+)\\s+(\\d+)\\s+(\\d+)\\s+(\\S+).*$'
)
STORED AS TEXTFILE
LOCATION '/data/user_logs/user_logs_M';

SET hive.exec.max.dynamic.partitions=120;
SET hive.exec.max.dynamic.partitions.pernode=120;
SET hive.exec.dynamic.partition.mode=nonstrict;

DROP TABLE IF EXISTS Logs;
CREATE TABLE Logs (
	ip STRING,
	query STRING,
	page_size SMALLINT,
	status SMALLINT,
	browser STRING
)
PARTITIONED BY (day BIGINT);

INSERT OVERWRITE TABLE Logs
PARTITION(day)
SELECT ip, query, page_size, status, browser, REGEXP_EXTRACT(time, '(\\d{8}).*', 1) FROM LogsUnpart;

SELECT * FROM Logs LIMIT 10;
--SHOW PARTITIONS Logs;

DROP TABLE IF EXISTS Users;
CREATE EXTERNAL TABLE Users (
	ip STRING,
	browser STRING,
	sex STRING,
	age TINYINT	
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
	"input.regex" = '^(\\S*)\\s*(\\S*)\\s*(\\S*)\\s*(\\d*).*$'
)
STORED AS TEXTFILE
LOCATION '/data/user_logs/user_data_M';

SELECT * FROM Users LIMIT 10;

DROP TABLE IF EXISTS IPRegions;
CREATE EXTERNAL TABLE IPRegions (
	ip STRING,
	region STRING	
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
	"input.regex" = '^(\\S*)\\s*(\\S*).*$'
)
STORED AS TEXTFILE
LOCATION '/data/user_logs/ip_data_M';

SELECT * FROM IPRegions LIMIT 10;

DROP TABLE IF EXISTS Subnets;
CREATE EXTERNAL TABLE Subnets (
	ip STRING,
	mask STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
	"input.regex" = '^(\\S*)\\s*(\\S*).*$'
)
STORED AS TEXTFILE
LOCATION '/data/subnets/variant1';

SELECT * FROM Subnets LIMIT 10;

