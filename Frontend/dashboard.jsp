<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.Habitye.util.DBConnection" %>

<%
    // ==========================================
    // CHECK LOGIN SESSION
    // ==========================================

    Integer userId = (Integer) session.getAttribute("USER_ID");

    if (userId == null) {
        response.sendRedirect("login.html");
        return;
    }


    // ==========================================
    // DASHBOARD VARIABLES
    // ==========================================

    String userName = "";

    int activeHabits = 0;
    int goalsCompleted = 0;
    int currentStreak = 0;

    int totalToday = 0;
    int completedToday = 0;

    int progress = 0;


    // ==========================================
    // LOAD DASHBOARD DATA
    // ==========================================

    try (Connection conn = DBConnection.getConnection()) {


        // --------------------------------------
        // 1. USER NAME
        // --------------------------------------

        String userSql =
            "SELECT FULL_NAME " +
            "FROM USERS " +
            "WHERE USER_ID = ?";

        try (PreparedStatement ps = conn.prepareStatement(userSql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    userName = rs.getString("FULL_NAME");
                }
            }
        }


        // --------------------------------------
        // 2. ACTIVE HABITS
        // --------------------------------------

        String habitSql =
            "SELECT COUNT(*) AS TOTAL " +
            "FROM HABITS " +
            "WHERE USER_ID = ? " +
            "AND STATUS = 1";

        try (PreparedStatement ps = conn.prepareStatement(habitSql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    activeHabits = rs.getInt("TOTAL");
                }
            }
        }


        // --------------------------------------
        // 3. COMPLETED GOALS
        // --------------------------------------

        String goalSql =
            "SELECT COUNT(*) AS TOTAL " +
            "FROM GOALS G " +
            "JOIN HABITS H " +
            "ON G.HABIT_ID = H.HABIT_ID " +
            "WHERE H.USER_ID = ? " +
            "AND G.STATUS = 1";

        try (PreparedStatement ps = conn.prepareStatement(goalSql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    goalsCompleted = rs.getInt("TOTAL");
                }
            }
        }


        // --------------------------------------
        // 4. CURRENT STREAK
        // --------------------------------------

        String streakSql =
            "SELECT NVL(MAX(S.CURRENT_STREAK), 0) AS STREAK " +
            "FROM STREAKS S " +
            "JOIN HABITS H " +
            "ON S.HABIT_ID = H.HABIT_ID " +
            "WHERE H.USER_ID = ?";

        try (PreparedStatement ps = conn.prepareStatement(streakSql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    currentStreak = rs.getInt("STREAK");
                }
            }
        }


        // --------------------------------------
        // 5. TOTAL ACTIVE HABITS FOR TODAY
        // --------------------------------------

        String todayTotalSql =
            "SELECT COUNT(*) AS TOTAL " +
            "FROM HABITS " +
            "WHERE USER_ID = ? " +
            "AND STATUS = 1";

        try (PreparedStatement ps = conn.prepareStatement(todayTotalSql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    totalToday = rs.getInt("TOTAL");
                }
            }
        }


        // --------------------------------------
        // 6. COMPLETED HABITS TODAY
        // --------------------------------------

        String todayCompletedSql =
            "SELECT COUNT(*) AS TOTAL " +
            "FROM HABITS H " +
            "WHERE H.USER_ID = ? " +
            "AND H.STATUS = 1 " +
            "AND EXISTS ( " +
            "    SELECT 1 " +
            "    FROM HABIT_LOG L " +
            "    WHERE L.HABIT_ID = H.HABIT_ID " +
            "    AND TRUNC(L.LOG_DATE) = TRUNC(SYSDATE) " +
            "    AND L.COMPLETED = 1 " +
            ")";

        try (PreparedStatement ps = conn.prepareStatement(todayCompletedSql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    completedToday = rs.getInt("TOTAL");
                }
            }
        }

    } catch (Exception e) {

        e.printStackTrace();
    }


    // ==========================================
    // CALCULATE TODAY'S PROGRESS
    // ==========================================

    if (totalToday > 0) {
        progress = (completedToday * 100) / totalToday;
    }

%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Habitye — Dashboard</title>

    <link rel="stylesheet"
          href="styles.css">

</head>


<body>


<div class="app-layout">


    <!-- ==========================================
         SIDEBAR
    =========================================== -->

    <aside class="sidebar">

        <div class="brand">
            Habit<span>ye</span>
        </div>


        <ul class="nav-links">

            <li>
                <a href="dashboard.jsp"
                   class="active">
                    ✦ Dashboard
                </a>
            </li>


            <li>
                <a href="habits.jsp">
                    ♡ Habits
                </a>
            </li>


            <li>
                <a href="goals.jsp">
                    ◇ Goals
                </a>
            </li>


            <li>
                <a href="reminders.jsp">
                    ◌ Reminders
                </a>
            </li>


            <li>
                <a href="achievements.jsp">
                    ✿ Achievements
                </a>
            </li>


            <li style="margin-top: 25px;">

                <a href="logout">
                    ↩ Logout
                </a>

            </li>

        </ul>

    </aside>



    <!-- ==========================================
         MAIN CONTENT
    =========================================== -->

    <main class="main-content">


        <!-- ======================================
             HEADER
        ======================================= -->

        <div class="header">

            <h1>
                Good to see you again ♡
            </h1>

            <p>
                Welcome, <%= userName %>.
                A little progress is still progress.
            </p>

        </div>



        <!-- ======================================
             STATISTICS
        ======================================= -->

        <div class="grid-stats">


            <div class="card stat-card">

                <h3>
                    Active Habits
                </h3>

                <div class="val">
                    <%= activeHabits %>
                </div>

            </div>


            <div class="card stat-card">

                <h3>
                    Goals Completed
                </h3>

                <div class="val">
                    <%= goalsCompleted %>
                </div>

            </div>


            <div class="card stat-card">

                <h3>
                    Current Streak
                </h3>

                <div class="val">
                    <%= currentStreak %> days
                </div>

            </div>


            <div class="card stat-card">

                <h3>
                    Today's Progress
                </h3>

                <div class="val">
                    <%= progress %>%
                </div>

            </div>


        </div>



        <!-- ======================================
             TODAY'S HABITS
        ======================================= -->

        <div class="card">


            <div class="header">

                <h1 style="font-size: 24px;">
                    Today's little wins ✦
                </h1>

                <p>
                    Your active habits for today.
                </p>

            </div>



            <div class="item-list">


<%
                    /*
                     * MAX(L.COMPLETED) prevents duplicate
                     * display if multiple logs exist for today.
                     */

                    String habitsSql =
                        "SELECT H.HABIT_ID, " +
                        "       H.HABIT_NAME, " +
                        "       C.CATEGORY_NAME, " +
                        "       H.FREQUENCY, " +
                        "       NVL(MAX(L.COMPLETED), 0) AS COMPLETED " +
                        "FROM HABITS H " +
                        "JOIN CATEGORIES C " +
                        "ON H.CATEGORY_ID = C.CATEGORY_ID " +
                        "LEFT JOIN HABIT_LOG L " +
                        "ON H.HABIT_ID = L.HABIT_ID " +
                        "AND TRUNC(L.LOG_DATE) = TRUNC(SYSDATE) " +
                        "WHERE H.USER_ID = ? " +
                        "AND H.STATUS = 1 " +
                        "GROUP BY H.HABIT_ID, " +
                        "         H.HABIT_NAME, " +
                        "         C.CATEGORY_NAME, " +
                        "         H.FREQUENCY " +
                        "ORDER BY H.HABIT_ID";


                    try (
                        Connection conn =
                            DBConnection.getConnection();

                        PreparedStatement ps =
                            conn.prepareStatement(habitsSql)
                    ) {


                        ps.setInt(1, userId);


                        try (ResultSet rs =
                                 ps.executeQuery()) {


                            boolean hasHabits = false;


                            while (rs.next()) {


                                hasHabits = true;


                                int habitId =
                                    rs.getInt("HABIT_ID");


                                String habitName =
                                    rs.getString("HABIT_NAME");


                                String category =
                                    rs.getString("CATEGORY_NAME");


                                String frequency =
                                    rs.getString("FREQUENCY");


                                int completed =
                                    rs.getInt("COMPLETED");

%>


                <!-- ==================================
                     SINGLE HABIT
                =================================== -->

                <div class="item-card">


                    <div>

                        <h3>
                            <%= habitName %>
                        </h3>


                        <p>
                            <%= category %>
                            ·
                            <%= frequency %>
                        </p>

                    </div>



                    <div>


<%
                            if (completed == 1) {
%>


                        <!-- COMPLETED -->

                        <button class="btn-done"
                                type="button"
                                disabled>

                            ✓ Done

                        </button>


<%
                            } else {
%>


                        <!-- MARK DONE -->

                        <form action="habit-log"
                              method="post"
                              style="margin:0;">

                            <input type="hidden"
                                   name="habitId"
                                   value="<%= habitId %>">


                            <button class="btn"
                                    type="submit">

                                Mark done

                            </button>

                        </form>


<%
                            }
%>


                    </div>


                </div>


<%
                            }


                            if (!hasHabits) {
%>


                <div class="item-card">

                    <div>

                        <h3>
                            No active habits yet ♡
                        </h3>

                        <p>
                            Create your first habit to start
                            tracking your progress.
                        </p>

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

                        <h3>
                            Unable to load habits
                        </h3>

                        <p>
                            Please check the database connection.
                        </p>

                    </div>

                </div>


<%
                    }
%>


            </div>


        </div>


    </main>


</div>


</body>

</html>