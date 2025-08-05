-- Create a new database named 'blinkitdb'
CREATE DATABASE blinkitdb;

-- Create a table 'blinkit_data' with relevant columns for item and outlet details
CREATE TABLE blinkit_data (
    Item_Fat_Content          VARCHAR(50),
    Item_Identifier           VARCHAR(50),
    Item_Type                 VARCHAR(50),
    Outlet_Establishment_Year INT,
    Outlet_Identifier         VARCHAR(50),
    Outlet_Location_Type      VARCHAR(50),
    Outlet_Size               VARCHAR(50),
    Outlet_Type               VARCHAR(50),
    Item_Visibility           FLOAT,
    Item_Weight               FLOAT,
    Sales                     FLOAT NOT NULL,
    Rating                    FLOAT
);

-- View all data in the blinkit_data table
SELECT * FROM blinkit_data;

-- Count total number of rows/items in the table
SELECT COUNT(*) FROM blinkit_data;

-- Standardize the values in 'item_fat_content'
-- 'LF' and 'low fat' → 'Low Fat', 'reg' → 'Regular'
UPDATE blinkit_data 
SET item_fat_content =
CASE 
    WHEN item_fat_content IN ('LF','low fat') THEN 'Low Fat'
    WHEN item_fat_content = 'reg' THEN 'Regular'
    ELSE item_fat_content
END;

-- Check unique values in 'item_fat_content' after cleanup
SELECT DISTINCT(item_fat_content) FROM blinkit_data;

-- Calculate total sales
SELECT SUM(sales) AS total_sales 
FROM blinkit_data;

-- Total sales in millions (formatted to 2 decimal places)
SELECT CAST(SUM(sales)/ 1000000 AS DECIMAL(10,2)) AS total_sales_millions
FROM blinkit_data;

-- Average sales overall
SELECT AVG(sales) AS Avg_Sales FROM blinkit_data;

-- Average sales with different rounding formats
SELECT CAST(AVG(sales) AS DECIMAL(10,2)) AS Avg_Sales FROM blinkit_data;
SELECT CAST(AVG(sales) AS DECIMAL(10,0)) AS Avg_Sales FROM blinkit_data;
SELECT CAST(AVG(sales) AS DECIMAL(10,1)) AS Avg_Sales FROM blinkit_data;

-- Count total number of items
SELECT COUNT(*) AS No_Of_Items FROM blinkit_data;

-- Total sales (in millions) for 'Low Fat' products
SELECT CAST(SUM(sales)/ 1000000 AS DECIMAL(10,2)) AS total_sales_millions
FROM blinkit_data
WHERE item_fat_content = 'Low Fat';

-- Total, average sales and count for outlets established in 2022
SELECT CAST(SUM(sales)/ 1000000 AS DECIMAL(10,2)) AS total_sales_millions
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2022;

SELECT CAST(AVG(sales) AS DECIMAL(10,1)) AS Avg_Sales
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2022;

SELECT COUNT(*) AS No_Of_Items
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2022;

-- Overall average rating
SELECT AVG(Rating) AS Avg_Rating FROM blinkit_data;
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating FROM blinkit_data;

-- Total sales grouped by item fat content (descending)
SELECT item_fat_content, SUM(sales) AS total_sales
FROM blinkit_data
GROUP BY item_fat_content
ORDER BY total_sales DESC;

-- Grouped sales with casting, avg sales, item count, and avg rating
SELECT item_fat_content, 
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(AVG(sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY item_fat_content
ORDER BY total_sales DESC;

-- Same as above but filtered for year 2020
SELECT item_fat_content, 
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(AVG(sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2020
GROUP BY item_fat_content
ORDER BY total_sales DESC;

-- Sales in thousands by fat content
SELECT item_fat_content, 
       CAST(SUM(sales)/1000 AS DECIMAL(10,2)) AS total_sales_thousands,
       CAST(AVG(sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY item_fat_content
ORDER BY total_sales_thousands DESC;

-- Grouping by item type
SELECT item_type, 
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(AVG(sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY item_type
ORDER BY total_sales DESC;

-- Bottom 5 item types by total sales
SELECT item_type,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(AVG(sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY item_type
ORDER BY total_sales ASC
LIMIT 5;

-- Analysis by location type and fat content
SELECT outlet_location_type, item_fat_content,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(AVG(sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY outlet_location_type, item_fat_content
ORDER BY total_sales ASC;

-- Total sales by location and fat content only
SELECT outlet_location_type, item_fat_content,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales
FROM blinkit_data
GROUP BY outlet_location_type, item_fat_content
ORDER BY total_sales ASC;

-- Sales by location, split by fat content types (pivot-style)
SELECT 
    outlet_location_type,
    CAST(SUM(CASE WHEN item_fat_content = 'Low Fat' THEN sales ELSE 0 END) AS DECIMAL(10,2)) AS Low_Fat,
    CAST(SUM(CASE WHEN item_fat_content = 'Regular' THEN sales ELSE 0 END) AS DECIMAL(10,2)) AS Regular
FROM blinkit_data
GROUP BY outlet_location_type
ORDER BY outlet_location_type;

-- Sales summary by outlet establishment year
SELECT outlet_establishment_year,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales
FROM blinkit_data
GROUP BY outlet_establishment_year
ORDER BY total_sales ASC;

-- Full metrics by establishment year
SELECT outlet_establishment_year,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(AVG(sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY outlet_establishment_year
ORDER BY total_sales DESC;

-- Sales and percentage by outlet size
SELECT outlet_size,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales,
       CAST((SUM(sales) * 100.0 / SUM(SUM(sales)) OVER()) AS DECIMAL(10,2)) AS sales_percentage
FROM blinkit_data
GROUP BY outlet_size
ORDER BY total_sales DESC;

-- Location-based sales metrics (filtered by year = 2022)
SELECT outlet_location_type,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales,
       CAST((SUM(sales) * 100.0 / SUM(SUM(sales)) OVER()) AS DECIMAL(10,2)) AS sales_percentage,
       CAST(AVG(sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2022
GROUP BY outlet_location_type
ORDER BY total_sales ASC;

-- Same analysis for year = 2020
SELECT outlet_location_type,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales,
       CAST((SUM(sales) * 100.0 / SUM(SUM(sales)) OVER()) AS DECIMAL(10,2)) AS sales_percentage,
       CAST(AVG(sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2020
GROUP BY outlet_location_type
ORDER BY total_sales ASC;

-- Sales analysis by outlet type
SELECT outlet_type,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales,
       CAST((SUM(sales) * 100.0 / SUM(SUM(sales)) OVER()) AS DECIMAL(10,2)) AS sales_percentage,
       CAST(AVG(sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY outlet_type
ORDER BY total_sales ASC;
