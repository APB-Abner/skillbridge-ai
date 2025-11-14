-- SkillBridge.AI — DB Init (MySQL 8.0 & Oracle 19c+)
-- Este arquivo contém DOIS blocos: primeiro MySQL, depois Oracle.
-- Ajustado a partir do V1__init.sql (PostgreSQL) para uso em sala.
/***********************************
 *            MYSQL 8.0+           *
 ***********************************/
-- Recomendado: MySQL 8.0.16+ (CHECK e default expressions)
-- Charset/Collation para case-insensitive em e-mail
CREATE DATABASE IF NOT EXISTS skillbridge DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_0900_ai_ci;
USE skillbridge;
-- USERS
CREATE TABLE IF NOT EXISTS users (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    email VARCHAR(320) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    preferred_name VARCHAR(255),
    phone VARCHAR(50),
    locale VARCHAR(16) DEFAULT 'pt_BR',
    timezone VARCHAR(64) DEFAULT 'America/Sao_Paulo',
    auth_provider VARCHAR(20) DEFAULT 'local',
    -- local | google | msft | github
    external_id VARCHAR(128),
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    UNIQUE KEY ux_users_email (email)
) ENGINE = InnoDB;
-- ROLES
CREATE TABLE IF NOT EXISTS roles (
    code VARCHAR(32) PRIMARY KEY,
    name VARCHAR(100) NOT NULL
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS user_roles (
    user_id CHAR(36) NOT NULL,
    role_code VARCHAR(32) NOT NULL,
    granted_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (user_id, role_code),
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_code) REFERENCES roles(code) ON DELETE CASCADE
) ENGINE = InnoDB;
-- ORGANIZATIONS
CREATE TABLE IF NOT EXISTS organizations (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(255) NOT NULL,
    org_type VARCHAR(20) CHECK (
        org_type IN (
            'company',
            'school',
            'ngo',
            'government',
            'community'
        )
    ),
    website VARCHAR(500),
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS org_memberships (
    org_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    role_in_org VARCHAR(32),
    joined_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (org_id, user_id),
    CONSTRAINT fk_orgm_org FOREIGN KEY (org_id) REFERENCES organizations(id) ON DELETE CASCADE,
    CONSTRAINT fk_orgm_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE = InnoDB;
-- SKILLS
CREATE TABLE IF NOT EXISTS skill_categories (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(120) NOT NULL,
    UNIQUE KEY ux_skillcat_name (name)
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS skills (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    slug VARCHAR(120) NOT NULL,
    name VARCHAR(120) NOT NULL,
    category_id CHAR(36),
    UNIQUE KEY ux_skills_slug (slug),
    CONSTRAINT fk_skills_cat FOREIGN KEY (category_id) REFERENCES skill_categories(id) ON DELETE
    SET NULL
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS user_skill_profiles (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36) NOT NULL UNIQUE,
    headline VARCHAR(255),
    summary TEXT,
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_usp_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS user_skills (
    profile_id CHAR(36) NOT NULL,
    skill_id CHAR(36) NOT NULL,
    level TINYINT NOT NULL CHECK (
        level BETWEEN 0 AND 5
    ),
    years_exp DECIMAL(4, 1) DEFAULT 0 CHECK (years_exp >= 0),
    last_used_on DATE,
    evidence_url VARCHAR(500),
    PRIMARY KEY (profile_id, skill_id),
    CONSTRAINT fk_us_profile FOREIGN KEY (profile_id) REFERENCES user_skill_profiles(id) ON DELETE CASCADE,
    CONSTRAINT fk_us_skill FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE
) ENGINE = InnoDB;
-- LEARNING
CREATE TABLE IF NOT EXISTS courses (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    org_id CHAR(36),
    code VARCHAR(64) NOT NULL,
    title VARCHAR(255) NOT NULL,
    mode ENUM('online', 'presential', 'hybrid') NOT NULL,
    level VARCHAR(32),
    language VARCHAR(16) DEFAULT 'pt-BR',
    description TEXT,
    created_by CHAR(36),
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    UNIQUE KEY ux_courses_code (code),
    CONSTRAINT fk_courses_org FOREIGN KEY (org_id) REFERENCES organizations(id) ON DELETE
    SET NULL,
        CONSTRAINT fk_courses_user FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE
    SET NULL
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS course_modules (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    course_id CHAR(36) NOT NULL,
    idx INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    summary TEXT,
    UNIQUE KEY ux_course_modules (course_id, idx),
    CONSTRAINT fk_cm_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS enrollments (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36) NOT NULL,
    course_id CHAR(36) NOT NULL,
    status ENUM('pending', 'active', 'completed', 'cancelled') NOT NULL,
    enrolled_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    completed_at TIMESTAMP(6) NULL,
    UNIQUE KEY ux_enroll_user_course (user_id, course_id),
    CONSTRAINT fk_en_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_en_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE = InnoDB;
-- MENTORING
CREATE TABLE IF NOT EXISTS mentors (
    user_id CHAR(36) NOT NULL PRIMARY KEY,
    headline VARCHAR(255),
    bio TEXT,
    rating DECIMAL(3, 2) CHECK (
        rating BETWEEN 0 AND 5
    ),
    hourly_rate DECIMAL(10, 2),
    currency CHAR(3) DEFAULT 'BRL',
    CONSTRAINT fk_mentors_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS mentor_availability (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    mentor_user_id CHAR(36) NOT NULL,
    weekday TINYINT NOT NULL CHECK (
        weekday BETWEEN 0 AND 6
    ),
    -- 0=domingo
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    timezone VARCHAR(64) DEFAULT 'America/Sao_Paulo',
    CONSTRAINT ck_ma_time CHECK (start_time < end_time),
    UNIQUE KEY ux_ma_uq (mentor_user_id, weekday, start_time, end_time),
    CONSTRAINT fk_ma_mentor FOREIGN KEY (mentor_user_id) REFERENCES mentors(user_id) ON DELETE CASCADE
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS mentoring_sessions (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    mentor_user_id CHAR(36) NOT NULL,
    learner_user_id CHAR(36) NOT NULL,
    scheduled_start DATETIME(6) NOT NULL,
    scheduled_end DATETIME(6) NOT NULL,
    status ENUM(
        'requested',
        'scheduled',
        'completed',
        'cancelled',
        'no_show'
    ) NOT NULL,
    location_url VARCHAR(500),
    notes TEXT,
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    UNIQUE KEY ux_ms_unique (mentor_user_id, learner_user_id, scheduled_start),
    CONSTRAINT fk_ms_mentor FOREIGN KEY (mentor_user_id) REFERENCES mentors(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_ms_learner FOREIGN KEY (learner_user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS session_feedback (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    session_id CHAR(36) NOT NULL,
    rating TINYINT NOT NULL CHECK (
        rating BETWEEN 1 AND 5
    ),
    comment TEXT,
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    UNIQUE KEY ux_sf_session (session_id),
    CONSTRAINT fk_sf_session FOREIGN KEY (session_id) REFERENCES mentoring_sessions(id) ON DELETE CASCADE
) ENGINE = InnoDB;
-- BADGES & ASSESSMENTS
CREATE TABLE IF NOT EXISTS assessment_attempts (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36) NOT NULL,
    course_id CHAR(36),
    module_id CHAR(36),
    score DECIMAL(5, 2),
    rubric JSON,
    started_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    finished_at DATETIME(6),
    CONSTRAINT fk_aa_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_aa_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE
    SET NULL,
        CONSTRAINT fk_aa_module FOREIGN KEY (module_id) REFERENCES course_modules(id) ON DELETE
    SET NULL
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS badges (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    code VARCHAR(64) NOT NULL,
    name VARCHAR(120) NOT NULL,
    description TEXT,
    UNIQUE KEY ux_badges_code (code)
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS user_badges (
    user_id CHAR(36) NOT NULL,
    badge_id CHAR(36) NOT NULL,
    awarded_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (user_id, badge_id),
    CONSTRAINT fk_ub_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_ub_badge FOREIGN KEY (badge_id) REFERENCES badges(id) ON DELETE CASCADE
) ENGINE = InnoDB;
-- MENSAGENS & NOTIFICAÇÕES
CREATE TABLE IF NOT EXISTS messages (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    sender_user_id CHAR(36) NOT NULL,
    receiver_user_id CHAR(36) NOT NULL,
    session_id CHAR(36),
    body TEXT NOT NULL,
    sent_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    KEY ix_messages_receiver_time (receiver_user_id, sent_at DESC),
    CONSTRAINT fk_msg_sender FOREIGN KEY (sender_user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_msg_receiver FOREIGN KEY (receiver_user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_msg_session FOREIGN KEY (session_id) REFERENCES mentoring_sessions(id) ON DELETE
    SET NULL
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS notifications (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36) NOT NULL,
    n_type VARCHAR(64) NOT NULL,
    payload JSON NOT NULL,
    read_at DATETIME(6),
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    KEY ix_notifications_user_time (user_id, created_at DESC),
    CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE = InnoDB;
-- TELEMETRIA & OUTBOX
CREATE TABLE IF NOT EXISTS analytics_events (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36),
    name VARCHAR(120) NOT NULL,
    metadata JSON,
    occurred_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    KEY ix_events_name_time (name, occurred_at DESC),
    CONSTRAINT fk_ae_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE
    SET NULL
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS domain_events_outbox (
    id CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    aggregate_type VARCHAR(120) NOT NULL,
    aggregate_id CHAR(36) NOT NULL,
    event_type VARCHAR(120) NOT NULL,
    payload JSON NOT NULL,
    occurred_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    processed_at DATETIME(6)
) ENGINE = InnoDB;
-- SEEDS (idempotentes)
INSERT INTO roles(code, name)
VALUES ('ADMIN', 'Administrador'),
('LEARNER', 'Aluno(a)'),
('MENTOR', 'Mentor(a)'),
('ORG_OWNER', 'Dono(a) da Organização') ON DUPLICATE KEY
UPDATE name =
VALUES(name);
INSERT INTO skill_categories(id, name)
VALUES (UUID(), 'Software Engineering'),
(UUID(), 'Data & AI'),
(UUID(), 'AR/VR'),
(UUID(), 'Soft Skills') ON DUPLICATE KEY
UPDATE name =
VALUES(name);
INSERT INTO skills(id, slug, name, category_id)
SELECT UUID(),
    s.slug,
    s.name,
    sc.id
FROM (
        SELECT 'java' slug,
            'Java' name,
            'Software Engineering' cat
        UNION ALL
        SELECT 'spring-boot',
            'Spring Boot',
            'Software Engineering'
        UNION ALL
        SELECT 'sql',
            'SQL',
            'Software Engineering'
        UNION ALL
        SELECT 'python',
            'Python',
            'Data & AI'
        UNION ALL
        SELECT 'ml-basics',
            'Machine Learning (Básico)',
            'Data & AI'
        UNION ALL
        SELECT 'unity',
            'Unity 3D',
            'AR/VR'
        UNION ALL
        SELECT 'communication',
            'Comunicação',
            'Soft Skills'
    ) s
    JOIN skill_categories sc ON sc.name = s.cat
    LEFT JOIN skills k ON k.slug = s.slug
WHERE k.id IS NULL;
INSERT INTO badges(id, code, name, description)
VALUES (
        UUID(),
        'ONBOARD_OK',
        'Onboarding Concluído',
        'Finalizou perfil e primeiros passos'
    ),
    (
        UUID(),
        'FIRST_SESSION',
        'Primeira Mentoria',
        'Realizou a primeira sessão de mentoria'
    ),
    (
        UUID(),
        'COURSE_STARTER',
        'Começou Curso',
        'Iniciou o primeiro curso'
    ) ON DUPLICATE KEY
UPDATE name =
VALUES(name),
    description =
VALUES(description);