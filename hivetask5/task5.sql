ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD FILE ./mapper.sh;

USE suharnikovan;


SELECT TRANSFORM(ip, day, query, page_size, status, browser)
USING './mapper.sh'
FROM Logs
LIMIT 10;

