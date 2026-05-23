<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    int totalStudents = (Integer) request.getAttribute("totalStudents");
    int totalCourses = (Integer) request.getAttribute("totalCourses");
    double totalRevenue = (Double) request.getAttribute("totalRevenue");
    double attendanceRate = (Double) request.getAttribute("attendanceRate");
    List<Map<String, String>> emailLogs = (List<Map<String, String>>) request.getAttribute("emailLogs");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Tanishq Training Institute</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <!-- Chart.js for beautiful graphs -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .dashboard-layout {
            display: flex;
            min-height: 100vh;
        }
    </style>
</head>
<body>
    <!-- Ambient Background Blobs -->
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>

    <div class="app-container">
        <!-- stateful navigation sidebar -->
        <jsp:include page="sidebar.jsp" />

        <!-- Main dashboard screen -->
        <main class="main-content">
            <header class="content-header">
                <div class="header-title">
                    <h1>System Dashboard</h1>
                    <p>Welcome back, <%= user.getUsername() %>! Here is what's happening at your institute today.</p>
                </div>
            </header>

            <!-- Metrics Cards Grid -->
            <section class="metrics-grid">
                <!-- Students Card -->
                <div class="metric-card">
                    <div class="metric-header">
                        <span class="metric-title">Registered Students</span>
                        <div class="metric-icon indigo">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle></svg>
                        </div>
                    </div>
                    <span class="metric-value"><%= totalStudents %></span>
                </div>

                <!-- Courses Card -->
                <div class="metric-card">
                    <div class="metric-header">
                        <span class="metric-title">Active Courses</span>
                        <div class="metric-icon violet">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                        </div>
                    </div>
                    <span class="metric-value"><%= totalCourses %></span>
                </div>

                <!-- Revenue Card -->
                <div class="metric-card">
                    <div class="metric-header">
                        <span class="metric-title">Overall Revenue</span>
                        <div class="metric-icon emerald">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                        </div>
                    </div>
                    <span class="metric-value">INR <%= String.format("%,.2f", totalRevenue) %></span>
                </div>

                <!-- Attendance Rate Card -->
                <div class="metric-card">
                    <div class="metric-header">
                        <span class="metric-title">Attendance Rate</span>
                        <div class="metric-icon amber">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        </div>
                    </div>
                    <span class="metric-value"><%= String.format("%.1f%%", attendanceRate) %></span>
                </div>
            </section>

            <!-- Chart.js analytical panel grid -->
            <section class="charts-grid">
                <!-- Attendance Line Graph -->
                <div class="glass-panel">
                    <div class="panel-header">
                        <span class="panel-title">Weekly Attendance Analytics</span>
                    </div>
                    <div class="chart-card">
                        <canvas id="attendanceChart"></canvas>
                    </div>
                </div>

                <!-- Course Distribution Doughnut Graph -->
                <div class="glass-panel">
                    <div class="panel-header">
                        <span class="panel-title">Enrollment Distribution</span>
                    </div>
                    <div class="chart-card">
                        <canvas id="courseEnrollmentChart"></canvas>
                    </div>
                </div>
            </section>

            <!-- Simulated SMTP Email Console Logs -->
            <section class="glass-panel" style="margin-bottom: 0;">
                <div class="panel-header">
                    <div style="display: flex; flex-direction: column;">
                        <span class="panel-title" style="display: flex; align-items: center; gap: 0.5rem;">
                            <span style="display: inline-block; width: 8px; height: 8px; border-radius: 50%; background: #10b981; box-shadow: 0 0 8px #10b981;"></span>
                            SMTP Mock Notification Logs Console
                        </span>
                        <span style="color: var(--text-muted); font-size: 0.75rem; margin-top: 0.25rem;">Real-time automated dispatches captured by in-app simulator. Register a student or log payments to inspect.</span>
                    </div>
                </div>
                <div class="mock-logs-box">
                    <% if (emailLogs == null || emailLogs.isEmpty()) { %>
                        <div style="color: var(--text-muted); text-align: center; margin-top: 4rem;">
                            [No emails dispatched yet. Register students or log payments to trigger notifications]
                        </div>
                    <% } else { 
                        for (Map<String, String> log : emailLogs) { %>
                            <div class="log-item">
                                <span class="log-meta">[<%= log.get("timestamp") %>] OUTBOUND to: <strong><%= log.get("to") %></strong></span>
                                <span class="log-meta">Subject: <strong><%= log.get("subject") %></strong></span>
                                <span class="log-body"><%= log.get("body").replace("\n", "<br>") %></span>
                            </div>
                        <% } 
                    } %>
                </div>
            </section>
        </main>
    </div>

    <!-- Base interaction layers -->
    <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
