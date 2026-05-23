<%@ page import="com.institute.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    String currentURI = request.getRequestURI();
%>
<div class="sidebar">
    <div class="brand">
        <div class="brand-icon">T</div>
        <div class="brand-title">Tanishq Inst</div>
    </div>
    
    <ul class="nav-menu">
        <li>
            <a href="<%= request.getContextPath() %>/dashboard" class="nav-link <%= currentURI.contains("dashboard.jsp") || currentURI.endsWith("/dashboard") ? "active" : "" %>">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
                Dashboard
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/students" class="nav-link <%= currentURI.contains("students.jsp") || currentURI.endsWith("/students") ? "active" : "" %>">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                Students
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/courses" class="nav-link <%= currentURI.contains("courses.jsp") || currentURI.endsWith("/courses") ? "active" : "" %>">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                Courses
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/attendance" class="nav-link <%= currentURI.contains("attendance.jsp") || currentURI.endsWith("/attendance") ? "active" : "" %>">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                Attendance
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/fees" class="nav-link <%= currentURI.contains("fees.jsp") || currentURI.endsWith("/fees") ? "active" : "" %>">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                Fee Ledger
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/reports" class="nav-link <%= currentURI.contains("reports.jsp") || currentURI.endsWith("/reports") ? "active" : "" %>">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                Reports
            </a>
        </li>
    </ul>
    
    <div class="user-profile-badge">
        <div class="badge-avatar">
            <%= loggedInUser.getUsername().substring(0,1).toUpperCase() %>
        </div>
        <div class="badge-details">
            <span class="badge-name"><%= loggedInUser.getUsername() %></span>
            <span class="badge-role"><%= loggedInUser.getRole() %></span>
        </div>
        <a href="<%= request.getContextPath() %>/auth/logout" class="logout-btn" title="Logout">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
        </a>
    </div>
</div>
