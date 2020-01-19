/*
Oracle
*/

SELECT f1.x, f1.y
FROM functions f1
INNER JOIN functions f2
    ON f1.x = f2.y
    AND f1.y = f2.x
WHERE f1.x < f1.y
UNION
SELECT x, y
FROM functions
WHERE x = y
GROUP BY x, y
HAVING COUNT(x) > 1
ORDER BY x, y;