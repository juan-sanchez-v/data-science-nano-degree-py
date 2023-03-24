-- Provide a table for all web_events associated with the account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.

Select a.primary_poc, w.occurred_at, w.channel, a.name
From accounts a
Join web_events w 
on a.id = w.account_id
Where a.name = 'Walmart';


-- Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to the account name.

Select r.name as region_name, s.name as sales_rep_name, a.name as acc_name
From region r
Join sales_reps s
On r.id = s.region_id
Join accounts a
On a.sales_rep_id = s.id
ORDER BY a.name;

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.

Select r.name as region_name, a.name as acc_name, o.total_amt_usd / (o.total + 0.01) as unit_price
From region r
Join sales_reps s
On r.id = s.region_id
Join accounts a
On a.sales_rep_id = s.id
Join orders o
On o.account_id = a.id;

-- NOTE: You can filter a table by putting the filtering condition in the ON clause. This will filter the table before joining it.

SELECT orders.*, accounts.*
FROM orders
LEFT JOIN accounts
ON orders.account_id = accounts.id 
AND accounts.sales_rep_id = 321500

-- In the example above, the orders table will be filtered before the join takes place. It is like if you are building a new table where the filter is applied to then use it to join it with the first table.

-- FINAL QUIZ
-- Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to the account name.

Select r.name as region, s.name as rep, a.name as account
From region r
Join sales_reps s
On r.id = s.region_id
Join accounts a
On s.id = sales_rep_id
Where r.name = 'Midwest'
Order by a.name;


-- Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to the account name.

Select r.name as region, s.name as rep, a.name as account
From region r
Join sales_reps s
On r.id = s.region_id
Join accounts a
On s.id = sales_rep_id
Where r.name = 'Midwest' and s.name like 'S%'
Order by a.name;

-- 3 Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to the account name.

Select r.name as region, s.name as rep, a.name as account
From region r
Join sales_reps s
On r.id = s.region_id
Join accounts a
On s.id = sales_rep_id
Where r.name = 'Midwest' and s.name like '% K%'
Order by a.name;

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).

Select r.name as regionName, a.name as accountName, o.total_amt_usd / (o.total + 0.01) as unitPrice
From region r
Join sales_reps s
On r.id = s.region_id
Join accounts a
On a.sales_rep_id = s.id
Join orders o
On o.account_id = a.id
Where o.standard_qty > 100;

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

Select r.name as regionName, a.name as accountName, o.total_amt_usd / (o.total + 0.01) as unitPrice
From region r
Join sales_reps s
On r.id = s.region_id
Join accounts a
On a.sales_rep_id = s.id
Join orders o
On o.account_id = a.id
Where o.standard_qty > 100 AND poster_qty > 50
Order by unitPrice;

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

Select r.name as regionName, a.name as accountName, o.total_amt_usd / (o.total + 0.01) as unitPrice
From region r
Join sales_reps s
On r.id = s.region_id
Join accounts a
On a.sales_rep_id = s.id
Join orders o
On o.account_id = a.id
Where o.standard_qty > 100 AND poster_qty > 50
Order by unitPrice DESC;

-- What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. You can try SELECT DISTINCT to narrow down the results to only the unique values.

Select DISTINCT a.name as accountName, w.channel
From accounts a
Join web_events w
On a.id = w.account_id 
where a.id = 1001;

-- Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.

Select w.occurred_at, a.name as accountName, o.total, o.total_amt_usd
From orders o
Join accounts a
On a.id = o.account_id 
Join web_events w
On a.id = w.account_id
where w.occurred_at BETWEEN '2015-01-01' AND '2016-01-01';