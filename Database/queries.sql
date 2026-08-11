-- ============================================================
-- HABITYE
-- Smart Habit & Goal Management System
-- Database Queries
-- Oracle SQL*Plus
-- ============================================================

-- ============================================================
-- 1. DISPLAY ALL USERS
-- ============================================================

SELECT *
FROM USERS;

-- ============================================================
-- 2. DISPLAY ALL CATEGORIES
-- ============================================================

SELECT *
FROM CATEGORIES;

-- ============================================================
-- 3. DISPLAY ALL HABITS WITH READABLE STATUS
-- 1 = Active, 0 = Inactive
-- ============================================================

SELECT habit_id,
user_id,
category_id,
habit_name,
description,
frequency,
start_date,
CASE
WHEN status = 1 THEN 'Active'
ELSE 'Inactive'
END AS habit_status
FROM HABITS;

-- ============================================================
-- 4. DISPLAY ALL GOALS WITH READABLE STATUS
-- 1 = Completed, 0 = In Progress
-- ============================================================

SELECT goal_id,
habit_id,
goal_name,
goal_type,
target_value,
current_progress,
deadline,
CASE
WHEN status = 1 THEN 'Completed'
ELSE 'In Progress'
END AS goal_status
FROM GOALS;

-- ============================================================
-- 5. DISPLAY ALL HABIT LOGS WITH READABLE COMPLETION STATUS
-- 1 = Completed, 0 = Missed
-- ============================================================

SELECT log_id,
habit_id,
log_date,
CASE
WHEN completed = 1 THEN 'Completed'
ELSE 'Missed'
END AS log_status,
remarks
FROM HABIT_LOG
ORDER BY log_date DESC;

-- ============================================================
-- 6. DISPLAY ALL REMINDERS WITH READABLE STATUS
-- 1 = Active, 0 = Inactive
-- ============================================================

SELECT reminder_id,
habit_id,
reminder_time,
days_of_week,
CASE
WHEN status = 1 THEN 'Active'
ELSE 'Inactive'
END AS reminder_status
FROM REMINDERS;

-- ============================================================
-- 7. DISPLAY ACTIVE HABITS
-- ============================================================

SELECT habit_id,
habit_name,
frequency,
start_date
FROM HABITS
WHERE status = 1
ORDER BY start_date;

-- ============================================================
-- 8. DISPLAY INACTIVE HABITS
-- ============================================================

SELECT habit_id,
habit_name,
frequency,
start_date
FROM HABITS
WHERE status = 0
ORDER BY start_date;

-- ============================================================
-- 9. DISPLAY COMPLETED GOALS
-- ============================================================

SELECT goal_id,
habit_id,
goal_name,
target_value,
current_progress,
deadline
FROM GOALS
WHERE status = 1
ORDER BY deadline;

-- ============================================================
-- 10. DISPLAY GOALS THAT ARE STILL IN PROGRESS
-- ============================================================

SELECT goal_id,
habit_id,
goal_name,
target_value,
current_progress,
deadline
FROM GOALS
WHERE status = 0
ORDER BY deadline;

-- ============================================================
-- 11. DISPLAY USERS WITH THEIR HABITS
-- JOIN: USERS -> HABITS
-- ============================================================

SELECT u.user_id,
u.full_name,
h.habit_id,
h.habit_name,
h.frequency,
CASE
WHEN h.status = 1 THEN 'Active'
ELSE 'Inactive'
END AS habit_status
FROM USERS u
JOIN HABITS h
ON u.user_id = h.user_id
ORDER BY u.full_name, h.habit_name;

-- ============================================================
-- 12. DISPLAY HABITS WITH THEIR CATEGORIES
-- JOIN: CATEGORIES -> HABITS
-- ============================================================

SELECT h.habit_id,
h.habit_name,
c.category_name,
h.frequency,
CASE
WHEN h.status = 1 THEN 'Active'
ELSE 'Inactive'
END AS habit_status
FROM HABITS h
JOIN CATEGORIES c
ON h.category_id = c.category_id
ORDER BY c.category_name, h.habit_name;

-- ============================================================
-- 13. DISPLAY HABITS WITH THEIR GOALS
-- JOIN: HABITS -> GOALS
-- ============================================================

SELECT h.habit_id,
h.habit_name,
g.goal_id,
g.goal_name,
g.goal_type,
g.target_value,
g.current_progress,
g.deadline,
CASE
WHEN g.status = 1 THEN 'Completed'
ELSE 'In Progress'
END AS goal_status
FROM HABITS h
JOIN GOALS g
ON h.habit_id = g.habit_id
ORDER BY h.habit_name, g.deadline;

-- ============================================================
-- 14. DISPLAY HABITS WITH THEIR LOGS
-- JOIN: HABITS -> HABIT_LOG
-- ============================================================

SELECT h.habit_id,
h.habit_name,
hl.log_id,
hl.log_date,
CASE
WHEN hl.completed = 1 THEN 'Completed'
ELSE 'Missed'
END AS completion_status,
hl.remarks
FROM HABITS h
JOIN HABIT_LOG hl
ON h.habit_id = hl.habit_id
ORDER BY h.habit_name, hl.log_date DESC;

-- ============================================================
-- 15. DISPLAY HABITS WITH THEIR REMINDERS
-- JOIN: HABITS -> REMINDERS
-- ============================================================

SELECT h.habit_id,
h.habit_name,
r.reminder_id,
r.reminder_time,
r.days_of_week,
CASE
WHEN r.status = 1 THEN 'Active'
ELSE 'Inactive'
END AS reminder_status
FROM HABITS h
JOIN REMINDERS r
ON h.habit_id = r.habit_id
ORDER BY h.habit_name;

-- ============================================================
-- 16. DISPLAY HABITS WITH THEIR STREAK INFORMATION
-- JOIN: HABITS -> STREAKS
-- ============================================================

SELECT h.habit_id,
h.habit_name,
s.current_streak,
s.longest_streak,
s.last_completed_date
FROM HABITS h
JOIN STREAKS s
ON h.habit_id = s.habit_id
ORDER BY s.current_streak DESC;

-- ============================================================
-- 17. DISPLAY USERS WITH THEIR ACHIEVEMENTS
-- JOIN: USERS -> ACHIEVEMENTS
-- ============================================================

SELECT u.user_id,
u.full_name,
a.achievement_id,
a.achievement_name,
a.description,
a.achieved_date
FROM USERS u
JOIN ACHIEVEMENTS a
ON u.user_id = a.user_id
ORDER BY a.achieved_date DESC;

-- ============================================================
-- 18. COUNT TOTAL HABITS FOR EACH USER
-- GROUP BY + COUNT
-- ============================================================

SELECT u.user_id,
u.full_name,
COUNT(h.habit_id) AS total_habits
FROM USERS u
LEFT JOIN HABITS h
ON u.user_id = h.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_habits DESC;

-- ============================================================
-- 19. COUNT HABITS IN EACH CATEGORY
-- GROUP BY + COUNT
-- ============================================================

SELECT c.category_id,
c.category_name,
COUNT(h.habit_id) AS total_habits
FROM CATEGORIES c
LEFT JOIN HABITS h
ON c.category_id = h.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_habits DESC;

-- ============================================================
-- 20. COUNT COMPLETED AND MISSED LOGS FOR EACH HABIT
-- CONDITIONAL AGGREGATION
-- ============================================================

SELECT h.habit_id,
h.habit_name,
SUM(CASE WHEN hl.completed = 1 THEN 1 ELSE 0 END)
AS completed_logs,
SUM(CASE WHEN hl.completed = 0 THEN 1 ELSE 0 END)
AS missed_logs
FROM HABITS h
LEFT JOIN HABIT_LOG hl
ON h.habit_id = hl.habit_id
GROUP BY h.habit_id, h.habit_name
ORDER BY h.habit_name;

-- ============================================================
-- 21. DISPLAY HABITS HAVING MORE THAN ONE COMPLETED LOG
-- GROUP BY + HAVING
-- ============================================================

SELECT h.habit_id,
h.habit_name,
COUNT(hl.log_id) AS completed_logs
FROM HABITS h
JOIN HABIT_LOG hl
ON h.habit_id = hl.habit_id
WHERE hl.completed = 1
GROUP BY h.habit_id, h.habit_name
HAVING COUNT(hl.log_id) > 1
ORDER BY completed_logs DESC;

-- ============================================================
-- 22. DISPLAY USERS WHO HAVE AT LEAST ONE HABIT
-- EXISTS SUBQUERY
-- ============================================================

SELECT u.user_id,
u.full_name
FROM USERS u
WHERE EXISTS (
SELECT 1
FROM HABITS h
WHERE h.user_id = u.user_id
);

-- ============================================================
-- 23. DISPLAY USERS WHO HAVE MORE THAN ONE HABIT
-- IN SUBQUERY + GROUP BY + HAVING
-- ============================================================

SELECT u.user_id,
u.full_name
FROM USERS u
WHERE u.user_id IN (
SELECT h.user_id
FROM HABITS h
GROUP BY h.user_id
HAVING COUNT(h.habit_id) > 1
);

-- ============================================================
-- 24. DISPLAY THE HABIT WITH THE LONGEST STREAK
-- SUBQUERY + MAX
-- ============================================================

SELECT h.habit_id,
h.habit_name,
s.longest_streak
FROM HABITS h
JOIN STREAKS s
ON h.habit_id = s.habit_id
WHERE s.longest_streak = (
SELECT MAX(longest_streak)
FROM STREAKS
);

-- ============================================================
-- 25. DISPLAY THE HABIT WITH THE HIGHEST CURRENT STREAK
-- SUBQUERY + MAX
-- ============================================================

SELECT h.habit_id,
h.habit_name,
s.current_streak
FROM HABITS h
JOIN STREAKS s
ON h.habit_id = s.habit_id
WHERE s.current_streak = (
SELECT MAX(current_streak)
FROM STREAKS
);

-- ============================================================
-- 26. DISPLAY GOALS WHERE PROGRESS IS BELOW TARGET
-- ============================================================

SELECT goal_id,
habit_id,
goal_name,
target_value,
current_progress,
deadline,
CASE
WHEN status = 1 THEN 'Completed'
ELSE 'In Progress'
END AS goal_status
FROM GOALS
WHERE current_progress < target_value
ORDER BY deadline;

-- ============================================================
-- 27. DISPLAY GOALS WHERE TARGET HAS BEEN REACHED
-- ============================================================

SELECT goal_id,
habit_id,
goal_name,
target_value,
current_progress,
deadline,
CASE
WHEN status = 1 THEN 'Completed'
ELSE 'In Progress'
END AS goal_status
FROM GOALS
WHERE current_progress >= target_value
ORDER BY deadline;

-- ============================================================
-- 28. DISPLAY ACTIVE REMINDERS
-- ============================================================

SELECT reminder_id,
habit_id,
reminder_time,
days_of_week
FROM REMINDERS
WHERE status = 1;

-- ============================================================
-- 29. DISPLAY HABITS WITH THEIR USER AND CATEGORY
-- MULTIPLE JOIN
-- ============================================================

SELECT u.full_name,
h.habit_name,
c.category_name,
h.frequency,
h.start_date
FROM USERS u
JOIN HABITS h
ON u.user_id = h.user_id
JOIN CATEGORIES c
ON h.category_id = c.category_id
ORDER BY u.full_name, h.habit_name;

-- ============================================================
-- 30. DISPLAY USER, HABIT AND GOAL INFORMATION
-- MULTIPLE JOIN
-- ============================================================

SELECT u.full_name,
h.habit_name,
g.goal_name,
g.target_value,
g.current_progress,
g.deadline,
CASE
WHEN g.status = 1 THEN 'Completed'
ELSE 'In Progress'
END AS goal_status
FROM USERS u
JOIN HABITS h
ON u.user_id = h.user_id
JOIN GOALS g
ON h.habit_id = g.habit_id
ORDER BY u.full_name, g.deadline;

-- ============================================================
-- 31. TOTAL NUMBER OF USERS
-- ============================================================

SELECT COUNT(*) AS total_users
FROM USERS;

-- ============================================================
-- 32. TOTAL NUMBER OF CATEGORIES
-- ============================================================

SELECT COUNT(*) AS total_categories
FROM CATEGORIES;

-- ============================================================
-- 33. TOTAL NUMBER OF HABITS
-- ============================================================

SELECT COUNT(*) AS total_habits
FROM HABITS;

-- ============================================================
-- 34. TOTAL NUMBER OF GOALS
-- ============================================================

SELECT COUNT(*) AS total_goals
FROM GOALS;

-- ============================================================
-- 35. TOTAL NUMBER OF COMPLETED HABIT LOGS
-- ============================================================

SELECT COUNT(*) AS total_completed_logs
FROM HABIT_LOG
WHERE completed = 1;

-- ============================================================
-- 36. TOTAL NUMBER OF ACHIEVEMENTS
-- ============================================================

SELECT COUNT(*) AS total_achievements
FROM ACHIEVEMENTS;

-- ============================================================
-- 37. UPDATE GOAL PROGRESS
-- COMMENTED TO PROTECT SAMPLE DATA
-- ============================================================

-- UPDATE GOALS
-- SET current_progress = current_progress + 1
-- WHERE goal_id = 1;

-- ============================================================
-- 38. UPDATE HABIT STATUS
-- COMMENTED TO PROTECT SAMPLE DATA
-- 1 = Active, 0 = Inactive
-- ============================================================

-- UPDATE HABITS
-- SET status = 0
-- WHERE habit_id = 1;

-- ============================================================
-- 39. UPDATE REMINDER STATUS
-- COMMENTED TO PROTECT SAMPLE DATA
-- 1 = Active, 0 = Inactive
-- ============================================================

-- UPDATE REMINDERS
-- SET status = 0
-- WHERE reminder_id = 1;

-- ============================================================
-- 40. DELETE A REMINDER
-- COMMENTED TO PROTECT SAMPLE DATA
-- ============================================================

-- DELETE FROM REMINDERS
-- WHERE reminder_id = 1;

-- ============================================================
-- END OF HABITYE QUERIES
-- ============================================================

