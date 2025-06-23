{{ 
    config(
        tags=['vendas']
    ) 
}}
WITH produtos_raw AS (
    SELECT
        ID_PRODUTO,
        IFNULL(UPPER(TRIM(NOME)),'NÃO DEFINIDA')NOME,
        IFNULL(UPPER(TRIM(MARCA)),'SEM MARCA')MARCA,
        IFNULL(SAFE_CAST(PRECO AS FLOAT64),0) AS PRECO,
        CASE WHEN UPPER(TRIM(disponivel_em_estoque)) IN ('1','TRUE','SIM') THEN TRUE
             ELSE FALSE END DISPONIVEL_EM_ESTOQUE,
        IFNULL(UPPER(TRIM(CATEGORIA)),'NÃO DEFINIDA')CATEGORIA
    FROM {{ source('canno', 'produtos_raw') }}
)

SELECT
    *
FROM produtos_raw
WHERE id_produto IS NOT NULL
