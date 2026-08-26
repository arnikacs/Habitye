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
import java.sql.ResultSet;

@WebServlet("/habit")
public class HabitServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER_ID") == null) {
            response.sendRedirect("login.html");
            return;
        }

        int userId = (Integer) session.getAttribute("USER_ID");

        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {

            // =========================
            // ADD HABIT
            // =========================
            if ("add".equals(action)) {

                String habitName = request.getParameter("habitName");
                String description = request.getParameter("description");
                String frequency = request.getParameter("frequency");
                String categoryId = request.getParameter("categoryId");

                String sql =
                    "INSERT INTO HABITS " +
                    "(HABIT_ID, USER_ID, CATEGORY_ID, HABIT_NAME, DESCRIPTION, FREQUENCY, START_DATE, STATUS) " +
                    "VALUES " +
                    "(HABIT_SEQ.NEXTVAL, ?, ?, ?, ?, ?, SYSDATE, 1)";

                try (PreparedStatement ps = conn.prepareStatement(sql)) {

                    ps.setInt(1, userId);
                    ps.setInt(2, Integer.parseInt(categoryId));
                    ps.setString(3, habitName);
                    ps.setString(4, description);
                    ps.setString(5, frequency);

                    ps.executeUpdate();
                }

                response.sendRedirect("habits.jsp");
                return;
            }


            // =========================
            // DEACTIVATE HABIT
            // =========================
            if ("deactivate".equals(action)) {

                int habitId = Integer.parseInt(
                    request.getParameter("habitId")
                );

                String sql =
                    "UPDATE HABITS " +
                    "SET STATUS = 0 " +
                    "WHERE HABIT_ID = ? AND USER_ID = ?";

                try (PreparedStatement ps = conn.prepareStatement(sql)) {

                    ps.setInt(1, habitId);
                    ps.setInt(2, userId);

                    ps.executeUpdate();
                }

                response.sendRedirect("habits.jsp");
                return;
            }

            response.sendRedirect("habits.jsp");

        } catch (Exception e) {

            e.printStackTrace();
            response.sendRedirect("habits.jsp?error=database");
        }
    }
}