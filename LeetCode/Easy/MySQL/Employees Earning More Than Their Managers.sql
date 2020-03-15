-- # Write your MySQL query statement below


SELECT E.Name Employee
FROM Employee AS E
LEFT JOIN Employee AS ME
ON E.ManagerId = ME.Id
WHERE E.Salary > ME.Salary;