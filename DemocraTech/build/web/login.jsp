<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.democratech.dao.StudentDAO, com.democratech.dao.AdminDAO, com.democratech.model.Student, com.democratech.model.Admin" %>
<%
    String errorMessage = null;
    String successMessage = (String) request.getAttribute("successMessage");
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");
        
        if (email != null && !email.trim().isEmpty() && 
            password != null && !password.trim().isEmpty()) {
            
            if ("admin".equals(userType)) {
              
                AdminDAO adminDAO = new AdminDAO();
                Admin admin = adminDAO.loginAdmin(email, password);
                
                if (admin != null) {
                    session.setAttribute("user", admin);
                    session.setAttribute("userType", "admin");
                    session.setAttribute("userId", admin.getAdminId());
                    session.setAttribute("userName", admin.getName());
                    session.setAttribute("facultyId", admin.getFacultyId());
                    response.sendRedirect("admin-dashboard.jsp");
                    return;
                } else {
                    errorMessage = "Invalid admin credentials";
                }
            } else {
                
                StudentDAO studentDAO = new StudentDAO();
                Student student = studentDAO.loginStudent(email, password);
                
                if (student != null) {
                    session.setAttribute("user", student);
                    session.setAttribute("userType", "student");
                    session.setAttribute("userId", student.getStudentId());
                    session.setAttribute("userName", student.getName());
                    session.setAttribute("facultyId", student.getFacultyId());
                    response.sendRedirect("student-dashboard.jsp");
                    return;
                } else {
                    errorMessage = "Invalid student credentials";
                }
            }
        } else {
            errorMessage = "Email and password are required";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - DemocraTech</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #333;
            line-height: 1.6;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            overflow: hidden;
        }

        .header {
            background-color: #003366;
            color: white;
            padding: 1rem 2rem;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
            z-index: 1000;
            pointer-event: none;
            cursor:default;
        }

        .header h1 {
            font-size: 1.5rem;
            font-weight: 600;
        }

        .login-container {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 380px;
            margin-top: 3.5rem;
        }

        .logo-container {
            text-align: center;
            margin-bottom: 1rem;
        }

        .logo-container img {
            width: 100px;
            height: auto;
            object-fit: contain;
        }

        .login-header {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .login-header h2 {
            color: #003366;
            font-size: 1.5rem;
            margin-bottom: 0.3rem;
        }

        .login-header p {
            color: #6c757d;
            font-size: 0.9rem;
            pointer-event: none;
            cursor:default;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.4rem;
            color: #003366;
            font-weight: 500;
            font-size: 0.9rem;
        }

        .form-control {
            width: 100%;
            padding: 0.65rem;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            font-size: 0.95rem;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #003366;
            box-shadow: 0 0 0 2px rgba(0, 51, 102, 0.1);
        }

        .user-type-selector {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .user-type-option {
            flex: 1;
        }

        .user-type-option input[type="radio"] {
            display: none;
        }

        .user-type-option label {
            display: block;
            padding: 0.6rem;
            text-align: center;
            border: 2px solid #dee2e6;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 500;
        }

        .user-type-option input[type="radio"]:checked + label {
            background-color: #003366;
            color: white;
            border-color: #003366;
        }

        .login-btn {
            width: 100%;
            background-color: #FFB200;
            color: #003366;
            padding: 0.75rem;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 1rem;
        }

        .login-btn:hover {
            background-color: #e6a000;
        }

        .register-link {
            text-align: center;
            color: #6c757d;
        }

        .register-link a {
            color: #003366;
            text-decoration: none;
            font-weight: 500;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 0.75rem;
            border-radius: 4px;
            margin-bottom: 1rem;
            border-left: 4px solid #dc3545;
        }

        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 0.75rem;
            border-radius: 4px;
            margin-bottom: 1rem;
            border-left: 4px solid #28a745;
        }

        .footer {
            text-align: center;
            color: #6c757d;
            font-size: 0.8rem;
            margin-top: 1rem;
            padding-top: 0.75rem;
            border-top: 1px solid #dee2e6;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>DemocraTech - Student Election System</h1>
    </div>

    <div class="login-container">
        <div class="logo-container">
            <img src="images/DT_logo.png" alt="DemocraTech Logo">
        </div>
        
        <div class="login-header">
            <h2>Login</h2>
            <p>Access your dashboard</p>
        </div>

        <% if (errorMessage != null) { %>
            <div class="error-message">
                <%= errorMessage %>
            </div>
        <% } %>

        <% if (successMessage != null) { %>
            <div class="success-message">
                <%= successMessage %>
            </div>
        <% } %>

        <form action="login.jsp" method="post">
            <div class="user-type-selector">
                <div class="user-type-option">
                    <input type="radio" id="studentType" name="userType" value="student" checked>
                    <label for="studentType">Student</label>
                </div>
                <div class="user-type-option">
                    <input type="radio" id="adminType" name="userType" value="admin">
                    <label for="adminType">Admin</label>
                </div>
            </div>

            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="Enter your email" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required>
            </div>

            <button type="submit" class="login-btn">Login</button>

            <div class="register-link">
                <p>Don't have an account? <a href="register.jsp">Register here</a></p>
            </div>
        </form>

        <div class="footer">
            <p>© 2025 DemocraTech | Student Election System</p>
        </div>
    </div>
</body>
</html>
