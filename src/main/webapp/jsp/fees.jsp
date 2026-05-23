<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.model.Fee" %>
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
    List<Fee> payments = (List<Fee>) request.getAttribute("payments");
    List<Map<String, Object>> pendingReport = (List<Map<String, Object>>) request.getAttribute("pendingReport");
    List<Student> students = (List<Student>) request.getAttribute("students");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fee Ledger - Tanishq Training Institute</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .split-grid-fees {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1.5rem;
            align-items: start;
        }
        @media (max-width: 1024px) {
            .split-grid-fees {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Ambient Background Blobs -->
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>

    <div class="app-container">
        <!-- Navigation Sidebar -->
        <jsp:include page="sidebar.jsp" />

        <!-- Main Ledger board -->
        <main class="main-content">
            <header class="content-header">
                <div class="header-title">
                    <h1>Fee Ledger Logs</h1>
                    <p>Track student accounts, log incoming tuition collections, and review pending balances sheet.</p>
                </div>
            </header>

            <div class="split-grid-fees">
                <!-- Transaction log column -->
                <div style="display: flex; flex-direction: column; gap: 2rem;">
                    <!-- Collection Logs Panel -->
                    <div class="glass-panel">
                        <div class="panel-header">
                            <span class="panel-title">Receipt Collections History Ledger</span>
                        </div>
                        <div class="table-container">
                            <table class="custom-table">
                                <thead>
                                    <tr>
                                        <th>Receipt ID</th>
                                        <th>Student</th>
                                        <th>Amount Paid</th>
                                        <th>Collection Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (payments == null || payments.isEmpty()) { %>
                                        <tr>
                                            <td colspan="4" style="text-align: center; color: var(--text-muted); padding: 4rem 1rem;">
                                                No receipts recorded. Post payment logs to populate ledger.
                                            </td>
                                        </tr>
                                    <% } else {
                                        for (Fee p : payments) { %>
                                            <tr>
                                                <td>#<%= p.getPaymentId() %></td>
                                                <td style="font-weight: 500;"><%= p.getStudentName() %></td>
                                                <td style="font-weight: 700; color: #34d399;">INR <%= String.format("%,.2f", p.getAmountPaid()) %></td>
                                                <td><%= p.getPaymentDate() %></td>
                                            </tr>
                                        <% }
                                    } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Outstanding balance list Panel -->
                    <div class="glass-panel">
                        <div class="panel-header">
                            <span class="panel-title">Outstanding Pending Balances Report</span>
                        </div>
                        <div class="table-container">
                            <table class="custom-table">
                                <thead>
                                    <tr>
                                        <th>Student</th>
                                        <th>Course Program</th>
                                        <th>Total cost</th>
                                        <th>Paid So Far</th>
                                        <th>Dues Balance</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (pendingReport == null || pendingReport.isEmpty()) { %>
                                        <tr>
                                            <td colspan="5" style="text-align: center; color: var(--text-muted); padding: 3rem 1rem;">
                                                [All registries are fully paid! Outstanding balance cleared]
                                            </td>
                                        </tr>
                                    <% } else {
                                        for (Map<String, Object> log : pendingReport) { %>
                                            <tr>
                                                <td style="font-weight: 600;"><%= log.get("student_name") %></td>
                                                <td style="font-size: 0.85rem;"><%= log.get("course") %></td>
                                                <td>INR <%= String.format("%,.0f", log.get("total_course_fee")) %></td>
                                                <td style="color: #34d399;">INR <%= String.format("%,.0f", log.get("paid_so_far")) %></td>
                                                <td style="font-weight: 700; color: #fbbf24;">INR <%= String.format("%,.0f", log.get("pending_balance")) %></td>
                                            </tr>
                                        <% }
                                    } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Record roll column -->
                <% if ("admin".equals(loggedUser.getRole())) { %>
                    <div class="glass-panel">
                        <div class="panel-header">
                            <span class="panel-title">Log tuition Payment</span>
                        </div>
                        <form action="<%= request.getContextPath() %>/fees/pay" method="POST">
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
                                <label class="form-label">Amount Received (INR)</label>
                                <input type="number" name="amount_paid" class="form-input" placeholder="e.g. 15000" min="1" required>
                            </div>
                            <div class="form-group" style="margin-bottom: 2rem;">
                                <label class="form-label">Receipt Date</label>
                                <input type="date" name="date" class="form-input" required>
                            </div>
                            <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">Record Payment</button>
                        </form>
                    </div>
                <% } else { %>
                    <div class="glass-panel" style="text-align: center; color: var(--text-muted); padding: 2.5rem 1rem;">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-bottom: 0.75rem;"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                        <p style="font-size: 0.85rem;">Log transactions is locked. Only Admin role can record tuition payments.</p>
                    </div>
                <% } %>
            </div>
        </main>
    </div>

    <script src="<%= request.getContextPath() %>/js/app.js"></script>
    <script>
        // Auto pre-populate receipt dates
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
