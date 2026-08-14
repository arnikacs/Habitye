package com.Habitye.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection Utility Class for Habitye - Smart Habit & Goal Management System.
 * Handles Oracle SQL*Plus JDBC Connection lifecycle without frameworks.
 * Updated with user's specific Oracle 21c XEPDB1 credentials.
 */
public class DBConnection {
    // Standard Oracle JDBC Thin Driver connection parameters
    private static final String DRIVER = "oracle.jdbc.driver.OracleDriver";
    
    // Using XEPDB1 service name as specified in your SQL*Plus configuration
    private static final String URL = "jdbc:oracle:thin:@localhost:1521/XEPDB1";
    
    // Your verified database credentials from the screenshot
    private static final String USER = "student_admin";
    private static final String PASSWORD = "arnika123";

    /**
     * Establishes and returns a connection to the Oracle Database.
     * @return Connection object
     * @throws SQLException if database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        try {
            // Load Oracle JDBC Driver explicitly
            Class.forName(DRIVER);
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Oracle JDBC Driver not found in webapps/Habitye/WEB-INF/lib/ or Tomcat lib/ folder.", e);
        }
    }

    /**
     * Safe utility method to close a database connection.
     * @param conn Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                // Fail-safe logging for clean connection release
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
}