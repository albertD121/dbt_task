select
    customers.country,
    count(order_id) as number_of_orders,
    status

from {{ source('thelook_ecommerce', 'orders') }}
left join customers on customer_id = user_id 
group by customers.country, status
order by customers.country, number_of_orders DESC, status