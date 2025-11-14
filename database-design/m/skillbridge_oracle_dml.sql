-- SkillBridge.AI — Oracle 19c+ DML (Seeds)
-- Observação: usa sub-selects por chaves únicas (email, code, slug, name) para resolver FKs.
-- Executar após criar o schema (DDL). Gera ≥5 linhas em TODAS as tabelas.

/* ========= ROLES ========= */
INSERT INTO roles(code,name) VALUES ('ADMIN','Administrador');
INSERT INTO roles(code,name) VALUES ('LEARNER','Aluno(a)');
INSERT INTO roles(code,name) VALUES ('MENTOR','Mentor(a)');
INSERT INTO roles(code,name) VALUES ('ORG_OWNER','Dono(a) da Organização');

/* ========= SKILL CATEGORIES ========= */
INSERT INTO skill_categories(id, name) VALUES (SYS_GUID(),'Software Engineering');
INSERT INTO skill_categories(id, name) VALUES (SYS_GUID(),'Data & AI');
INSERT INTO skill_categories(id, name) VALUES (SYS_GUID(),'AR/VR');
INSERT INTO skill_categories(id, name) VALUES (SYS_GUID(),'Soft Skills');

/* ========= SKILLS (7; ≥5 ok) ========= */
INSERT INTO skills(id, slug, name, category_id)
SELECT SYS_GUID(), 'java', 'Java', (SELECT id FROM skill_categories WHERE name='Software Engineering') FROM dual;
INSERT INTO skills(id, slug, name, category_id)
SELECT SYS_GUID(), 'spring-boot', 'Spring Boot', (SELECT id FROM skill_categories WHERE name='Software Engineering') FROM dual;
INSERT INTO skills(id, slug, name, category_id)
SELECT SYS_GUID(), 'sql', 'SQL', (SELECT id FROM skill_categories WHERE name='Software Engineering') FROM dual;
INSERT INTO skills(id, slug, name, category_id)
SELECT SYS_GUID(), 'python', 'Python', (SELECT id FROM skill_categories WHERE name='Data & AI') FROM dual;
INSERT INTO skills(id, slug, name, category_id)
SELECT SYS_GUID(), 'ml-basics', 'Machine Learning (Básico)', (SELECT id FROM skill_categories WHERE name='Data & AI') FROM dual;
INSERT INTO skills(id, slug, name, category_id)
SELECT SYS_GUID(), 'unity', 'Unity 3D', (SELECT id FROM skill_categories WHERE name='AR/VR') FROM dual;
INSERT INTO skills(id, slug, name, category_id)
SELECT SYS_GUID(), 'communication', 'Comunicação', (SELECT id FROM skill_categories WHERE name='Soft Skills') FROM dual;

/* ========= ORGANIZATIONS (5) ========= */
INSERT INTO organizations(id,name,org_type,website) VALUES (SYS_GUID(),'SkillBridge.AI','company','https://skillbridge.ai');
INSERT INTO organizations(id,name,org_type,website) VALUES (SYS_GUID(),'FIAP Labs','school','https://fiap.com.br');
INSERT INTO organizations(id,name,org_type,website) VALUES (SYS_GUID(),'Tech4Good','ngo','https://t4g.example');
INSERT INTO organizations(id,name,org_type,website) VALUES (SYS_GUID(),'Gov BR Work','government','https://gov.br');
INSERT INTO organizations(id,name,org_type,website) VALUES (SYS_GUID(),'Community Hub','community','https://community.example');

/* ========= USERS (5) ========= */
INSERT INTO users(id,email,full_name,preferred_name,phone,locale,timezone,auth_provider,external_id)
VALUES (SYS_GUID(),'abner@skillbridge.ai','Abner Paiva','Abner','+55 11 90000-0000','pt_BR','America/Sao_Paulo','local',NULL);
INSERT INTO users(id,email,full_name,preferred_name,phone) VALUES (SYS_GUID(),'mentor1@skillbridge.ai','Mentora Lina','Lina','+55 11 90000-0001');
INSERT INTO users(id,email,full_name,preferred_name,phone) VALUES (SYS_GUID(),'mentor2@skillbridge.ai','Mentor Caio','Caio','+55 11 90000-0002');
INSERT INTO users(id,email,full_name,preferred_name,phone) VALUES (SYS_GUID(),'learner1@skillbridge.ai','Aluno Bruno','Bruno','+55 11 90000-0003');
INSERT INTO users(id,email,full_name,preferred_name,phone) VALUES (SYS_GUID(),'learner2@skillbridge.ai','Aluna Julia','Julia','+55 11 90000-0004');

/* ========= USER_ROLES (≥5) ========= */
INSERT INTO user_roles(user_id, role_code) SELECT id, 'ADMIN' FROM users WHERE email='abner@skillbridge.ai';
INSERT INTO user_roles(user_id, role_code) SELECT id, 'ORG_OWNER' FROM users WHERE email='abner@skillbridge.ai';
INSERT INTO user_roles(user_id, role_code) SELECT id, 'MENTOR' FROM users WHERE email='mentor1@skillbridge.ai';
INSERT INTO user_roles(user_id, role_code) SELECT id, 'MENTOR' FROM users WHERE email='mentor2@skillbridge.ai';
INSERT INTO user_roles(user_id, role_code) SELECT id, 'LEARNER' FROM users WHERE email='learner1@skillbridge.ai';
INSERT INTO user_roles(user_id, role_code) SELECT id, 'LEARNER' FROM users WHERE email='learner2@skillbridge.ai';

/* ========= ORG_MEMBERSHIPS (≥5) ========= */
INSERT INTO org_memberships(org_id,user_id,role_in_org)
SELECT (SELECT id FROM organizations WHERE name='SkillBridge.AI'),
       (SELECT id FROM users WHERE email='abner@skillbridge.ai'),'owner' FROM dual;
INSERT INTO org_memberships(org_id,user_id,role_in_org)
SELECT (SELECT id FROM organizations WHERE name='SkillBridge.AI'),
       (SELECT id FROM users WHERE email='mentor1@skillbridge.ai'),'member' FROM dual;
INSERT INTO org_memberships(org_id,user_id,role_in_org)
SELECT (SELECT id FROM organizations WHERE name='SkillBridge.AI'),
       (SELECT id FROM users WHERE email='mentor2@skillbridge.ai'),'member' FROM dual;
INSERT INTO org_memberships(org_id,user_id,role_in_org)
SELECT (SELECT id FROM organizations WHERE name='SkillBridge.AI'),
       (SELECT id FROM users WHERE email='learner1@skillbridge.ai'),'member' FROM dual;
INSERT INTO org_memberships(org_id,user_id,role_in_org)
SELECT (SELECT id FROM organizations WHERE name='SkillBridge.AI'),
       (SELECT id FROM users WHERE email='learner2@skillbridge.ai'),'member' FROM dual;

/* ========= USER SKILL PROFILE (5 perfis) ========= */
INSERT INTO user_skill_profiles(id,user_id,headline,summary)
SELECT SYS_GUID(), id, 'Full‑stack Learner','Interessado em Java/Spring e ML.' FROM users WHERE email='abner@skillbridge.ai';
INSERT INTO user_skill_profiles(id,user_id,headline,summary)
SELECT SYS_GUID(), id, 'Data Mentor','Experiência com Python/ML.' FROM users WHERE email='mentor1@skillbridge.ai';
INSERT INTO user_skill_profiles(id,user_id,headline,summary)
SELECT SYS_GUID(), id, 'Backend Mentor','Foco em Java/Spring.' FROM users WHERE email='mentor2@skillbridge.ai';
INSERT INTO user_skill_profiles(id,user_id,headline,summary)
SELECT SYS_GUID(), id, 'Alune iniciante','Aprendendo fundamentos.' FROM users WHERE email='learner1@skillbridge.ai';
INSERT INTO user_skill_profiles(id,user_id,headline,summary)
SELECT SYS_GUID(), id, 'Alune curiosa','Explorando AR/VR.' FROM users WHERE email='learner2@skillbridge.ai';

/* ========= USER_SKILLS (≥5) ========= */
INSERT INTO user_skills(profile_id, skill_id, level, years_exp, last_used_on, evidence_url)
SELECT usp.id, s.id, 3, 1.0, DATE '2025-10-01', 'https://portfolio/abner'
FROM user_skill_profiles usp
JOIN users u ON u.id=usp.user_id AND u.email='abner@skillbridge.ai'
JOIN skills s ON s.slug='java';
INSERT INTO user_skills(profile_id, skill_id, level, years_exp, last_used_on, evidence_url)
SELECT usp.id, s.id, 2, 0.5, DATE '2025-10-10', 'https://portfolio/abner'
FROM user_skill_profiles usp JOIN users u ON u.id=usp.user_id AND u.email='abner@skillbridge.ai'
JOIN skills s ON s.slug='ml-basics';
INSERT INTO user_skills(profile_id, skill_id, level, years_exp, last_used_on)
SELECT usp.id, s.id, 5, 5.0, DATE '2025-09-01'
FROM user_skill_profiles usp JOIN users u ON u.id=usp.user_id AND u.email='mentor1@skillbridge.ai'
JOIN skills s ON s.slug='python';
INSERT INTO user_skills(profile_id, skill_id, level, years_exp, last_used_on)
SELECT usp.id, s.id, 5, 6.0, DATE '2025-09-01'
FROM user_skill_profiles usp JOIN users u ON u.id=usp.user_id AND u.email='mentor2@skillbridge.ai'
JOIN skills s ON s.slug='spring-boot';
INSERT INTO user_skills(profile_id, skill_id, level, years_exp, last_used_on)
SELECT usp.id, s.id, 1, 0.1, DATE '2025-10-15'
FROM user_skill_profiles usp JOIN users u ON u.id=usp.user_id AND u.email='learner2@skillbridge.ai'
JOIN skills s ON s.slug='unity';

/* ========= COURSES (5) ========= */
INSERT INTO courses(id,org_id,code,title,mode,level,language,description,created_by)
SELECT SYS_GUID(), o.id, 'JAVA101','Introdução ao Java','online','beginner','pt-BR','Fundamentos de Java.', u.id
FROM organizations o JOIN users u ON o.name='SkillBridge.AI' AND u.email='mentor2@skillbridge.ai';
INSERT INTO courses(id,org_id,code,title,mode,level,language,description,created_by)
SELECT SYS_GUID(), o.id, 'SPRING201','APIs com Spring Boot','online','intermediate','pt-BR','REST e JPA.', u.id
FROM organizations o JOIN users u ON o.name='SkillBridge.AI' AND u.email='mentor2@skillbridge.ai';
INSERT INTO courses(id,org_id,code,title,mode,level,language,description,created_by)
SELECT SYS_GUID(), o.id, 'ML101','ML Básico com Python','online','beginner','pt-BR','Conceitos de ML.', u.id
FROM organizations o JOIN users u ON o.name='SkillBridge.AI' AND u.email='mentor1@skillbridge.ai';
INSERT INTO courses(id,org_id,code,title,mode,level,language,description,created_by)
SELECT SYS_GUID(), o.id, 'ARVR101','Introdução a AR/VR','hybrid','beginner','pt-BR','AR/VR fundamentos.', u.id
FROM organizations o JOIN users u ON o.name='FIAP Labs' AND u.email='mentor1@skillbridge.ai';
INSERT INTO courses(id,org_id,code,title,mode,level,language,description,created_by)
SELECT SYS_GUID(), o.id, 'SOFT001','Comunicação Profissional','presential','beginner','pt-BR','Soft skills essenciais.', u.id
FROM organizations o JOIN users u ON o.name='Tech4Good' AND u.email='mentor1@skillbridge.ai';

/* ========= COURSE_MODULES (≥5) ========= */
INSERT INTO course_modules(id,course_id,idx,title,summary)
SELECT SYS_GUID(), c.id, 1, 'Sintaxe Básica','Tipos, variáveis, controle.' FROM courses c WHERE c.code='JAVA101';
INSERT INTO course_modules(id,course_id,idx,title,summary)
SELECT SYS_GUID(), c.id, 2, 'POO','Classes e objetos.' FROM courses c WHERE c.code='JAVA101';
INSERT INTO course_modules(id,course_id,idx,title,summary)
SELECT SYS_GUID(), c.id, 1, 'REST Controllers','@RestController, DTO.' FROM courses c WHERE c.code='SPRING201';
INSERT INTO course_modules(id,course_id,idx,title,summary)
SELECT SYS_GUID(), c.id, 1, 'Pipelines','Train/Test, métricas.' FROM courses c WHERE c.code='ML101';
INSERT INTO course_modules(id,course_id,idx,title,summary)
SELECT SYS_GUID(), c.id, 1, 'Fundamentos AR/VR','Conceitos e cases.' FROM courses c WHERE c.code='ARVR101';

/* ========= ENROLLMENTS (≥5) ========= */
INSERT INTO enrollments(id,user_id,course_id,status)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='learner1@skillbridge.ai'), c.id, 'active' FROM courses c WHERE c.code='JAVA101';
INSERT INTO enrollments(id,user_id,course_id,status)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='learner1@skillbridge.ai'), c.id, 'active' FROM courses c WHERE c.code='SPRING201';
INSERT INTO enrollments(id,user_id,course_id,status)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='learner2@skillbridge.ai'), c.id, 'active' FROM courses c WHERE c.code='ML101';
INSERT INTO enrollments(id,user_id,course_id,status)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='learner2@skillbridge.ai'), c.id, 'pending' FROM courses c WHERE c.code='ARVR101';
INSERT INTO enrollments(id,user_id,course_id,status)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='abner@skillbridge.ai'), c.id, 'active' FROM courses c WHERE c.code='SOFT001';

/* ========= MENTORS ========= */
-- criar 2 usuários mentores extras
INSERT INTO users(id,email,full_name,preferred_name) VALUES (SYS_GUID(),'mentor3@skillbridge.ai','Mentora Carol','Carol');
INSERT INTO users(id,email,full_name,preferred_name) VALUES (SYS_GUID(),'mentor4@skillbridge.ai','Mentor Diego','Diego');
INSERT INTO user_roles(user_id, role_code) SELECT id, 'MENTOR' FROM users WHERE email IN ('mentor3@skillbridge.ai','mentor4@skillbridge.ai');

-- 5 registros em mentors
INSERT INTO mentors(user_id,headline,bio,rating,hourly_rate) SELECT id,'Mentora de Dados','10 anos em DS.',4.8,250 FROM users WHERE email='mentor1@skillbridge.ai';
INSERT INTO mentors(user_id,headline,bio,rating,hourly_rate) SELECT id,'Mentor Backend','Spring guru.',4.7,240 FROM users WHERE email='mentor2@skillbridge.ai';
INSERT INTO mentors(user_id,headline,bio,rating,hourly_rate) SELECT id,'Mentora Cloud','DevOps/Cloud.',4.9,300 FROM users WHERE email='mentor3@skillbridge.ai';
INSERT INTO mentors(user_id,headline,bio,rating,hourly_rate) SELECT id,'Mentor Arquitetura','DDD/Hexagonal.',4.6,260 FROM users WHERE email='mentor4@skillbridge.ai';
INSERT INTO mentors(user_id,headline,bio,rating,hourly_rate) SELECT id,'Mentor Líder','Eng. de Soluções.',4.5,200 FROM users WHERE email='abner@skillbridge.ai';

/* ========= MENTOR_AVAILABILITY (≥5) ========= */
INSERT INTO mentor_availability(id,mentor_user_id,weekday,start_time,end_time,timezone)
SELECT SYS_GUID(), m.user_id, 1, INTERVAL '10:00:00' HOUR TO SECOND, INTERVAL '12:00:00' HOUR TO SECOND, 'America/Sao_Paulo' FROM mentors m WHERE m.user_id=(SELECT id FROM users WHERE email='mentor1@skillbridge.ai');
INSERT INTO mentor_availability(id,mentor_user_id,weekday,start_time,end_time,timezone)
SELECT SYS_GUID(), m.user_id, 3, INTERVAL '14:00:00' HOUR TO SECOND, INTERVAL '16:00:00' HOUR TO SECOND, 'America/Sao_Paulo' FROM mentors m WHERE m.user_id=(SELECT id FROM users WHERE email='mentor2@skillbridge.ai');
INSERT INTO mentor_availability(id,mentor_user_id,weekday,start_time,end_time,timezone)
SELECT SYS_GUID(), m.user_id, 5, INTERVAL '09:00:00' HOUR TO SECOND, INTERVAL '11:00:00' HOUR TO SECOND, 'America/Sao_Paulo' FROM mentors m WHERE m.user_id=(SELECT id FROM users WHERE email='mentor3@skillbridge.ai');
INSERT INTO mentor_availability(id,mentor_user_id,weekday,start_time,end_time,timezone)
SELECT SYS_GUID(), m.user_id, 2, INTERVAL '19:00:00' HOUR TO SECOND, INTERVAL '21:00:00' HOUR TO SECOND, 'America/Sao_Paulo' FROM mentors m WHERE m.user_id=(SELECT id FROM users WHERE email='mentor4@skillbridge.ai');
INSERT INTO mentor_availability(id,mentor_user_id,weekday,start_time,end_time,timezone)
SELECT SYS_GUID(), m.user_id, 4, INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '10:00:00' HOUR TO SECOND, 'America/Sao_Paulo' FROM mentors m WHERE m.user_id=(SELECT id FROM users WHERE email='abner@skillbridge.ai');

/* ========= MENTORING_SESSIONS (5) ========= */
INSERT INTO mentoring_sessions(id,mentor_user_id,learner_user_id,scheduled_start,scheduled_end,status,location_url,notes)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='mentor1@skillbridge.ai'),
                   (SELECT id FROM users WHERE email='learner1@skillbridge.ai'),
                   TO_TIMESTAMP('2025-11-12 10:00:00','YYYY-MM-DD HH24:MI:SS'),
                   TO_TIMESTAMP('2025-11-12 11:00:00','YYYY-MM-DD HH24:MI:SS'),
                   'scheduled','https://meet/1','Primeiros passos ML' FROM dual;
INSERT INTO mentoring_sessions(id,mentor_user_id,learner_user_id,scheduled_start,scheduled_end,status,location_url,notes)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='mentor2@skillbridge.ai'),
                   (SELECT id FROM users WHERE email='learner1@skillbridge.ai'),
                   TO_TIMESTAMP('2025-11-13 14:00:00','YYYY-MM-DD HH24:MI:SS'),
                   TO_TIMESTAMP('2025-11-13 15:00:00','YYYY-MM-DD HH24:MI:SS'),
                   'scheduled','https://meet/2','API com Spring' FROM dual;
INSERT INTO mentoring_sessions(id,mentor_user_id,learner_user_id,scheduled_start,scheduled_end,status,location_url,notes)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='mentor3@skillbridge.ai'),
                   (SELECT id FROM users WHERE email='learner2@skillbridge.ai'),
                   TO_TIMESTAMP('2025-11-14 09:00:00','YYYY-MM-DD HH24:MI:SS'),
                   TO_TIMESTAMP('2025-11-14 10:00:00','YYYY-MM-DD HH24:MI:SS'),
                   'scheduled','https://meet/3','Cloud basics' FROM dual;
INSERT INTO mentoring_sessions(id,mentor_user_id,learner_user_id,scheduled_start,scheduled_end,status,location_url,notes)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='mentor4@skillbridge.ai'),
                   (SELECT id FROM users WHERE email='learner2@skillbridge.ai'),
                   TO_TIMESTAMP('2025-11-15 19:00:00','YYYY-MM-DD HH24:MI:SS'),
                   TO_TIMESTAMP('2025-11-15 20:00:00','YYYY-MM-DD HH24:MI:SS'),
                   'scheduled','https://meet/4','DDD intro' FROM dual;
INSERT INTO mentoring_sessions(id,mentor_user_id,learner_user_id,scheduled_start,scheduled_end,status,location_url,notes)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='abner@skillbridge.ai'),
                   (SELECT id FROM users WHERE email='learner1@skillbridge.ai'),
                   TO_TIMESTAMP('2025-11-16 08:00:00','YYYY-MM-DD HH24:MI:SS'),
                   TO_TIMESTAMP('2025-11-16 09:00:00','YYYY-MM-DD HH24:MI:SS'),
                   'scheduled','https://meet/5','Plano de estudos' FROM dual;

/* ========= SESSION_FEEDBACK (5) ========= */
INSERT INTO session_feedback(id,session_id,rating,comment)
SELECT SYS_GUID(), s.id, 5, 'Excelente sessão' FROM mentoring_sessions s WHERE s.location_url='https://meet/1';
INSERT INTO session_feedback(id,session_id,rating,comment)
SELECT SYS_GUID(), s.id, 4, 'Muito bom' FROM mentoring_sessions s WHERE s.location_url='https://meet/2';
INSERT INTO session_feedback(id,session_id,rating,comment)
SELECT SYS_GUID(), s.id, 5, 'Top!' FROM mentoring_sessions s WHERE s.location_url='https://meet/3';
INSERT INTO session_feedback(id,session_id,rating,comment)
SELECT SYS_GUID(), s.id, 4, 'Conteúdo denso' FROM mentoring_sessions s WHERE s.location_url='https://meet/4';
INSERT INTO session_feedback(id,session_id,rating,comment)
SELECT SYS_GUID(), s.id, 5, 'Objetivo e claro' FROM mentoring_sessions s WHERE s.location_url='https://meet/5';

/* ========= BADGES (5) ========= */
INSERT INTO badges(id,code,name,description) VALUES (SYS_GUID(),'ONBOARD_OK','Onboarding Concluído','Finalizou perfil e primeiros passos');
INSERT INTO badges(id,code,name,description) VALUES (SYS_GUID(),'FIRST_SESSION','Primeira Mentoria','Realizou a primeira sessão de mentoria');
INSERT INTO badges(id,code,name,description) VALUES (SYS_GUID(),'COURSE_STARTER','Começou Curso','Iniciou o primeiro curso');
INSERT INTO badges(id,code,name,description) VALUES (SYS_GUID(),'JAVA_INIT','Java Iniciante','Concluiu JAVA101');
INSERT INTO badges(id,code,name,description) VALUES (SYS_GUID(),'SPRING_API','Spring APIs','Concluiu SPRING201');

/* ========= USER_BADGES (≥5) ========= */
INSERT INTO user_badges(user_id,badge_id,awarded_at)
SELECT (SELECT id FROM users WHERE email='learner1@skillbridge.ai'),
       (SELECT id FROM badges WHERE code='ONBOARD_OK'),
       SYSTIMESTAMP FROM dual;
INSERT INTO user_badges(user_id,badge_id,awarded_at)
SELECT (SELECT id FROM users WHERE email='learner1@skillbridge.ai'),
       (SELECT id FROM badges WHERE code='FIRST_SESSION'),
       SYSTIMESTAMP FROM dual;
INSERT INTO user_badges(user_id,badge_id,awarded_at)
SELECT (SELECT id FROM users WHERE email='learner2@skillbridge.ai'),
       (SELECT id FROM badges WHERE code='ONBOARD_OK'),
       SYSTIMESTAMP FROM dual;
INSERT INTO user_badges(user_id,badge_id,awarded_at)
SELECT (SELECT id FROM users WHERE email='learner2@skillbridge.ai'),
       (SELECT id FROM badges WHERE code='COURSE_STARTER'),
       SYSTIMESTAMP FROM dual;
INSERT INTO user_badges(user_id,badge_id,awarded_at)
SELECT (SELECT id FROM users WHERE email='learner2@skillbridge.ai'),
       (SELECT id FROM badges WHERE code='JAVA_INIT'),
       SYSTIMESTAMP FROM dual;

/* ========= ASSESSMENT_ATTEMPTS (≥5) ========= */
INSERT INTO assessment_attempts(id,user_id,course_id,module_id,score,rubric,started_at,finished_at)
SELECT SYS_GUID(), u.id, c.id, m.id, 8.5, '{"criteria":["fundamentos","poo"]}',
       SYSTIMESTAMP-10, SYSTIMESTAMP-10+INTERVAL '50' MINUTE
FROM users u JOIN courses c ON c.code='JAVA101'
JOIN course_modules m ON m.course_id=c.id AND m.idx=1
WHERE u.email='learner1@skillbridge.ai';

INSERT INTO assessment_attempts(id,user_id,course_id,module_id,score,rubric,started_at,finished_at)
SELECT SYS_GUID(), u.id, c.id, m.id, 9.0, '{"criteria":["rest","dto"]}',
       SYSTIMESTAMP-9, SYSTIMESTAMP-9+INTERVAL '45' MINUTE
FROM users u JOIN courses c ON c.code='SPRING201'
JOIN course_modules m ON m.course_id=c.id AND m.idx=1
WHERE u.email='learner1@skillbridge.ai';

INSERT INTO assessment_attempts(id,user_id,course_id,module_id,score,rubric,started_at,finished_at)
SELECT SYS_GUID(), u.id, c.id, m.id, 7.0, '{"criteria":["pipelines"]}',
       SYSTIMESTAMP-8, SYSTIMESTAMP-8+INTERVAL '30' MINUTE
FROM users u JOIN courses c ON c.code='ML101'
JOIN course_modules m ON m.course_id=c.id AND m.idx=1
WHERE u.email='learner2@skillbridge.ai';

INSERT INTO assessment_attempts(id,user_id,course_id,module_id,score,rubric,started_at,finished_at)
SELECT SYS_GUID(), u.id, c.id, m.id, 10.0, '{"criteria":["fundamentos arvr"]}',
       SYSTIMESTAMP-7, SYSTIMESTAMP-7+INTERVAL '40' MINUTE
FROM users u JOIN courses c ON c.code='ARVR101'
JOIN course_modules m ON m.course_id=c.id AND m.idx=1
WHERE u.email='learner2@skillbridge.ai';

INSERT INTO assessment_attempts(id,user_id,course_id,module_id,score,rubric,started_at,finished_at)
SELECT SYS_GUID(), u.id, c.id, m.id, 9.5, '{"criteria":["comunicacao"]}',
       SYSTIMESTAMP-6, SYSTIMESTAMP-6+INTERVAL '35' MINUTE
FROM users u JOIN courses c ON c.code='SOFT001'
JOIN course_modules m ON m.course_id=c.id AND m.idx=1
WHERE u.email='abner@skillbridge.ai';

/* ========= MESSAGES (≥5) ========= */
INSERT INTO messages(id,sender_user_id,receiver_user_id,session_id,body)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='learner1@skillbridge.ai'),
       (SELECT id FROM users WHERE email='mentor1@skillbridge.ai'),
       (SELECT id FROM mentoring_sessions WHERE location_url='https://meet/1'),
       'Oi, tudo pronto para a sessão?' FROM dual;
INSERT INTO messages(id,sender_user_id,receiver_user_id,session_id,body)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='mentor1@skillbridge.ai'),
       (SELECT id FROM users WHERE email='learner1@skillbridge.ai'),
       (SELECT id FROM mentoring_sessions WHERE location_url='https://meet/1'),
       'Sim! Traga dúvidas de regressão.' FROM dual;
INSERT INTO messages(id,sender_user_id,receiver_user_id,session_id,body)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='learner2@skillbridge.ai'),
       (SELECT id FROM users WHERE email='mentor3@skillbridge.ai'),
       (SELECT id FROM mentoring_sessions WHERE location_url='https://meet/3'),
       'Pode recomendar material de Cloud?' FROM dual;
INSERT INTO messages(id,sender_user_id,receiver_user_id,session_id,body)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='mentor2@skillbridge.ai'),
       (SELECT id FROM users WHERE email='learner1@skillbridge.ai'),
       (SELECT id FROM mentoring_sessions WHERE location_url='https://meet/2'),
       'Veja o repo de exemplo.' FROM dual;
INSERT INTO messages(id,sender_user_id,receiver_user_id,session_id,body)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='mentor4@skillbridge.ai'),
       (SELECT id FROM users WHERE email='learner2@skillbridge.ai'),
       (SELECT id FROM mentoring_sessions WHERE location_url='https://meet/4'),
       'Anexe seu diagrama DDD.' FROM dual;

/* ========= NOTIFICATIONS (≥5) ========= */
INSERT INTO notifications(id,user_id,n_type,payload) SELECT SYS_GUID(), id, 'session_confirmed', '{"session":"/1"}' FROM users WHERE email='learner1@skillbridge.ai';
INSERT INTO notifications(id,user_id,n_type,payload) SELECT SYS_GUID(), id, 'new_message', '{"session":"/1"}' FROM users WHERE email='mentor1@skillbridge.ai';
INSERT INTO notifications(id,user_id,n_type,payload) SELECT SYS_GUID(), id, 'session_confirmed', '{"session":"/3"}' FROM users WHERE email='learner2@skillbridge.ai';
INSERT INTO notifications(id,user_id,n_type,payload) SELECT SYS_GUID(), id, 'new_message', '{"session":"/2"}' FROM users WHERE email='learner1@skillbridge.ai';
INSERT INTO notifications(id,user_id,n_type,payload) SELECT SYS_GUID(), id, 'badge_awarded', '{"badge":"JAVA_INIT"}' FROM users WHERE email='learner2@skillbridge.ai';

/* ========= ANALYTICS_EVENTS (≥5) ========= */
INSERT INTO analytics_events(id,user_id,name,metadata)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='learner1@skillbridge.ai'),'login','{"device":"web"}' FROM dual;
INSERT INTO analytics_events(id,user_id,name,metadata)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='learner1@skillbridge.ai'),'open_course','{"code":"JAVA101"}' FROM dual;
INSERT INTO analytics_events(id,user_id,name,metadata)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='learner2@skillbridge.ai'),'login','{"device":"mobile"}' FROM dual;
INSERT INTO analytics_events(id,user_id,name,metadata)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='learner2@skillbridge.ai'),'open_course','{"code":"ML101"}' FROM dual;
INSERT INTO analytics_events(id,user_id,name,metadata)
SELECT SYS_GUID(), (SELECT id FROM users WHERE email='abner@skillbridge.ai'),'create_org','{"org":"SkillBridge.AI"}' FROM dual;

/* ========= DOMAIN_EVENTS_OUTBOX (≥5) ========= */
INSERT INTO domain_events_outbox(id,aggregate_type,aggregate_id,event_type,payload,occurred_at)
SELECT SYS_GUID(),'MentoringSession', s.id, 'SessionScheduled', '{"url":"'||s.location_url||'"}', SYSTIMESTAMP FROM mentoring_sessions s WHERE ROWNUM <= 5;
