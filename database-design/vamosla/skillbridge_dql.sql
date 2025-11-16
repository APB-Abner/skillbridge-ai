--------------------------------------------------------------------
-- SKILLBRIDGE.AI - SCRIPT DQL (ORACLE)
-- Consultas de exemplo
--------------------------------------------------------------------
--------------------------------------------------------------------
-- 1) INNER JOIN
-- Listar usuários e suas trilhas ativas (matrículas ativas)
--------------------------------------------------------------------
SELECT u.nome AS nome_usuario,
    t.titulo AS titulo_trilha,
    m.status,
    m.criada_em
FROM matriculas m
    INNER JOIN users u ON u.id = m.user_id
    INNER JOIN trilhas t ON t.id = m.trilha_id
WHERE m.status = 'ATIVA';
--------------------------------------------------------------------
-- 2) GROUP BY + FUNÇÃO DE GRUPO
-- Quantidade de matrículas e média de conclusão por trilha
--------------------------------------------------------------------
SELECT t.titulo AS titulo_trilha,
    COUNT(m.id) AS total_matriculas,
    AVG(p.percentual_conclusao) AS media_percentual_conclusao
FROM trilhas t
    INNER JOIN matriculas m ON m.trilha_id = t.id
    INNER JOIN progresso_modulo p ON p.matricula_id = m.id
GROUP BY t.titulo
ORDER BY media_percentual_conclusao DESC;
--------------------------------------------------------------------
-- 3) LEFT OUTER JOIN + WHERE + ORDER BY
-- Listar todas as trilhas ativas e quantidade de matrículas ativas,
-- incluindo trilhas sem nenhum aluno ainda
--------------------------------------------------------------------
SELECT t.titulo AS titulo_trilha,
    NVL(COUNT(m.id), 0) AS total_matriculas_ativas
FROM trilhas t
    LEFT OUTER JOIN matriculas m ON m.trilha_id = t.id
    AND m.status = 'ATIVA'
WHERE t.ativa = 'S'
GROUP BY t.titulo
ORDER BY total_matriculas_ativas DESC,
    t.titulo;