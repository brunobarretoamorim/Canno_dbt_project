{{ 
    config(
        tags=['vendas']
    ) 
}}

WITH agendamentos_raw AS (
    SELECT
        SAFE_CAST(REPLACE(id_agendamento,'A','1') AS INT64) id_agendamento,
        id_cliente,
        id_servico,
        CASE 
            WHEN SAFE.PARSE_DATE('%d/%m/%Y', TRIM(data_agendada)) IS NOT NULL THEN SAFE.PARSE_DATE('%d/%m/%Y', TRIM(data_agendada))
            WHEN SAFE.PARSE_DATE('%Y-%m-%d', TRIM(data_agendada)) IS NOT NULL THEN SAFE.PARSE_DATE('%Y-%m-%d', TRIM(data_agendada))
            ELSE NULL
        END AS data_agendada,
        IFNULL(UPPER(TRIM(hora)), 'NÃO DEFINIDA') AS hora,
        IFNULL(UPPER(TRIM(status_agendamento)), 'NÃO DEFINIDO') AS status_agendamento
    FROM {{ source('canno', 'agendamentos_raw') }}
)

SELECT
    id_agendamento,
    id_cliente,
    id_servico,
    data_agendada,
    hora,
    status_agendamento
FROM agendamentos_raw
WHERE id_agendamento IS NOT NULL
  AND id_cliente IS NOT NULL
  AND id_servico IS NOT NULL
