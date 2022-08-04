USE PROJECT;

--DATA PREPARATION AND UNDERSTANDING:-

--Q1. What is the total number of rows in each of the 3 tables in the database?
SELECT
COUNT(CUSTOMER_ID) AS ROW_NUM
FROM CUSTOMER;  --5647 rows

SELECT
COUNT(PROD_CAT_CODE) AS ROW_NUM
FROM PROD_CAT_INFO;  --23 rows

SELECT
COUNT(TRANSACTION_ID) AS ROW_NUM
FROM TRANSACTIONS;  --23053 rows

--Q2. What is the total number of transactions that have a return?
SELECT 
COUNT(QTY) AS [NO. OF RETURNS]
FROM TRANSACTIONS 
WHERE QTY < 0;

/*Q3. As you would have noticed, the dates provided across the datasets are not in a correct format. 
As first steps, please convert the data variables into valid date formats before proceeding ahead.*/
SELECT TRAN_DATE,
CONVERT(VARCHAR,TRAN_DATE,105) AS NEW_DATE
FROM TRANSACTIONS;

SELECT DOB,
CONVERT(VARCHAR,DOB,105) AS NEW_DATE
FROM CUSTOMER;

/*Q4. What is the time range of the transaction data available for analysis? Show the output in number of days,
months and years simultaneously in different columns.*/
SELECT 
DATEDIFF(YEAR, '2011-01-25', '2014-02-28') AS YEARS,
DATEDIFF(MONTH, '2011-01-25', '2014-02-28') AS MONTHS,
DATEDIFF(DAY, '2011-01-25', '2014-02-28') AS DAYS
FROM TRANSACTIONS;

--Q5. Which product category does the sub category "DIY" belongs to?
SELECT * FROM PROD_CAT_INFO
WHERE prod_sub_cat_code = 6;
-- SUB CATEGORY "DIY" BELONGS TO PROD_CAT_CODE 5 i.e, "BOOKS".





