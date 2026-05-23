<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.model.User" %>
<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports Console - Tanishq Training Institute</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .reports-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .report-card {
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 2rem;
            display: flex;
            flex-direction: column;
            gap: 1rem;
            transition: var(--transition-smooth);
            box-shadow: var(--glass-shadow);
        }

        .report-card:hover {
            transform: translateY(-4px);
            border-color: var(--glass-hover-border);
        }

        .report-card-icon {
            width: 48px;
            height: 48px;
            border-radius: var(--radius-md);
            background: rgba(99, 102, 241, 0.1);
            color: #818cf8;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 0.5rem;
        }

        .report-card-title {
            font-size: 1.1rem;
            font-weight: 600;
        }

        .report-card-desc {
            font-size: 0.85rem;
            color: var(--text-secondary);
            line-height: 1.4;
            flex-grow: 1;
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

        <!-- Main Reports Workspace -->
        <main class="main-content">
            <header class="content-header">
                <div class="header-title">
                    <h1>Reports & Analytics Workspace</h1>
                    <p>Compile academic documents, extract spreadsheet spreadsheets, and download student profiles roster sheets.</p>
                </div>
            </header>

            <section class="reports-grid">
                <!-- PDF Student Roster Card -->
                <div class="report-card">
                    <div class="report-card-icon">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                    </div>
                    <h3 class="report-card-title">Student Registry Report (PDF)</h3>
                    <p class="report-card-desc">Compiles all active student registry details (ID, Name, Email, Enrolled Course, and Phone numbers) into a formal PDF document. Perfect for physical printouts and registry archives.</p>
                    <a href="<%= request.getContextPath() %>/reports/download" class="btn btn-primary" style="justify-content: center; margin-top: 1rem;">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>
                        Compile & Download PDF
                    </a>
                </div>

                <!-- Simulated XLSX collections report -->
                <div class="report-card">
                    <div class="report-card-icon" style="background: rgba(16, 185, 129, 0.1); color: #34d399;">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><line x1="9" y1="3" x2="9" y2="21"></line><line x1="15" y1="3" x2="15" y2="21"></line><line x1="3" y1="9" x2="21" y2="9"></line><line x1="3" y1="15" x2="21" y2="15"></line></svg>
                    </div>
                    <h3 class="report-card-title">Tuition Collections Sheet (XLSX)</h3>
                    <p class="report-card-desc">Formats all ledger receipts and collections invoices into a spreadsheet-ready tabular structure for financial auditing, ledger aggregations, and taxation archiving.</p>
                    <button class="btn btn-secondary" style="justify-content: center; margin-top: 1rem;" onclick="alert('Simulated spreadsheet compile: Ledger reports cleared! In-memory transactions exported.')">
                        Download Spreadsheet
                    </button>
                </div>

                <!-- Simulated core stats summary sheet -->
                <div class="report-card">
                    <div class="report-card-icon" style="background: rgba(168, 85, 247, 0.1); color: #c084fc;">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>
                    </div>
                    <h3 class="report-card-title">Overall Institute Stats Digest</h3>
                    <p class="report-card-desc">Extracts dynamic attendance rate calculations, revenue logs, student densities per course, and summaries of course advisors into a quick summary document.</p>
                    <button class="btn btn-secondary" style="justify-content: center; margin-top: 1rem;" onclick="alert('Simulated statistics summary extraction: Overall attendance rate: 86.7%, Total revenue logged: INR 65,000.')">
                        Extract Digest Summary
                    </button>
                </div>
            </section>
        </main>
    </div>

    <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
