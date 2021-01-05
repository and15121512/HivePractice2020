USE suharnikovan;

SELECT day, count(ip) AS cnt
FROM logs
GROUP BY day
SORT BY cnt DESC;
