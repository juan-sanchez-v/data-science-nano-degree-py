Select a.name, AVG(o.standard_qty) avg_standard_paper, AVG(o.gloss_qty) avg_gloss_paper, AVG(o.poster_qty) avg_poster_paper
From accounts a
Join orders o
On a.id = o.account_id
Group by a.name;


Select a.name, AVG(o.standard_amt_usd) avg_standard_amt_spent, AVG(o.gloss_amt_usd) avg_gloss_amt_spent, AVG(o.poster_amt_usd) avg_poster_amt_spent
From accounts a
Join orders o
On a.id = o.account_id
Group by a.name;

Select s.name, w.channel, Count(w.*) channel_use_count
From sales_reps s
Join accounts a
On s.id = a.sales_rep_id
Join web_events w
On w.account_id = a.id
Group By s.name, w.channel
Order by channel_use_count DESC;


Select r.name, w.channel, Count(w.*) channel_use_count
From sales_reps s
Join accounts a
On s.id = a.sales_rep_id
Join web_events w
On w.account_id = a.id
Join region r
On s.region_id = r.id
Group By r.name, w.channel
Order by channel_use_count DESC;
