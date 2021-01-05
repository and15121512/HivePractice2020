USE suharnikovan;

SELECT day, count(ip) AS cnt
FROM Logs
GROUP BY day
SORT BY cnt DESC;
