/*
Oracle
*/
SELECT ROUND(SQRT(X),4)
FROM (SELECT (MAX(LAT_N) - MIN(LAT_N))*(MAX(LAT_N) - MIN(LAT_N))
           + (MAX(LONG_W) - MIN(LONG_W))*(MAX(LONG_W) - MIN(LONG_W)) AS X
      FROM station);
