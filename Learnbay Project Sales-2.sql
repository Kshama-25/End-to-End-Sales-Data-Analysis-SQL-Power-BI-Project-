CREATE DATABASE Learnbay_P;

USE Learnbay_P;
SELECT * FROM INVENTORY;
SELECT * FROM PRODUCTS;
SELECT * FROM SALES;
SELECT * FROM STORES;

     --Monthlywise sales trend over the stores, location for both year ( 2022 & 2023)--

SELECT
    st.Store_Name,
    st.Store_Location,
    YEAR(CONVERT(date, s.Date, 105)) AS Sales_Year,
    MONTH(CONVERT(date, s.Date, 105)) AS Month_Number,
    DATENAME(MONTH, CONVERT(date, s.Date, 105)) AS Sales_Month,
    CAST(SUM(CAST(s.Units AS INT)) AS INT) AS Total_Units_Sold
FROM SALES s
JOIN STORES st ON s.Store_ID = st.Store_ID
WHERE YEAR(CONVERT(date, s.Date, 105)) IN (2022, 2023)
GROUP BY
    st.Store_Name,
    st.Store_Location,
    YEAR(CONVERT(date, s.Date, 105)),
    MONTH(CONVERT(date, s.Date, 105)),
    DATENAME(MONTH, CONVERT(date, s.Date, 105))
ORDER BY
    Sales_Year,
    Month_Number;
   


-- sTill want more clearnce for this--

	-2--Find the sales trend over the different Stores and find the best and least five stores as per the performance in one query.---

SELECT Store_Name, Total_Units_Sold, Performance_Category
FROM (
    SELECT TOP 5
        st.Store_Name,
        SUM(CAST(s.Units AS INT)) AS Total_Units_Sold,
        'Top 5 Store' AS Performance_Category
    FROM SALES s
    JOIN STORES st ON s.Store_ID = st.Store_ID
    GROUP BY st.Store_Name
    ORDER BY SUM(CAST(s.Units AS INT)) DESC
) AS TopStores

UNION ALL

SELECT Store_Name, Total_Units_Sold, Performance_Category
FROM (
    SELECT TOP 5
        st.Store_Name,
        SUM(CAST(s.Units AS INT)) AS Total_Units_Sold,
        'Bottom 5 Store' AS Performance_Category
    FROM SALES s
    JOIN STORES st ON s.Store_ID = st.Store_ID
    GROUP BY st.Store_Name
    ORDER BY SUM(CAST(s.Units AS INT)) ASC
) AS BottomStores

ORDER BY Total_Units_Sold DESC;


	3--Does the area of store location effect the sales of the product--

	SELECT 
    st.Store_Location,
    SUM(CAST(s.Units AS INT)) AS Total_Units_Sold
FROM SALES s
JOIN STORES st ON s.Store_ID = st.Store_ID
GROUP BY st.Store_Location
ORDER BY Total_Units_Sold DESC;


	--Find out the report of Product and Store relationship towards sale.---

	SELECT 
    st.Store_Name,
    p.Product_Name,
    SUM(CAST(s.Units AS INT)) AS Total_Units_Sold
FROM SALES s
JOIN STORES st ON s.Store_ID = st.Store_ID
JOIN PRODUCTS p ON s.Product_ID = p.Product_ID
GROUP BY st.Store_Name, p.Product_Name
ORDER BY Total_Units_Sold DESC;



	--Is there any category that outshines the rest .High demanded product among all locations as per the sales.--

	
SELECT 
    p.Product_Category,
    SUM(CAST(s.Units AS INT)) AS Total_Units_Sold
FROM SALES s
JOIN PRODUCTS p ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Category
ORDER BY Total_Units_Sold DESC;


---High demanded product among all locations as per the sales.--
	
	SELECT TOP 1 
    p.Product_Category,
    SUM(CAST(s.Units AS INT)) AS Total_Units_Sold
FROM SALES s
JOIN PRODUCTS p ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Category
ORDER BY Total_Units_Sold DESC;

	---Find out the avg_inventory as per the store and product.
 
SELECT 
    i.Store_ID,
    i.Product_ID,
    AVG(CAST(i.Stock_On_Hand AS INT)) AS Avg_Inventory
FROM INVENTORY i
GROUP BY i.Store_ID, i.Product_ID
ORDER BY Avg_Inventory DESC;
