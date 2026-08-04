-- ===========================================
-- Habitye - Smart Habit & Goal Management System
-- create_tables.sql
-- ===========================================

-- 1. USERS
CREATE TABLE USERS (
    user_id NUMBER PRIMARY KEY,
    full_name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    password VARCHAR2(100) NOT NULL,
    phone VARCHAR2(20),
    join_date DATE DEFAULT SYSDATE
);

-- 2. CATEGORIES
CREATE TABLE CATEGORIES (
    category_id NUMBER PRIMARY KEY,
    category_name VARCHAR2(50) NOT NULL,
    description VARCHAR2(255)
);

-- 3. HABITS
CREATE TABLE HABITS (
    habit_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    category_id NUMBER NOT NULL,
    habit_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(255),
    frequency VARCHAR2(20),
    start_date DATE DEFAULT SYSDATE,
    status NUMBER(1) DEFAULT 1 CHECK (status IN (0,1)),

    CONSTRAINT fk_habit_user
        FOREIGN KEY (user_id)
        REFERENCES USERS(user_id),

    CONSTRAINT fk_habit_category
        FOREIGN KEY (category_id)
        REFERENCES CATEGORIES(category_id)
);

-- 4. GOALS
CREATE TABLE GOALS (
    goal_id NUMBER PRIMARY KEY,
    habit_id NUMBER NOT NULL,
    goal_name VARCHAR2(100) NOT NULL,
    goal_type VARCHAR2(30),
    target_value NUMBER,
    current_progress NUMBER DEFAULT 0,
    deadline DATE,
    status NUMBER(1) DEFAULT 0 CHECK (status IN (0,1)),

    CONSTRAINT fk_goal_habit
        FOREIGN KEY (habit_id)
        REFERENCES HABITS(habit_id)
);

-- 5. HABIT_LOG
CREATE TABLE HABIT_LOG (
    log_id NUMBER PRIMARY KEY,
    habit_id NUMBER NOT NULL,
    log_date DATE DEFAULT SYSDATE,
    completed NUMBER(1) DEFAULT 0 CHECK (completed IN (0,1)),
    remarks VARCHAR2(255),

    CONSTRAINT fk_log_habit
        FOREIGN KEY (habit_id)
        REFERENCES HABITS(habit_id)
);

-- 6. REMINDERS
CREATE TABLE REMINDERS (
    reminder_id NUMBER PRIMARY KEY,
    habit_id NUMBER NOT NULL,
    reminder_time VARCHAR2(20),
    days_of_week VARCHAR2(50),
    status NUMBER(1) DEFAULT 1 CHECK (status IN (0,1)),

    CONSTRAINT fk_reminder_habit
        FOREIGN KEY (habit_id)
        REFERENCES HABITS(habit_id)
);

-- 7. STREAKS
CREATE TABLE STREAKS (
    streak_id NUMBER PRIMARY KEY,
    habit_id NUMBER UNIQUE NOT NULL,
    current_streak NUMBER DEFAULT 0,
    longest_streak NUMBER DEFAULT 0,
    last_completed_date DATE,

    CONSTRAINT fk_streak_habit
        FOREIGN KEY (habit_id)
        REFERENCES HABITS(habit_id)
);

-- 8. ACHIEVEMENTS
CREATE TABLE ACHIEVEMENTS (
    achievement_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    achievement_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(255),
    achieved_date DATE,

    CONSTRAINT fk_achievement_user
        FOREIGN KEY (user_id)
        REFERENCES USERS(user_id)
);
