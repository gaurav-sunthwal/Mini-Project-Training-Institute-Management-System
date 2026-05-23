<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.model.Course" %>
<%@ page import="com.institute.model.User" %>
<%@ page import="java.util.List" %>
<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    List<Course> courses = (List<Course>) request.getAttribute("courses");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Catalog - Tanishq Training Institute</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .course-card {
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 2rem;
            box-shadow: var(--glass-shadow);
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
            transition: var(--transition-smooth);
            position: relative;
            overflow: hidden;
        }

        .course-card:hover {
            transform: translateY(-5px);
            border-color: var(--glass-hover-border);
        }

        .course-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: var(--accent-indigo);
        }

        .course-card.violet::before { background: var(--accent-violet); }
        .course-card.emerald::before { background: var(--accent-emerald); }
        .course-card.amber::before { background: var(--accent-amber); }

        .course-header {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .course-title {
            font-size: 1.25rem;
            font-weight: 700;
        }

        .course-meta {
            color: var(--text-muted);
            font-size: 0.85rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .course-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            padding-top: 1rem;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .detail-label {
            font-size: 0.75rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            font-weight: 600;
        }

        .detail-value {
            font-size: 0.95rem;
            font-weight: 500;
        }

        .course-faculty-badge {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 0.75rem 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .faculty-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: var(--accent-indigo);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.85rem;
        }

        .faculty-info {
            display: flex;
            flex-direction: column;
        }

        .faculty-label {
            font-size: 0.7rem;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        .faculty-name {
            font-size: 0.85rem;
            font-weight: 600;
        }

        .page-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
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

        <!-- Main Course catalog board -->
        <main class="main-content">
            <header class="content-header">
                <div class="header-title">
                    <h1>Course Catalog</h1>
                    <p>Browse syllabus programs, duration frameworks, tuition packages, and faculty assignments.</p>
                </div>
            </header>

            <div class="page-actions">
                <div style="flex-grow: 1;"></div>
                <% if ("admin".equals(loggedUser.getRole())) { %>
                    <button class="btn btn-primary" data-modal="addCourseModal">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
                        Create Course
                    </button>
                <% } %>
            </div>

            <!-- Course list layout -->
            <section class="courses-grid">
                <% if (courses == null || courses.isEmpty()) { %>
                    <div class="glass-panel" style="grid-column: 1 / -1; text-align: center; padding: 4rem 1rem; color: var(--text-muted);">
                        No courses registered in catalogue. Create a course to get started.
                    </div>
                <% } else {
                    int idx = 0;
                    for (Course c : courses) { 
                        idx++;
                        String styleClass = "";
                        if (idx % 3 == 0) styleClass = "violet";
                        else if (idx % 3 == 1) styleClass = "emerald";
                        else styleClass = "amber";
                    %>
                        <div class="course-card <%= styleClass %>">
                            <div class="course-header">
                                <span class="course-meta">Syllabus ID: #<%= c.getCourseId() %></span>
                                <h3 class="course-title"><%= c.getCourseName() %></h3>
                            </div>

                            <div class="course-details">
                                <div class="detail-item">
                                    <span class="detail-label">Duration</span>
                                    <span class="detail-value"><%= c.getDuration() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Tuition Fee</span>
                                    <span class="detail-value" style="font-weight: 700; color: #34d399;">INR <%= String.format("%,.0f", c.getFees()) %></span>
                                </div>
                            </div>

                            <div class="course-faculty-badge">
                                <div class="faculty-avatar">
                                    <%= c.getFacultyName().replaceAll("(?i)(Dr\\.|Mr\\.|Mrs\\.|Prof\\.)", "").trim().substring(0, 1).toUpperCase() %>
                                </div>
                                <div class="faculty-info">
                                    <span class="faculty-label">Faculty Supervisor</span>
                                    <span class="faculty-name"><%= c.getFacultyName() %></span>
                                </div>
                            </div>

                            <% if ("admin".equals(loggedUser.getRole())) { %>
                                <div style="display: flex; gap: 0.5rem; border-top: 1px solid rgba(255, 255, 255, 0.05); padding-top: 1rem; margin-top: auto;">
                                    <button class="btn btn-secondary btn-sm" style="flex-grow: 1; padding: 0.4rem 0.8rem; font-size: 0.8rem;" 
                                            onclick="openEditCourseModal(<%= c.getCourseId() %>, '<%= c.getCourseName().replace("'", "\\'") %>', '<%= c.getDuration() %>', <%= c.getFees() %>, '<%= c.getFacultyName().replace("'", "\\'") %>')">
                                        Edit Course
                                    </button>
                                    <a href="<%= request.getContextPath() %>/courses/delete?id=<%= c.getCourseId() %>" 
                                       class="btn btn-danger btn-sm" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;" 
                                       onclick="return confirm('Are you sure you want to delete this course?')">
                                        Delete
                                    </a>
                                </div>
                            <% } %>
                        </div>
                    <% }
                } %>
            </section>
        </main>
    </div>

    <!-- Modal 1: Create Course -->
    <div class="modal-overlay" id="addCourseModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3>Create Course Syllabus</h3>
                <button class="logout-btn close-modal">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>
            <form action="<%= request.getContextPath() %>/courses/add" method="POST">
                <div class="form-group">
                    <label class="form-label">Course Title</label>
                    <input type="text" name="course_name" class="form-input" placeholder="e.g. Kotlin Android Apps" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Duration Program</label>
                    <input type="text" name="duration" class="form-input" placeholder="e.g. 5 Months" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Tuition Fees (INR)</label>
                    <input type="number" name="fees" class="form-input" placeholder="45000" min="0" required>
                </div>
                <div class="form-group" style="margin-bottom: 2rem;">
                    <label class="form-label">Assigned Faculty Advisor</label>
                    <input type="text" name="faculty_name" class="form-input" placeholder="e.g. Dr. Luke Skywalker" required>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">Register Course</button>
            </form>
        </div>
    </div>

    <!-- Modal 2: Edit Course -->
    <div class="modal-overlay" id="editCourseModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3>Modify Course Details</h3>
                <button class="logout-btn close-modal">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>
            <form action="<%= request.getContextPath() %>/courses/update" method="POST">
                <input type="hidden" name="course_id" id="edit_course_id">
                <div class="form-group">
                    <label class="form-label">Course Title</label>
                    <input type="text" name="course_name" id="edit_course_name" class="form-input" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Duration Program</label>
                    <input type="text" name="duration" id="edit_duration" class="form-input" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Tuition Fees (INR)</label>
                    <input type="number" name="fees" id="edit_fees" class="form-input" min="0" required>
                </div>
                <div class="form-group" style="margin-bottom: 2rem;">
                    <label class="form-label">Assigned Faculty Advisor</label>
                    <input type="text" name="faculty_name" id="edit_faculty_name" class="form-input" required>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">Save Changes</button>
            </form>
        </div>
    </div>

    <!-- Script to populate course edits -->
    <script>
        function openEditCourseModal(id, name, duration, fees, faculty) {
            document.getElementById("edit_course_id").value = id;
            document.getElementById("edit_course_name").value = name;
            document.getElementById("edit_duration").value = duration;
            document.getElementById("edit_fees").value = fees;
            document.getElementById("edit_faculty_name").value = faculty;
            document.getElementById("editCourseModal").classList.add("active");
        }
    </script>
    <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
