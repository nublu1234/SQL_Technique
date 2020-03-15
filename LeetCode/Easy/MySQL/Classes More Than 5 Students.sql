-- # Write your MySQL query statement below

# Write your MySQL query statement below

SELECT c.class
FROM (SELECT DISTINCT * FROM courses) AS c
GROUP BY c.class
HAVING COUNT(c.class) >= 5;