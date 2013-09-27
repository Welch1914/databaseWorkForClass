
/******************************************************************************************************************************************/
/* The JW Trading Company is planning to do their strategic planning session and needs some input data for the sessions by 11:59 on       */
/* April 2.  As a Georgian graduate, you have been selected as the best possible person to query the database and provide the leadership  */
/* team the necessary  insights to bring the company to the next level.                                  								  */
/*																			                                                              */
/* Listed below are a series of requested reports, please write the appropriate queries.  As the information is very sensitive, your      */
/* Director will review the queries to ensure they are complete, so they MUST be easily readable.  Be sure to spread the queries across   */
/* multiple lines as follows:																											  */
/*                                                                                                                                        */   
/* SELECT [column names]                                                                                                                  */
/* FROM   [TABLE name] (if JOINs are required, only put 1 JOIN per line)                                                                  */
/* WHERE  [conditions]                                                                                                                    */
/* HAVING [conditions]                                                                                                                    */
/*                                                                                                                                        */
/* Please embed your queries into this file and save it named as comp2003-assignment 2-student num.sql                                    */
/*                                                                                                                                        */
/* The resulting queries should have CLEAR headers as the leadership team will not understand SQL.  So if you need to use something like  */
/* SUM(quantity), you should rename the column as '# of units sold'.																			                                */
/*                                                                                                                                        */
/* If you have any questions or clarifications, please contact Jaret Wright at jaret.wright@georgiancollege.ca, see him in class or       */
/* during the office hours.                                                                                                               */
/*                                                                                                                                        */ 
/*                                                                                                                                        */ 
/* Student Name:    Sam Welch                                                                                                                        */ 
/* Student Number:  200238810                                                                                                                      */ 
/* Assignment #2                                                                                                                          */ 
/*                                                                                                                                        */ 
/*                                                                                                                                        */ 
/* Question  Marks available    Marks earned                                                                                              */
/*  1           1                                                                                                                         */
/*  2           2                                                                                                                         */
/*  3           2                                                                                                                         */
/*  4           2                                                                                                                         */
/*  5           2                                                                                                                         */
/*  6           2                                                                                                                         */
/*  7           3                                                                                                                         */
/*  8           4                                                                                                                         */
/*  9           4                                                                                                                         */
/* 10           3                                                                                                                         */
/* 11           3                                                                                                                         */
/* 12           4                                                                                                                         */
/* 13           2                                                                                                                         */
/* 14           4                                                                                                                         */
/* 15           4                                                                                                                         */
/* 16           4                                                                                                                         */
/* 17           3                                                                                                                         */
/* 18           3                                                                                                                         */
/* 19           4                                                                                                                         */
/* 20           4                                                                                                                         */
/* total       60
/******************************************************************************************************************************************/
USE assignment2;
/******************************************************************************************************************************************/
/*1.  How many employees does the company have?  (1 mark)                                                                                 */
/*     Marks earned:  1                                                                                                                    */
/******************************************************************************************************************************************/
SELECT COUNT(employeeID)
FROM employees;


/******************************************************************************************************************************************/
/*2. Show all employees who have made sales that were shipped to Seattle.  Employee names should only be shown once for each employee     */
/*   List the employee ID, first and last name. (2 marks)																					                                        */
/*     Marks earned:     2                                                                                                                */
/******************************************************************************************************************************************/
SELECT employees.employeeID, firstName, lastName
FROM employees INNER JOIN orders ON employees.employeeID = orders.employeeID
WHERE orders.shipcity = 'Seattle'
GROUP BY employees.employeeID;


/******************************************************************************************************************************************/
/*3.  List all the products that need to be reordered including how many are currently in stock, how many are on order and the reorder    */
/*    level.  Be sure to account for both units in stock and already on order (2 marks)                                                   */
/*     Marks earned: 1                                                                                                                    */
/*   JW comment:  You need to use unitsInStock + unitsOnOrder < reorderLevel                                                              */
/******************************************************************************************************************************************/
SELECT productID, productName, reorderLevel, UnitsOnOrder, UnitsInStock  
FROM products
WHERE reorderLevel > 0
ORDER BY reorderLevel desc;


/******************************************************************************************************************************************/
/*4. Select the 10 most popular products. (2 marks)																							                                          */
/*     Marks earned:    2                                                                                                                  */
/******************************************************************************************************************************************/
SELECT products.productID, products.productName, SUM(Order_Details.quantity) AS 'Total Ordered'
FROM products INNER JOIN Order_Details ON products.productID = Order_Details.productID
GROUP BY products.productID
ORDER BY `Total Ordered` DESC
LIMIT 10;

/******************************************************************************************************************************************/
/*5. select the 10 customers with the highest # of orders (2 marks)                                                                       */
/*     Marks earned:     2                                                                                                                 */
/******************************************************************************************************************************************/
SELECT customers.customerID, customers.companyName, SUM(quantity) AS 'Total Orders'
FROM customers INNER JOIN orders ON customers.customerID = orders.customerID
			   INNER JOIN order_details ON  orders.orderID = order_details.orderID 
GROUP BY customers.customerID
ORDER BY `Total Orders` DESC
LIMIT 10;

/******************************************************************************************************************************************/
/*6. Show the total of each order (in $) without a discount (2 marks) 																		                                */
/*     Marks earned:   1                                                                                                                  */
/*   JW comment:  You need to use SUM(unitPrice*quantity) to arrive at the total $ for each order                                         */
/******************************************************************************************************************************************/
SELECT customers.customerID, customers.companyName, SUM(unitPrice) AS 'total value($)'
FROM customers INNER JOIN orders ON customers.customerID = orders.customerID
			   INNER JOIN order_details ON  orders.orderID = order_details.orderID 
GROUP BY orders.orderID
ORDER BY customers.customerID;


/******************************************************************************************************************************************/
/*7.  Show the total of each order (in $) including the discount rate (3 marks)							        							                        */
/*     Marks earned:   2                                                                                                                  */
/*   JW comment:  similar to the last question, you need to incorporate the quantity.  Why would you order by customerID?  Wouldn't       */
/*                orderID make a lot more sense?   The question doesn't talk about customer info at all.    
/******************************************************************************************************************************************/
SELECT customers.customerID, customers.companyName, ROUND((SUM(unitPrice) -SUM(unitPrice* discount)),2) AS 'total value($)'
FROM customers INNER JOIN orders ON customers.customerID = orders.customerID
			   INNER JOIN order_details ON  orders.orderID = order_details.orderID 
GROUP BY orders.orderID
ORDER BY customers.customerID;


/******************************************************************************************************************************************/
/*8.  Show the total amount spent per customer including the discount rate (4 marks)														                          */
/*     Marks earned:  3.5                                                                                                                    */
/*   JW comment:  Overall it looks good, however, you are using the wrong formula 
/******************************************************************************************************************************************/
SELECT customers.customerID, customers.companyName, ROUND((SUM(unitPrice) -SUM(unitPrice* discount)),2) AS 'total value($)'
FROM customers INNER JOIN orders ON customers.customerID = orders.customerID
			   INNER JOIN order_details ON  orders.orderID = order_details.orderID 
GROUP BY customers.customerID
ORDER BY `total value($)` DESC;


/******************************************************************************************************************************************/
/*9. Show the 10 customer names with the highest dollar value of orders (4 marks)														                              */
/*     Marks earned: 3.5                                                                                                                     */
/*   JW comment:  Overall it looks good, however, you are using the wrong formula 
/******************************************************************************************************************************************/

SELECT customers.customerID, customers.companyName, ROUND((SUM(unitPrice) -SUM(unitPrice* discount)),2) AS 'total value($)'
FROM customers INNER JOIN orders ON customers.customerID = orders.customerID
			   INNER JOIN order_details ON  orders.orderID = order_details.orderID 
GROUP BY customers.customerID
ORDER BY `total value($)` DESC
LIMIT 10;
/******************************************************************************************************************************************/
/*10. find total sales made in Germany (3 marks)																							                                            */
/*     Marks earned:   2.5                                                                                                                */
/*   JW comment:  Overall it looks good, however, you are using the wrong formula 
/******************************************************************************************************************************************/

SELECT ROUND((SUM(unitPrice) -SUM(unitPrice* discount)),2) AS 'total value($)'
FROM customers INNER JOIN orders ON customers.customerID = orders.customerID
			   INNER JOIN order_details ON  orders.orderID = order_details.orderID 
WHERE country = 'Germany';

/******************************************************************************************************************************************/
/*11.  Show the total # of units sold for each product, even those that have never been purchased, from lowest to highest (3 marks)        */
/*     Marks earned:   2                                                                                                                  */
/*  JW comment - you need to use LEFT OUTER JOIN to get ALL the products                                                                   */
/******************************************************************************************************************************************/

SELECT products.productID,products.productName, SUM(quantity) AS 'Units Sold'
FROM products INNER JOIN order_details ON products.productID = order_details.productID
			   INNER JOIN orders ON   order_details.orderID = orders.orderID 
WHERE products.productID = order_details.productID
GROUP BY products.productID
ORDER BY `Units Sold`;

/******************************************************************************************************************************************/
/*12. Show the order total for each product, even those that have never been purchased, from lowest to highest (4 marks)                  */
/*     Marks earned:   3                                                                                                                  */
/*  JW comment - you need to use LEFT OUTER JOIN to get ALL the products                                                                   */
/******************************************************************************************************************************************/

SELECT products.productID ,products.productName, COUNT(orders.orderID) AS 'Units Sold'
FROM products INNER JOIN order_details ON products.productID = order_details.productID
			  INNER JOIN orders ON   order_details.orderID = orders.orderID 
WHERE products.productID = order_details.productID
GROUP BY products.productID
ORDER BY `Units Sold`;



/******************************************************************************************************************************************/
/*13. Show the complete category & product list, ordered by category then product (2 marks)                                               */
/*     Marks earned: 2                                                                                                                    */
/******************************************************************************************************************************************/
SELECT * 
FROM categories INNER JOIN products ON categories.categoryID = products.categoryID
ORDER BY categories.categoryID, productID;

/******************************************************************************************************************************************/
/*14. Show total amount of discounts given on sales for each country.  This should be ordered highest to lowest (4 marks)                 */
/*     Marks earned:     4                                                                                                                */
/******************************************************************************************************************************************/
SELECT country, COUNT(discount) AS 'total # of disocunts' /*,ROUND(SUM(unitPrice* discount),2) AS 'value of discounts'*/
FROM customers INNER JOIN orders ON customers.customerID = orders.customerID
			   INNER JOIN order_details ON  orders.orderID = order_details.orderID 
GROUP BY country
ORDER BY `total # of disocunts` DESC;

/******************************************************************************************************************************************/
/*15. Show total sales by employee.  List the employee ID, first and last name (4 marks)													                        */
/*     Marks earned:  3.5                                                                                                                  */
/*  JW comment:  wrong formula, but otherwise correct                                                                                    */
/******************************************************************************************************************************************/
SELECT employees.employeeID, firstName, lastName, ROUND(SUM(unitPrice),2) AS 'Total Sales($)'
FROM employees INNER JOIN orders ON employees.employeeID = orders.employeeID
			   INNER JOIN order_details ON  orders.orderID = order_details.orderID
GROUP BY employees.employeeID
ORDER BY `Total Sales($)` DESC;

/******************************************************************************************************************************************/
/*16. Show the most expensive product in each category along with the price.  Hint:  Nested queries could be helpful here (4 marks)   		*/
/*     Marks earned:  0                                                                                                                    */
/*  JW comment - we did this question as a class 
/******************************************************************************************************************************************/
SELECT productID,categoryID, productName, unitprice
FROM products 
WHERE unitPrice = (SELECT unitprice
				   FROM products
				   WHERE categoryID = categoryID
				   HAVING  MAX(unitPrice)> unitPrice )
GROUP BY categoryID;



###### I have no idea how to answer this question;













/******************************************************************************************************************************************/
/*17. Show by country, the # of orders and total shipping cost paid to each shipping carrier (3 marks)                                             */
/*     Marks earned:   2                                                                                                                   */
/*  JW comment:  This only shows the shipCountry, not the shipping carrier.  You need to use GROUP BY shipCountry, shipVia 
/******************************************************************************************************************************************/
SELECT shipcountry, COUNT(OrderID) AS '# of orders', ROUND(SUM(freight),2) AS 'shipping cost'
FROM orders 
GROUP BY shipcountry
ORDER BY shipcountry;

/******************************************************************************************************************************************/
/*18.  List ALL the suppliers ordered by total # of units sold (3 marks)																                             	    */
/*     Marks earned: 2                                                                                                                    */
/*  JW comment:  You need to use a LEFT OUTER JOIN for ALL the suppliers
/******************************************************************************************************************************************/
SELECT suppliers.supplierID, companyName, SUM(order_details.quantity) AS 'Units Sold'
FROM suppliers INNER JOIN products ON suppliers.supplierID = products.supplierID
			   INNER JOIN order_details ON products.productID = order_details.productID
GROUP BY suppliers.supplierID
ORDER BY `Units Sold` DESC;
/******************************************************************************************************************************************/
/*19.  Which supplier provides the most product in terms of total revenue (total $ sales). Be sure to take into account the discount 		  */
/*     rate (4 marks)																														                                                          */
/*     Marks earned:  3.5                                                                                                                    */
/*  JW comment:  due to the formula error, you arrived at the wrong company
/******************************************************************************************************************************************/
SELECT suppliers.supplierID, companyName, ROUND((SUM(products.unitPrice) -SUM(products.unitPrice* discount)),2) AS 'total value($)'
FROM suppliers INNER JOIN products ON suppliers.supplierID = products.supplierID
			   INNER JOIN order_details ON products.productID = order_details.productID
GROUP BY suppliers.supplierID
ORDER BY `total value($)` DESC
LIMIT 1;

/******************************************************************************************************************************************/
/*20.  Show the employee that sold the most in 2012 (including discounts) Note:  the discount is a % of the cost (4 marks)                */
/*     Marks earned:   3.5                                                                                                                   */
/*  JW comment - same as previous, you need to use the quantity field in your formula
/******************************************************************************************************************************************/
SELECT employees.employeeID,firstname, lastname, ROUND((SUM(products.unitPrice) -SUM(products.unitPrice* discount)),2) AS 'total sales'
FROM employees INNER JOIN orders ON employees.employeeID = orders.employeeID
			   INNER JOIN order_details ON orders.orderID = order_details.orderID
			   INNER JOIN products ON order_details.productID = products.ProductID
WHERE orderDate LIKE '2012%'
GROUP BY employeeID
ORDER BY `total sales` DESC
LIMIT 1;
				
