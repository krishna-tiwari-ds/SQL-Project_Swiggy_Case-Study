#Find the customers who have never ordered#

select name from users where user_id not in (select user_id from orders);
select* from menu;
select*  from restaurants;
select* from food;
select* from users;
select* from orders;

#Average Price/dish#

select f_id,avg(price) from menu group by f_id;
select f_name, AVG(price) as 'Avg. Price'  from menu m
join food f
on m.f_id=f.f_id
group by m.f_id


#Restaurants with monthly sales>500 rs#

select r.r_name, sum(amount) as 'revenue' 
from orders o
join restaurants r
on o.r_id=r.r_id
where monthname (date) like 'JUNE'
group by o.r_id
having revenue > 500



##show all orders with order details for a perticular customer in a perticular date range.##

select* 
from orders o
join restaurants r
on r.r_id = o.r_id
join order_details od
on o.order_id=od.order_id
join food f
on f.f_id=od.f_id
where user_id= (select user_id from users where name like 'Ankit')
and (date >'2022-06-10' and date < '2022-07-10');


#Find restaurants with max repeated customers#

select r.r_name, count(*) as 'loyal_customers'
from(
select r_id,user_id,count(*) as 'visits'
from orders
group by r_id, user_id
having visits>1
) t
join restaurants r
ON r.r_id =t.r_id
group by t.r_id
order by loyal_customers DESC LIMIT 1


#
select month, ((revenue-prev)/prev)*100 from(
with sales as 
(
	select monthname (date) as 'month',sum(amount) as 'revenue'
    from orders 
    group by month
    order by month(date)
    )
select month,revenue,LAG (revenue,1) over(order by revenue) as prev from sales)t


# Customer--> favourite food

with temp as 
(
	select o.user_id ,od.f_id, count(*) as 'frequency'
	from orders o
	join order_details od
	on o.order_id = od.order_id
	group by o.user_id,od.f_id
)
select u.name,f.f_name, t1.frequency from 
temp t1
join users u
on u.user_id= t1.user_id
join food f
on f.f_id = t1.f_id
where t1.frequency=(
	select MAX (frequency)
    from temp t2
    where t2.user_id=t1.user_id
);




with temp as (
    Select o.user_id, od.f_id, count(*) as 'frequency'
    from orders o
    join order_details od
    on o.order_id = od.order_id
    group by o.user_id, od.f_id
)



select u.name, f.f_name, t1.frequency
from temp t1
join users u
on u.user_id=t1.user_id
join food f
on f.f_id=t1.f_id
where t1.frequency = (
select max(frequency)
from temp t2
where t2.user_id=t1.user_id);




select sum(user_id) 
from users
