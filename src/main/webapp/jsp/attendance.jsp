<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.model.Attendance" %>
<%@ page import="com.institute.model.Student" %>
<%@ page import="com.institute.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    List<Attendance> attendanceLogs = (List<Attendance>) request.getAttribute("attendanceLogs");
    List<Student> students = (List<Student>) request.getAttribute("students");
    Map<Integer, Double> percentages = (Map<Integer, Double>) request.getAttribute("percentages");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance Board - Tanishq Training Institute</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .attendance-split-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1.5rem;
            align-items: start;
        }
        @media (max-width: 1024px) {
            .attendance-split-grid {
                grid-template-columns: 1fr;
            }
        }
        .roster-rate-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 1rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.03);
        }
        .rate-indicator {
            font-weight: 700;
            font-size: 0.9rem;
        }
        .rate-indicator.green { color: #34d399; }
        .rate-indicator.orange { color: #fbbf24; }
        .rate-indicator.red { color: #f43f5e; }
    </style>
</head>
<body>
    <!-- Ambient Background Blobs -->
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>

    <div class="app-container">
        <!-- Navigation Sidebar -->
        <jsp:include page="sidebar.jsp" />

        <!-- Main Attendance Board -->
        <main class="main-content">
            <header class="content-header">
                <div class="header-title">
                    <h1>Attendance Board</h1>
                    <p>Track class participation, review student attendance rates, and record daily rolls.</p>
                </div>
            </header>

            <div class="attendance-split-grid">
                <!-- History Sheet Logs Column -->
                <div class="glass-panel">
                    <div class="panel-header">
                        <span class="panel-title">Daily Rolls History Log</span>
                    </div>
                    <div class="table-container">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>Log ID</th>
                                    <th>Student</th>
                                    <th>Date</th>
                                    <th>Status Roll</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (attendanceLogs == null || attendanceLogs.isEmpty()) { %>
                                    <tr>
                                        <td colspan="4" style="text-align: center; color: var(--text-muted); padding: 4rem 1rem;">
                                            No attendance rolls logged. Register dynamic markers to start.
                                        </td>
                                    </tr>
                                <% } else {
                                    for (Attendance att : attendanceLogs) { %>
                                        <tr>
                                            <td>#<%= att.getAttendanceId() %></td>
                                            <td style="font-weight: 500;"><%= att.getStudentName() %></td>
                                            <td><%= att.getDate() %></td>
                                            <td>
                                                <% if ("Present".equalsIgnoreCase(att.getStatus())) { %>
                                                    <span class="badge-pill success">Present</span>
                                                <% } else { %>
                                                    <span class="badge-pill danger">Absent</span>
                                                <% } %>
                                            </td>
                                        </tr>
                                    <% }
                                } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Roll Call Form & Roster Column -->
                <div style="display: flex; flex-direction: column; gap: 1.5rem;">
                    <% if ("admin".equals(loggedUser.getRole()) || "faculty".equals(loggedUser.getRole())) { %>
                        <!-- Roll Marker Form Panel -->
                        <div class="glass-panel">
                            <div class="panel-header">
                                <span class="panel-title">Record Roll Call</span>
                            </div>
                            <form action="<%= request.getContextPath() %>/attendance/mark" method="POST">
                                <div class="form-group">
                                    <label class="form-label">Select Student</label>
                                    <select name="student_id" class="form-input" required>
                                        <% if (students != null) {
                                            for (Student s : students) { %>
                                                <option value="<%= s.getStudentId() %>"><%= s.getStudentName() %> (ID: <%= s.getStudentId() %>)</option>
                                            <% }
                                        } %>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Roll Date</label>
                                    <input type="date" name="date" class="form-input" required>
                                </div>
                                <div class="form-group" style="margin-bottom: 1.5rem;">
                                    <label class="form-label">Status Roll</label>
                                    <select name="status" class="form-input" required>
                                        <option value="Present">Present</option>
                                        <option value="Absent">Absent</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">Record Log</button>
                            </form>
                        </div>
                    <% } %>

                    <!-- Rate roster scoreboard Panel -->
                    <div class="glass-panel">
                        <div class="panel-header">
                            <span class="panel-title">Roster Attendance Rates</span>
                        </div>
                        <div style="display: flex; flex-direction: column;">
                            <% if (students == null || students.isEmpty()) { %>
                                <span style="color: var(--text-muted); font-size: 0.85rem; text-align: center; padding: 1.5rem 0;">Roster empty.</span>
                            <% } else {
                                for (Student s : students) {
                                    double rate = percentages.getOrDefault(s.getStudentId(), 100.0);
                                    String colorClass = "green";
                                    if (rate < 75.0) colorClass = "red";
                                    else if (rate < 90.0) colorClass = "orange";
                                %>
                                    <div class="roster-rate-item">
                                        <div style="display: flex; flex-direction: column;">
                                            <span style="font-size: 0.85rem; font-weight: 600;"><%= s.getStudentName() %></span>
                                            <span style="font-size: 0.75rem; color: var(--text-muted);"><%= s.getCourse() %></span>
                                        </div>
                                        <span class="rate-indicator <%= colorClass %>"><%= String.format("%.1f%%", rate) %></span>
                                    </div>
                                <% }
                            } %>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="<%= request.getContextPath() %>/js/app.js"></script>
    <script>
        // Set today's date automatically in the input
        document.addEventListener("DOMContentLoaded", () => {
            const dateInput = document.querySelector('input[type="date"]');
            if (dateInput) {
                const today = new Date().toISOString().split('T')[0];
                dateInput.value = today;
            }
        });
    </script>
</body>
</html>
