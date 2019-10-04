CREATE DATABASE IF NOT EXISTS SQL_Recipe;

USE SQL_Recipe;

DROP TABLE IF EXISTS access_log;
CREATE TABLE access_log(
    session  varchar(255)
  , user_id  varchar(255)
  , action   varchar(255)
  , stamp    varchar(255)
);

INSERT INTO access_log
VALUES
    ('98900e', 'U001', 'view', '2016-01-01 18:00:00')
  , ('98900e', 'U001', 'view', '2016-01-02 20:00:00')
  , ('98900e', 'U001', 'view', '2016-01-03 22:00:00')
  , ('1cf768', 'U002', 'view', '2016-01-04 23:00:00')
  , ('1cf768', 'U002', 'view', '2016-01-05 00:30:00')
  , ('1cf768', 'U002', 'view', '2016-01-06 02:30:00')
  , ('87b575', 'U001', 'view', '2016-01-07 03:30:00')
  , ('87b575', 'U001', 'view', '2016-01-08 04:00:00')
  , ('87b575', 'U001', 'view', '2016-01-09 12:00:00')
  , ('eee2b2', 'U002', 'view', '2016-01-10 13:00:00')
  , ('eee2b2', 'U001', 'view', '2016-01-11 15:00:00')
;
