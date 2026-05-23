package com.institute.config;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.Properties;

public class DatabaseConfig {
    private static Properties properties = new Properties();

    static {
        try (InputStream input = DatabaseConfig.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                System.err.println("Sorry, unable to find db.properties. Using default H2 configuration.");
                properties.setProperty("db.type", "H2");
                properties.setProperty("db.h2.url", "jdbc:h2:./tanishq_institute;DB_CLOSE_DELAY=-1;MODE=MySQL");
                properties.setProperty("db.h2.username", "sa");
                properties.setProperty("db.h2.password", "");
            } else {
                properties.load(input);
            }
            
            // Register Drivers
            String dbType = properties.getProperty("db.type", "H2").toUpperCase();
            if ("H2".equals(dbType)) {
                Class.forName("org.h2.Driver");
            } else if ("SQLITE".equals(dbType)) {
                Class.forName("org.sqlite.JDBC");
            } else if ("MYSQL".equals(dbType)) {
                Class.forName("com.mysql.cj.jdbc.Driver");
            }
            
            // Initialize Database Schema on start
            initializeDatabase();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws Exception {
        String dbType = properties.getProperty("db.type", "H2").toUpperCase();
        String url;
        String user = "";
        String pass = "";

        if ("SQLITE".equals(dbType)) {
            url = properties.getProperty("db.sqlite.url", "jdbc:sqlite:tanishq_institute.db");
            return DriverManager.getConnection(url);
        } else if ("MYSQL".equals(dbType)) {
            url = properties.getProperty("db.mysql.url");
            user = properties.getProperty("db.mysql.username");
            pass = properties.getProperty("db.mysql.password");
            return DriverManager.getConnection(url, user, pass);
        } else { // Default to H2
            url = properties.getProperty("db.h2.url", "jdbc:h2:./tanishq_institute;DB_CLOSE_DELAY=-1;MODE=MySQL");
            user = properties.getProperty("db.h2.username", "sa");
            pass = properties.getProperty("db.h2.password", "");
            return DriverManager.getConnection(url, user, pass);
        }
    }

    private static void initializeDatabase() {
        System.out.println("Initializing Database Tables...");
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             InputStream schemaStream = DatabaseConfig.class.getClassLoader().getResourceAsStream("schema.sql")) {
            
            if (schemaStream == null) {
                System.err.println("schema.sql not found!");
                return;
            }

            BufferedReader reader = new BufferedReader(new InputStreamReader(schemaStream));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                // Ignore SQL comments
                if (line.trim().startsWith("--") || line.trim().isEmpty()) {
                    continue;
                }
                sb.append(line).append(" ");
            }

            // Split by semicolon to run individual queries
            String[] queries = sb.toString().split(";");
            for (String query : queries) {
                if (!query.trim().isEmpty()) {
                    try {
                        stmt.execute(query.trim());
                    } catch (Exception ex) {
                        System.err.println("Error executing query: " + query.trim() + " - " + ex.getMessage());
                    }
                }
            }
            System.out.println("Database tables successfully initialized and seeded!");
        } catch (Exception e) {
            System.err.println("Failed to initialize database: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
