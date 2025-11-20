/***********************************
 *           ORACLE 19c+           *
 ***********************************/
-- Observações:
--  - IDs: RAW(16) com default SYS_GUID()
--  - E-mail único case-insensitive via índice funcional em LOWER(email)
--  - JSON: usar CLOB com constraint IS JSON
--  - updated_at via trigger BEFORE UPDATE
-- USERS
CREATE TABLE users (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    email VARCHAR2(320) NOT NULL,
    full_name VARCHAR2(255) NOT NULL,
    preferred_name VARCHAR2(255),
    phone VARCHAR2(50),
    locale VARCHAR2(16) DEFAULT 'pt_BR',
    timezone VARCHAR2(64) DEFAULT 'America/Sao_Paulo',
    auth_provider VARCHAR2(20) DEFAULT 'local',
    external_id VARCHAR2(128),
    created_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    updated_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL
);
CREATE UNIQUE INDEX ux_users_email_ci ON users (LOWER(email));
CREATE OR REPLACE TRIGGER trg_users_updated BEFORE
UPDATE ON users FOR EACH ROW BEGIN :NEW.updated_at := SYSTIMESTAMP;
END;
/ -- ROLES
CREATE TABLE roles (
    code VARCHAR2(32) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL
);
CREATE TABLE user_roles (
    user_id RAW(16) NOT NULL,
    role_code VARCHAR2(32) NOT NULL,
    granted_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT pk_user_roles PRIMARY KEY (user_id, role_code),
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_code) REFERENCES roles(code) ON DELETE CASCADE
);
-- ORGANIZATIONS
CREATE TABLE organizations (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    org_type VARCHAR2(20),
    website VARCHAR2(500),
    created_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    updated_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT ck_org_type CHECK (
        org_type IN (
            'company',
            'school',
            'ngo',
            'government',
            'community'
        )
    )
);
CREATE OR REPLACE TRIGGER trg_orgs_updated BEFORE
UPDATE ON organizations FOR EACH ROW BEGIN :NEW.updated_at := SYSTIMESTAMP;
END;
/ CREATE TABLE org_memberships (
    org_id RAW(16) NOT NULL,
    user_id RAW(16) NOT NULL,
    role_in_org VARCHAR2(32),
    joined_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT pk_org_memberships PRIMARY KEY (org_id, user_id),
    CONSTRAINT fk_orgm_org FOREIGN KEY (org_id) REFERENCES organizations(id) ON DELETE CASCADE,
    CONSTRAINT fk_orgm_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
-- SKILLS
CREATE TABLE skill_categories (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    name VARCHAR2(120) NOT NULL
);
CREATE UNIQUE INDEX ux_skillcat_name ON skill_categories(name);
CREATE TABLE skills (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    slug VARCHAR2(120) NOT NULL,
    name VARCHAR2(120) NOT NULL,
    category_id RAW(16),
    CONSTRAINT uq_skills_slug UNIQUE (slug),
    CONSTRAINT fk_skills_cat FOREIGN KEY (category_id) REFERENCES skill_categories(id) ON DELETE
    SET NULL
);
CREATE TABLE user_skill_profiles (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    user_id RAW(16) NOT NULL UNIQUE,
    headline VARCHAR2(255),
    summary CLOB,
    created_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    updated_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT fk_usp_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE OR REPLACE TRIGGER trg_usp_updated BEFORE
UPDATE ON user_skill_profiles FOR EACH ROW BEGIN :NEW.updated_at := SYSTIMESTAMP;
END;
/ CREATE TABLE user_skills (
    profile_id RAW(16) NOT NULL,
    skill_id RAW(16) NOT NULL,
    level NUMBER(2) DEFAULT 0 NOT NULL,
    years_exp NUMBER(5, 1) DEFAULT 0,
    last_used_on DATE,
    evidence_url VARCHAR2(500),
    CONSTRAINT pk_user_skills PRIMARY KEY (profile_id, skill_id),
    CONSTRAINT ck_us_level CHECK (
        level BETWEEN 0 AND 5
    ),
    CONSTRAINT ck_us_years CHECK (years_exp >= 0),
    CONSTRAINT fk_us_profile FOREIGN KEY (profile_id) REFERENCES user_skill_profiles(id) ON DELETE CASCADE,
    CONSTRAINT fk_us_skill FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE
);
-- LEARNING
CREATE TABLE courses (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    org_id RAW(16),
    code VARCHAR2(64) NOT NULL,
    title VARCHAR2(255) NOT NULL,
    mode VARCHAR2(16) NOT NULL,
    level VARCHAR2(32),
    language VARCHAR2(16) DEFAULT 'pt-BR',
    description CLOB,
    created_by RAW(16),
    created_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    updated_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT uq_courses_code UNIQUE (code),
    CONSTRAINT ck_courses_mode CHECK (mode IN ('online', 'presential', 'hybrid')),
    CONSTRAINT fk_courses_org FOREIGN KEY (org_id) REFERENCES organizations(id) ON DELETE
    SET NULL,
        CONSTRAINT fk_courses_user FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE
    SET NULL
);
CREATE OR REPLACE TRIGGER trg_courses_updated BEFORE
UPDATE ON courses FOR EACH ROW BEGIN :NEW.updated_at := SYSTIMESTAMP;
END;
/ CREATE TABLE course_modules (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    course_id RAW(16) NOT NULL,
    idx NUMBER(10) NOT NULL,
    title VARCHAR2(255) NOT NULL,
    summary CLOB,
    CONSTRAINT uq_course_modules UNIQUE (course_id, idx),
    CONSTRAINT fk_cm_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);
CREATE TABLE enrollments (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    user_id RAW(16) NOT NULL,
    course_id RAW(16) NOT NULL,
    status VARCHAR2(16) NOT NULL,
    enrolled_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    completed_at TIMESTAMP(6),
    CONSTRAINT uq_enroll_user_course UNIQUE (user_id, course_id),
    CONSTRAINT ck_en_status CHECK (
        status IN ('pending', 'active', 'completed', 'cancelled')
    ),
    CONSTRAINT fk_en_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_en_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);
-- MENTORING
CREATE TABLE mentors (
    user_id RAW(16) PRIMARY KEY,
    headline VARCHAR2(255),
    bio CLOB,
    rating NUMBER(4, 2),
    hourly_rate NUMBER(12, 2),
    currency CHAR(3) DEFAULT 'BRL',
    CONSTRAINT ck_rating CHECK (
        rating BETWEEN 0 AND 5
    ),
    CONSTRAINT fk_mentors_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE TABLE mentor_availability (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    mentor_user_id RAW(16) NOT NULL,
    weekday NUMBER(1) NOT NULL,
    start_time INTERVAL DAY TO SECOND,
    -- alternativa: VARCHAR2(8) 'HH24:MI:SS'
    end_time INTERVAL DAY TO SECOND,
    timezone VARCHAR2(64) DEFAULT 'America/Sao_Paulo',
    CONSTRAINT ck_ma_wd CHECK (
        weekday BETWEEN 0 AND 6
    ),
    CONSTRAINT ck_ma_time CHECK (end_time > start_time),
    CONSTRAINT uq_ma UNIQUE (mentor_user_id, weekday, start_time, end_time),
    CONSTRAINT fk_ma_mentor FOREIGN KEY (mentor_user_id) REFERENCES mentors(user_id) ON DELETE CASCADE
);
CREATE TABLE mentoring_sessions (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    mentor_user_id RAW(16) NOT NULL,
    learner_user_id RAW(16) NOT NULL,
    scheduled_start TIMESTAMP(6) NOT NULL,
    scheduled_end TIMESTAMP(6) NOT NULL,
    status VARCHAR2(16) NOT NULL,
    location_url VARCHAR2(500),
    notes CLOB,
    created_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT ck_ms_status CHECK (
        status IN (
            'requested',
            'scheduled',
            'completed',
            'cancelled',
            'no_show'
        )
    ),
    CONSTRAINT uq_ms UNIQUE (mentor_user_id, learner_user_id, scheduled_start),
    CONSTRAINT fk_ms_mentor FOREIGN KEY (mentor_user_id) REFERENCES mentors(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_ms_learner FOREIGN KEY (learner_user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE TABLE session_feedback (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    session_id RAW(16) NOT NULL,
    rating NUMBER(1) NOT NULL,
    comment CLOB,
    created_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT ck_sf_rating CHECK (
        rating BETWEEN 1 AND 5
    ),
    CONSTRAINT uq_sf_session UNIQUE (session_id),
    CONSTRAINT fk_sf_session FOREIGN KEY (session_id) REFERENCES mentoring_sessions(id) ON DELETE CASCADE
);
-- ASSESSMENTS, BADGES
CREATE TABLE assessment_attempts (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    user_id RAW(16) NOT NULL,
    course_id RAW(16),
    module_id RAW(16),
    score NUMBER(5, 2),
    rubric CLOB CHECK (rubric IS JSON),
    started_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    finished_at TIMESTAMP(6),
    CONSTRAINT fk_aa_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_aa_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE
    SET NULL,
        CONSTRAINT fk_aa_module FOREIGN KEY (module_id) REFERENCES course_modules(id) ON DELETE
    SET NULL
);
CREATE TABLE badges (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    code VARCHAR2(64) NOT NULL UNIQUE,
    name VARCHAR2(120) NOT NULL,
    description CLOB
);
CREATE TABLE user_badges (
    user_id RAW(16) NOT NULL,
    badge_id RAW(16) NOT NULL,
    awarded_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT pk_user_badges PRIMARY KEY (user_id, badge_id),
    CONSTRAINT fk_ub_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_ub_badge FOREIGN KEY (badge_id) REFERENCES badges(id) ON DELETE CASCADE
);
-- MENSAGENS & NOTIFICAÇÕES
CREATE TABLE messages (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    sender_user_id RAW(16) NOT NULL,
    receiver_user_id RAW(16) NOT NULL,
    session_id RAW(16),
    body CLOB NOT NULL,
    sent_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT fk_msg_sender FOREIGN KEY (sender_user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_msg_receiver FOREIGN KEY (receiver_user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_msg_session FOREIGN KEY (session_id) REFERENCES mentoring_sessions(id) ON DELETE
    SET NULL
);
CREATE INDEX ix_messages_receiver_time ON messages(receiver_user_id, sent_at DESC);
CREATE TABLE notifications (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    user_id RAW(16) NOT NULL,
    n_type VARCHAR2(64) NOT NULL,
    payload CLOB CHECK (payload IS JSON) NOT NULL,
    read_at TIMESTAMP(6),
    created_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX ix_notifications_user_time ON notifications(user_id, created_at DESC);
-- TELEMETRIA & OUTBOX
CREATE TABLE analytics_events (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    user_id RAW(16),
    name VARCHAR2(120) NOT NULL,
    metadata CLOB CHECK (metadata IS JSON),
    occurred_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT fk_ae_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE
    SET NULL
);
CREATE INDEX ix_events_name_time ON analytics_events(name, occurred_at DESC);
CREATE TABLE domain_events_outbox (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    aggregate_type VARCHAR2(120) NOT NULL,
    aggregate_id RAW(16) NOT NULL,
    event_type VARCHAR2(120) NOT NULL,
    payload CLOB CHECK (payload IS JSON) NOT NULL,
    occurred_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
    processed_at TIMESTAMP(6)
);
-- SEEDS (idempotentes)
-- ROLES
INSERT INTO roles(code, name)
SELECT 'ADMIN',
    'Administrador'
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM roles
        WHERE code = 'ADMIN'
    );
INSERT INTO roles(code, name)
SELECT 'LEARNER',
    'Aluno(a)'
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM roles
        WHERE code = 'LEARNER'
    );
INSERT INTO roles(code, name)
SELECT 'MENTOR',
    'Mentor(a)'
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM roles
        WHERE code = 'MENTOR'
    );
INSERT INTO roles(code, name)
SELECT 'ORG_OWNER',
    'Dono(a) da Organização'
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM roles
        WHERE code = 'ORG_OWNER'
    );
-- SKILL CATEGORIES
INSERT INTO skill_categories(id, name)
SELECT SYS_GUID(),
    'Software Engineering'
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM skill_categories
        WHERE name = 'Software Engineering'
    );
INSERT INTO skill_categories(id, name)
SELECT SYS_GUID(),
    'Data & AI'
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM skill_categories
        WHERE name = 'Data & AI'
    );
INSERT INTO skill_categories(id, name)
SELECT SYS_GUID(),
    'AR/VR'
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM skill_categories
        WHERE name = 'AR/VR'
    );
INSERT INTO skill_categories(id, name)
SELECT SYS_GUID(),
    'Soft Skills'
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM skill_categories
        WHERE name = 'Soft Skills'
    );
-- SKILLS
INSERT INTO skills(id, slug, name, category_id)
SELECT SYS_GUID(),
    'java',
    'Java',
    (
        SELECT id
        FROM skill_categories
        WHERE name = 'Software Engineering'
    )
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM skills
        WHERE slug = 'java'
    );
INSERT INTO skills(id, slug, name, category_id)
SELECT SYS_GUID(),
    'spring-boot',
    'Spring Boot',
    (
        SELECT id
        FROM skill_categories
        WHERE name = 'Software Engineering'
    )
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM skills
        WHERE slug = 'spring-boot'
    );
INSERT INTO skills(id, slug, name, category_id)
SELECT SYS_GUID(),
    'sql',
    'SQL',
    (
        SELECT id
        FROM skill_categories
        WHERE name = 'Software Engineering'
    )
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM skills
        WHERE slug = 'sql'
    );
INSERT INTO skills(id, slug, name, category_id)
SELECT SYS_GUID(),
    'python',
    'Python',
    (
        SELECT id
        FROM skill_categories
        WHERE name = 'Data & AI'
    )
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM skills
        WHERE slug = 'python'
    );
INSERT INTO skills(id, slug, name, category_id)
SELECT SYS_GUID(),
    'ml-basics',
    'Machine Learning (Básico)',
    (
        SELECT id
        FROM skill_categories
        WHERE name = 'Data & AI'
    )
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM skills
        WHERE slug = 'ml-basics'
    );
INSERT INTO skills(id, slug, name, category_id)
SELECT SYS_GUID(),
    'unity',
    'Unity 3D',
    (
        SELECT id
        FROM skill_categories
        WHERE name = 'AR/VR'
    )
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM skills
        WHERE slug = 'unity'
    );
INSERT INTO skills(id, slug, name, category_id)
SELECT SYS_GUID(),
    'communication',
    'Comunicação',
    (
        SELECT id
        FROM skill_categories
        WHERE name = 'Soft Skills'
    )
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM skills
        WHERE slug = 'communication'
    );
-- BADGES
INSERT INTO badges(id, code, name, description)
SELECT SYS_GUID(),
    'ONBOARD_OK',
    'Onboarding Concluído',
    'Finalizou perfil e primeiros passos'
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM badges
        WHERE code = 'ONBOARD_OK'
    );
INSERT INTO badges(id, code, name, description)
SELECT SYS_GUID(),
    'FIRST_SESSION',
    'Primeira Mentoria',
    'Realizou a primeira sessão de mentoria'
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM badges
        WHERE code = 'FIRST_SESSION'
    );
INSERT INTO badges(id, code, name, description)
SELECT SYS_GUID(),
    'COURSE_STARTER',
    'Começou Curso',
    'Iniciou o primeiro curso'
FROM dual
WHERE NOT EXISTS (
        SELECT 1
        FROM badges
        WHERE code = 'COURSE_STARTER'
    );