{{ 
    config(
        tags=['vendas']
    ) 
}}

WITH clientes_campanhas_raw AS (
    SELECT
        cliente,
        campanha,
        CASE 
            WHEN SAFE.PARSE_DATE('%d/%m/%Y', TRIM(data)) IS NOT NULL THEN SAFE.PARSE_DATE('%d/%m/%Y', TRIM(data))
            WHEN SAFE.PARSE_DATE('%Y-%m-%d', TRIM(data)) IS NOT NULL THEN SAFE.PARSE_DATE('%Y-%m-%d', TRIM(data))
            ELSE NULL
        END AS data
    FROM {{ source('canno', 'clientes_campanhas_raw') }}
)

SELECT
    cliente,
    campanha,
    data
FROM clientes_campanhas_raw
WHERE cliente IS NOT NULL
  AND campanha IS NOT NULL
