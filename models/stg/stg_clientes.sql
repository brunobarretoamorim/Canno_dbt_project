{{ 
    config(
        tags=['vendas']
    ) 
}}
WITH clientes_raw AS (
    SELECT
        id,
        nome_completo,
        e_mail,
        tel,
        nasc,
        genero,
        cep,
        cidade,
        estado,
        criado_em
    FROM {{ source('canno', 'clientes_raw') }}
)

SELECT
    *
FROM clientes_raw
WHERE id IS NOT NULL
