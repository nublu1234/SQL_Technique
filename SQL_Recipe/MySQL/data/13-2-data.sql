CREATE DATABASE IF NOT EXISTS SQL_Recipe;

USE SQL_Recipe;

DROP TABLE IF EXISTS action_log;
CREATE TABLE action_log(
    dt       varchar(255)
  , session  varchar(255)
  , user_id  varchar(255)
  , action   varchar(255)
  , products varchar(255)
  , stamp    varchar(255)
);

INSERT INTO action_log
VALUES
    ('2016-11-03', 'A', 'U001', 'add_cart', '1'    , '2016-11-03 18:00:00')
  , ('2016-11-03', 'A', 'U001', 'add_cart', '2'    , '2016-11-03 18:01:00')
  , ('2016-11-03', 'A', 'U001', 'add_cart', '3'    , '2016-11-03 18:02:00')
  , ('2016-11-03', 'A', 'U001', 'purchase', '1,2,3', '2016-11-03 18:10:00')
  , ('2016-11-03', 'B', 'U002', 'add_cart', '1'    , '2016-11-03 19:00:00')
  , ('2016-11-03', 'B', 'U002', 'purchase', '1'    , '2016-11-03 20:00:00')
  , ('2016-11-03', 'B', 'U002', 'add_cart', '2'    , '2016-11-03 20:30:00')
  , ('2016-11-04', 'C', 'U001', 'add_cart', '4'    , '2016-11-04 12:00:00')
  , ('2016-11-04', 'C', 'U001', 'add_cart', '5'    , '2016-11-04 12:00:00')
  , ('2016-11-04', 'C', 'U001', 'add_cart', '6'    , '2016-11-04 12:00:00')
  , ('2016-11-04', 'D', 'U002', 'purchase', '2'    , '2016-11-04 13:00:00')
  , ('2016-11-04', 'D', 'U001', 'purchase', '5,6'  , '2016-11-04 15:00:00')
;
