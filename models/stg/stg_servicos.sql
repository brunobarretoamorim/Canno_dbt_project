{{ 
    config(
        tags=['vendas']
    ) 
}}

WITH servicos_raw AS (
    SELECT
        id,
        IFNULL(UPPER(TRIM(nome_servico)), 'NÃO DEFINIDO') AS nome_servico,
        IFNULL(UPPER(TRIM(categoria)), 'NÃO DEFINIDA') AS categoria,
        SAFE_CAST(preco AS FLOAT64) AS preco,
        IFNULL(SAFE_CAST(duracao AS INT64), 0) AS duracao,
        IFNULL(UPPER(TRIM(responsavel)), 'NÃO DEFINIDO') AS responsavel
    FROM {{ source('canno', 'servicos_raw') }}
)

SELECT
    id,
    nome_servico,
    categoria,
    preco,
    duracao,
    responsavel
FROM servicos_raw
WHERE id IS NOT NULL
