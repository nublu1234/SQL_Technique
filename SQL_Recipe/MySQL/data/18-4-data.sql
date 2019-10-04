CREATE DATABASE IF NOT EXISTS SQL_Recipe;

USE SQL_Recipe;

DROP TABLE IF EXISTS action_log_with_ip;
CREATE TABLE action_log_with_ip(
    session  varchar(255)
  , user_id  varchar(255)
  , action   varchar(255)
  , ip       varchar(255)
  , stamp    varchar(255)
);

INSERT INTO action_log_with_ip
VALUES
    ('989004ea', 'U001', 'view', '216.58.220.238', '2016-11-03 18:00:00')
  , ('47db0370', 'U002', 'view', '98.139.183.24' , '2016-11-03 19:00:00')
  , ('1cf7678e', 'U003', 'view', '210.154.149.63', '2016-11-03 20:00:00')
  , ('5eb2e107', 'U004', 'view', '127.0.0.1'     , '2016-11-03 21:00:00')
  , ('fe05e1d8', 'U001', 'view', '216.58.220.238', '2016-11-04 18:00:00')
  , ('87b5725f', 'U005', 'view', '10.0.0.3'      , '2016-11-04 19:00:00')
  , ('5d5b0997', 'U006', 'view', '172.16.0.5'    , '2016-11-04 20:00:00')
  , ('111f2996', 'U007', 'view', '192.168.0.23'  , '2016-11-04 21:00:00')
  , ('3efe001c', 'U008', 'view', '192.0.0.10'    , '2016-11-04 22:00:00')
;
