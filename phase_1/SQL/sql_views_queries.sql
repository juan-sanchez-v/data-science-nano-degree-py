-- Create View Syntax

Create VIEW MyFistView
As 
Select *
From table_name;

-- Example
Create View Sales_Rep_NE
AS
Select s.id, s.name as Rep_Name, r.name as Region_Name
From sales_reps sales_reps
JOIN region r
On s.region_id = r.id
AND r.name = 'Northeast';

CREATE VIEW V2
AS
SELECT r.name region, a.name account, 
       o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;



