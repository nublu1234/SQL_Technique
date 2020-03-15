-- # Write your MySQL query statement below

SELECT W1.Id
FROM Weather AS W1
LEFT JOIN (SELECT *, DATE_ADD(RecordDate, INTERVAL 1 DAY) RecordDate_P1 
           FROM Weather) AS W2
ON W1.RecordDate = W2.RecordDate_P1
WHERE W1.Temperature > W2.Temperature;