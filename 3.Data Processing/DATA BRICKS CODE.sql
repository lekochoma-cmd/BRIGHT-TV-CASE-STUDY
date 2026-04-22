---Query 1 Filtering to check data set for Viewership records

SELECT (*)
FROM workspace.default.bright_tv_dataset_update_viewership;

----Query 2 filtering to date range on Viewers data as part of data exploration FROM 01/01/2016 TILL 31/03/2016
----4 MONTHS PERIOD
SELECT MIN(RecordDate2) AS START_DATE,
       MAX(RecordDate2) AS  END_DATE
FROM workspace.default.bright_tv_dataset_update_viewership;

----Querying 3 Filtering to join table User Profile with Viewrship ON userID as Common column LEFT JOIN to gain more information 
SELECT *
FROM workspace.default.bright_tv_dataset_update_viewership AS VP
LEFT JOIN `workspace`.`default`.`bright_tv_dataset_user_p` AS UP
ON VP. UserID0 = UP. UserID;

---Query 4 filtering to change time from UTC to Africa/Johannesburg
 SELECT 
       MIN(from_utc_timestamp(vp.RecordDate2, 'Africa/Johannesburg')) AS Earliest,
       MIN(from_utc_timestamp(vp.RecordDate2, 'Africa/Johannesburg')) AS Latest
FROM workspace.default.bright_tv_dataset_update_viewership AS VP
LEFT JOIN `workspace`.`default`.`bright_tv_dataset_user_p` AS UP
ON VP.UserID0 = UP.UserID;

----Query 5 to check total number of viewers on Bright tv 4386

SELECT 
COUNT(DISTINCT UserID0)
FROM workspace.default.bright_tv_dataset_update_viewership;

--- Query 6 filtering to check the multiple channels on offer 21 DIFFERENT CHANNELS Supersport Live Events ect
SELECT DISTINCT Channel2
FROM workspace.default.bright_tv_dataset_update_viewership;

--- Query 7 filtering to check min and max duration Most watched Africa Magic Least Watched KykNET
SELECT DISTINCT 
                MIN(Channel2) AS Most_Watched,
                MAX(Channel2) AS Least_Watched
FROM workspace.default.bright_tv_dataset_update_viewership;

---Query 8 checking diversity of viewership by race indian_asian, None,white,black,coloured and other

SELECT DISTINCT Race
FROM `workspace`.`default`.`bright_tv_dataset_user_p`;

---Query 9 checking AGE DIFFERENCES Youngest is 0 AND Oldest 114 years old  
SELECT DISTINCT AGE
FROM `workspace`.`default`.`bright_tv_dataset_user_p`;

--- Query 10 filtering to check number of province 9 PROVINCES and 1 NONE
SELECT DISTINCT Province
FROM `workspace`.`default`.`bright_tv_dataset_user_p`;


--- Query 10 filtering to check Gender demographic and total number 3 Males, Female and None
SELECT DISTINCT gender
FROM `workspace`.`default`.`bright_tv_dataset_user_p`;

---------------------------------------------------------------------------------------
-- Quering 11 Data set to clean and gain more insights on combined tables
SELECT * FROM `workspace`.`default`.`bright_tv_dataset_user_p`;

------Running joint table to review new columns on combined data set

SELECT UP.UserID,
       UP.Gender,
       UP.Race,
       UP.Age,
       UP.Province,
       VP.UserID0,
       VP.Channel2,
       VP.RecordDate2,
       VP.userid4
FROM workspace.default.bright_tv_dataset_update_viewership AS VP
LEFT JOIN `workspace`.`default`.`bright_tv_dataset_user_p` AS UP
ON VP.UserID0 = UP.UserID;

--Query 11 Filtering to check Count by Viewrship Province in Ascending order 
SELECT 
COUNT(UserID) AS User_count_by_province
FROM  `workspace`.`default`.`bright_tv_dataset_user_p`
GROUP BY Province
ORDER BY User_count_by_province ASC;

--- Query 13 filtering to check NULLS and replace them with 'No'
----------------------------------------------------------------
SELECT 
       VP.UserID0,
------------------------------------------------------------------------------------------------
       CASE 
             WHEN UP.Gender = 'UNKOWN' OR UP.Gender IS NULL THEN 'NO'
             ELSE UP.Gender
      END AS Gender,

       CASE 
             WHEN UP.Race = 'UNKOWN' OR UP.Race IS NULL THEN 'NO'
             ELSE UP.Race
      END AS Race,

      
       CASE 
             WHEN UP.Province = 'UNKOWN' OR UP.Province IS NULL THEN 'NO'
             ELSE UP.Province
      END AS Province,

       CASE 
             WHEN VP.Channel2 = 'UNKOWN' OR VP.Channel2 IS NULL THEN 'NO'
             ELSE VP.Channel2
      END AS Channel2,


       VP.RecordDate2


FROM workspace.default.bright_tv_dataset_update_viewership AS VP
LEFT JOIN `workspace`.`default`.`bright_tv_dataset_user_p` AS UP
ON VP.UserID0 = UP.UserID;

--------------------------
--Query 14 remove any null values for data cleanning purpose----
SELECT UP.Gender,
       UP.Race,
       UP.Age,
       UP.Province,
       VP.UserID0,
       VP.Channel2 AS Programs

FROM workspace.default.bright_tv_dataset_update_viewership AS VP
LEFT JOIN `workspace`.`default`.`bright_tv_dataset_user_p` AS UP
ON VP.UserID0 = UP.UserID
WHERE Gender IS NULL OR
      Race IS NULL OR
      Age IS NULL OR 
      Province IS NULL OR
      RecordDate2 IS NULL OR
      Channel2 IS NULL OR
      VP.UserID0 IS NULL;
----Query 15 filtering to check DAYNAME MONTHNAME AND DAY OF MONTH in order to understand when is Bright Tv most Viewed in a weekday
SELECT RecordDate2,
     Dayname(RecordDate2) AS Day_name,
     Monthname(RecordDate2) AS Month_name,
     Dayofmonth(RecordDate2) AS Day_of_month
FROM workspace.default.bright_tv_dataset_update_viewership AS VP
LEFT JOIN `workspace`.`default`.`bright_tv_dataset_user_p` AS UP
ON VP.UserID0 = UP.UserID;


-----Query 16 Adding more columns to our data set to gain more insight and provide improved analysis for presentation purposes
--------Adding timestamps to our data to pay close attention to viewrship pattens.
SELECT 
     CASE
     WHEN DAYNAME(RecordDate2) IN ('Sun','Sat') THEN 'Weekend'
     ELSE 'Weekday'
     END AS Day_Classification
FROM workspace.default.bright_tv_dataset_update_viewership AS VP
LEFT JOIN `workspace`.`default`.`bright_tv_dataset_user_p` AS UP
ON VP.UserID0 = UP.UserID;

----Query 17 Viewership by timeslots ------------
SELECT UP.UserID,
       UP.Gender,
       UP.Race,
       UP.Age,
       UP.Province,
       VP.UserID0,
       VP.Channel2,
       VP.RecordDate2,
       VP.userid4,
CASE
     WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '05:00:00'AND'11:59:59' THEN '01.Morning View'
     WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '12:00:00'AND '17:59:59' THEN '02.Afternoon View'
     WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '18:00:00'AND '23:59:59' THEN '03.Evening View'
     ELSE 'Midnight View'
     END AS VIEWING_SLOT
FROM workspace.default.bright_tv_dataset_update_viewership AS VP
LEFT JOIN `workspace`.`default`.`bright_tv_dataset_user_p` AS UP
ON VP.UserID0 = UP.UserID;


----Query 18  Filtering to group viewrship by age bucket
--------------------------------------------------------------
SELECT 

CASE WHEN Age IS NULL THEN '00.UNKOWN'
     WHEN Age <=13 THEN '01.CHILD'
     WHEN Age BETWEEN 14 AND 35 THEN'02.TEEN TO YOUNG ADULT'
     WHEN Age BETWEEN 36 AND 55 THEN'03.MIDDLE AGE'
     ELSE '04 OLD'
     END AS Age_class,
----------------------------------------------------------------------------------------------

CASE 
     WHEN Age IS NULL THEN '00.UNKNOWN'
     WHEN Age <=13 THEN '01.CHILD'
     WHEN AGE BETWEEN 14 AND 35 THEN'02.TEEN TO YOUNG ADULT'
     WHEN AGE BETWEEN 36 AND 55 THEN'03.MIDDLE AGE'
     ELSE '04 OLD'
     END AS Age_class
------------------------------------------------------------
FROM workspace.default.bright_tv_dataset_update_viewership AS VP
LEFT JOIN `workspace`.`default`.`bright_tv_dataset_user_p` AS UP
ON VP.UserID0 = UP.UserID;
------------Filtering to extract insights for final table to Visualize outcomes gained for reporting 
----------------------------------------------------------------------------------------------------------
SELECT
       UP.UserID,
       UP.Gender,
       UP.Race,
       UP.Age,
       UP.Province,
       VP.UserID0,
       VP.Channel2,
       VP.RecordDate2,
       VP.userid4,

--- filtering to check NULLS and replace them with 'No'
----------------------------------------------------------------
       VP.UserID0,
------------------------------------------------------------------------------------------------
       CASE 
             WHEN UP.Gender = 'UNKOWN' OR UP.Gender IS NULL THEN 'NO'
             ELSE UP.Gender
      END AS Gender,

       CASE 
             WHEN UP.Race = 'UNKOWN' OR UP.Race IS NULL THEN 'NO'
             ELSE UP.Race
      END AS Race,

      
       CASE 
             WHEN UP.Province = 'UNKOWN' OR UP.Province IS NULL THEN 'NO'
             ELSE UP.Province
      END AS Province,

       CASE 
             WHEN VP.Channel2 = 'UNKOWN' OR VP.Channel2 IS NULL THEN 'NO'
             ELSE VP.Channel2
      END AS Channel2,


       VP.RecordDate2,
---filtering to check DAYNAME MONTHNAME AND DAY OF MONTH in order to understand when is Bright Tv most Viewed in a weekday          
     RecordDate2,
     Dayname(RecordDate2) AS Day_name,
     Monthname(RecordDate2) AS Month_name,
     Dayofmonth(RecordDate2) AS Day_of_month,
---- Adding more columns to our data set to gain more insight and provide improved analysis for presentation purpose

---Viewership by timeslots ------------
CASE
     WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '05:00:00'AND'11:59:59' THEN 'Morning View'
     WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '12:00:00'AND '17:59:59' THEN 'Afternoon View'
     WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '18:00:00'AND '23:59:59' THEN 'Evening View'
     ELSE 'Midnight View'
     END AS VIEWING_SLOT,
---- Filtering to group viewrship by age bucket
--------------------------------------------------------------


CASE WHEN Age IS NULL THEN '00.UNKOWN'
     WHEN Age <=13 THEN '01.CHILD'
     WHEN Age BETWEEN 14 AND 35 THEN'02.TEEN TO YOUNG ADULT'
     WHEN Age BETWEEN 36 AND 55 THEN'03.MIDDLE AGE'
     ELSE '04 OLD'
     END AS Age_class,
----------------------------------------------------------------------------------------------

CASE 
     WHEN Age IS NULL THEN '00.UNKNOWN'
     WHEN Age <=13 THEN '01.CHILD'
     WHEN AGE BETWEEN 14 AND 35 THEN'02.TEEN TO YOUNG ADULT'
     WHEN AGE BETWEEN 36 AND 55 THEN'03.MIDDLE AGE'
     ELSE '04 OLD'
     END AS Age_class,
--------Adding timestamps to our data to pay close attention to viewrship pattens.
CASE
     WHEN DAYNAME(RecordDate2) IN ('Sun','Sat') THEN 'Weekend'
     ELSE 'Weekday'
     END AS Day_Classification
FROM workspace.default.bright_tv_dataset_update_viewership AS VP
LEFT JOIN `workspace`.`default`.`bright_tv_dataset_user_p` AS UP
ON VP.UserID0 = UP.UserID;
---------------------------------------------------------------------------------------------------
