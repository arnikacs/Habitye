-- =====================================================
-- HABITYE — REALISTIC SAMPLE DATA
-- Smart Habit & Goal Management System
-- =====================================================


-- =====================================================
-- 1. USERS
-- =====================================================

INSERT INTO USERS VALUES
(1, 'Arnika', 'arnika@gmail.com', '12345', '01711111111', DATE '2026-08-01');

INSERT INTO USERS VALUES
(2, 'Fahmida', 'fahmida@gmail.com', '12345', '01722222222', DATE '2026-08-02');

INSERT INTO USERS VALUES
(3, 'Nipa', 'nipa@gmail.com', '12345', '01933333333', DATE '2026-08-03');

INSERT INTO USERS VALUES
(4, 'Sadia', 'sadia@gmail.com', '12345', '01844444444', DATE '2026-08-04');

INSERT INTO USERS VALUES
(5, 'Mim', 'mim@gmail.com', '12345', '01655555555', DATE '2026-08-05');


-- =====================================================
-- 2. CATEGORIES
-- =====================================================

INSERT INTO CATEGORIES VALUES
(1, 'Study', 'Academic and learning habits');

INSERT INTO CATEGORIES VALUES
(2, 'Fitness', 'Workout and physical activity');

INSERT INTO CATEGORIES VALUES
(3, 'Health', 'Healthy lifestyle and nutrition');

INSERT INTO CATEGORIES VALUES
(4, 'Sleep', 'Sleep and rest routine');

INSERT INTO CATEGORIES VALUES
(5, 'Self Care', 'Personal care and me-time');

INSERT INTO CATEGORIES VALUES
(6, 'Mindfulness', 'Journaling, relaxation and mental well-being');


-- =====================================================
-- 3. HABITS
-- =====================================================

-- Arnika
INSERT INTO HABITS VALUES
(1, 1, 1, 'Study DBMS', 'Practice SQL and DBMS for at least 1 hour', 'Daily', DATE '2026-08-01', 1);

INSERT INTO HABITS VALUES
(2, 1, 2, 'Morning Workout', 'Do a short workout or stretching session', 'Daily', DATE '2026-08-01', 1);

INSERT INTO HABITS VALUES
(3, 1, 3, 'Eat Healthy', 'Have at least one healthy homemade meal', 'Daily', DATE '2026-08-01', 1);

INSERT INTO HABITS VALUES
(4, 1, 4, 'Sleep on Time', 'Try to maintain a consistent sleep schedule', 'Daily', DATE '2026-08-02', 1);

INSERT INTO HABITS VALUES
(5, 1, 5, 'Me Time', 'Spend 20 minutes doing something enjoyable', 'Daily', DATE '2026-08-02', 1);

INSERT INTO HABITS VALUES
(6, 1, 6, 'Journal Thoughts', 'Write down thoughts instead of overthinking', 'Daily', DATE '2026-08-03', 1);


-- Fahmida
INSERT INTO HABITS VALUES
(7, 2, 1, 'Read Book', 'Read at least 20 pages', 'Daily', DATE '2026-08-02', 1);

INSERT INTO HABITS VALUES
(8, 2, 2, 'Evening Walk', 'Walk for 30 minutes', 'Daily', DATE '2026-08-02', 1);

INSERT INTO HABITS VALUES
(9, 2, 3, 'Drink Water', 'Drink enough water throughout the day', 'Daily', DATE '2026-08-02', 1);


-- Nipa
INSERT INTO HABITS VALUES
(10, 3, 4, 'Fixed Sleep Time', 'Go to bed before midnight', 'Daily', DATE '2026-08-03', 1);

INSERT INTO HABITS VALUES
(11, 3, 5, 'Skincare', 'Complete basic skincare routine', 'Daily', DATE '2026-08-03', 1);

INSERT INTO HABITS VALUES
(12, 3, 1, 'Practice Coding', 'Practice programming problems', 'Daily', DATE '2026-08-03', 1);


-- Sadia
INSERT INTO HABITS VALUES
(13, 4, 2, 'Yoga', 'Do 20 minutes of yoga', 'Daily', DATE '2026-08-04', 1);

INSERT INTO HABITS VALUES
(14, 4, 3, 'Healthy Breakfast', 'Eat breakfast without skipping', 'Daily', DATE '2026-08-04', 1);


-- Mim
INSERT INTO HABITS VALUES
(15, 5, 6, 'Meditation', 'Practice mindfulness for 10 minutes', 'Daily', DATE '2026-08-05', 1);

INSERT INTO HABITS VALUES
(16, 5, 1, 'Learn Java', 'Practice Java programming', 'Daily', DATE '2026-08-05', 1);


-- =====================================================
-- 4. GOALS
-- =====================================================

INSERT INTO GOALS VALUES
(1, 1, 'Complete DBMS Preparation', 'Hours', 30, 12, DATE '2026-08-31', 0);

INSERT INTO GOALS VALUES
(2, 2, 'Build Workout Routine', 'Days', 20, 7, DATE '2026-08-31', 0);

INSERT INTO GOALS VALUES
(3, 3, 'Eat Healthy for 21 Days', 'Days', 21, 8, DATE '2026-08-31', 0);

INSERT INTO GOALS VALUES
(4, 4, 'Fix Sleep Schedule', 'Days', 30, 9, DATE '2026-09-01', 0);

INSERT INTO GOALS VALUES
(5, 5, 'Daily Me-Time', 'Minutes', 600, 180, DATE '2026-08-31', 0);

INSERT INTO GOALS VALUES
(6, 6, 'Journal Consistently', 'Days', 15, 6, DATE '2026-08-31', 0);

INSERT INTO GOALS VALUES
(7, 7, 'Finish One Book', 'Pages', 300, 120, DATE '2026-09-15', 0);

INSERT INTO GOALS VALUES
(8, 8, 'Walk 100 KM', 'Kilometers', 100, 32, DATE '2026-09-30', 0);

INSERT INTO GOALS VALUES
(9, 12, 'Solve Coding Problems', 'Problems', 50, 21, DATE '2026-09-01', 0);

INSERT INTO GOALS VALUES
(10, 16, 'Improve Java Skills', 'Hours', 25, 10, DATE '2026-09-15', 0);


-- =====================================================
-- 5. HABIT LOG
-- =====================================================

INSERT INTO HABIT_LOG VALUES
(1, 1, DATE '2026-08-10', 1, 'Completed 1 hour SQL practice');

INSERT INTO HABIT_LOG VALUES
(2, 1, DATE '2026-08-11', 1, 'Completed DBMS practice');

INSERT INTO HABIT_LOG VALUES
(3, 1, DATE '2026-08-12', 0, 'Too tired to study');

INSERT INTO HABIT_LOG VALUES
(4, 2, DATE '2026-08-10', 1, '20 minute workout');

INSERT INTO HABIT_LOG VALUES
(5, 2, DATE '2026-08-11', 0, 'Skipped workout');

INSERT INTO HABIT_LOG VALUES
(6, 2, DATE '2026-08-12', 1, 'Stretching completed');

INSERT INTO HABIT_LOG VALUES
(7, 3, DATE '2026-08-10', 1, 'Healthy homemade meal');

INSERT INTO HABIT_LOG VALUES
(8, 3, DATE '2026-08-11', 1, 'Ate vegetables and protein');

INSERT INTO HABIT_LOG VALUES
(9, 3, DATE '2026-08-12', 0, 'Ate fast food');

INSERT INTO HABIT_LOG VALUES
(10, 4, DATE '2026-08-10', 0, 'Slept very late');

INSERT INTO HABIT_LOG VALUES
(11, 4, DATE '2026-08-11', 1, 'Went to bed earlier');

INSERT INTO HABIT_LOG VALUES
(12, 4, DATE '2026-08-12', 1, 'Maintained sleep schedule');

INSERT INTO HABIT_LOG VALUES
(13, 5, DATE '2026-08-12', 1, 'Watched a favorite show and relaxed');

INSERT INTO HABIT_LOG VALUES
(14, 6, DATE '2026-08-12', 1, 'Wrote thoughts before sleeping');

INSERT INTO HABIT_LOG VALUES
(15, 7, DATE '2026-08-12', 1, 'Read 20 pages');

INSERT INTO HABIT_LOG VALUES
(16, 8, DATE '2026-08-12', 1, 'Walked for 30 minutes');


-- =====================================================
-- 6. REMINDERS
-- =====================================================

INSERT INTO REMINDERS VALUES
(1, 1, '08:00 PM', 'Daily', 1);

INSERT INTO REMINDERS VALUES
(2, 2, '07:00 AM', 'Mon,Tue,Wed,Thu,Fri,Sat,Sun', 1);

INSERT INTO REMINDERS VALUES
(3, 3, '01:00 PM', 'Daily', 1);

INSERT INTO REMINDERS VALUES
(4, 4, '11:00 PM', 'Daily', 1);

INSERT INTO REMINDERS VALUES
(5, 5, '09:00 PM', 'Daily', 1);

INSERT INTO REMINDERS VALUES
(6, 6, '10:30 PM', 'Daily', 1);

INSERT INTO REMINDERS VALUES
(7, 7, '09:30 PM', 'Daily', 1);

INSERT INTO REMINDERS VALUES
(8, 8, '06:30 PM', 'Daily', 1);


-- =====================================================
-- 7. STREAKS
-- =====================================================

INSERT INTO STREAKS VALUES
(1, 1, 5, 12, DATE '2026-08-11');

INSERT INTO STREAKS VALUES
(2, 2, 2, 8, DATE '2026-08-12');

INSERT INTO STREAKS VALUES
(3, 3, 4, 10, DATE '2026-08-11');

INSERT INTO STREAKS VALUES
(4, 4, 3, 7, DATE '2026-08-12');

INSERT INTO STREAKS VALUES
(5, 5, 6, 9, DATE '2026-08-12');

INSERT INTO STREAKS VALUES
(6, 6, 4, 6, DATE '2026-08-12');

INSERT INTO STREAKS VALUES
(7, 7, 10, 15, DATE '2026-08-12');

INSERT INTO STREAKS VALUES
(8, 8, 7, 14, DATE '2026-08-12');

INSERT INTO STREAKS VALUES
(9, 12, 8, 11, DATE '2026-08-12');

INSERT INTO STREAKS VALUES
(10, 16, 5, 8, DATE '2026-08-12');


-- =====================================================
-- 8. ACHIEVEMENTS
-- =====================================================

INSERT INTO ACHIEVEMENTS VALUES
(1, 1, '7-Day Study Streak', 'Studied DBMS for 7 consecutive days', DATE '2026-08-07');

INSERT INTO ACHIEVEMENTS VALUES
(2, 1, 'Self Care Starter', 'Completed 5 self-care sessions', DATE '2026-08-10');

INSERT INTO ACHIEVEMENTS VALUES
(3, 2, 'Fitness Beginner', 'Completed first week of workouts', DATE '2026-08-09');

INSERT INTO ACHIEVEMENTS VALUES
(4, 2, 'Hydration Hero', 'Maintained regular water intake', DATE '2026-08-11');

INSERT INTO ACHIEVEMENTS VALUES
(5, 3, 'Healthy Start', 'Completed healthy lifestyle habits', DATE '2026-08-10');

INSERT INTO ACHIEVEMENTS VALUES
(6, 3, 'Coding Streak', 'Practiced coding for 7 days', DATE '2026-08-11');

INSERT INTO ACHIEVEMENTS VALUES
(7, 4, 'Yoga Beginner', 'Completed 5 yoga sessions', DATE '2026-08-12');

INSERT INTO ACHIEVEMENTS VALUES
(8, 5, 'Mindful Week', 'Completed 7 mindfulness sessions', DATE '2026-08-12');


-- =====================================================
-- SAVE
-- =====================================================

COMMIT;

