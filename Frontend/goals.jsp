<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.Habitye.util.DBConnection" %>

<%
Integer userId = (Integer) session.getAttribute("USER_ID");


if (userId == null) {
    response.sendRedirect("login.html");
    return;
}

String todayDate =
    LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE);


%>

<!DOCTYPE html>

<html lang="en">

<head>


<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Habitye — Goals</title>

<link rel="stylesheet" href="styles.css">

<style>

    .goal-create {
        margin-bottom: 28px;
    }

    .goal-create summary {
        list-style: none;

        display: inline-flex;
        align-items: center;

        padding: 10px 17px;

        border-radius: 13px;

        background: var(--primary);

        color: white;

        font-family: "DM Sans", sans-serif;

        font-size: 12px;
        font-weight: 600;

        cursor: pointer;

        transition: 0.25s ease;
    }

    .goal-create summary::-webkit-details-marker {
        display: none;
    }

    .goal-create summary:hover {
        background: var(--primary-dark);
        transform: translateY(-1px);
    }

    .goal-create[open] summary {
        margin-bottom: 18px;
    }

    .goal-form-card {
        background: rgba(255, 253, 253, 0.88);

        border: 1px solid var(--border);

        border-radius: var(--radius);

        padding: 22px;

        box-shadow:
            0 12px 35px rgba(78, 55, 82, 0.06);
    }

    .goal-form-title {
        font-family: "Playfair Display", serif;

        font-size: 24px;

        font-weight: 500;

        color: #4e4254;

        margin-bottom: 5px;
    }

    .goal-form-subtitle {
        color: var(--muted);

        font-size: 12px;

        margin-bottom: 20px;
    }

    .goal-form {
        display: grid;

        grid-template-columns:
            repeat(2, minmax(0, 1fr));

        gap: 15px;
    }

    .goal-field {
        display: flex;

        flex-direction: column;

        gap: 7px;
    }

    .goal-field.full {
        grid-column: 1 / -1;
    }

    .goal-field label {
        color: #706574;

        font-size: 11px;

        font-weight: 600;
    }

    .goal-field input,
    .goal-field select {
        width: 100%;

        height: 46px;

        padding: 0 13px;

        border: 1px solid var(--border);

        border-radius: 13px;

        background: #fff;

        color: var(--text);

        font-family: "DM Sans", sans-serif;

        font-size: 12px;

        outline: none;

        transition: 0.25s ease;
    }

    .goal-field input:focus,
    .goal-field select:focus {
        border-color: #b59bc2;

        box-shadow:
            0 0 0 4px rgba(181, 155, 194, 0.10);
    }

    .goal-field input[type="date"] {
        cursor: pointer;
    }

    .goal-submit {
        border: none;

        padding: 10px 17px;

        border-radius: 13px;

        background: var(--primary);

        color: white;

        font-family: "DM Sans", sans-serif;

        font-size: 12px;

        font-weight: 600;

        cursor: pointer;
    }

    .goal-submit:hover {
        background: var(--primary-dark);
    }

    .goal-card {
        flex-direction: column;
        align-items: flex-start;
    }

    .goal-top {
        width: 100%;

        display: flex;

        justify-content: space-between;

        align-items: flex-start;

        gap: 15px;
    }

    .goal-top h3 {
        margin-bottom: 0;
    }

    .goal-progress-bar {
        width: 100%;

        height: 8px;

        appearance: none;
        -webkit-appearance: none;

        border: none;

        border-radius: 20px;

        overflow: hidden;

        background: #eadfe8;
    }

    .goal-progress-bar::-webkit-progress-bar {
        background: #eadfe8;
        border-radius: 20px;
    }

    .goal-progress-bar::-webkit-progress-value {
        background: var(--primary);
        border-radius: 20px;
    }

    .goal-progress-bar::-moz-progress-bar {
        background: var(--primary);
        border-radius: 20px;
    }

    .goal-actions {
        width: 100%;

        display: flex;

        flex-wrap: wrap;

        align-items: center;

        gap: 10px;
    }

    .goal-update-form {
        display: flex;

        align-items: center;

        gap: 10px;
    }

    .goal-update-form input {
        width: 120px;

        height: 42px;

        padding: 0 12px;

        border: 1px solid var(--border);

        border-radius: 12px;

        background: white;

        color: var(--text);

        font-family: "DM Sans", sans-serif;

        font-size: 12px;

        outline: none;
    }

    .goal-update-form input:focus {
        border-color: #b59bc2;

        box-shadow:
            0 0 0 4px rgba(181, 155, 194, 0.10);
    }

    @media (max-width: 650px) {

        .goal-form {
            grid-template-columns: 1fr;
        }

        .goal-field.full {
            grid-column: auto;
        }

        .goal-top {
            flex-direction: column;
        }

        .goal-actions {
            flex-direction: column;
            align-items: stretch;
        }

        .goal-update-form {
            width: 100%;
        }

        .goal-update-form input {
            width: 100%;
        }
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
            <a href="goals.jsp"
               class="active">
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
            Your dreams & goals ✦
        </h1>

        <p>
            Keep the bigger picture close,
            one step at a time.
        </p>

    </div>



    <!-- CREATE GOAL -->

    <details class="goal-create">

        <summary>
            + Create Goal
        </summary>


        <div class="goal-form-card">

            <div class="goal-form-title">
                Create a new goal
            </div>

            <div class="goal-form-subtitle">
                Turn your habits into meaningful goals.
            </div>


            <form action="goal"
                  method="post"
                  class="goal-form">


                <input type="hidden"
                       name="action"
                       value="add">


                <!-- HABIT -->

                <div class="goal-field">

                    <label for="habitId">
                        Habit
                    </label>

                    <select id="habitId"
                            name="habitId"
                            required>

                        <option value="">
                            Select a habit
                        </option>


<%
String habitSql =
"SELECT HABIT_ID, HABIT_NAME " +
"FROM HABITS " +
"WHERE USER_ID = ? " +
"AND STATUS = 1 " +
"ORDER BY HABIT_NAME";


                        try (
                            Connection conn =
                                DBConnection.getConnection();

                            PreparedStatement ps =
                                conn.prepareStatement(habitSql)
                        ) {

                            ps.setInt(1, userId);

                            try (ResultSet rs =
                                     ps.executeQuery()) {

                                while (rs.next()) {


%>


                        <option value="<%= rs.getInt("HABIT_ID") %>">
                            <%= rs.getString("HABIT_NAME") %>
                        </option>


<%
}
}


                        } catch (Exception e) {

                            e.printStackTrace();
                        }


%>


                    </select>

                </div>



                <!-- GOAL NAME -->

                <div class="goal-field">

                    <label for="goalName">
                        Goal Name
                    </label>

                    <input type="text"
                           id="goalName"
                           name="goalName"
                           placeholder="e.g. Walk 60 Days"
                           required>

                </div>



                <!-- GOAL TYPE -->

                <div class="goal-field">

                    <label for="goalType">
                        Goal Type
                    </label>

                    <select id="goalType"
                            name="goalType"
                            required>

                        <option value="">
                            Select type
                        </option>

                        <option value="Days">
                            Days
                        </option>

                        <option value="Books">
                            Books
                        </option>

                        <option value="Pages">
                            Pages
                        </option>

                        <option value="Times">
                            Times
                        </option>

                        <option value="Sessions">
                            Sessions
                        </option>

                        <option value="Servings">
                            Servings
                        </option>

                    </select>

                </div>



                <!-- TARGET -->

                <div class="goal-field">

                    <label for="targetValue">
                        Target Value
                    </label>

                    <input type="number"
                           id="targetValue"
                           name="targetValue"
                           min="1"
                           step="1"
                           placeholder="e.g. 60"
                           required>

                </div>



                <!-- DEADLINE -->

                <div class="goal-field">

                    <label for="deadline">
                        Deadline
                    </label>

                    <input type="date"
                           id="deadline"
                           name="deadline"
                           min="<%= todayDate %>"
                           required>

                </div>



                <!-- SUBMIT -->

                <div class="goal-field full">

                    <button class="goal-submit"
                            type="submit">

                        + Create Goal

                    </button>

                </div>


            </form>

        </div>

    </details>



    <!-- GOAL LIST -->

    <div class="item-list">


<%
String goalSql =
"SELECT " +
"G.GOAL_ID, " +
"G.GOAL_NAME, " +
"G.GOAL_TYPE, " +
"G.TARGET_VALUE, " +
"G.CURRENT_PROGRESS, " +
"G.DEADLINE, " +
"G.STATUS, " +
"H.HABIT_NAME " +
"FROM GOALS G " +
"JOIN HABITS H " +
"ON G.HABIT_ID = H.HABIT_ID " +
"WHERE H.USER_ID = ? " +
"ORDER BY G.DEADLINE, G.GOAL_NAME";


        try (
            Connection conn =
                DBConnection.getConnection();

            PreparedStatement ps =
                conn.prepareStatement(goalSql)
        ) {

            ps.setInt(1, userId);


            try (ResultSet rs =
                     ps.executeQuery()) {


                boolean hasGoals = false;


                while (rs.next()) {


                    hasGoals = true;


                    int goalId =
                        rs.getInt("GOAL_ID");


                    String goalName =
                        rs.getString("GOAL_NAME");


                    String goalType =
                        rs.getString("GOAL_TYPE");


                    double target =
                        rs.getDouble("TARGET_VALUE");


                    double current =
                        rs.getDouble("CURRENT_PROGRESS");


                    java.sql.Date deadline =
                        rs.getDate("DEADLINE");


                    int status =
                        rs.getInt("STATUS");


                    int percentage = 0;


                    if (target > 0) {

                        percentage =
                            (int)((current / target) * 100);


                        if (percentage > 100) {
                            percentage = 100;
                        }


                        if (percentage < 0) {
                            percentage = 0;
                        }

                    }


                    String deadlineText = "";

                    if (deadline != null) {

                        deadlineText =
                            deadline.toLocalDate()
                                    .format(
                                        DateTimeFormatter.ofPattern(
                                            "dd MMM yyyy"
                                        )
                                    );
                    }


%>


        <!-- GOAL CARD -->

        <div class="item-card goal-card">


            <div class="goal-top">


                <div>

                    <h3>
                        <%= goalName %>
                    </h3>


                    <p>

                        <%= goalType %>

                        ·

                        Target:
                        <%= target %>

                        ·

                        Deadline:
                        <%= deadlineText %>

                    </p>


                    <p>

                        Linked Habit:
                        <%= rs.getString("HABIT_NAME") %>

                    </p>

                </div>


                <span class="badge
                    <%= status == 1
                        ? "badge-success"
                        : "" %>">

                    <%= percentage %>%

                </span>


            </div>



            <!-- PROGRESS -->

            <progress class="goal-progress-bar"
                      value="<%= percentage %>"
                      max="100">
            </progress>



            <!-- PROGRESS TEXT -->

            <p>

                Progress:
                <%= current %>
                /
                <%= target %>
                <%= goalType %>

                <% if (status == 1) { %>

                    · Completed ✓

                <% } else if (percentage >= 75) { %>

                    · You're getting there ♡

                <% } else { %>

                    · Keep going ♡

                <% } %>

            </p>



            <!-- ACTIONS -->

            <% if (status == 0) { %>


                <div class="goal-actions">


                    <form action="goal"
                          method="post"
                          class="goal-update-form">

                        <input type="hidden"
                               name="action"
                               value="update">

                        <input type="hidden"
                               name="goalId"
                               value="<%= goalId %>">

                        <input type="number"
                               name="progress"
                               min="0"
                               max="<%= target %>"
                               step="1"
                               value="<%= current %>"
                               required>

                        <button class="btn"
                                type="submit">

                            Update Progress

                        </button>

                    </form>



                    <form action="goal"
                          method="post">

                        <input type="hidden"
                               name="action"
                               value="complete">

                        <input type="hidden"
                               name="goalId"
                               value="<%= goalId %>">

                        <button class="btn-done"
                                type="submit">

                            ✓ Complete Goal

                        </button>

                    </form>


                </div>


            <% } else { %>


                <span class="badge badge-success">

                    Completed ✓

                </span>


            <% } %>


        </div>


<%
}


                if (!hasGoals) {


%>


        <div class="item-card">

            <div>

                <h3>
                    No goals yet ♡
                </h3>

                <p>
                    Create your first goal above.
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
                    Unable to load goals.
                </h3>

                <p>
                    Please check the Tomcat console.
                </p>

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
