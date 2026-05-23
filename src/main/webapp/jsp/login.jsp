<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Tanishq Training Institute</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .login-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            position: relative;
            padding: 1.5rem;
        }
        
        .login-card {
            width: 440px;
            padding: 2.5rem;
        }
        
        .login-logo {
            display: flex;
            justify-content: center;
            margin-bottom: 2rem;
        }
        
        .logo-circle {
            width: 56px;
            height: 56px;
            background: var(--accent-indigo);
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 1.6rem;
            box-shadow: 0 0 25px rgba(99, 102, 241, 0.4);
            font-family: 'Poppins', sans-serif;
        }
        
        .login-header h2 {
            font-size: 1.5rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 0.5rem;
        }
        
        .login-header p {
            color: var(--text-secondary);
            font-size: 0.9rem;
            text-align: center;
            margin-bottom: 2rem;
        }

        .alert-box {
            padding: 0.75rem 1rem;
            border-radius: var(--radius-md);
            font-size: 0.85rem;
            font-weight: 500;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-box.danger {
            background: rgba(244, 63, 94, 0.1);
            color: #f43f5e;
            border: 1px solid rgba(244, 63, 94, 0.2);
        }

        .alert-box.success {
            background: rgba(16, 185, 129, 0.1);
            color: #34d399;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .demo-roles {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--glass-border);
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .demo-roles-title {
            font-size: 0.8rem;
            text-transform: uppercase;
            font-weight: 600;
            color: var(--text-muted);
            letter-spacing: 0.5px;
        }

        .demo-badges {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .demo-badge {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--glass-border);
            padding: 0.35rem 0.75rem;
            border-radius: 50px;
            font-size: 0.75rem;
            color: var(--text-secondary);
            cursor: pointer;
            transition: var(--transition-smooth);
        }

        .demo-badge:hover {
            background: rgba(255, 255, 255, 0.08);
            color: var(--text-primary);
            border-color: var(--glass-hover-border);
        }
    </style>
</head>
<body>
    <!-- Ambient Background Blobs -->
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>

    <div class="login-wrapper">
        <div class="glass-panel login-card">
            <div class="login-logo">
                <div class="logo-circle">T</div>
            </div>
            
            <div class="login-header">
                <h2>Welcome Back</h2>
                <p>Training Institute Management System</p>
            </div>

            <!-- Login feedback alerts -->
            <% if ("invalid_credentials".equals(request.getParameter("error"))) { %>
                <div class="alert-box danger">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    Invalid username or password.
                </div>
            <% } %>

            <% if ("logged_out".equals(request.getParameter("msg"))) { %>
                <div class="alert-box success">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    Logout successful!
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/auth/login" method="POST">
                <div class="form-group">
                    <label class="form-label" for="username">Username (Email)</label>
                    <input type="text" name="username" id="username" class="form-input" placeholder="name@institute.com" required>
                </div>
                
                <div class="form-group" style="margin-bottom: 2rem;">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" name="password" id="password" class="form-input" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center; padding: 0.85rem 1rem;">
                    Secure Sign In
                </button>
            </form>

            <div class="demo-roles">
                <span class="demo-roles-title">Quick Evaluation Credentials</span>
                <div class="demo-badges">
                    <span class="demo-badge" onclick="fillCredentials('admin', 'admin123')">Admin Panel</span>
                    <span class="demo-badge" onclick="fillCredentials('faculty', 'faculty123')">Faculty Board</span>
                    <span class="demo-badge" onclick="fillCredentials('tanishq@institute.com', 'student123')">Student Profile</span>
                </div>
            </div>
        </div>
    </div>

    <script>
        function fillCredentials(user, pass) {
            document.getElementById("username").value = user;
            document.getElementById("password").value = pass;
            
            // Add subtle active glow transition visual feedback
            const inputs = document.querySelectorAll(".form-input");
            inputs.forEach(input => {
                input.style.borderColor = "#6366f1";
                input.style.boxShadow = "0 0 10px rgba(99, 102, 241, 0.25)";
            });

            setTimeout(() => {
                inputs.forEach(input => {
                    input.style.borderColor = "";
                    input.style.boxShadow = "";
                });
            }, 800);
        }
    </script>
</body>
</html>
