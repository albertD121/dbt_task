select
    oi. product_id,
    products.category,
    products.name,
    products.brand,
    count(oi.order_id) as number_of_orders,
    oi.status

from {{ source('thelook_ecommerce', 'order_items') }} oi
left join from {{ source('thelook_ecommerce', 'products') }} on products.id = product_id
group by oi.product_id,products.category,products.name,products.brand,oi.status
order by number_of_orders DESC, status DESC