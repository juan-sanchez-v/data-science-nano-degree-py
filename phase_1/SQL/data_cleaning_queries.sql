-- Data cleaning is a very important part of any data project
-- Data cleaning: Massaging raw data to be usable for analysis.
-- Data cleaning is used all the time.
-- Normalization: Standardizing or “cleaning up a column” by transforming it in some way to make it ready for analysis. A few normalization techniques are below:
-- Adjusting a column that includes multiple currencies to one common currency
-- Adjusting the varied distribution of a column value by transforming it into a z-score
-- Converting all price into a common metric (e.g., price per ounce)
-- Left: Extracts a number of characters from a string starting from the left
-- Right: Extracts a number of characters from a string starting from the right
-- Substr: Extracts a substring from a string (starting at any position)
-- Position: Returns the position of the first occurrence of a substring in a string
-- Strpos: Returns the position of a substring within a string
-- Concat: Adds two or more expressions together
-- Cast: Converts a value of any type into a specific, different data type
-- Coalesce: Returns the first non-null value in a list
-- Extracting Information Functions
-- Left
Left(string, number_of_chars)
Select LEFT(UPPER(name), 1) as initial,
    Count(*)
From accounts
Group by 1
Order by 1;
-- Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and the second group of those company names that start with a letter. What proportion of company names start with a letter?
SELECT SUM(num) nums,
    SUM(letter) letters
FROM (
        SELECT name,
            CASE
                WHEN LEFT(UPPER(name), 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') -- Used to check if the name starts with a number. Set num to 1
                THEN 1
                ELSE 0
            END AS num,
            CASE
                WHEN LEFT(UPPER(name), 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') -- If name starts with number, set letter to 1
                THEN 0
                ELSE 1
            END AS letter
        FROM accounts
    ) t1;
-- Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?
With t1 AS (
    SELECT name,
        CASE
            WHEN LEFT(UPPER(name), 1) IN ('A', 'E', 'I', 'O', 'U') THEN 1
            ELSE 0
        END AS vowels,
        CASE
            WHEN LEFT(UPPER(name), 1) IN ('A', 'E', 'I', 'O', 'U') THEN 0
            ELSE 1
        END AS other
    FROM accounts
)
Select SUM(t1.vowels) vowels,
    SUM(t1.other) other
From t1 

-- Same exaple but using a second table in the with to calculate the percentage
    With t1 AS (
        SELECT name,
            CASE
                WHEN LEFT(UPPER(name), 1) IN ('A', 'E', 'I', 'O', 'U') THEN 1
                ELSE 0
            END AS vowels,
            CASE
                WHEN LEFT(UPPER(name), 1) IN ('A', 'E', 'I', 'O', 'U') THEN 0
                ELSE 1
            END AS other
        FROM accounts
    ),
    t2 AS (
        Select Cast(Count(*) as decimal)
        from accounts
    )
Select SUM(t1.vowels) vowels,
    SUM(t1.other) other,
    SUM(t1.vowels) / (
        select *
        from t2
    ) as vowels_perc,
    SUM(t1.other) / (
        select *
        from t2
    ) as other_perc
From t1;
-- Right
Right(string, number_of_chars)
Select Right(website, 3) as domain,
    Count(*) as ct
From accounts
Group By 1
Order By 2 DESC;
-- Substr
substr(string, start, length) 
-- || means concatenate as well
SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2)) new_date
FROM sf_crime_data;


SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;
-- Create a unique identifier function
-- Concat
CONCAT(string1, string2, string3) -- From the accounts table, display the name of the client, the coordinate as concatenated (latitude, longitude), email id of the primary point of contact as <first letter of the primary_poc><last letter of the primary_poc>@<extracted name and domain from the website>.
Select a.name client_name,
    CONCAT('(', a.lat, ',', a.long, ')') as coordinate,
    CONCAT(
        LEFT(a.primary_poc, 1),
        RIGHT(a.primary_poc, 1),
        '@',
        Substr(a.website, 5)
    ) as email_id
From accounts a;
-- Converting data to different format function
-- Cast
Cast(columnname as datatype) Cast(salary as int) 

-- SPLIT
String_split(columnname, ',') 

-- ---------------- Advanced Cleaning functions ----------------------
-- Position : Returns the position of the fist occurrence o a substring in a string

position(substing in string) Position("$" IN student_information) as salary_starting_position 

-- STRPOS
STRPOS(columnname, substring) 
Select name,  LEFT(name, STRPOS(name, ' ')-1) as first, Substr(name, (STRPOS(name, ' '))) as last
From sales_reps
Limit 10;


-- Coalesce: If there are multiple columns that have a combination of null and non-null values and the user needs to extract the first non-null value, he/she can use the coalesce function.
Coalesce(val1, val2, val3,...) Coalesce(column1, column2, column3,...) -- Usefull when you want to compute or extract a column from multiple columns where only on of them is not NULL.
SELECT COALESCE(a.id, a.id) filled_id,
    a.name,
    a.website,
    a.lat,
    a.long,
    a.primary_poc,
    a.sales_rep_id,
    o.*
FROM accounts a
    LEFT JOIN orders o ON a.id = o.account_id
WHERE o.total IS NULL;
-- Set null to 0 using Coalesce
SELECT COALESCE(a.id, a.id) filled_id,
    a.name,
    a.website,
    a.lat,
    a.long,
    a.primary_poc,
    a.sales_rep_id,
    COALESCE(o.account_id, a.id) account_id,
    o.occurred_at,
    COALESCE(o.standard_qty, 0) standard_qty,
    COALESCE(o.gloss_qty, 0) gloss_qty,
    COALESCE(o.poster_qty, 0) poster_qty,
    COALESCE(o.total, 0) total,
    COALESCE(o.standard_amt_usd, 0) standard_amt_usd,
    COALESCE(o.gloss_amt_usd, 0) gloss_amt_usd,
    COALESCE(o.poster_amt_usd, 0) poster_amt_usd,
    COALESCE(o.total_amt_usd, 0) total_amt_usd
FROM accounts a
    LEFT JOIN orders o ON a.id = o.account_id
WHERE o.total IS NULL;
-- Set null values to 0 and fill in the null ids 
SELECT COALESCE(a.id, a.id) filled_id,
    a.name,
    a.website,
    a.lat,
    a.long,
    a.primary_poc,
    a.sales_rep_id,
    COALESCE(o.account_id, a.id) account_id,
    o.occurred_at,
    COALESCE(o.standard_qty, 0) standard_qty,
    COALESCE(o.gloss_qty, 0) gloss_qty,
    COALESCE(o.poster_qty, 0) poster_qty,
    COALESCE(o.total, 0) total,
    COALESCE(o.standard_amt_usd, 0) standard_amt_usd,
    COALESCE(o.gloss_amt_usd, 0) gloss_amt_usd,
    COALESCE(o.poster_amt_usd, 0) poster_amt_usd,
    COALESCE(o.total_amt_usd, 0) total_amt_usd
FROM accounts a
    LEFT JOIN orders o ON a.id = o.account_id;