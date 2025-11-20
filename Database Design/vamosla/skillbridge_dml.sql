--------------------------------------------------------------------
-- SKILLBRIDGE.AI - SCRIPT DML (ORACLE)
-- Dados fictícios - mínimo 5 linhas por tabela
--------------------------------------------------------------------
--------------------------------------------------------------------
-- TABELA: USERS
--------------------------------------------------------------------
INSERT INTO users (id, nome, email, cpf, tipo_usuario)
VALUES (
        1,
        'Abner Silva',
        'abner@skillbridge.ai',
        '12345678901',
        'ALUNO'
    );
INSERT INTO users (id, nome, email, cpf, tipo_usuario)
VALUES (
        2,
        'Clara Souza',
        'clara@skillbridge.ai',
        '22233344455',
        'ALUNO'
    );
INSERT INTO users (id, nome, email, cpf, tipo_usuario)
VALUES (
        3,
        'João Mentor',
        'joao.mentor@skillbridge.ai',
        '33344455566',
        'MENTOR'
    );
INSERT INTO users (id, nome, email, cpf, tipo_usuario)
VALUES (
        4,
        'Ana Mentora',
        'ana.mentora@skillbridge.ai',
        '44455566677',
        'MENTOR'
    );
INSERT INTO users (id, nome, email, cpf, tipo_usuario)
VALUES (
        5,
        'Admin Plataforma',
        'admin@skillbridge.ai',
        '55566677788',
        'ADMIN'
    );
--------------------------------------------------------------------
-- TABELA: TRILHAS
--------------------------------------------------------------------
INSERT INTO trilhas (
        id,
        titulo,
        descricao,
        ativa,
        nivel,
        carga_horaria,
        publico_alvo
    )
VALUES (
        1,
        'Trilha Back-end Java Júnior',
        'Fundamentos de Java, API REST e DDD para iniciantes.',
        'S',
        'INICIANTE',
        60,
        'Pessoas iniciando em desenvolvimento back-end'
    );
INSERT INTO trilhas (
        id,
        titulo,
        descricao,
        ativa,
        nivel,
        carga_horaria,
        publico_alvo
    )
VALUES (
        2,
        'Introdução ao Machine Learning',
        'Conceitos básicos de ML e primeiros modelos supervisionados.',
        'S',
        'INICIANTE',
        40,
        'Requalificação em dados e IA'
    );
INSERT INTO trilhas (
        id,
        titulo,
        descricao,
        ativa,
        nivel,
        carga_horaria,
        publico_alvo
    )
VALUES (
        3,
        'Requalificação em Dados',
        'SQL, ETL e fundamentos de análise de dados.',
        'S',
        'INTERMEDIARIO',
        50,
        'Profissionais migrando para área de dados'
    );
INSERT INTO trilhas (
        id,
        titulo,
        descricao,
        ativa,
        nivel,
        carga_horaria,
        publico_alvo
    )
VALUES (
        4,
        'Soft Skills para Área de Tecnologia',
        'Comunicação, colaboração e feedback em times ágeis.',
        'S',
        'INICIANTE',
        30,
        'Profissionais de tecnologia em geral'
    );
INSERT INTO trilhas (
        id,
        titulo,
        descricao,
        ativa,
        nivel,
        carga_horaria,
        publico_alvo
    )
VALUES (
        5,
        'Fundamentos de Cloud e DevOps',
        'Conceitos de nuvem, CI/CD e observabilidade.',
        'N',
        'AVANCADO',
        45,
        'Profissionais de TI em requalificação'
    );
--------------------------------------------------------------------
-- TABELA: MATRICULAS
--------------------------------------------------------------------
INSERT INTO matriculas (id, user_id, trilha_id, criada_em, status)
VALUES (1, 1, 1, SYSTIMESTAMP, 'ATIVA');
INSERT INTO matriculas (id, user_id, trilha_id, criada_em, status)
VALUES (2, 1, 2, SYSTIMESTAMP, 'ATIVA');
INSERT INTO matriculas (id, user_id, trilha_id, criada_em, status)
VALUES (3, 2, 1, SYSTIMESTAMP, 'CONCLUIDA');
-- Depois (tudo certo com a constraint)
INSERT INTO matriculas (id, user_id, trilha_id, criada_em, status)
VALUES (4, 2, 3, SYSTIMESTAMP, 'CANCELADA');
INSERT INTO matriculas (id, user_id, trilha_id, criada_em, status)
VALUES (5, 1, 3, SYSTIMESTAMP, 'TRANCADA');
--------------------------------------------------------------------
-- TABELA: MODULOS
--------------------------------------------------------------------
INSERT INTO modulos (
        id,
        trilha_id,
        titulo,
        descricao,
        ordem,
        carga_horaria
    )
VALUES (
        1,
        1,
        'Fundamentos de Java',
        'Sintaxe básica, tipos e estruturas de controle.',
        1,
        10
    );
INSERT INTO modulos (
        id,
        trilha_id,
        titulo,
        descricao,
        ordem,
        carga_horaria
    )
VALUES (
        2,
        1,
        'APIs REST e HTTP',
        'Construção de APIs com boas práticas.',
        2,
        12
    );
INSERT INTO modulos (
        id,
        trilha_id,
        titulo,
        descricao,
        ordem,
        carga_horaria
    )
VALUES (
        3,
        2,
        'Introdução ao ML',
        'Conceitos de treino, validação e teste.',
        1,
        8
    );
INSERT INTO modulos (
        id,
        trilha_id,
        titulo,
        descricao,
        ordem,
        carga_horaria
    )
VALUES (
        4,
        2,
        'Modelos Supervisionados',
        'Regressão, classificação e métricas.',
        2,
        12
    );
INSERT INTO modulos (
        id,
        trilha_id,
        titulo,
        descricao,
        ordem,
        carga_horaria
    )
VALUES (
        5,
        3,
        'SQL para Dados',
        'Consultas, joins e agregações.',
        1,
        10
    );
INSERT INTO modulos (
        id,
        trilha_id,
        titulo,
        descricao,
        ordem,
        carga_horaria
    )
VALUES (
        6,
        3,
        'ETL Básico',
        'Processos de extração e transformação.',
        2,
        10
    );
--------------------------------------------------------------------
-- TABELA: PROGRESSO_MODULO
--------------------------------------------------------------------
INSERT INTO progresso_modulo (
        id,
        matricula_id,
        modulo_id,
        status,
        percentual_conclusao,
        ultima_atualizacao
    )
VALUES (1, 1, 1, 'EM_ANDAMENTO', 50, SYSTIMESTAMP);
INSERT INTO progresso_modulo (
        id,
        matricula_id,
        modulo_id,
        status,
        percentual_conclusao,
        ultima_atualizacao
    )
VALUES (2, 1, 2, 'NAO_INICIADO', 0, SYSTIMESTAMP);
INSERT INTO progresso_modulo (
        id,
        matricula_id,
        modulo_id,
        status,
        percentual_conclusao,
        ultima_atualizacao
    )
VALUES (3, 3, 1, 'CONCLUIDO', 100, SYSTIMESTAMP);
INSERT INTO progresso_modulo (
        id,
        matricula_id,
        modulo_id,
        status,
        percentual_conclusao,
        ultima_atualizacao
    )
VALUES (4, 4, 5, 'EM_ANDAMENTO', 30, SYSTIMESTAMP);
INSERT INTO progresso_modulo (
        id,
        matricula_id,
        modulo_id,
        status,
        percentual_conclusao,
        ultima_atualizacao
    )
VALUES (5, 2, 3, 'EM_ANDAMENTO', 20, SYSTIMESTAMP);
--------------------------------------------------------------------
-- TABELA: SKILLS
--------------------------------------------------------------------
INSERT INTO skills (id, nome, descricao, categoria)
VALUES (
        1,
        'Java Básico',
        'Sintaxe, OO e boas práticas iniciais.',
        'TECNICA'
    );
INSERT INTO skills (id, nome, descricao, categoria)
VALUES (
        2,
        'Banco de Dados SQL',
        'Modelagem e consultas relacionais.',
        'TECNICA'
    );
INSERT INTO skills (id, nome, descricao, categoria)
VALUES (
        3,
        'Machine Learning',
        'Fundamentos de modelos e avaliação.',
        'TECNICA'
    );
INSERT INTO skills (id, nome, descricao, categoria)
VALUES (
        4,
        'Comunicação',
        'Apresentação de ideias em público.',
        'COMPORTAMENTAL'
    );
INSERT INTO skills (id, nome, descricao, categoria)
VALUES (
        5,
        'Trabalho em Equipe',
        'Colaboração em times multidisciplinares.',
        'COMPORTAMENTAL'
    );
--------------------------------------------------------------------
-- TABELA: TRILHA_SKILL
--------------------------------------------------------------------
INSERT INTO trilha_skill (trilha_id, skill_id, nivel_esperado)
VALUES (1, 1, 80);
INSERT INTO trilha_skill (trilha_id, skill_id, nivel_esperado)
VALUES (1, 2, 60);
INSERT INTO trilha_skill (trilha_id, skill_id, nivel_esperado)
VALUES (2, 3, 70);
INSERT INTO trilha_skill (trilha_id, skill_id, nivel_esperado)
VALUES (3, 2, 75);
INSERT INTO trilha_skill (trilha_id, skill_id, nivel_esperado)
VALUES (4, 4, 70);
--------------------------------------------------------------------
-- TABELA: PERGUNTAS_DIAGNOSTICO
--------------------------------------------------------------------
INSERT INTO perguntas_diagnostico (id, texto_pergunta, skill_id, peso)
VALUES (
        1,
        'Quão confortável você está com a sintaxe básica de Java?',
        1,
        1
    );
INSERT INTO perguntas_diagnostico (id, texto_pergunta, skill_id, peso)
VALUES (
        2,
        'Você consegue escrever consultas SQL com JOIN?',
        2,
        2
    );
INSERT INTO perguntas_diagnostico (id, texto_pergunta, skill_id, peso)
VALUES (
        3,
        'Você já treinou algum modelo de machine learning?',
        3,
        2
    );
INSERT INTO perguntas_diagnostico (id, texto_pergunta, skill_id, peso)
VALUES (
        4,
        'Você se sente à vontade para apresentar em reuniões?',
        4,
        1
    );
INSERT INTO perguntas_diagnostico (id, texto_pergunta, skill_id, peso)
VALUES (
        5,
        'Como você lida com feedback em equipe?',
        5,
        1
    );
--------------------------------------------------------------------
-- TABELA: DIAGNOSTICOS
--------------------------------------------------------------------
INSERT INTO diagnosticos (
        id,
        user_id,
        trilha_id,
        data_aplicacao,
        tipo,
        score_geral
    )
VALUES (1, 1, 1, SYSTIMESTAMP, 'INICIAL', 65.5);
INSERT INTO diagnosticos (
        id,
        user_id,
        trilha_id,
        data_aplicacao,
        tipo,
        score_geral
    )
VALUES (2, 1, 2, SYSTIMESTAMP, 'INICIAL', 50.0);
INSERT INTO diagnosticos (
        id,
        user_id,
        trilha_id,
        data_aplicacao,
        tipo,
        score_geral
    )
VALUES (3, 2, 1, SYSTIMESTAMP, 'INICIAL', 80.0);
INSERT INTO diagnosticos (
        id,
        user_id,
        trilha_id,
        data_aplicacao,
        tipo,
        score_geral
    )
VALUES (4, 2, 3, SYSTIMESTAMP, 'INICIAL', 55.0);
INSERT INTO diagnosticos (
        id,
        user_id,
        trilha_id,
        data_aplicacao,
        tipo,
        score_geral
    )
VALUES (5, 1, 4, SYSTIMESTAMP, 'CHECKPOINT', 70.0);
--------------------------------------------------------------------
-- TABELA: RESPOSTAS_DIAGNOSTICO
--------------------------------------------------------------------
INSERT INTO respostas_diagnostico (
        id,
        diagnostico_id,
        pergunta_id,
        resposta_texto,
        valor_numerico
    )
VALUES (1, 1, 1, 'Tenho boa base de Java.', 7.0);
INSERT INTO respostas_diagnostico (
        id,
        diagnostico_id,
        pergunta_id,
        resposta_texto,
        valor_numerico
    )
VALUES (
        2,
        1,
        2,
        'Consigo fazer SELECT com JOIN simples.',
        6.0
    );
INSERT INTO respostas_diagnostico (
        id,
        diagnostico_id,
        pergunta_id,
        resposta_texto,
        valor_numerico
    )
VALUES (
        3,
        2,
        3,
        'Nunca treinei modelo, só vi teoria.',
        4.0
    );
INSERT INTO respostas_diagnostico (
        id,
        diagnostico_id,
        pergunta_id,
        resposta_texto,
        valor_numerico
    )
VALUES (4, 3, 1, 'Uso Java no dia a dia.', 9.0);
INSERT INTO respostas_diagnostico (
        id,
        diagnostico_id,
        pergunta_id,
        resposta_texto,
        valor_numerico
    )
VALUES (
        5,
        4,
        5,
        'Aprendi a lidar melhor com feedback.',
        7.5
    );
--------------------------------------------------------------------
-- TABELA: SESSOES_MENTORIA
--------------------------------------------------------------------
INSERT INTO sessoes_mentoria (
        id,
        mentor_id,
        aluno_id,
        trilha_id,
        data_hora_inicio,
        data_hora_fim,
        status,
        canal,
        observacoes
    )
VALUES (
        1,
        3,
        1,
        1,
        TO_TIMESTAMP('2025-11-10 19:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_TIMESTAMP('2025-11-10 20:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        'REALIZADA',
        'ONLINE',
        'Sessão focada em dúvidas de Java básico.'
    );
INSERT INTO sessoes_mentoria (
        id,
        mentor_id,
        aluno_id,
        trilha_id,
        data_hora_inicio,
        data_hora_fim,
        status,
        canal,
        observacoes
    )
VALUES (
        2,
        3,
        2,
        1,
        TO_TIMESTAMP('2025-11-12 19:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        NULL,
        'AGENDADA',
        'ONLINE',
        'Preparação para entrevista de estágio.'
    );
INSERT INTO sessoes_mentoria (
        id,
        mentor_id,
        aluno_id,
        trilha_id,
        data_hora_inicio,
        data_hora_fim,
        status,
        canal,
        observacoes
    )
VALUES (
        3,
        4,
        1,
        2,
        TO_TIMESTAMP('2025-11-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        NULL,
        'AGENDADA',
        'ONLINE',
        'Apoio em fundamentos de ML.'
    );
INSERT INTO sessoes_mentoria (
        id,
        mentor_id,
        aluno_id,
        trilha_id,
        data_hora_inicio,
        data_hora_fim,
        status,
        canal,
        observacoes
    )
VALUES (
        4,
        4,
        2,
        3,
        TO_TIMESTAMP('2025-11-16 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        NULL,
        'AGENDADA',
        'PRESENCIAL',
        'Mentoria sobre carreira em dados.'
    );
INSERT INTO sessoes_mentoria (
        id,
        mentor_id,
        aluno_id,
        trilha_id,
        data_hora_inicio,
        data_hora_fim,
        status,
        canal,
        observacoes
    )
VALUES (
        5,
        3,
        1,
        4,
        TO_TIMESTAMP('2025-11-20 19:30:00', 'YYYY-MM-DD HH24:MI:SS'),
        NULL,
        'AGENDADA',
        'ONLINE',
        'Trabalhando soft skills em ambiente híbrido.'
    );