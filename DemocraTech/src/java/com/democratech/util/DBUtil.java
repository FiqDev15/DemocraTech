package com.democratech.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DBUtil {
    
    private static final String DB_URL = "jdbc:derby://localhost:1527/democratech_db";
    private static final String DB_USERNAME = "app";
    private static final String DB_PASSWORD = "app";
    private static final String DB_DRIVER = "org.apache.derby.jdbc.ClientDriver";
    
    static {
        try {
            Class.forName(DB_DRIVER);
            System.out.println("Derby JDBC Driver loaded");
        } catch (ClassNotFoundException e) {
            System.err.println("Derby Driver not found!");
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
    }
    
    public static void closeResources(Connection conn, PreparedStatement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        try {
            if (stmt != null) stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public static void closeConnection(Connection conn) {
        closeResources(conn, null, null);
    }
}
