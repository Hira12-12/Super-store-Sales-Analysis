-- 🧱 STEP 1: Create Database
CREATE DATABASE sales_dashboard;
USE sales_dashboard;

-- 🧱 STEP 2: Create Table
CREATE TABLE orders (
    Row_ID INT PRIMARY KEY,
    Order_ID VARCHAR(50),
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode VARCHAR(50),
    Customer_ID VARCHAR(50),
    Customer_Name VARCHAR(100),
    Segment VARCHAR(50),
    Country VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    Postal_Code VARCHAR(20),
    Region VARCHAR(50),
    Product_ID VARCHAR(50),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name VARCHAR(255),
    Sales DECIMAL(10,2),
    Shipping_Delay INT,
    Sales_Capped DECIMAL(10,2),
    Delivery_Time INT,
    Order_Month VARCHAR(20),
    Order_Year INT,
    Sales_Log DECIMAL(10,2),
    Sales_Capped_Log DECIMAL(10,2),
    Year INT,
    Month INT
);

-- 🧭 STEP 3: Import Dataset (update path as per your folder)
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Superstore Sales Dataset - Cleaned.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 🧩 STEP 4: ANALYSIS QUERIES

-- Q1️⃣ Total Sales per Region
SELECT Region, SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Region
ORDER BY Total_Sales DESC;

-- Q2️⃣ Customer-wise Total Sales
SELECT Customer_Name, SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;

-- Q3️⃣ Category-wise Total Sales & Top Product
SELECT Category, Sub_Category, SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Category, Sub_Category
ORDER BY Total_Sales DESC;

-- Q4️⃣ Monthly Sales Trend (Ordered by Month & Year)
SELECT Order_Year, Order_Month, SUM(Sales) AS Monthly_Sales
FROM orders
GROUP BY Order_Year, Order_Month
ORDER BY Order_Year, Order_Month;

-- Q5️⃣ Ship Mode-wise Total Sales
SELECT Ship_Mode, SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Ship_Mode
ORDER BY Total_Sales DESC;

-- Q6️⃣ Highest Selling Product
SELECT Product_Name, SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Product_Name
ORDER BY Total_Sales DESC
LIMIT 1;

-- Q7️⃣ Highest Selling Customer
SELECT Customer_Name, SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Customer_Name
ORDER BY Total_Sales DESC
LIMIT 1;

-- Q8️⃣ Filtering Queries
-- Sales > 500
SELECT * FROM orders
WHERE Sales > 500;

-- Region = 'East'
SELECT * FROM orders
WHERE Region = 'East';

-- 🧠 ADVANCED ANALYTICS (for dashboard insights)

-- ✅ Average Delivery Time per Region
SELECT Region, AVG(Delivery_Time) AS Avg_Delivery_Time
FROM orders
GROUP BY Region
ORDER BY Avg_Delivery_Time ASC;

-- ✅ Shipping Delay Analysis
SELECT 
  CASE 
    WHEN Shipping_Delay < 0 THEN 'Early Delivery'
    WHEN Shipping_Delay = 0 THEN 'On Time'
    ELSE 'Delayed'
  END AS Shipping_Status,
  COUNT(*) AS Total_Orders
FROM orders
GROUP BY Shipping_Status;

-- ✅ Yearly Sales Growth (%)
SELECT 
  Order_Year,
  SUM(Sales) AS Total_Sales,
  LAG(SUM(Sales)) OVER (ORDER BY Order_Year) AS Prev_Year_Sales,
  ROUND(
    (SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY Order_Year)) /
    LAG(SUM(Sales)) OVER (ORDER BY Order_Year) * 100, 2
  ) AS Growth_Percentage
FROM orders
GROUP BY Order_Year
ORDER BY Order_Year;

-- ✅ Segment-wise Average Delivery Time & Total Sales
SELECT Segment, 
       AVG(Delivery_Time) AS Avg_Delivery,
       SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Segment;

-- ✅ Top 10 Products by Sales
SELECT Product_Name, SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Product_Name
ORDER BY Total_Sales DESC
LIMIT 10;

-- ✅ Top 10 Customers by Sales
SELECT Customer_Name, SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;

-- ✅ Category-wise Average Shipping Delay
SELECT Category, ROUND(AVG(Shipping_Delay),2) AS Avg_Shipping_Delay
FROM orders
GROUP BY Category;

-- ✅ Region-wise Order Count
SELECT Region, COUNT(Order_ID) AS Total_Orders
FROM orders
GROUP BY Region
ORDER BY Total_Orders DESC;

-- ✅ Month-wise Average Sales
SELECT Month, ROUND(AVG(Sales),2) AS Avg_Sales
FROM orders
GROUP BY Month
ORDER BY Month;

-- ✅ Delivery Performance Classification
SELECT 
  CASE 
    WHEN Delivery_Time <= 3 THEN 'Good'
    WHEN Delivery_Time BETWEEN 4 AND 6 THEN 'Average'
    ELSE 'Delayed'
  END AS Delivery_Status,
  COUNT(*) AS Total_Orders
FROM orders
GROUP BY Delivery_Status;
