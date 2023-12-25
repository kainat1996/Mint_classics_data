/* Warehouses compile data on the company’s warehouses used to store product inventory.
Products compile data about the product types, stock quantities, sales quantities, purchase prices, and more.
Product lines compile data about the descriptions of each product line they sell.
Customers compile data about the company’s customer profiles, such as customer names, addresses, credit limits, and others.
Payments compile data about payments made by customers, including payment dates and amounts.
Orders compile data regarding customer orders for specific products.
Order details compile data about orders for specific products, including the quantity of products ordered and the price of each product.
Employees compile data about company employees, including names, addresses, offices, and more.
Offices compile data about company office profiles.*/

/*business problem:
wants to reduce the one the their storage facility.
also wants to reduce the inventories while mainting timely service to their customers..*/

/*for this at first we find total inventory(total stock) for each product.
we use table warehouse, products.*/

SELECT warehouseName, sum(quantityInStock) AS stockquantity FROM products
INNER JOIN warehouses ON products.warehousecode= warehouses.warehousecode
GROUP BY warehouseName
ORDER BY stockquantity DESC;

-- noe we check total stock for each product is in warehouse

SELECT warehouseName, productName,  sum(quantityInStock) AS stockquantity FROM products 
INNER JOIN warehouses ON products.warehousecode= warehouses.warehousecode
GROUP BY warehouseName, productName
ORDER BY stockquantity DESC;

-- total stock of products in productline

SELECT warehouseName, productLine, sum(quantityInStock) AS stockquantity FROM products
INNER JOIN warehouses ON products.warehousecode= warehouses.warehousecode
GROUP BY warehouseName, productLine
ORDER BY stockquantity DESC;

/*Total sales of the company:
sales of products, productline and warehouse.
at first we check the total sales of the company by products*/

-- we need products table and orderdetails,

SELECT warehouseName, productName, productLine, sum(quantityordered) AS totalsales ,sum(quantityInStock) as stockquantity from products
INNER JOIN orderdetails ON orderdetails.productCode= products.productCode
INNER JOIN warehouses ON warehouses.warehouseCode=products.warehouseCode
GROUP BY warehouseName,productName,productLine, quantityOrdered
ORDER BY stockquantity DESC;

/*now that we know that the warehouse, order name, quantity and stock we will check the remaining stock
for that we subtract total stock - total ordered*/

SELECT warehouseName, productName, productLine,quantityInStock, sum(quantityordered) AS orderedtotal ,(quantityInStock- sum(quantityOrdered)) AS currentstock FROM products
JOIN orderdetails ON orderdetails.productCode= products.productCode
JOIN warehouses ON warehouses.warehouseCode=products.warehouseCode
GROUP BY warehouseName,productName,productLine, quantityInStock
ORDER BY currentstock  DESC;

-- we also have to check the quantity of the products sold;

SELECT productName, productLine, buyPrice,priceEach, quantityordered FROM products
JOIN orderdetails ON orderdetails.productCode= products.productCode
GROUP BY productName,productLine, buyPrice, priceEach,quantityordered
ORDER BY quantityOrdered DESC;

-- now that we know that which warehouse has the most sale and which has the lesser sales now we will check the timely services of the company
select *from orders;

SELECT  productName, orderDate,requiredDate, shippedDate FROM orderdetails
JOIN orders ON orders.OrderNumber=orderdetails.orderNumber
JOIN products ON products.productCode= orderDetails.productCode
GROUP BY  productName, orderDate,requiredDate, shippedDate
ORDER BY orderDate DESC;

-- now we will see the total revenue generated by the company and from which warehouse

SELECT warehouseName, sum(quantityOrdered) AS totalquantity,buyPrice, priceEach, sum(quantityOrdered * priceEach) AS revenue FROM products
    INNER JOIN warehouses ON warehouses.warehouseCode=products.warehouseCode
    INNER JOIN orderdetails ON orderdetails.productCode= products.productCode
    GROUP BY warehouseName,buyPrice, priceEach
    ORDER BY revenue DESC;
    
    
-- now we will check product line revenue

SELECT productName, productLine, sum(quantityOrdered) AS totalquantity,buyPrice, priceEach, sum(quantityOrdered * priceEach) as revenue FROM products
    JOIN orderdetails on orderdetails.productCode= products.productCode
    GROUP BY productName, productLine, buyPrice, priceEach
    ORDER BY revenue DESC;
 
 -- now we will check which company is having the most orders
 
 SELECT country, sum(quantityordered) AS totalquantityordered FROM customers
 JOIN orders on orders.customerNumber= customers.customerNumber
 JOIN orderdetails on orderdetails.orderNumber = orders.orderNumber
 GROUP BY country
 ORDER BY  totalquantityordered DESC;
 