package com.Habitye;

import com.Habitye.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/reminder")
public class ReminderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("USER_ID") == null) {

            response.sendRedirect("login.html");
            return;
        }

        int userId = (Integer) session.getAttribute("USER_ID");

        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {

            // ==========================================
            // ADD REMINDER
            // ==========================================

            if ("add".equals(action)) {

                int habitId = Integer.parseInt(
                    request.getParameter("habitId")
                );

                String reminderTime =
                    request.getParameter("reminderTime");

                String daysOfWeek =
                    request.getParameter("daysOfWeek");


                // Make sure the habit belongs
                // to the logged-in user.

                String verifySql =
                    "SELECT HABIT_ID " +
                    "FROM HABITS " +
                    "WHERE HABIT_ID = ? " +
                    "AND USER_ID = ? " +
                    "AND STATUS = 1";

                try (PreparedStatement verifyPs =
                         conn.prepareStatement(verifySql)) {

                    verifyPs.setInt(1, habitId);
                    verifyPs.setInt(2, userId);

                    try (var rs = verifyPs.executeQuery()) {

                        if (!rs.next()) {
                            response.sendRedirect(
                                "reminders.jsp?error=invalid_habit"
                            );
                            return;
                        }
                    }
                }


                String sql =
                    "INSERT INTO REMINDERS " +
                    "(REMINDER_ID, HABIT_ID, REMINDER_TIME, " +
                    "DAYS_OF_WEEK, STATUS) " +
                    "VALUES " +
                    "(REMINDER_SEQ.NEXTVAL, ?, ?, ?, 1)";

                try (PreparedStatement ps =
                         conn.prepareStatement(sql)) {

                    ps.setInt(1, habitId);
                    ps.setString(2, reminderTime);
                    ps.setString(3, daysOfWeek);

                    ps.executeUpdate();
                }

                response.sendRedirect("reminders.jsp");
                return;
            }


            // ==========================================
            // DEACTIVATE REMINDER
            // ==========================================

            if ("deactivate".equals(action)) {

                int reminderId = Integer.parseInt(
                    request.getParameter("reminderId")
                );


                String sql =
                    "UPDATE REMINDERS R " +
                    "SET R.STATUS = 0 " +
                    "WHERE R.REMINDER_ID = ? " +
                    "AND EXISTS (" +
                    "    SELECT 1 " +
                    "    FROM HABITS H " +
                    "    WHERE H.HABIT_ID = R.HABIT_ID " +
                    "    AND H.USER_ID = ?" +
                    ")";

                try (PreparedStatement ps =
                         conn.prepareStatement(sql)) {

                    ps.setInt(1, reminderId);
                    ps.setInt(2, userId);

                    ps.executeUpdate();
                }

                response.sendRedirect("reminders.jsp");
                return;
            }


            // ==========================================
            // UNKNOWN ACTION
            // ==========================================

            response.sendRedirect("reminders.jsp");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "reminders.jsp?error=database"
            );
        }
    }
}