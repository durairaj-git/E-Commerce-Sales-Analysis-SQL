#1. Total Revenue Generated
SELECT SUM(p.price * oi.quantity) AS total_revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id;

#2. Which Month Generated the Highest Revenue?
SELECT
    MONTHNAME(o.order_date) AS month,
    SUM(p.price * oi.quantity) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY MONTHNAME(o.order_date)
ORDER BY revenue DESC
LIMIT 1;

#3. Monthly Sales Trend
SELECT
    YEAR(o.order_date) AS year,
    MONTHNAME(o.order_date) AS month,
    SUM(p.price * oi.quantity) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date), MONTHNAME(o.order_date)
ORDER BY YEAR(o.order_date), MONTH(o.order_date);
#4. Revenue Across Product Categories
SELECT
    p.category,
    SUM(p.price * oi.quantity) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY revenue DESC;
#5. Average Order Value
SELECT
AVG(order_total) AS average_order_value
FROM
(
SELECT
o.order_id,
SUM(p.price * oi.quantity) AS order_total
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY o.order_id
) t;
#6. Top 10 Customers by Total Spending
SELECT
c.customer_name,
SUM(p.price * oi.quantity) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 10;
#7. Customer with Highest Number of Orders
SELECT
c.customer_name,
COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC
LIMIT 1;
#8. Customers Who Ordered More Than 5 Times
SELECT
c.customer_name,
COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 5;
#9. State with Highest Number of Customers
SELECT
state,
COUNT(customer_id) AS total_customers
FROM customers
GROUP BY state
ORDER BY total_customers DESC
LIMIT 1;
#10. Customers Who Never Placed an Order
SELECT
c.customer_name
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
#11. Top 10 Selling Products by Revenue
SELECT
p.product_name,
SUM(p.price * oi.quantity) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;
#12. Products Sold in Highest Quantity
SELECT
p.product_name,
SUM(oi.quantity) AS total_quantity
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC;
#13. Category with Highest Revenue
SELECT
p.category,
SUM(p.price * oi.quantity) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY revenue DESC
LIMIT 1;
#14. Products Never Sold
SELECT
p.product_name
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;
#15. Least Selling Products
SELECT
p.product_name,
SUM(oi.quantity) AS total_quantity
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity ASC;
#16. Orders Placed Each Month
SELECT
MONTHNAME(order_date) AS month,
COUNT(order_id) AS total_orders
FROM orders
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY MONTH(order_date);

#17. Day with Highest Sales
SELECT
o.order_date,
SUM(p.price * oi.quantity) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY o.order_date
ORDER BY revenue DESC
LIMIT 1;
#18. Largest Order by Revenue
SELECT
o.order_id,
SUM(p.price * oi.quantity) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY o.order_id
ORDER BY revenue DESC
LIMIT 1;
#19. Orders Above Average Order Value (Subquery)
SELECT *
FROM
(
SELECT
o.order_id,
SUM(p.price * oi.quantity) AS order_total
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY o.order_id
) t
WHERE order_total >
(
SELECT AVG(order_total)
FROM
(
SELECT
SUM(p.price * oi.quantity) AS order_total
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY o.order_id
) avg_table
);

#20. Revenue for Every Order
SELECT
o.order_id,
SUM(p.price * oi.quantity) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY o.order_id
ORDER BY o.order_id;

#21. Which state generated the highest revenue?
SELECT
    c.state,
    SUM(p.price * oi.quantity) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY c.state
ORDER BY revenue DESC
LIMIT 1;
#22. Which city has the most customers?
SELECT
    city,
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC
LIMIT 1;
#23. Contribution (%) of each category to total revenue
SELECT
    category,
    revenue,
    ROUND(
        revenue * 100 /
        SUM(revenue) OVER(),2
    ) AS contribution_percentage
FROM
(
SELECT
    p.category,
    SUM(p.price * oi.quantity) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY p.category
)t;
#24. Rank Products by Revenue
SELECT
    product_name,
    revenue,
    RANK() OVER(ORDER BY revenue DESC) AS product_rank
FROM
(
SELECT
    p.product_name,
    SUM(p.price*oi.quantity) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY p.product_name
)t;
#25. Top 3 Products in Each Category
SELECT *
FROM
(
SELECT
    p.category,
    p.product_name,
    SUM(p.price*oi.quantity) revenue,
    RANK() OVER(
        PARTITION BY p.category
        ORDER BY SUM(p.price*oi.quantity) DESC
    ) rnk
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY p.category,p.product_name
)t
WHERE rnk<=3;
#26. Top 5 Customers by Total Spending
SELECT
    c.customer_name,
    SUM(p.price*oi.quantity) total_spent
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON o.order_id=oi.order_id
JOIN products p
ON oi.product_id=p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 5;
#27. Repeat Customers
SELECT
    c.customer_name,
    COUNT(o.order_id) total_orders
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id)>1;
#28. Customer Lifetime Value (CLV)
SELECT
    c.customer_name,
    SUM(p.price*oi.quantity) AS customer_lifetime_value
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON o.order_id=oi.order_id
JOIN products p
ON oi.product_id=p.product_id
GROUP BY c.customer_name
ORDER BY customer_lifetime_value DESC;
#29. Month with Highest Growth (LAG)
WITH monthly_sales AS
(
SELECT
    YEAR(o.order_date) yr,
    MONTH(o.order_date) mn,
    SUM(p.price*oi.quantity) revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
JOIN products p
ON oi.product_id=p.product_id
GROUP BY YEAR(o.order_date),MONTH(o.order_date)
)

SELECT
    yr,
    mn,
    revenue,
    revenue-
    LAG(revenue) OVER(ORDER BY yr,mn)
    AS growth
FROM monthly_sales;

#30. Running Total Revenue
SELECT
    order_date,
    daily_sales,
    SUM(daily_sales)
    OVER(
        ORDER BY order_date
    ) AS running_total
FROM
(
SELECT
    o.order_date,
    SUM(p.price*oi.quantity) daily_sales
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
JOIN products p
ON oi.product_id=p.product_id
GROUP BY o.order_date
)t;


SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    COUNT(*) AS times_purchased_together
FROM order_items oi1
JOIN order_items oi2
ON oi1.order_id = oi2.order_id
AND oi1.product_id < oi2.product_id
JOIN products p1
ON oi1.product_id = p1.product_id
JOIN products p2
ON oi2.product_id = p2.product_id
GROUP BY
    p1.product_name,
    p2.product_name
ORDER BY times_purchased_together DESC;
#36. Calculate the Percentage Contribution of Every Product (Window Function)

Purpose: Find how much each product contributes to the total revenue.

SELECT
    product_name,
    revenue,
    ROUND(
        revenue * 100.0 /
        SUM(revenue) OVER (), 2
    ) AS contribution_percentage
FROM
(
    SELECT
        p.product_name,
        SUM(p.price * oi.quantity) AS revenue
    FROM products p
    JOIN order_items oi
    ON p.product_id = oi.product_id
    GROUP BY p.product_name
) t
ORDER BY contribution_percentage DESC;
#37. Find Customers Whose Spending Is Above the Average Customer Spending (Subquery)

Purpose: Identify high-value customers.

SELECT *
FROM
(
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(p.price * oi.quantity) AS total_spent
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_items oi
    ON o.order_id = oi.order_id
    JOIN products p
    ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
) customer_sales
WHERE total_spent >
(
    SELECT AVG(total_spent)
    FROM
    (
        SELECT
            SUM(p.price * oi.quantity) AS total_spent
        FROM customers c
        JOIN orders o
        ON c.customer_id = o.customer_id
        JOIN order_items oi
        ON o.order_id = oi.order_id
        JOIN products p
        ON oi.product_id = p.product_id
        GROUP BY c.customer_id
    ) avg_sales
);
#38. Identify Inactive Customers (No Orders in the Last 6 Months)

#Purpose: Find customers who haven't purchased recently.

SELECT
    c.customer_id,
    c.customer_name,
    MAX(o.order_date) AS last_order_date
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING
    MAX(o.order_date) IS NULL
    OR MAX(o.order_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
#39. Find the Top-Selling Product in Every State


SELECT
    state,
    product_name,
    revenue
FROM
(
    SELECT
        c.state,
        p.product_name,
        SUM(p.price * oi.quantity) AS revenue,
        RANK() OVER
        (
            PARTITION BY c.state
            ORDER BY SUM(p.price * oi.quantity) DESC
        ) AS rnk
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_items oi
    ON o.order_id = oi.order_id
    JOIN products p
    ON oi.product_id = p.product_id
    GROUP BY
        c.state,
        p.product_name
) ranked_products
WHERE rnk = 1
ORDER BY state;

#40. Build a Sales Dashboard Dataset Using SQL Only

#Purpose: Create a single dataset for importing into Power BI.

SELECT
    o.order_id,
    o.order_date,

    c.customer_id,
    c.customer_name,
    c.city,
    c.state,

    p.product_id,
    p.product_name,
    p.category,

    oi.quantity,
    p.price,

    (oi.quantity * p.price) AS sales_amount

FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id

JOIN order_items oi
ON o.order_id = oi.order_id

JOIN products p
ON oi.product_id = p.product_id

ORDER BY
    o.order_date,
    o.order_id;