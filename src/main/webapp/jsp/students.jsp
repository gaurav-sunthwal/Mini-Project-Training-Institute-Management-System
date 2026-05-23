<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.model.Student" %>
<%@ page import="com.institute.model.User" %>
<%@ page import="java.util.List" %>
<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    List<Student> students = (List<Student>) request.getAttribute("students");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Students Directory - Tanishq Training Institute</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .page-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1.5rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
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

        <!-- Main Students Directory -->
        <main class="main-content">
            <header class="content-header">
                <div class="header-title">
                    <h1>Students Directory</h1>
                    <p>Track student registers, profiles, and initiate registrations or update details.</p>
                </div>
            </header>

            <!-- Actions Header (AJAX Search + Add Button) -->
            <div class="page-actions">
                <div class="search-container">
                    <svg class="search-icon-svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    <input type="text" id="directorySearch" class="form-input search-input" placeholder="Search by name, email..." data-search-type="student">
                </div>
                
                <% if ("admin".equals(loggedUser.getRole()) || "faculty".equals(loggedUser.getRole())) { %>
                    <button class="btn btn-primary" data-modal="addStudentModal">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><line x1="19" y1="8" x2="19" y2="14"></line><line x1="22" y1="11" x2="16" y2="11"></line></svg>
                        Register Student
                    </button>
                <% } %>
            </div>

            <!-- Student Directory Roster -->
            <section class="glass-panel" style="margin-bottom: 0;">
                <div class="table-container">
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Student ID</th>
                                <th>Name & Profile</th>
                                <th>Email</th>
                                <th>Course Name</th>
                                <th>Contact Number</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="directoryResults">
                            <% if (students == null || students.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 4rem 1rem;">
                                        No students found in registry. Register one to start.
                                    </td>
                                </tr>
                            <% } else {
                                for (Student s : students) { %>
                                    <tr>
                                        <td><%= s.getStudentId() %></td>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: 0.75rem;">
                                                <% if (s.getPhotoPath() != null && !s.getPhotoPath().isEmpty()) { %>
                                                    <img src="<%= request.getContextPath() %>/<%= s.getPhotoPath() %>" class="avatar-frame" alt="<%= s.getStudentName() %>">
                                                <% } else { %>
                                                    <div class="avatar-placeholder"><%= s.getStudentName().substring(0, 1).toUpperCase() %></div>
                                                <% } %>
                                                <span style="font-weight: 500;"><%= s.getStudentName() %></span>
                                            </div>
                                        </td>
                                        <td><%= s.getEmail() %></td>
                                        <td><%= s.getCourse() %></td>
                                        <td><%= s.getPhone() %></td>
                                        <td>
                                            <div style="display: flex; gap: 0.5rem;">
                                                <% if ("admin".equals(loggedUser.getRole()) || "faculty".equals(loggedUser.getRole())) { %>
                                                    <button class="btn btn-secondary btn-sm" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;" 
                                                            onclick="openEditModal(<%= s.getStudentId() %>, '<%= s.getStudentName() %>', '<%= s.getEmail() %>', '<%= s.getCourse() %>', '<%= s.getPhone() %>')">
                                                        Edit
                                                    </button>
                                                    <button class="btn btn-secondary btn-sm" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;" 
                                                            onclick="openPhotoUploadModal(<%= s.getStudentId() %>)">
                                                        Photo
                                                    </button>
                                                    <a href="<%= request.getContextPath() %>/students/delete?id=<%= s.getStudentId() %>" 
                                                       class="btn btn-danger btn-sm" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;" 
                                                       onclick="return confirm('Are you sure you want to delete this student profile? The user login and payments will be cascaded.')">
                                                        Delete
                                                    </a>
                                                <% } else { %>
                                                    <span style="color: var(--text-muted); font-size: 0.8rem;">Read Only</span>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                <% }
                            } %>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>

    <!-- Modal 1: Register Student -->
    <div class="modal-overlay" id="addStudentModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3>Register Student</h3>
                <button class="logout-btn close-modal">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>
            <form action="<%= request.getContextPath() %>/students/add" method="POST">
                <div class="form-group">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="student_name" class="form-input" placeholder="e.g. John Doe" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" class="form-input" placeholder="john.doe@gmail.com" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Enrolled Course</label>
                    <select name="course" class="form-input" required>
                        <option value="Java Full Stack Development">Java Full Stack Development</option>
                        <option value="Python Data Science & ML">Python Data Science & ML</option>
                        <option value="React Native Mobile Apps">React Native Mobile Apps</option>
                    </select>
                </div>
                <div class="form-group" style="margin-bottom: 2rem;">
                    <label class="form-label">Contact Number</label>
                    <input type="text" name="phone" class="form-input" placeholder="+91 98765 43210" required>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">Register Profile</button>
            </form>
        </div>
    </div>

    <!-- Modal 2: Edit Student -->
    <div class="modal-overlay" id="editStudentModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3>Modify Student Profile</h3>
                <button class="logout-btn close-modal">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>
            <form action="<%= request.getContextPath() %>/students/update" method="POST">
                <input type="hidden" name="student_id" id="edit_id">
                <div class="form-group">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="student_name" id="edit_name" class="form-input" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" id="edit_email" class="form-input" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Enrolled Course</label>
                    <select name="course" id="edit_course" class="form-input" required>
                        <option value="Java Full Stack Development">Java Full Stack Development</option>
                        <option value="Python Data Science & ML">Python Data Science & ML</option>
                        <option value="React Native Mobile Apps">React Native Mobile Apps</option>
                    </select>
                </div>
                <div class="form-group" style="margin-bottom: 2rem;">
                    <label class="form-label">Contact Number</label>
                    <input type="text" name="phone" id="edit_phone" class="form-input" required>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">Save Changes</button>
            </form>
        </div>
    </div>

    <!-- Modal 3: Upload Student Photo -->
    <div class="modal-overlay" id="photoStudentModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3>Upload Student Photo</h3>
                <button class="logout-btn close-modal">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>
            <form action="<%= request.getContextPath() %>/students/upload-photo" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="student_id" id="photo_student_id">
                
                <div class="photo-uploader-container" style="margin-bottom: 2rem;">
                    <div class="circle-preview">
                        <img id="avatarPreview" src="<%= request.getContextPath() %>/css/style.css" style="display: none;">
                        <svg id="avatarPlaceholderIcon" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="17 8 12 3 7 8"></polyline><line x1="12" y1="3" x2="12" y2="15"></line></svg>
                    </div>
                    <div style="display: flex; flex-direction: column; gap: 0.5rem; flex-grow: 1;">
                        <label class="form-label">Select Image File</label>
                        <input type="file" name="photo" class="form-input photo-file-input" data-preview-target="avatarPreview" accept="image/*" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">Upload Avatar</button>
            </form>
        </div>
    </div>

    <!-- Scripts to populate edit triggers and modals -->
    <script>
        function openEditModal(id, name, email, course, phone) {
            document.getElementById("edit_id").value = id;
            document.getElementById("edit_name").value = name;
            document.getElementById("edit_email").value = email;
            document.getElementById("edit_course").value = course;
            document.getElementById("edit_phone").value = phone;
            document.getElementById("editStudentModal").classList.add("active");
        }

        function openPhotoUploadModal(studentId) {
            document.getElementById("photo_student_id").value = studentId;
            document.getElementById("avatarPreview").style.display = "none";
            document.getElementById("avatarPlaceholderIcon").style.display = "block";
            document.getElementById("photoStudentModal").classList.add("active");
        }
        
        // Setup listener for preview updates
        document.querySelector(".photo-file-input").addEventListener("change", (e) => {
            const preview = document.getElementById("avatarPreview");
            const placeholder = document.getElementById("avatarPlaceholderIcon");
            const file = e.target.files[0];
            
            if (file) {
                const reader = new FileReader();
                reader.onload = (event) => {
                    preview.src = event.target.result;
                    preview.style.display = "block";
                    placeholder.style.display = "none";
                };
                reader.readAsDataURL(file);
            }
        });
    </script>
    <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
