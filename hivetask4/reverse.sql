add jar ReverseUDF/target/ReverseUDF-1.0-SNAPSHOT.jar;

USE suharnikovan;

create temporary function reverse as 'com.hobod.app.ReverseUDF';

SELECT reverse(ip)
FROM Subnets
LIMIT 10;
