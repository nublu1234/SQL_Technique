-- # Write your MySQL query statement below

SELECT NAME Customers
FROM Customers
WHERE Id NOT IN (SELECT CustomerId FROM Orders);
