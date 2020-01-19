/*
Oracle
*/

SELECT company_code, founder, 
       (SELECT COUNT(DISTINCT lead_manager_code) FROM lead_manager WHERE company_code = c.company_code) lead_manager_cnt, 
       (SELECT COUNT(DISTINCT senior_manager_code) FROM senior_manager WHERE company_code = c.company_code) senior_manager_cnt, 
       (SELECT COUNT(DISTINCT manager_code) FROM manager WHERE company_code = c.company_code) manager_cnt, 
       (SELECT COUNT(DISTINCT employee_code) FROM employee WHERE company_code = c.company_code) employee_cnt
FROM company c 
ORDER BY company_code;