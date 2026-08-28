<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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


%>

<!DOCTYPE html>

<html lang="en">

<head>


<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Habitye — Reminders</title>

<link rel="stylesheet"
      href="styles.css">

<style>
    .reminder-create {
        margin-bottom: 28px;
    }

    .reminder-create summary {
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

    .reminder-create summary::-webkit-details-marker {
        display: none;
    }

    .reminder-create summary:hover {
        background: var(--primary-dark);
        transform: translateY(-1px);
    }

    .reminder-create[open] summary {
        margin-bottom: 18px;
    }

    .reminder-form-card {
        background: rgba(255, 253, 253, 0.88);

        border: 1px solid var(--border);

        border-radius: var(--radius);

        padding: 22px;

        box-shadow:
            0 12px 35px rgba(78, 55, 82, 0.06);
    }

    .reminder-form-title {
        font-family: "Playfair Display", serif;

        font-size: 24px;

        font-weight: 500;

        color: #4e4254;

        margin-bottom: 5px;
    }

    .reminder-form-subtitle {
        color: var(--muted);

        font-size: 12px;

        margin-bottom: 20px;
    }

    .reminder-form {
        display: grid;

        grid-template-columns:
            repeat(2, minmax(0, 1fr));

        gap: 15px;
    }

    .reminder-field {
        display: flex;

        flex-direction: column;

        gap: 7px;
    }

    .reminder-field.full {
        grid-column: 1 / -1;
    }

    .reminder-field label {
        color: #706574;

        font-size: 11px;

        font-weight: 600;
    }

    .reminder-field input,
    .reminder-field select {
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

    .reminder-field input:focus,
    .reminder-field select:focus {
        border-color: #b59bc2;

        box-shadow:
            0 0 0 4px rgba(181, 155, 194, 0.10);
    }

    .reminder-field input[type="time"] {
        cursor: pointer;
    }

    .reminder-submit {
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

    .reminder-submit:hover {
        background: var(--primary-dark);
    }

    .reminder-status {
        display: flex;

        align-items: center;

        gap: 10px;
    }

    @media (max-width: 650px) {

        .reminder-form {
            grid-template-columns: 1fr;
        }

        .reminder-field.full {
            grid-column: auto;
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
            <a href="goals.jsp">
                ◇ Goals
            </a>
        </li>

        <li>
            <a href="reminders.jsp"
               class="active">
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
            Gentle reminders ◌
        </h1>

        <p>
            A little nudge when you need one.
        </p>

    </div>



    <!-- ADD REMINDER -->

    <details class="reminder-create">


        <summary>
            + Add Reminder
        </summary>


        <div class="reminder-form-card">


            <div class="reminder-form-title">
                Add a reminder
            </div>


            <div class="reminder-form-subtitle">
                Choose a habit and set a gentle reminder.
            </div>


            <form action="reminder"
                  method="post"
                  class="reminder-form">


                <input type="hidden"
                       name="action"
                       value="add">


                <!-- HABIT -->

                <div class="reminder-field">

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



                <!-- TIME -->

                <div class="reminder-field">

                    <label for="reminderTime">
                        Reminder Time
                    </label>

                    <input type="time"
                           id="reminderTime"
                           name="reminderTime"
                           required>

                </div>



                <!-- DAYS -->

                <div class="reminder-field full">

                    <label for="daysOfWeek">
                        Days of Week
                    </label>

                    <select id="daysOfWeek"
                            name="daysOfWeek"
                            required>

                        <option value="Every Day">
                            Every Day
                        </option>

                        <option value="Weekdays">
                            Weekdays
                        </option>

                        <option value="Weekends">
                            Weekends
                        </option>

                        <option value="Sunday">
                            Sunday
                        </option>

                        <option value="Monday">
                            Monday
                        </option>

                        <option value="Tuesday">
                            Tuesday
                        </option>

                        <option value="Wednesday">
                            Wednesday
                        </option>

                        <option value="Thursday">
                            Thursday
                        </option>

                        <option value="Friday">
                            Friday
                        </option>

                        <option value="Saturday">
                            Saturday
                        </option>

                    </select>

                </div>



                <!-- SUBMIT -->

                <div class="reminder-field full">

                    <button class="reminder-submit"
                            type="submit">

                        + Save Reminder

                    </button>

                </div>


            </form>


        </div>

    </details>



    <!-- REMINDER LIST -->

    <div class="item-list">


<%
String reminderSql =
"SELECT " +
"R.REMINDER_ID, " +
"R.REMINDER_TIME, " +
"R.DAYS_OF_WEEK, " +
"R.STATUS, " +
"H.HABIT_NAME " +
"FROM REMINDERS R " +
"JOIN HABITS H " +
"ON R.HABIT_ID = H.HABIT_ID " +
"WHERE H.USER_ID = ? " +
"ORDER BY R.REMINDER_TIME, H.HABIT_NAME";


        try (
            Connection conn =
                DBConnection.getConnection();

            PreparedStatement ps =
                conn.prepareStatement(reminderSql)
        ) {

            ps.setInt(1, userId);


            try (ResultSet rs =
                     ps.executeQuery()) {


                boolean hasReminders = false;


                while (rs.next()) {

                    hasReminders = true;


                    int reminderId =
                        rs.getInt("REMINDER_ID");


                    String habitName =
                        rs.getString("HABIT_NAME");


                    String reminderTime =
                        rs.getString("REMINDER_TIME");


                    String daysOfWeek =
                        rs.getString("DAYS_OF_WEEK");


                    int status =
                        rs.getInt("STATUS");


%>


        <div class="item-card">


            <div>

                <h3>
                    <%= habitName %>
                </h3>


                <p>

                    <%= daysOfWeek %>
                    ·
                    <%= reminderTime %>

                </p>

            </div>


            <div class="reminder-status">


                <% if (status == 1) { %>


                    <span class="badge badge-success">
                        Active
                    </span>


                    <form action="reminder"
                          method="post"
                          style="margin:0;">

                        <input type="hidden"
                               name="action"
                               value="deactivate">

                        <input type="hidden"
                               name="reminderId"
                               value="<%= reminderId %>">

                        <button class="btn-done"
                                type="submit">

                            Pause

                        </button>

                    </form>


                <% } else { %>


                    <span class="badge">
                        Paused
                    </span>


                <% } %>


            </div>


        </div>


<%
}


                if (!hasReminders) {


%>


        <div class="item-card">

            <div>

                <h3>
                    No reminders yet ◌
                </h3>

                <p>
                    Add a reminder for one of your active habits.
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
                    Unable to load reminders.
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
