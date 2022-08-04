USE db_SQLCaseStudies;

--SQL Advance Case Study


/*Q1--List all the states in which we have customers who have bought cellphones
from 2005 till today.*/


SELECT T1.DATE, T2.STATE
FROM FACT_TRANSACTIONS AS T1
LEFT JOIN DIM_LOCATION AS T2
ON T1. IDLocation = T2. IDLocation
WHERE DATE > '2005-01-01'
GROUP BY T1.DATE, T2.STATE;






/*Q2--What state in the US is buying the most 'Samsung' cell phones?*/


SELECT TOP 1 T1.IDModel, T1.Quantity, T2.Country,T2.State
FROM FACT_TRANSACTIONS AS T1
INNER JOIN DIM_LOCATION AS T2
ON T1.IDLocation = T2.IDLocation
WHERE (IDMODEL BETWEEN 118 AND 125) AND COUNTRY ='US'
GROUP BY T1.IDModel, T1.Quantity, T2.Country,T2.State
ORDER BY QUANTITY DESC;
--Maryland is buying most 'Samsung'cellphones.
	





/*Q3--Show the number of transactions for each model per zip code per state.*/


SELECT T1. IDModel, T2.ZipCode,T2.State,
COUNT(T1. IDModel) AS COUNTS
FROM FACT_TRANSACTIONS AS T1
LEFT JOIN DIM_LOCATION AS T2
ON T1. IDLocation = T2. IDLocation
GROUP BY T1. IDModel, T2.ZipCode,T2.State;
	





--Q4--Show the cheapest cellphone. (Output should contain the price also)


SELECT TOP 1 IDModel,
MIN(TOTALPRICE) AS CHEAPEST
FROM FACT_TRANSACTIONS
GROUP BY IDModel
ORDER BY CHEAPEST;






/*Q5--Find out the average price for each model in the top5 manufacturers in
terms of sales quantity and order by average price.*/


SELECT T1.IDModel, T2.IDManufacturer,
AVG(TOTALPRICE) AS AVERAGE,
COUNT(QUANTITY) AS SALES_QUANTITY
FROM FACT_TRANSACTIONS AS T1
INNER JOIN DIM_MODEL AS T2
ON T1.IDModel = T2.IDModel
GROUP BY T1.IDModel, T2.IDManufacturer
ORDER BY  AVG(TOTALPRICE) DESC;






/*Q6--List the names of the customers and the average amount spent in 2009,
where the average is higher than 500 */


SELECT T2.Customer_Name,
AVG(T1.TotalPrice) as AVERAGE,
YEAR(DATE) AS YEAR1
FROM FACT_TRANSACTIONS AS T1
INNER JOIN DIM_CUSTOMER AS T2
ON T1.IDCustomer = T2.IDCustomer
WHERE (YEAR(DATE) = 2009)
GROUP BY T2.Customer_Name, T1.Date
HAVING AVG(T1.TotalPrice) > 500
ORDER BY T2.Customer_Name;






/*Q7-- List if there is any model that was in the top 5 in terms of quantity,
simultaneously in 2008, 2009 and 2010 */


WITH CTE
AS
(
 SELECT 
        ROW_NUMBER() OVER(PARTITION BY YEAR(DATE) ORDER BY COUNT(Quantity) DESC) AS ROW_NUM,
		IDMODEL,
        YEAR(DATE) AS YEARS,
        COUNT(Quantity) AS COUNTS
    FROM FACT_TRANSACTIONS
       WHERE YEAR(DATE) IN (2008,2009,2010)
       GROUP BY IDMODEL, YEAR(DATE)
)
SELECT TOP 5
    IDMODEL
    FROM CTE 
    WHERE ROW_NUM <6
    GROUP BY IDModel
    HAVING COUNT(1)=3;
---There is No Model that was in top 5 in terms of quantity, simultaneously in 2008, 2009 and 2010.
	
	




/*Q8--Show the manufacturer with the 2nd top sales in the year of 2009 and the
manufacturer with the 2nd top sales in the year of 2010.*/


SELECT T2009.Manufacturer_Name AS Manufacturer_Name_2009, T2010.Manufacturer_Name AS Manufacturer_Name2010
FROM
(
  SELECT MANUFACTURER_NAME,
  YEAR(DATE) AS YEARS,
  ROW_NUMBER() OVER(ORDER BY SUM(TOTALPRICE) DESC) AS ROW_NUM2009
  FROM FACT_TRANSACTIONS AS T1
  LEFT JOIN DIM_MODEL AS T2
  ON T1.IDModel = T2.IDModel
  LEFT JOIN DIM_MANUFACTURER AS T3
  ON T2.IDManufacturer = T3.IDManufacturer
  WHERE YEAR(DATE) = '2009'
  GROUP BY MANUFACTURER_NAME, YEAR(DATE)
) AS T2009 
INNER JOIN
(
  SELECT MANUFACTURER_NAME,
  YEAR(DATE) AS YEARS,
  ROW_NUMBER() OVER(ORDER BY SUM(TOTALPRICE) DESC) AS ROW_NUM2010
  FROM FACT_TRANSACTIONS AS T1
  LEFT JOIN DIM_MODEL AS T2
  ON T1.IDModel = T2.IDModel
  LEFT JOIN DIM_MANUFACTURER AS T3
  ON T2.IDManufacturer = T3.IDManufacturer
  WHERE YEAR(DATE) = '2010'
  GROUP BY MANUFACTURER_NAME, YEAR(DATE)
 ) AS T2010
  ON ROW_NUM2009 = ROW_NUM2010
  WHERE ROW_NUM2009 =2 AND ROW_NUM2010 =2;






/*Q9--Show the manufacturers that sold cellphones in 2010 but did not in 2009.*/


SELECT Manufacturer_Name
FROM FACT_TRANSACTIONS AS T1
LEFT JOIN DIM_MODEL AS T2
ON T1.IDModel = T2.IDModel
LEFT JOIN DIM_MANUFACTURER AS T3
ON T2.IDManufacturer = T3.IDManufacturer
WHERE YEAR(DATE) in (2010)
EXCEPT
SELECT Manufacturer_Name
FROM FACT_TRANSACTIONS AS T1
LEFT JOIN DIM_MODEL AS T2
ON T1.IDModel = T2.IDModel
LEFT JOIN DIM_MANUFACTURER AS T3
ON T2.IDManufacturer = T3.IDManufacturer
WHERE YEAR(DATE) in (2009);
	





--Q10--Find top 100 customers and their average spend, average quantity by each year.

SELECT TOP 100 
T1.IDCUSTOMER AS CUSTOMER_ID,
YEAR(DATE) AS YEARS,
AVG(TOTALPRICE) AS AVG_SPEND,
AVG(QUANTITY) AS AVG_QUANTITY
FROM FACT_TRANSACTIONS AS T1
INNER JOIN DIM_CUSTOMER AS T2
ON T1.IDCUSTOMER = T2.IDCUSTOMER
GROUP BY DATE, T1.IDCUSTOMER;

	
	