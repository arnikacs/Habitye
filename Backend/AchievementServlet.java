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

@WebServlet("/achievements")
public class AchievementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("USER_ID") == null) {

            response.sendRedirect("login.html");
            return;
        }

        response.sendRedirect("achievements.jsp");
    }


    public static void checkAchievements(Connection conn,
                                         int userId)
            throws Exception {

        // ==========================================
        // FIRST COMPLETED HABIT
        // ==========================================

        String firstStepDescription =
            "Completed your first habit.";

        int totalCompleted = 0;

        String completedSql =
            "SELECT COUNT(*) " +
            "FROM HABIT_LOG L " +
            "JOIN HABITS H ON L.HABIT_ID = H.HABIT_ID " +
            "WHERE H.USER_ID = ? " +
            "AND L.COMPLETED = 1";

        try (PreparedStatement ps =
                 conn.prepareStatement(completedSql)) {

            ps.setInt(1, userId);

            try (ResultSet rs =
                     ps.executeQuery()) {

                if (rs.next()) {
                    totalCompleted = rs.getInt(1);
                }
            }
        }

        if (totalCompleted >= 1) {

            insertAchievementIfMissing(
                conn,
                userId,
                "Fresh Start",
                firstStepDescription
            );
        }


        // ==========================================
        // 7-DAY STREAK
        // ==========================================

        int maxCurrentStreak = 0;

        String streakSql =
            "SELECT NVL(MAX(S.CURRENT_STREAK), 0) " +
            "FROM STREAKS S " +
            "JOIN HABITS H ON S.HABIT_ID = H.HABIT_ID " +
            "WHERE H.USER_ID = ?";

        try (PreparedStatement ps =
                 conn.prepareStatement(streakSql)) {

            ps.setInt(1, userId);

            try (ResultSet rs =
                     ps.executeQuery()) {

                if (rs.next()) {
                    maxCurrentStreak = rs.getInt(1);
                }
            }
        }

        if (maxCurrentStreak >= 7) {

            insertAchievementIfMissing(
                conn,
                userId,
                "7-Day Streak",
                "Kept a habit for seven consecutive days."
            );
        }


        // ==========================================
        // 30 COMPLETIONS
        // ==========================================

        if (totalCompleted >= 30) {

            insertAchievementIfMissing(
                conn,
                userId,
                "30 Completions",
                "Completed habits at least thirty times."
            );
        }


        // ==========================================
        // GOAL GETTER
        // ==========================================

        int completedGoals = 0;

        String goalSql =
            "SELECT COUNT(*) " +
            "FROM GOALS G " +
            "JOIN HABITS H ON G.HABIT_ID = H.HABIT_ID " +
            "WHERE H.USER_ID = ? " +
            "AND G.STATUS = 1";

        try (PreparedStatement ps =
                 conn.prepareStatement(goalSql)) {

            ps.setInt(1, userId);

            try (ResultSet rs =
                     ps.executeQuery()) {

                if (rs.next()) {
                    completedGoals = rs.getInt(1);
                }
            }
        }

        if (completedGoals >= 5) {

            insertAchievementIfMissing(
                conn,
                userId,
                "Goal Getter",
                "Completed five major goals."
            );
        }
    }


    private static void insertAchievementIfMissing(
            Connection conn,
            int userId,
            String achievementName,
            String description)
            throws Exception {

        String checkSql =
            "SELECT COUNT(*) " +
            "FROM ACHIEVEMENTS " +
            "WHERE USER_ID = ? " +
            "AND ACHIEVEMENT_NAME = ?";

        try (PreparedStatement checkPs =
                 conn.prepareStatement(checkSql)) {

            checkPs.setInt(1, userId);
            checkPs.setString(2, achievementName);

            try (ResultSet rs =
                     checkPs.executeQuery()) {

                if (rs.next() && rs.getInt(1) > 0) {
                    return;
                }
            }
        }


        String insertSql =
            "INSERT INTO ACHIEVEMENTS " +
            "(ACHIEVEMENT_ID, USER_ID, ACHIEVEMENT_NAME, " +
            "DESCRIPTION, ACHIEVED_DATE) " +
            "VALUES " +
            "(ACHIEVEMENT_SEQ.NEXTVAL, ?, ?, ?, SYSDATE)";

        try (PreparedStatement ps =
                 conn.prepareStatement(insertSql)) {

            ps.setInt(1, userId);
            ps.setString(2, achievementName);
            ps.setString(3, description);

            ps.executeUpdate();
        }
    }
}