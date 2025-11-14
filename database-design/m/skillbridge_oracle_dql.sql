-- SkillBridge.AI — Oracle 19c+ DQL (Consultas pedidas)
-- 1) Uma consulta SQL utilizando INNER JOIN
SELECT u.full_name AS aluno,
       c.code      AS curso,
       e.status,
       e.enrolled_at
FROM enrollments e
INNER JOIN users u   ON u.id = e.user_id
INNER JOIN courses c ON c.id = e.course_id
ORDER BY e.enrolled_at DESC;

-- 2) Consulta com GROUP BY e funções de grupo
-- Média de avaliação por mentor (a partir do feedback das sessões)
SELECT m.user_id,
       (SELECT full_name FROM users u WHERE u.id = m.user_id) AS mentor_nome,
       COUNT(sf.id)    AS qtde_feedbacks,
       ROUND(AVG(sf.rating),2) AS media_rating
FROM mentors m
LEFT JOIN mentoring_sessions s ON s.mentor_user_id = m.user_id
LEFT JOIN session_feedback sf  ON sf.session_id = s.id
GROUP BY m.user_id
ORDER BY media_rating DESC NULLS LAST;

-- 3) LEFT OUTER JOIN + WHERE + ORDER BY
-- Usuários e sua última notificação (se houver), somente dos últimos 30 dias
SELECT u.full_name,
       n.n_type,
       n.created_at
FROM users u
LEFT JOIN (
  SELECT user_id, n_type, created_at,
         ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at DESC) AS rn
  FROM notifications
  WHERE created_at >= SYSTIMESTAMP - INTERVAL '30' DAY
) n ON n.user_id = u.id AND n.rn = 1
WHERE u.locale = 'pt_BR'
ORDER BY n.created_at DESC NULLS LAST, u.full_name;
