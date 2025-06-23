{{
    config(
        materialized='table',
        tags=['vendas']
    )
}}

WITH base AS (

    SELECT
        id_venda,
        tipo_venda,
        id_cliente,
        nome_cliente,
        cidade,
        estado,
        id_item_vendido,
        nome_item,
        marca_item,
        categoria_item,
        data_venda,
        FORMAT_DATE('%Y-%m', data_venda) AS ano_mes_venda,
        quantidade,
        preco_unitario,
        desconto,
        valor_liquido_item,
        metodo_pagamento,
        status_pagamento,
        valor_pago,
        CASE 
            WHEN status_pagamento = 'aprovado' THEN 'SIM'
            ELSE 'NÃO'
        END AS flag_pago
    FROM {{ ref('int_vendas') }}
    WHERE data_venda IS NOT NULL
      AND valor_liquido_item > 0
      AND (status_pagamento = 'APROVADO' OR status_pagamento IS NULL) -- IS NULL porque serviço não tem pagamento registrado
)

SELECT
    *
FROM base
