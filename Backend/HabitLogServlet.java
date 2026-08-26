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

@WebServlet("/habit-log")
public class HabitLogServlet extends HttpServlet {

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

        String habitIdParam = request.getParameter("habitId");

        if (habitIdParam == null || habitIdParam.trim().isEmpty()) {
            response.sendRedirect("habits.jsp");
            return;
        }

        int habitId;

        try {
            habitId = Integer.parseInt(habitIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("habits.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            // ==========================================
            // CHECK THAT HABIT BELONGS TO USER
            // ==========================================

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

                try (ResultSet rs = verifyPs.executeQuery()) {

                    if (!rs.next()) {
                        response.sendRedirect("habits.jsp");
                        return;
                    }
                }
            }


            // ==========================================
            // CHECK IF ALREADY COMPLETED TODAY
            // ==========================================

            String checkSql =
                "SELECT COUNT(*) AS TOTAL " +
                "FROM HABIT_LOG " +
                "WHERE HABIT_ID = ? " +
                "AND TRUNC(LOG_DATE) = TRUNC(SYSDATE) " +
                "AND COMPLETED = 1";

            try (PreparedStatement checkPs =
                     conn.prepareStatement(checkSql)) {

                checkPs.setInt(1, habitId);

                try (ResultSet rs = checkPs.executeQuery()) {

                    if (rs.next() && rs.getInt("TOTAL") > 0) {
                        response.sendRedirect("habits.jsp");
                        return;
                    }
                }
            }


            // ==========================================
            // INSERT TODAY'S LOG
            // ==========================================

            String insertSql =
                "INSERT INTO HABIT_LOG " +
                "(LOG_ID, HABIT_ID, LOG_DATE, COMPLETED) " +
                "VALUES " +
                "(HABIT_LOG_SEQ.NEXTVAL, ?, SYSDATE, 1)";

            try (PreparedStatement ps =
                     conn.prepareStatement(insertSql)) {

                ps.setInt(1, habitId);
                ps.executeUpdate();
            }


        } catch (Exception e) {

            e.printStackTrace();
            response.sendRedirect("habits.jsp");
            return;
        }


        // ==========================================
        // RETURN TO HABITS PAGE
        // ==========================================

        response.sendRedirect("habits.jsp");
    }
}