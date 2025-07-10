-- Test Queries only --
select
    oi. product_id,
    products.category,
    products.name,
    products.brand,
    count(oi.order_id) as number_of_orders,
    oi.status

from `bigquery-public-data`.thelook_ecommerce.order_items oi
left join `bigquery-public-data`.thelook_ecommerce.products on products.id = product_id
group by oi.product_id,products.category,products.name,products.brand,oi.status
order by number_of_orders DESC, status DESC

select
        customers.country,
        count(user_id) as number_of_customers,
        status

    from `bigquery-public-data`.thelook_ecommerce.orders
    left join `bigquery-public-data`.thelook_ecommerce.users customers on customers.id = user_id 
    group by customers.country, status
    order by customers.country, number_of_customers DESC, status