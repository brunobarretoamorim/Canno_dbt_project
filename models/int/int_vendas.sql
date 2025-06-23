{{
    config(
        materialized='view',
        tags=['vendas']
    )
}}

-- ======================
-- 1. Produtos vendidos
-- ======================
WITH produtos_vendas AS (

    SELECT
        p.id_pedido AS id_venda,
        p.id_cliente,
        c.nome_completo AS nome_cliente,
        c.cidade,
        c.estado,
        i.id_item,
        i.id_produto AS id_item_vendido,
        pr.nome AS nome_item,
        pr.marca AS marca_item,
        pr.categoria AS categoria_item,
        p.data_pedido AS data_venda,
        p.status_pedido AS status_venda,
        i.quantidade,
        i.preco_unitario,
        i.desconto,
        (i.quantidade * (i.preco_unitario - i.desconto)) AS valor_liquido_item,
        pg.metodo_pagamento,
        pg.status_pagamento,
        pg.valor_pago,
        'produto' AS tipo_venda
    FROM {{ ref('stg_pedidos') }} p
    LEFT JOIN {{ ref('stg_itens_pedidos') }} i ON p.id_pedido = i.id_pedido
    LEFT JOIN {{ ref('stg_produtos') }} pr ON i.id_produto = pr.id_produto
    LEFT JOIN {{ ref('stg_pagamentos') }} pg ON p.id_pedido = pg.id_pedido
    LEFT JOIN {{ ref('stg_clientes') }} c ON p.id_cliente = c.id
    WHERE p.data_pedido IS NOT NULL
      AND i.id_produto IS NOT NULL
      AND i.quantidade > 0

),

-- ======================
-- 2. Serviços vendidos
-- ======================
servicos_vendas AS (

    SELECT
        a.id_agendamento AS id_venda,
        a.id_cliente,
        c.nome_completo AS nome_cliente,
        c.cidade,
        c.estado,
        NULL AS id_item,
        s.id AS id_item_vendido,
        s.nome_servico AS nome_item,
        '' AS marca_item,
        s.categoria AS categoria_item,
        a.data_agendada AS data_venda,
        a.status_agendamento AS status_venda,
        1 AS quantidade,
        s.preco AS preco_unitario,
        0.0 AS desconto,
        (1 * (s.preco - 0.0)) AS valor_liquido_item,
        '' AS metodo_pagamento,
        'aprovado' AS status_pagamento,
        s.preco AS valor_pago,
        'servico' AS tipo_venda
    FROM {{ ref('stg_agendamentos') }} a
    LEFT JOIN {{ ref('stg_servicos') }} s ON a.id_servico = s.id
    LEFT JOIN {{ ref('stg_clientes') }} c ON a.id_cliente = c.id
    WHERE a.status_agendamento IN ('OK', 'FINALIZADO')

)

-- ======================
-- 3. Consolidado
-- ======================
SELECT * FROM produtos_vendas
--UNION ALL
--SELECT * FROM servicos_vendas
