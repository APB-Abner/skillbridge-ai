--------------------------------------------------------------------
-- SKILLBRIDGE.AI - SCRIPT DDL (ORACLE)
-- Estruturas: tabelas, constraints e sequences
--------------------------------------------------------------------
--------------------------------------------------------------------
-- TABELA: USERS
--------------------------------------------------------------------
CREATE TABLE users (
    id NUMBER(10) NOT NULL,
    nome VARCHAR2(150) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    cpf VARCHAR2(11) NOT NULL,
    tipo_usuario VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_users PRIMARY KEY (id),
    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT uq_users_cpf UNIQUE (cpf)
);
--------------------------------------------------------------------
-- TABELA: TRILHAS
--------------------------------------------------------------------
CREATE TABLE trilhas (
    id NUMBER(10) NOT NULL,
    titulo VARCHAR2(180) NOT NULL,
    descricao VARCHAR2(800),
    ativa CHAR(1) DEFAULT 'S' NOT NULL,
    nivel VARCHAR2(30),
    carga_horaria NUMBER(4),
    publico_alvo VARCHAR2(200),
    CONSTRAINT pk_trilhas PRIMARY KEY (id),
    CONSTRAINT ck_trilhas_ativa CHECK (ativa IN ('S', 'N'))
);
--------------------------------------------------------------------
-- TABELA: MATRICULAS
--------------------------------------------------------------------
CREATE TABLE matriculas (
    id NUMBER(10) NOT NULL,
    user_id NUMBER(10) NOT NULL,
    trilha_id NUMBER(10) NOT NULL,
    criada_em TIMESTAMP DEFAULT SYSTIMESTAMP,
    status VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_matriculas PRIMARY KEY (id),
    CONSTRAINT uk_matriculas_user_trilha UNIQUE (user_id, trilha_id),
    CONSTRAINT ck_matriculas_status CHECK (
        status IN ('ATIVA', 'CONCLUIDA', 'TRANCADA', 'CANCELADA')
    )
);
--------------------------------------------------------------------
-- TABELA: MODULOS
--------------------------------------------------------------------
CREATE TABLE modulos (
    id NUMBER(10) NOT NULL,
    trilha_id NUMBER(10) NOT NULL,
    titulo VARCHAR2(180) NOT NULL,
    descricao VARCHAR2(800),
    ordem NUMBER(3) NOT NULL,
    carga_horaria NUMBER(4),
    CONSTRAINT pk_modulos PRIMARY KEY (id),
    CONSTRAINT uk_modulos_trilha_ordem UNIQUE (trilha_id, ordem)
);
--------------------------------------------------------------------
-- TABELA: PROGRESSO_MODULO
--------------------------------------------------------------------
CREATE TABLE progresso_modulo (
    id NUMBER(10) NOT NULL,
    matricula_id NUMBER(10) NOT NULL,
    modulo_id NUMBER(10) NOT NULL,
    status VARCHAR2(20) NOT NULL,
    percentual_conclusao NUMBER(5, 2) DEFAULT 0,
    ultima_atualizacao TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT pk_progresso_modulo PRIMARY KEY (id),
    CONSTRAINT uk_prog_matricula_modulo UNIQUE (matricula_id, modulo_id),
    CONSTRAINT ck_prog_status CHECK (
        status IN ('NAO_INICIADO', 'EM_ANDAMENTO', 'CONCLUIDO')
    ),
    CONSTRAINT ck_prog_percentual CHECK (
        percentual_conclusao BETWEEN 0 AND 100
    )
);
--------------------------------------------------------------------
-- TABELA: SKILLS
--------------------------------------------------------------------
CREATE TABLE skills (
    id NUMBER(10) NOT NULL,
    nome VARCHAR2(100) NOT NULL,
    descricao VARCHAR2(400),
    categoria VARCHAR2(50),
    CONSTRAINT pk_skills PRIMARY KEY (id),
    CONSTRAINT uq_skills_nome UNIQUE (nome)
);
--------------------------------------------------------------------
-- TABELA: TRILHA_SKILL (ASSOCIATIVA)
--------------------------------------------------------------------
CREATE TABLE trilha_skill (
    trilha_id NUMBER(10) NOT NULL,
    skill_id NUMBER(10) NOT NULL,
    nivel_esperado NUMBER(3),
    CONSTRAINT pk_trilha_skill PRIMARY KEY (trilha_id, skill_id),
    CONSTRAINT ck_trilha_skill_nivel CHECK (
        nivel_esperado BETWEEN 0 AND 100
    )
);
--------------------------------------------------------------------
-- TABELA: PERGUNTAS_DIAGNOSTICO
--------------------------------------------------------------------
CREATE TABLE perguntas_diagnostico (
    id NUMBER(10) NOT NULL,
    texto_pergunta VARCHAR2(500) NOT NULL,
    skill_id NUMBER(10),
    peso NUMBER(3) DEFAULT 1 NOT NULL,
    CONSTRAINT pk_perguntas_diag PRIMARY KEY (id)
);
--------------------------------------------------------------------
-- TABELA: DIAGNOSTICOS
--------------------------------------------------------------------
CREATE TABLE diagnosticos (
    id NUMBER(10) NOT NULL,
    user_id NUMBER(10) NOT NULL,
    trilha_id NUMBER(10),
    data_aplicacao TIMESTAMP DEFAULT SYSTIMESTAMP,
    tipo VARCHAR2(30),
    score_geral NUMBER(5, 2),
    CONSTRAINT pk_diagnosticos PRIMARY KEY (id)
);
--------------------------------------------------------------------
-- TABELA: RESPOSTAS_DIAGNOSTICO
--------------------------------------------------------------------
CREATE TABLE respostas_diagnostico (
    id NUMBER(10) NOT NULL,
    diagnostico_id NUMBER(10) NOT NULL,
    pergunta_id NUMBER(10) NOT NULL,
    resposta_texto VARCHAR2(400),
    valor_numerico NUMBER(5, 2),
    CONSTRAINT pk_respostas_diag PRIMARY KEY (id),
    CONSTRAINT uk_resp_diag_pergunta UNIQUE (diagnostico_id, pergunta_id)
);
--------------------------------------------------------------------
-- TABELA: SESSOES_MENTORIA
--------------------------------------------------------------------
CREATE TABLE sessoes_mentoria (
    id NUMBER(10) NOT NULL,
    mentor_id NUMBER(10) NOT NULL,
    aluno_id NUMBER(10) NOT NULL,
    trilha_id NUMBER(10),
    data_hora_inicio TIMESTAMP NOT NULL,
    data_hora_fim TIMESTAMP,
    status VARCHAR2(20) NOT NULL,
    canal VARCHAR2(20),
    observacoes VARCHAR2(500),
    CONSTRAINT pk_sessoes_mentoria PRIMARY KEY (id),
    CONSTRAINT ck_mentoria_status CHECK (status IN ('AGENDADA', 'REALIZADA', 'CANCELADA'))
);
--------------------------------------------------------------------
-- FOREIGN KEYS (ALTER TABLE)
--------------------------------------------------------------------
-- MATRICULAS → USERS, TRILHAS
ALTER TABLE matriculas
ADD CONSTRAINT fk_matriculas_user FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE matriculas
ADD CONSTRAINT fk_matriculas_trilha FOREIGN KEY (trilha_id) REFERENCES trilhas (id);
-- MODULOS → TRILHAS
ALTER TABLE modulos
ADD CONSTRAINT fk_modulos_trilha FOREIGN KEY (trilha_id) REFERENCES trilhas (id);
-- PROGRESSO_MODULO → MATRICULAS, MODULOS
ALTER TABLE progresso_modulo
ADD CONSTRAINT fk_prog_matricula FOREIGN KEY (matricula_id) REFERENCES matriculas (id);
ALTER TABLE progresso_modulo
ADD CONSTRAINT fk_prog_modulo FOREIGN KEY (modulo_id) REFERENCES modulos (id);
-- TRILHA_SKILL → TRILHAS, SKILLS
ALTER TABLE trilha_skill
ADD CONSTRAINT fk_ts_trilha FOREIGN KEY (trilha_id) REFERENCES trilhas (id);
ALTER TABLE trilha_skill
ADD CONSTRAINT fk_ts_skill FOREIGN KEY (skill_id) REFERENCES skills (id);
-- PERGUNTAS_DIAGNOSTICO → SKILLS
ALTER TABLE perguntas_diagnostico
ADD CONSTRAINT fk_perg_skill FOREIGN KEY (skill_id) REFERENCES skills (id);
-- DIAGNOSTICOS → USERS, TRILHAS
ALTER TABLE diagnosticos
ADD CONSTRAINT fk_diag_user FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE diagnosticos
ADD CONSTRAINT fk_diag_trilha FOREIGN KEY (trilha_id) REFERENCES trilhas (id);
-- RESPOSTAS_DIAGNOSTICO → DIAGNOSTICOS, PERGUNTAS_DIAGNOSTICO
ALTER TABLE respostas_diagnostico
ADD CONSTRAINT fk_resp_diag FOREIGN KEY (diagnostico_id) REFERENCES diagnosticos (id);
ALTER TABLE respostas_diagnostico
ADD CONSTRAINT fk_resp_pergunta FOREIGN KEY (pergunta_id) REFERENCES perguntas_diagnostico (id);
-- SESSOES_MENTORIA → USERS, TRILHAS
ALTER TABLE sessoes_mentoria
ADD CONSTRAINT fk_mentoria_mentor FOREIGN KEY (mentor_id) REFERENCES users (id);
ALTER TABLE sessoes_mentoria
ADD CONSTRAINT fk_mentoria_aluno FOREIGN KEY (aluno_id) REFERENCES users (id);
ALTER TABLE sessoes_mentoria
ADD CONSTRAINT fk_mentoria_trilha FOREIGN KEY (trilha_id) REFERENCES trilhas (id);
--------------------------------------------------------------------
-- SEQUENCES (para uso futuro pela aplicação)
--------------------------------------------------------------------
CREATE SEQUENCE seq_users START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_trilhas START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_matriculas START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_modulos START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_progresso_modulo START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_skills START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_perguntas_diag START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_diagnosticos START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_respostas_diag START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_sessoes_mentoria START WITH 1 INCREMENT BY 1 NOCACHE;