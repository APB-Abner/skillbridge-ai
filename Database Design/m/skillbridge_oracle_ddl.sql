-- SkillBridge.AI — Oracle 19c+ DDL
-- Criação do schema mínimo para atender a GS Database Design (Oracle Data Modeler compatível)

/* ========== ROLES ========== */
CREATE TABLE roles (
  code        VARCHAR2(30)  PRIMARY KEY,
  name        VARCHAR2(100) NOT NULL
);

/* ========== USERS ========== */
CREATE TABLE users (
  id            RAW(16)       DEFAULT SYS_GUID() PRIMARY KEY,
  email         VARCHAR2(255) NOT NULL UNIQUE,
  full_name     VARCHAR2(150) NOT NULL,
  preferred_name VARCHAR2(80),
  phone         VARCHAR2(40),
  locale        VARCHAR2(16)  DEFAULT 'pt_BR' NOT NULL,
  timezone      VARCHAR2(64)  DEFAULT 'America/Sao_Paulo' NOT NULL,
  auth_provider VARCHAR2(40),
  external_id   VARCHAR2(100),
  created_at    TIMESTAMP(6)  DEFAULT SYSTIMESTAMP NOT NULL
);

/* ========== USER_ROLES ========== */
CREATE TABLE user_roles (
  user_id   RAW(16)     NOT NULL,
  role_code VARCHAR2(30) NOT NULL,
  granted_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT pk_user_roles PRIMARY KEY (user_id, role_code),
  CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_user_roles_role FOREIGN KEY (role_code) REFERENCES roles(code)
);

/* ========== ORGANIZATIONS ========== */
CREATE TABLE organizations (
  id          RAW(16)       DEFAULT SYS_GUID() PRIMARY KEY,
  name        VARCHAR2(150) NOT NULL UNIQUE,
  org_type    VARCHAR2(30)  CHECK (org_type IN ('company','school','ngo','government','community')),
  website     VARCHAR2(255),
  created_at  TIMESTAMP(6)  DEFAULT SYSTIMESTAMP NOT NULL
);

/* ========== ORG_MEMBERSHIPS ========== */
CREATE TABLE org_memberships (
  org_id     RAW(16) NOT NULL,
  user_id    RAW(16) NOT NULL,
  role_in_org VARCHAR2(40),
  joined_at  TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT pk_org_memberships PRIMARY KEY (org_id, user_id),
  CONSTRAINT fk_om_org FOREIGN KEY (org_id) REFERENCES organizations(id),
  CONSTRAINT fk_om_user FOREIGN KEY (user_id) REFERENCES users(id)
);

/* ========== SKILL CATEGORIES ========== */
CREATE TABLE skill_categories (
  id   RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  name VARCHAR2(100) NOT NULL UNIQUE
);

/* ========== SKILLS ========== */
CREATE TABLE skills (
  id           RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  slug         VARCHAR2(60) NOT NULL UNIQUE,
  name         VARCHAR2(120) NOT NULL,
  category_id  RAW(16) NOT NULL,
  CONSTRAINT fk_skill_category FOREIGN KEY (category_id) REFERENCES skill_categories(id)
);

/* ========== USER SKILL PROFILE ========== */
CREATE TABLE user_skill_profiles (
  id        RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  user_id   RAW(16) NOT NULL UNIQUE,
  headline  VARCHAR2(140),
  summary   CLOB,
  updated_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT fk_usp_user FOREIGN KEY (user_id) REFERENCES users(id)
);

/* ========== USER SKILLS ========== */
CREATE TABLE user_skills (
  profile_id  RAW(16) NOT NULL,
  skill_id    RAW(16) NOT NULL,
  level       NUMBER(2) CHECK (level BETWEEN 1 AND 5),
  years_exp   NUMBER(4,1),
  last_used_on DATE,
  evidence_url VARCHAR2(4000),
  CONSTRAINT pk_user_skills PRIMARY KEY (profile_id, skill_id),
  CONSTRAINT fk_us_profile FOREIGN KEY (profile_id) REFERENCES user_skill_profiles(id),
  CONSTRAINT fk_us_skill FOREIGN KEY (skill_id) REFERENCES skills(id)
);

/* ========== COURSES ========== */
CREATE TABLE courses (
  id          RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  org_id      RAW(16) NOT NULL,
  code        VARCHAR2(40) NOT NULL UNIQUE,
  title       VARCHAR2(200) NOT NULL,
  mode        VARCHAR2(20) CHECK (mode IN ('online','presential','hybrid')),
  level       VARCHAR2(20) CHECK (level IN ('beginner','intermediate','advanced')),
  language    VARCHAR2(10) DEFAULT 'pt-BR' NOT NULL,
  description CLOB,
  created_by  RAW(16) NOT NULL,
  created_at  TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT fk_course_org FOREIGN KEY (org_id) REFERENCES organizations(id),
  CONSTRAINT fk_course_creator FOREIGN KEY (created_by) REFERENCES users(id)
);

/* ========== COURSE MODULES ========== */
CREATE TABLE course_modules (
  id         RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  course_id  RAW(16) NOT NULL,
  idx        NUMBER(4) NOT NULL,
  title      VARCHAR2(200) NOT NULL,
  summary    VARCHAR2(4000),
  created_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT uq_course_modules UNIQUE (course_id, idx),
  CONSTRAINT fk_cm_course FOREIGN KEY (course_id) REFERENCES courses(id)
);

/* ========== ENROLLMENTS ========== */
CREATE TABLE enrollments (
  id          RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  user_id     RAW(16) NOT NULL,
  course_id   RAW(16) NOT NULL,
  status      VARCHAR2(20) CHECK (status IN ('active','completed','dropped','pending')),
  enrolled_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT fk_enr_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_enr_course FOREIGN KEY (course_id) REFERENCES courses(id)
);

/* ========== MENTORS ========== */
CREATE TABLE mentors (
  user_id     RAW(16) PRIMARY KEY,
  headline    VARCHAR2(140),
  bio         CLOB,
  rating      NUMBER(3,1) CHECK (rating BETWEEN 0 AND 5),
  hourly_rate NUMBER(10,2),
  timezone    VARCHAR2(64) DEFAULT 'America/Sao_Paulo' NOT NULL,
  created_at  TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT fk_mentor_user FOREIGN KEY (user_id) REFERENCES users(id)
);

/* ========== MENTOR AVAILABILITY ========== */
CREATE TABLE mentor_availability (
  id            RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  mentor_user_id RAW(16) NOT NULL,
  weekday       NUMBER(1) CHECK (weekday BETWEEN 1 AND 7),
  start_time    INTERVAL DAY TO SECOND,
  end_time      INTERVAL DAY TO SECOND,
  timezone      VARCHAR2(64) DEFAULT 'America/Sao_Paulo' NOT NULL,
  CONSTRAINT fk_ma_mentor FOREIGN KEY (mentor_user_id) REFERENCES mentors(user_id)
);

/* ========== MENTORING SESSIONS ========== */
CREATE TABLE mentoring_sessions (
  id              RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  mentor_user_id  RAW(16) NOT NULL,
  learner_user_id RAW(16) NOT NULL,
  scheduled_start TIMESTAMP(6) NOT NULL,
  scheduled_end   TIMESTAMP(6) NOT NULL,
  status          VARCHAR2(20) CHECK (status IN ('scheduled','done','canceled')),
  location_url    VARCHAR2(4000),
  notes           CLOB,
  attended_at     TIMESTAMP(6),
  CONSTRAINT fk_ms_mentor  FOREIGN KEY (mentor_user_id)  REFERENCES mentors(user_id),
  CONSTRAINT fk_ms_learner FOREIGN KEY (learner_user_id) REFERENCES users(id)
);

/* ========== SESSION FEEDBACK ========== */
CREATE TABLE session_feedback (
  id         RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  session_id RAW(16) NOT NULL,
  rating     NUMBER(2) CHECK (rating BETWEEN 1 AND 5),
  comment    CLOB,
  created_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT fk_sf_session FOREIGN KEY (session_id) REFERENCES mentoring_sessions(id)
);

/* ========== BADGES ========== */
CREATE TABLE badges (
  id          RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  code        VARCHAR2(60) NOT NULL UNIQUE,
  name        VARCHAR2(120) NOT NULL,
  description VARCHAR2(4000),
  icon_url    VARCHAR2(4000),
  created_at  TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL
);

/* ========== USER BADGES ========== */
CREATE TABLE user_badges (
  user_id    RAW(16) NOT NULL,
  badge_id   RAW(16) NOT NULL,
  awarded_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT pk_user_badges PRIMARY KEY (user_id, badge_id),
  CONSTRAINT fk_ub_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_ub_badge FOREIGN KEY (badge_id) REFERENCES badges(id)
);

/* ========== ASSESSMENT ATTEMPTS ========== */
CREATE TABLE assessment_attempts (
  id         RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  user_id    RAW(16) NOT NULL,
  course_id  RAW(16) NOT NULL,
  module_id  RAW(16) NOT NULL,
  score      NUMBER(5,2),
  rubric     CLOB CHECK (rubric IS JSON),
  started_at TIMESTAMP(6),
  finished_at TIMESTAMP(6),
  CONSTRAINT fk_aa_user   FOREIGN KEY (user_id)   REFERENCES users(id),
  CONSTRAINT fk_aa_course FOREIGN KEY (course_id) REFERENCES courses(id),
  CONSTRAINT fk_aa_module FOREIGN KEY (module_id) REFERENCES course_modules(id)
);

/* ========== MESSAGES ========== */
CREATE TABLE messages (
  id              RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  sender_user_id  RAW(16) NOT NULL,
  receiver_user_id RAW(16) NOT NULL,
  session_id      RAW(16),
  body            CLOB NOT NULL,
  created_at      TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT fk_msg_sender FOREIGN KEY (sender_user_id) REFERENCES users(id),
  CONSTRAINT fk_msg_receiver FOREIGN KEY (receiver_user_id) REFERENCES users(id),
  CONSTRAINT fk_msg_session FOREIGN KEY (session_id) REFERENCES mentoring_sessions(id)
);

/* ========== NOTIFICATIONS ========== */
CREATE TABLE notifications (
  id         RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  user_id    RAW(16) NOT NULL,
  n_type     VARCHAR2(60) NOT NULL,
  payload    CLOB CHECK (payload IS JSON),
  created_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
  read_at    TIMESTAMP(6),
  CONSTRAINT fk_n_user FOREIGN KEY (user_id) REFERENCES users(id)
);

/* ========== ANALYTICS EVENTS ========== */
CREATE TABLE analytics_events (
  id         RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  user_id    RAW(16),
  name       VARCHAR2(120) NOT NULL,
  metadata   CLOB CHECK (metadata IS JSON),
  created_at TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT fk_ae_user FOREIGN KEY (user_id) REFERENCES users(id)
);

/* ========== DOMAIN EVENTS OUTBOX ========== */
CREATE TABLE domain_events_outbox (
  id            RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  aggregate_type VARCHAR2(80) NOT NULL,
  aggregate_id   RAW(16) NOT NULL,
  event_type     VARCHAR2(120) NOT NULL,
  payload        CLOB CHECK (payload IS JSON),
  occurred_at    TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL,
  processed_at   TIMESTAMP(6)
);

/* ========== ÍNDICES AJUDAM CONSULTAS ========== */
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_courses_code ON courses(code);
CREATE INDEX idx_cm_course ON course_modules(course_id, idx);
CREATE INDEX idx_enr_user ON enrollments(user_id);
CREATE INDEX idx_enr_course ON enrollments(course_id);
CREATE INDEX idx_ms_mentor_time ON mentoring_sessions(mentor_user_id, scheduled_start);
CREATE INDEX idx_sf_session ON session_feedback(session_id);
CREATE INDEX idx_msg_session ON messages(session_id);
CREATE INDEX idx_ntf_user_time ON notifications(user_id, created_at);
CREATE INDEX idx_ae_user_time ON analytics_events(user_id, created_at);
