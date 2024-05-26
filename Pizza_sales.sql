-- 1. Retrieve the total number of orders placed.

select count(orders.order_id) as total_orders from orders;


-- 	2. Calculate the total revenue generated from pizza sales.

select round(sum(pizzas.price * order_details.quantity),2) as total_revenue
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id;


-- 3. Identify the highest-priced pizza.

select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;


-- 	4. Identify the most common pizza size ordered.

-- select order_details.quantity, count(quantity)
-- from order_details group by quantity;

-- select pizzas.size, count(pizzas.size
-- from pizzas group by(pizzas.size);

SELECT 
    pizzas.size, COUNT(order_details.quantity) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;


-- 5. List the top 5 most ordered pizza types along with their quantities.

select pizza_types.name, sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by quantity desc limit 5;

-- Intermediate:
-- 6. Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, sum(order_details.quantity) as total_quantity_ordered
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id =	pizzas.pizza_id
group by pizza_types.category order by total_quantity_ordered desc;


-- 7. Determine the distribution of orders by hour of the day.

select hour(order_time) as hour, count(order_id) as distribution_of_orders
from orders 
group by hour(order_time);	

-- 8. Join relevant tables to find the category-wise distribution of pizzas.

select pizza_types.category, count(pizza_types.name)
from pizza_types
group by pizza_types.category;

-- 9. Group the orders by date and calculate the average number of pizzas ordered per day.

select round(avg(orders),0) from
(select orders.order_date, sum(order_details.quantity) as orders
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity;


-- 10. Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name, sum(pizzas.price * order_details.quantity) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by revenue desc limit 3;

-- Advance
-- 11. Calculate the percentage contribution of each pizza type to total revenue.

select pizza_types.category, round((sum(pizzas.price * order_details.quantity) / (select 
round(sum(pizzas.price * order_details.quantity),2) as total_revenue
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id))*100,2) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue desc;


-- 12. Analyze the cumulative revenue generated over time.

select order_date, sum(revenue) over(order by order_date) as cum_revenue from
(select orders.order_date, round(sum(pizzas.price * order_details.quantity),2) as revenue
from orders join order_details
on orders.order_id = order_details.order_id
join pizzas
on pizzas.pizza_id = order_details.pizza_id
group by orders.order_date) as sales;

-- 13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category,name,revenue 
from
(select category, name, revenue,
rank() over(partition by category order by revenue desc) as ranks
from
(select pizza_types.category , pizza_types.name , sum(pizzas.price * order_details.quantity) as revenue 
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a) as b
where ranks<=3;










 