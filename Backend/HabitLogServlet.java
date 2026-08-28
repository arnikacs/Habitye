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
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

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

    /*
     * Decide where the user came from.
     *
     * Dashboard -> return to dashboard.jsp
     * Habits    -> return to habits.jsp
     *
     * The existing forms do not need to be changed.
     */
    String returnPage = "habits.jsp";

    String referer = request.getHeader("Referer");

    if (referer != null &&
        referer.contains("/dashboard.jsp")) {

        returnPage = "dashboard.jsp";
    }


    try (Connection conn = DBConnection.getConnection()) {

        // ==========================================
        // 1. VERIFY HABIT BELONGS TO CURRENT USER
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

            try (ResultSet rs =
                     verifyPs.executeQuery()) {

                if (!rs.next()) {
                    response.sendRedirect(returnPage);
                    return;
                }
            }
        }


        // ==========================================
        // 2. DON'T INSERT DUPLICATE TODAY
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

            try (ResultSet rs =
                     checkPs.executeQuery()) {

                if (rs.next() &&
                    rs.getInt("TOTAL") > 0) {

                    response.sendRedirect(returnPage);
                    return;
                }
            }
        }


        // ==========================================
        // 3. INSERT TODAY'S HABIT LOG
        // ==========================================

        String insertLogSql =
            "INSERT INTO HABIT_LOG " +
            "(LOG_ID, HABIT_ID, LOG_DATE, COMPLETED) " +
            "VALUES " +
            "(HABIT_LOG_SEQ.NEXTVAL, ?, SYSDATE, 1)";

        try (PreparedStatement ps =
                 conn.prepareStatement(insertLogSql)) {

            ps.setInt(1, habitId);
            ps.executeUpdate();
        }


        // ==========================================
        // 4. LOAD ALL COMPLETED DATES
        // ==========================================

        List<LocalDate> completedDates =
            new ArrayList<>();

        String datesSql =
            "SELECT DISTINCT TRUNC(LOG_DATE) AS LOG_DAY " +
            "FROM HABIT_LOG " +
            "WHERE HABIT_ID = ? " +
            "AND COMPLETED = 1 " +
            "ORDER BY LOG_DAY DESC";

        try (PreparedStatement datesPs =
                 conn.prepareStatement(datesSql)) {

            datesPs.setInt(1, habitId);

            try (ResultSet rs =
                     datesPs.executeQuery()) {

                while (rs.next()) {

                    Date sqlDate =
                        rs.getDate("LOG_DAY");

                    if (sqlDate != null) {

                        completedDates.add(
                            sqlDate.toLocalDate()
                        );
                    }
                }
            }
        }


        // ==========================================
        // 5. CALCULATE CURRENT STREAK
        // ==========================================

        LocalDate today = LocalDate.now();

        int currentStreak = 0;

        LocalDate expectedDate = today;

        for (LocalDate date : completedDates) {

            if (date.equals(expectedDate)) {

                currentStreak++;

                expectedDate =
                    expectedDate.minusDays(1);

            } else if (date.isBefore(expectedDate)) {

                break;
            }
        }


        // ==========================================
        // 6. CALCULATE LONGEST STREAK
        // ==========================================

        int longestStreak = 0;
        int runningStreak = 0;

        LocalDate previousDate = null;

        for (LocalDate date : completedDates) {

            if (previousDate == null) {

                runningStreak = 1;

            } else {

                long difference =
                    java.time.temporal.ChronoUnit.DAYS.between(
                        date,
                        previousDate
                    );

                if (difference == 1) {

                    runningStreak++;

                } else {

                    runningStreak = 1;
                }
            }

            if (runningStreak > longestStreak) {

                longestStreak = runningStreak;
            }

            previousDate = date;
        }


        // ==========================================
        // 7. INSERT OR UPDATE STREAKS
        // ==========================================

        String checkStreakSql =
            "SELECT STREAK_ID " +
            "FROM STREAKS " +
            "WHERE HABIT_ID = ?";

        Integer streakId = null;

        try (PreparedStatement streakCheckPs =
                 conn.prepareStatement(checkStreakSql)) {

            streakCheckPs.setInt(1, habitId);

            try (ResultSet rs =
                     streakCheckPs.executeQuery()) {

                if (rs.next()) {

                    streakId =
                        rs.getInt("STREAK_ID");
                }
            }
        }


        if (streakId == null) {

            String insertStreakSql =
                "INSERT INTO STREAKS " +
                "(STREAK_ID, HABIT_ID, CURRENT_STREAK, " +
                "LONGEST_STREAK, LAST_COMPLETED_DATE) " +
                "VALUES " +
                "(STREAK_SEQ.NEXTVAL, ?, ?, ?, SYSDATE)";

            try (PreparedStatement ps =
                     conn.prepareStatement(insertStreakSql)) {

                ps.setInt(1, habitId);
                ps.setInt(2, currentStreak);
                ps.setInt(3, longestStreak);

                ps.executeUpdate();
            }

        } else {

            String updateStreakSql =
                "UPDATE STREAKS " +
                "SET CURRENT_STREAK = ?, " +
                "LONGEST_STREAK = ?, " +
                "LAST_COMPLETED_DATE = SYSDATE " +
                "WHERE STREAK_ID = ?";

            try (PreparedStatement ps =
                     conn.prepareStatement(updateStreakSql)) {

                ps.setInt(1, currentStreak);
                ps.setInt(2, longestStreak);
                ps.setInt(3, streakId);

                ps.executeUpdate();
            }
        }


        // ==========================================
        // 8. CHECK ACHIEVEMENTS
        // ==========================================

        AchievementServlet.checkAchievements(
            conn,
            userId
        );


    } catch (Exception e) {

        e.printStackTrace();

        response.sendRedirect(
            returnPage + "?error=database"
        );

        return;
    }


    // ==========================================
    // 9. RETURN TO ORIGINAL PAGE
    // ==========================================

    response.sendRedirect(returnPage);
}


}
