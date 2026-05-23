package com.institute.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Date;

public class EmailUtility {
    private static final List<Map<String, String>> emailLogs = new ArrayList<>();

    public static synchronized void sendRegistrationEmail(String recipientName, String recipientEmail, String courseName) {
        String subject = "Welcome to Tanishq Institute - Registration Successful!";
        String body = "Dear " + recipientName + ",\n\n" +
                      "Congratulations! You have been successfully registered at Tanishq Institute.\n" +
                      "Enrolled Course: " + courseName + "\n" +
                      "Your credentials for login are:\n" +
                      "Username: " + recipientEmail + "\n" +
                      "Default Password: student123\n\n" +
                      "Please log in and update your password on your profile dashboard.\n\n" +
                      "Best Regards,\n" +
                      "Tanishq Training Institute Admin Board";
        
        logEmail(recipientEmail, subject, body);
    }

    public static synchronized void sendFeePaymentEmail(String recipientName, String recipientEmail, double amountPaid, double balance) {
        String subject = "Payment Receipt Received - Tanishq Institute";
        String body = "Dear " + recipientName + ",\n\n" +
                      "Thank you for your payment of INR " + String.format("%.2f", amountPaid) + ".\n" +
                      "Outstanding Balance: INR " + String.format("%.2f", balance) + "\n\n" +
                      "We have successfully credited this payment to your student account ledger.\n\n" +
                      "Best Regards,\n" +
                      "Tanishq Training Institute Finance Board";
                      
        logEmail(recipientEmail, subject, body);
    }

    private static void logEmail(String to, String subject, String body) {
        Map<String, String> log = new ConcurrentHashMap<>();
        log.put("to", to);
        log.put("subject", subject);
        log.put("body", body);
        log.put("timestamp", new Date().toString());
        
        emailLogs.add(0, log); // Newest first
        
        System.out.println("====== [SIMULATED EMAIL SENT] ======");
        System.out.println("To: " + to);
        System.out.println("Subject: " + subject);
        System.out.println("Body:\n" + body);
        System.out.println("====================================");
    }

    public static List<Map<String, String>> getEmailLogs() {
        return new ArrayList<>(emailLogs);
    }
    
    public static void clearLogs() {
        emailLogs.clear();
    }
}
