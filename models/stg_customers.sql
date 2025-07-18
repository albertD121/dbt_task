select
    id as customer_id,
    first_name,
    last_name,
    age,
    gender,
    state,
    postal_code,
    country,
    traffic_source

from {{ source('thelook_ecommerce', 'users') }}
order by customer_id