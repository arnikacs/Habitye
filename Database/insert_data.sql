-- ===========================
-- SAMPLE DATA
-- ===========================

INSERT INTO USERS VALUES
(1, 'Arnika', 'arnika@gmail.com', '12345', '01711111111', DATE '2026-08-01');

INSERT INTO USERS VALUES
(2, 'Fahmida', 'fahmida@gmail.com', '12345', '01722222222', DATE '2026-08-02');

INSERT INTO USERS VALUES
(3, 'Nipa', 'nipa@gmail.com', '12345', '01933333333', DATE '2026-08-03');


INSERT INTO CATEGORIES VALUES
(1, 'Study', 'Study related habits');

INSERT INTO CATEGORIES VALUES
(2, 'Fitness', 'Exercise and workout');

INSERT INTO CATEGORIES VALUES
(3, 'Health', 'Healthy lifestyle');


INSERT INTO HABITS VALUES
(1, 1, 1, 'Study DBMS', 'Practice SQL daily', 'Daily', DATE '2026-08-01', 1);

INSERT INTO HABITS VALUES
(2, 1, 2, 'Morning walk', 'walk for 30 minutes', 'Daily', DATE '2026-08-01', 1);

INSERT INTO HABITS VALUES
(3, 2, 3, 'Drink Water', 'Drink 8 glasses', 'Daily', DATE '2026-08-02', 1);


INSERT INTO GOALS VALUES
(1, 1, 'Finish DBMS Course', 'Days', 30, 10, DATE '2026-08-31', 0);

INSERT INTO GOALS VALUES
(2, 2, 'Walk 100 km', 'kilometers', 100, 20, DATE '2026-09-30', 0);

INSERT INTO GOALS VALUES
(3, 3, 'Drink 8 Glasses Daily', 'Glasses', 8, 5, DATE '2026-08-31', 0);


INSERT INTO HABIT_LOG VALUES
(1, 1, DATE '2026-08-01', 1, 'Completed');

INSERT INTO HABIT_LOG VALUES
(2, 2, DATE '2026-08-01', 1, 'Completed');

INSERT INTO HABIT_LOG VALUES
(3, 3, DATE '2026-08-02', 0, 'Missed');


INSERT INTO REMINDERS VALUES
(1, 1, '08:00 AM', 'Mon,Tue,Wed,Thu,Fri', 1);

INSERT INTO REMINDERS VALUES
(2, 2, '06:30 AM', 'Daily', 1);

INSERT INTO REMINDERS VALUES
(3, 3, '09:00 PM', 'Daily', 1);


INSERT INTO STREAKS VALUES
(1, 1, 10, 20, DATE '2026-08-01');

INSERT INTO STREAKS VALUES
(2, 2, 15, 25, DATE '2026-08-01');

INSERT INTO STREAKS VALUES
(3, 3, 5, 10, DATE '2026-08-02');


INSERT INTO ACHIEVEMENTS VALUES
(1, 1, '7-Day Streak', 'Completed 7 days continuously', DATE '2026-08-07');

INSERT INTO ACHIEVEMENTS VALUES
(2, 2, 'Fitness Beginner', 'Completed first fitness goal', DATE '2026-08-10');

INSERT INTO ACHIEVEMENTS VALUES
(3, 3, 'Healthy Start', 'Maintained water habit', DATE '2026-08-12');

COMMIT;

