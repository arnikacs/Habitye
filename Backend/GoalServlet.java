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

@WebServlet("/goal")
public class GoalServlet extends HttpServlet {

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
            // ADD GOAL
            // ==========================================

            if ("add".equals(action)) {

                int habitId = Integer.parseInt(
                    request.getParameter("habitId")
                );

                String goalName =
                    request.getParameter("goalName");

                String goalType =
                    request.getParameter("goalType");

                double targetValue =
                    Double.parseDouble(
                        request.getParameter("targetValue")
                    );

                String deadline =
                    request.getParameter("deadline");


                // Security check:
                // Make sure the selected habit belongs
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

                            response.sendRedirect("goals.jsp?error=invalid_habit");
                            return;
                        }
                    }
                }


                String sql =
                    "INSERT INTO GOALS " +
                    "(GOAL_ID, HABIT_ID, GOAL_NAME, GOAL_TYPE, " +
                    "TARGET_VALUE, CURRENT_PROGRESS, DEADLINE, STATUS) " +
                    "VALUES " +
                    "(GOAL_SEQ.NEXTVAL, ?, ?, ?, ?, 0, TO_DATE(?, 'YYYY-MM-DD'), 0)";

                try (PreparedStatement ps =
                         conn.prepareStatement(sql)) {

                    ps.setInt(1, habitId);
                    ps.setString(2, goalName);
                    ps.setString(3, goalType);
                    ps.setDouble(4, targetValue);
                    ps.setString(5, deadline);

                    ps.executeUpdate();
                }

                response.sendRedirect("goals.jsp");
                return;
            }


            // ==========================================
            // UPDATE GOAL PROGRESS
            // ==========================================

            if ("update".equals(action)) {

                int goalId = Integer.parseInt(
                    request.getParameter("goalId")
                );

                double progress = Double.parseDouble(
                    request.getParameter("progress")
                );


                if (progress < 0) {
                    progress = 0;
                }


                // Update only if this goal belongs
                // to the logged-in user's habit.

                String sql =
                    "UPDATE GOALS G " +
                    "SET G.CURRENT_PROGRESS = ?, " +
                    "    G.STATUS = CASE " +
                    "        WHEN ? >= G.TARGET_VALUE THEN 1 " +
                    "        ELSE 0 " +
                    "    END " +
                    "WHERE G.GOAL_ID = ? " +
                    "AND EXISTS (" +
                    "    SELECT 1 " +
                    "    FROM HABITS H " +
                    "    WHERE H.HABIT_ID = G.HABIT_ID " +
                    "    AND H.USER_ID = ?" +
                    ")";

                try (PreparedStatement ps =
                         conn.prepareStatement(sql)) {

                    ps.setDouble(1, progress);
                    ps.setDouble(2, progress);
                    ps.setInt(3, goalId);
                    ps.setInt(4, userId);

                    ps.executeUpdate();
                }

                response.sendRedirect("goals.jsp");
                return;
            }


            // ==========================================
            // COMPLETE GOAL
            // ==========================================

            if ("complete".equals(action)) {

                int goalId = Integer.parseInt(
                    request.getParameter("goalId")
                );


                String sql =
                    "UPDATE GOALS G " +
                    "SET G.CURRENT_PROGRESS = G.TARGET_VALUE, " +
                    "    G.STATUS = 1 " +
                    "WHERE G.GOAL_ID = ? " +
                    "AND EXISTS (" +
                    "    SELECT 1 " +
                    "    FROM HABITS H " +
                    "    WHERE H.HABIT_ID = G.HABIT_ID " +
                    "    AND H.USER_ID = ?" +
                    ")";

                try (PreparedStatement ps =
                         conn.prepareStatement(sql)) {

                    ps.setInt(1, goalId);
                    ps.setInt(2, userId);

                    ps.executeUpdate();
                }

                response.sendRedirect("goals.jsp");
                return;
            }


            response.sendRedirect("goals.jsp");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("goals.jsp?error=database");
        }
    }
}