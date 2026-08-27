<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.Habitye.util.DBConnection" %>

<%
    Integer userId = (Integer) session.getAttribute("USER_ID");

    if (userId == null) {
        response.sendRedirect("login.html");
        return;
    }

    String sql =
        "SELECT h.habit_id, h.habit_name, h.description, " +
        "c.category_name, h.frequency, h.start_date, " +
        "CASE WHEN h.status = 1 THEN 'Active' ELSE 'Inactive' END AS habit_status, " +
        "NVL((SELECT MAX(l.completed) " +
        "     FROM HABIT_LOG l " +
        "     WHERE l.habit_id = h.habit_id " +
        "     AND TRUNC(l.log_date) = TRUNC(SYSDATE)), 0) AS completed_today " +
        "FROM HABITS h " +
        "JOIN CATEGORIES c ON h.category_id = c.category_id " +
        "WHERE h.user_id = ? " +
        "ORDER BY h.start_date, h.habit_name";
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Habitye — Habits</title>

    <link rel="stylesheet" href="styles.css">
</head>

<body>

<div class="app-layout">

    <aside class="sidebar">

        <div class="brand">
            Habit<span>ye</span>
        </div>

        <ul class="nav-links">

            <li>
                <a href="dashboard.jsp">✦ Dashboard</a>
            </li>

            <li>
                <a href="habits.jsp" class="active">♡ Habits</a>
            </li>

            <li>
                <a href="goals.html">◇ Goals</a>
            </li>

            <li>
                <a href="reminders.html">◌ Reminders</a>
            </li>

            <li>
                <a href="achievements.html">✿ Achievements</a>
            </li>

            <li style="margin-top: 25px;">
                <a href="login.html">↩ Logout</a>
            </li>

        </ul>

    </aside>


    <main class="main-content">

        <div class="header"
             style="display:flex; justify-content:space-between; align-items:center; gap:20px;">

            <div>
                <h1>Your little habits ♡</h1>
                <p>Small routines that slowly become part of you.</p>
            </div>

            <button class="btn"
                    type="button"
                    onclick="document.getElementById('addHabitForm').style.display='block'">
                + New Habit
            </button>

        </div>


        <!-- ADD HABIT FORM -->

        <div class="card"
             id="addHabitForm"
             style="display:none; margin-bottom:20px;">

            <h2>Add New Habit</h2>

            <form action="habit" method="post">

                <input type="hidden"
                       name="action"
                       value="add">

                <div style="margin-bottom:12px;">
                    <label>Habit Name</label>
                    <input type="text"
                           name="habitName"
                           required>
                </div>

                <div style="margin-bottom:12px;">
                    <label>Description</label>
                    <input type="text"
                           name="description">
                </div>

                <div style="margin-bottom:12px;">
                    <label>Frequency</label>
                    <select name="frequency" required>
                        <option value="Daily">Daily</option>
                        <option value="Weekdays">Weekdays</option>
                        <option value="Weekly">Weekly</option>
                    </select>
                </div>

                <div style="margin-bottom:12px;">
                    <label>Category ID</label>
                    <input type="number"
                           name="categoryId"
                           min="1"
                           required>
                </div>

                <button class="btn" type="submit">
                    Add Habit
                </button>

            </form>

        </div>


        <div class="item-list">

<%
    try (
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)
    ) {

        ps.setInt(1, userId);

        try (ResultSet rs = ps.executeQuery()) {

            boolean hasHabits = false;

            while (rs.next()) {

                hasHabits = true;

                int habitId = rs.getInt("HABIT_ID");

                String habitName =
                    rs.getString("HABIT_NAME");

                String description =
                    rs.getString("DESCRIPTION");

                String categoryName =
                    rs.getString("CATEGORY_NAME");

                String frequency =
                    rs.getString("FREQUENCY");

                String status =
                    rs.getString("HABIT_STATUS");

                int completedToday =
                    rs.getInt("COMPLETED_TODAY");
%>

            <div class="item-card">

                <div>

                    <h3>
                        <%= habitName %>
                    </h3>

                    <p>
                        <%= categoryName %>
                        ·
                        <%= frequency %>

                        <% if (description != null && !description.trim().isEmpty()) { %>
                            · <%= description %>
                        <% } %>
                    </p>

                </div>


                <div>

                    <% if ("Active".equals(status)) { %>

                        <% if (completedToday == 1) { %>

                            <form action="habit-log"
                                  method="post"
                                  style="display:inline;">

                                <input type="hidden"
                                       name="habitId"
                                       value="<%= habitId %>">

                                <button class="btn-done"
                                        type="submit"
                                        disabled>
                                    ✓ Done
                                </button>

                            </form>

                        <% } else { %>

                            <form action="habit-log"
                                  method="post"
                                  style="display:inline;">

                                <input type="hidden"
                                       name="habitId"
                                       value="<%= habitId %>">

                                <button class="btn"
                                        type="submit">
                                    Mark done
                                </button>

                            </form>

                        <% } %>

                    <% } else { %>

                        <span class="badge">
                            Inactive
                        </span>

                    <% } %>

                </div>

            </div>

<%
            }

            if (!hasHabits) {
%>

            <div class="item-card">

                <div>
                    <h3>No habits yet ♡</h3>
                    <p>Start with one tiny habit.</p>
                </div>

            </div>

<%
            }
        }

    } catch (Exception e) {

        e.printStackTrace();
%>

        <div class="item-card">

            <div>
                <h3>Unable to load habits.</h3>
                <p>Database error. Check the Tomcat console.</p>
            </div>

        </div>

<%
    }
%>

        </div>

    </main>

</div>

</body>
</html>