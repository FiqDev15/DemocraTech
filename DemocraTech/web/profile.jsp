<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.democratech.model.Student, com.democratech.model.Faculty" %>
<%@ page import="com.democratech.dao.StudentDAO, com.democratech.dao.FacultyDAO" %>
<%
    String userType = (String) session.getAttribute("userType");
    
    if (!"student".equals(userType)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String studentName = (String) session.getAttribute("userName");
    Integer studentId = (Integer) session.getAttribute("userId");
    Integer facultyId = (Integer) session.getAttribute("facultyId");
    
    if (studentName == null || studentId == null || facultyId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    StudentDAO studentDAO = new StudentDAO();
    FacultyDAO facultyDAO = new FacultyDAO();
    
    Student student = studentDAO.getStudentById(studentId);
    Faculty faculty = facultyDAO.getFacultyById(facultyId);
    
    String message = "";
    String messageType = "";
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (newPassword.equals(confirmPassword)) {
                student.setPassword(newPassword);
                
                if (studentDAO.updateStudent(student)) {
                    message = "Password updated successfully!";
                    messageType = "success";
                } else {
                    message = "Failed to update password.";
                    messageType = "error";
                }
            } else {
                message = "Passwords do not match!";
                messageType = "error";
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - DemocraTech</title>
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
        }

        .header {
            background-color: #003366;
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .header h1 {
            font-size: 1.5rem;
            font-weight: 600;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .logout-btn {
            background-color: #FFB200;
            color: #003366;
            padding: 0.5rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
        }

        .logout-btn:hover {
            background-color: #e6a000;
        }

        .nav {
            background-color: #f8f9fa;
            padding: 0;
            border-bottom: 1px solid #dee2e6;
        }

        .nav ul {
            list-style: none;
            display: flex;
            gap: 0;
        }

        .nav a {
            display: block;
            padding: 1rem 1.5rem;
            color: #003366;
            text-decoration: none;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
        }

        .nav a:hover,
        .nav a.active {
            background-color: #e9ecef;
            border-bottom-color: #FFB200;
        }

        .container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .page-header {
            margin-bottom: 2rem;
        }

        .page-header h2 {
            color: #003366;
            font-size: 1.75rem;
            margin-bottom: 0.5rem;
        }

        .page-header p {
            color: #6c757d;
        }

        .message {
            padding: 1rem;
            border-radius: 4px;
            margin-bottom: 1.5rem;
            border-left: 4px solid;
        }

        .message.success {
            background-color: #d4edda;
            color: #155724;
            border-left-color: #28a745;
        }

        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border-left-color: #dc3545;
        }

        .card {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            margin-bottom: 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .card h3 {
            color: #003366;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #FFB200;
        }

        .profile-info {
            display: grid;
            grid-template-columns: 150px 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .profile-info label {
            font-weight: 600;
            color: #003366;
        }

        .profile-info span {
            color: #495057;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            color: #003366;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .form-group input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 1rem;
        }

        .btn-primary {
            background-color: #003366;
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            font-size: 1rem;
        }

        .btn-primary:hover {
            background-color: #002244;
        }

        .info-box {
            background-color: #e7f3ff;
            border-left: 4px solid #0056b3;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 4px;
        }

        .info-box p {
            color: #004085;
            margin: 0;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>DemocraTech - Student Portal</h1>
        <div class="user-info">
            <span>Welcome, <%= studentName %></span>
            <form action="logout.jsp" method="post" style="margin: 0;">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </div>

    <nav class="nav">
        <ul>
            <li><a href="student-dashboard.jsp">Dashboard</a></li>
            <li><a href="view-elections.jsp">Elections</a></li>
            <li><a href="vote-history.jsp">Vote History</a></li>
            <li><a href="election-results-student.jsp">Election Result</a></li>
            <li><a href="apply-candidate.jsp">Apply As Candidates</a></li>
            <li><a href="profile.jsp" class="active">Profile</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="page-header">
            <h2>My Profile</h2>
            <p>View and manage your account information</p>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="message <%= messageType %>">
                <%= message %>
            </div>
        <% } %>

        <div class="card">
            <h3>Personal Information</h3>
            <div class="profile-info">
                <label>Student ID:</label>
                <span><%= student.getStudentId() %></span>
                
                <label>Name:</label>
                <span><%= student.getName() %></span>
                
                <label>Email:</label>
                <span><%= student.getEmail() %></span>
                
                <label>Faculty:</label>
                <span><%= faculty != null ? faculty.getFacultyName() : "N/A" %></span>
            </div>
        </div>

        <div class="card">
            <h3>Change Password</h3>
            
            <div class="info-box">
                <p>For security reasons, please use a strong password with at least 8 characters.</p>
            </div>
            
            <form action="profile.jsp" method="post">
                <div class="form-group">
                    <label for="newPassword">New Password *</label>
                    <input type="password" id="newPassword" name="newPassword" 
                           placeholder="Enter new password" required minlength="6">
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" 
                           placeholder="Re-enter new password" required minlength="6">
                </div>

                <button type="submit" class="btn-primary">Update Password</button>
            </form>
        </div>
    </div>
</body>
</html>
