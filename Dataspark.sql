select*from public.customer_data;
select*from public.exchange_data;
select*from public.product_data;
select*from public.sales_data;
select*from public.store_data;

-- 10 queries to get insights from 5 tables
-- customer data
-- 1// overall gender counts;

create table query1 as SELECT 
    COUNT(CASE WHEN Gender = 'Female' THEN 1 END) AS Female_count,
    COUNT(CASE WHEN Gender = 'Male' THEN 1 END) AS Male_count
FROM customer_data;

-- 2// overall counts form continent , country , and state 
create table query2 as SELECT 
    Continent, 
    Country, 
    State, 
    COUNT(*) AS customer_count
FROM customer_data
GROUP BY Continent, Country, State;
  
-- 3// overall age counts like minor,adult,old 
CREATE TABLE query3 AS
SELECT 
    CASE 
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, Birthday)) BETWEEN 20 AND 39 THEN '20-39'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, Birthday)) BETWEEN 40 AND 59 THEN '40-59'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, Birthday)) BETWEEN 60 AND 79 THEN '60-79'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, Birthday)) >= 80 THEN '80 and above'
    END AS Age_Group,
    COUNT(*) AS Count_Age_Customers
FROM customer_data
GROUP BY Age_Group;

-- Exchange_data;
-- 4// currencycode contribution 
create table query4 as SELECT 
    Currency_Code, 
    SUM(Exchange) AS Total_Contribution
FROM exchange_data
GROUP BY Currency_Code
ORDER BY Total_Contribution DESC;

-- 5// yearwise Contribution
CREATE TABLE query5 AS 
SELECT 
    EXTRACT(YEAR FROM Date) AS Year,              
    AVG(Exchange) AS Average_Rate 
FROM 
    exchange_data                     
GROUP BY 
    EXTRACT(YEAR FROM Date)                               
ORDER BY 
    Year;

-- Product_data;
-- 6// Counts of Category, Subcategory, Product Name, and Product						
create table query6 as SELECT 
    Category,
    COUNT(DISTINCT Subcategory) AS Subcategory_Count,  
    COUNT(DISTINCT Product_Name) AS Product_Name_Count,  
    COUNT(*) AS Product_Count                             
FROM 
    product_data                                        
GROUP BY 
    Category                                             
ORDER BY 
    Category;                                           

-- 7// Brands sales analyze

create table query7 as SELECT 
    Brand,                                      
    SUM(Unit_Price_USD) AS total_sales,          
    COUNT(*) AS product_count                  
FROM 
    product_data                                
GROUP BY 
    Brand                                     
ORDER BY 
    total_sales DESC;       
    
-- 8// color contribution
create table query8 as SELECT 
    Color,                                        
    COUNT(*) AS product_count                     
FROM 
    product_data                                  
GROUP BY 
    color                                        
ORDER BY 
    product_count DESC;                          
    
-- 9// Profit analyze by Subcategory
create table query9 as SELECT 
    Subcategory,                              
    SUM(Unit_Cost_USD) AS total_manufacturing_cost,   
    SUM(Unit_Price_USD) AS total_selling_cost,   
    SUM(Unit_Price_USD) - SUM(Unit_Cost_USD) AS total_profit 
FROM 
    product_data                                
GROUP BY 
    Subcategory                              
ORDER BY 
    total_profit DESC;                          
    
-- sales_data
-- 10// Overall sales in year
CREATE TABLE query10 AS 
SELECT 
    EXTRACT(YEAR FROM Order_Date) AS year,                 
    SUM(Quantity) AS total_quantity           
FROM 
    sales_data                                  
GROUP BY 
    EXTRACT(YEAR FROM Order_Date)                                       
ORDER BY 
    year;

-- 11// currecy contribution
create table query11 as SELECT 
    Currency_Code,                             
    SUM(Quantity) AS total_quantity,          
    ROUND(SUM(Quantity) / (SELECT SUM(Quantity) FROM sales_data) * 100, 2) AS contribution_percentage  
FROM 
    sales_data                            
GROUP BY 
    Currency_Code                           
ORDER BY 
    total_quantity DESC;                     

-- Stores_data
-- 12//	Total Counts of Stores by Square Meter
create table query12 as SELECT 
    Country,                                  
    COUNT(*) AS total_stores,                 
    SUM(Square_Meters) AS total_square_meter    
FROM 
    store_data                                
GROUP BY 
    Country                                  
ORDER BY 
    total_square_meter DESC;
