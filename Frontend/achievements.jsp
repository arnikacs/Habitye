<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.Habitye.util.DBConnection" %>
<%@ page import="com.Habitye.AchievementServlet" %>

<%
Integer userId = (Integer) session.getAttribute("USER_ID");


if (userId == null) {
    response.sendRedirect("login.html");
    return;
}

/*
 * Refresh achievement status using the user's
 * current habit, streak and goal data.
 */
try (Connection conn = DBConnection.getConnection()) {

    AchievementServlet.checkAchievements(conn, userId);

} catch (Exception e) {

    e.printStackTrace();
}


%>

<!DOCTYPE html>

<html lang="en">

<head>


<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Habitye — Achievements</title>

<link rel="stylesheet"
      href="styles.css">

<style>

    .achievement-card {
        text-align: center;
        transition: 0.25s ease;
    }

    .achievement-icon {
        font-size: 42px;
        margin-bottom: 12px;
    }

    .achievement-card h3 {
        font-family: "Playfair Display", serif;
        font-size: 20px;
        font-weight: 500;
        color: #514457;
    }

    .achievement-card p {
        font-size: 11px;
        color: var(--muted);
        margin-top: 7px;
        line-height: 1.6;
    }

    .achievement-card.locked {
        opacity: 0.55;
    }

    .achievement-date {
        margin-top: 8px;
        font-size: 10px;
        color: var(--muted);
    }

    .achievement-grid {
        display: grid;

        grid-template-columns:
            repeat(auto-fit, minmax(210px, 1fr));

        gap: 17px;
    }

</style>


</head>

<body>

<div class="app-layout">


<!-- SIDEBAR -->

<aside class="sidebar">

    <div class="brand">
        Habit<span>ye</span>
    </div>


    <ul class="nav-links">

        <li>
            <a href="dashboard.jsp">
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
            <a href="achievements.jsp"
               class="active">
                ✿ Achievements
            </a>
        </li>


        <li style="margin-top:25px;">

            <a href="logout">
                ↩ Logout
            </a>

        </li>

    </ul>

</aside>



<!-- MAIN -->

<main class="main-content">


    <div class="header">

        <h1>
            Little things worth celebrating ✿
        </h1>

        <p>
            Your consistency deserves a little recognition.
        </p>

    </div>



    <div class="achievement-grid">


<%
/*
* Application achievements.
*
* Their unlocked state is determined from
* the ACHIEVEMENTS table.
*/


        String[] achievementNames = {
            "7-Day Streak",
            "Fresh Start",
            "Goal Getter",
            "30 Completions"
        };


        String[] achievementDescriptions = {
            "Kept a habit for seven consecutive days.",
            "Completed your first habit.",
            "Completed five major goals.",
            "Completed habits at least thirty times."
        };


        String[] achievementIcons = {
            "🔥",
            "🌱",
            "🎯",
            "🏆"
        };


        String achievementSql =
            "SELECT ACHIEVEMENT_NAME, " +
            "       DESCRIPTION, " +
            "       ACHIEVED_DATE " +
            "FROM ACHIEVEMENTS " +
            "WHERE USER_ID = ?";


        java.util.HashMap<String, String> unlockedDates =
            new java.util.HashMap<>();


        java.util.HashMap<String, String> descriptions =
            new java.util.HashMap<>();


        try (
            Connection conn =
                DBConnection.getConnection();

            PreparedStatement ps =
                conn.prepareStatement(achievementSql)
        ) {

            ps.setInt(1, userId);


            try (ResultSet rs =
                     ps.executeQuery()) {


                while (rs.next()) {


                    String name =
                        rs.getString("ACHIEVEMENT_NAME");


                    String description =
                        rs.getString("DESCRIPTION");


                    java.sql.Date achievedDate =
                        rs.getDate("ACHIEVED_DATE");


                    descriptions.put(
                        name,
                        description
                    );


                    if (achievedDate != null) {

                        unlockedDates.put(
                            name,
                            achievedDate.toLocalDate().toString()
                        );
                    }
                }
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        for (int i = 0;
             i < achievementNames.length;
             i++) {


            String name =
                achievementNames[i];


            boolean unlocked =
                unlockedDates.containsKey(name);


            String description =
                descriptions.get(name);


            if (description == null) {

                description =
                    achievementDescriptions[i];
            }


%>


        <!-- ACHIEVEMENT CARD -->

        <div class="card achievement-card
             <%= unlocked ? "" : "locked" %>">


            <div class="achievement-icon">
                <%= achievementIcons[i] %>
            </div>


            <h3>
                <%= name %>
            </h3>


            <p>
                <%= description %>
            </p>


            <% if (unlocked) { %>


                <span class="badge badge-success"
                      style="margin-top:15px;">

                    Unlocked ✓

                </span>


                <% if (unlockedDates.get(name) != null) { %>


                    <div class="achievement-date">

                        Achieved:
                        <%= unlockedDates.get(name) %>

                    </div>


                <% } %>


            <% } else { %>


                <span class="badge"
                      style="margin-top:15px;">

                    Locked

                </span>


            <% } %>


        </div>


<%
}
%>


    </div>



    <!-- MOTIVATION CARD -->

    <div class="card"
         style="margin-top:25px;">


        <div class="header"
             style="margin-bottom:0;">

            <h1 style="font-size:24px;">
                Keep going ♡
            </h1>


            <p>
                You don't have to be perfect.
                Just keep showing up.
            </p>

        </div>

    </div>


</main>


</div>

</body>

</html>
