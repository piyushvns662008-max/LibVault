package com.libvault.util;
// FILE: src/com/libvault/util/DBConnection.java

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    // ==== EDIT THESE 3 VALUES TO MATCH YOUR MYSQL SETUP ====
    private static final String URL = "jdbc:mysql://localhost:3306/libvault?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "piyush"; // <-- put your MySQL password here

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
}
