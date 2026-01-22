<%@ page import="com.democratech.dao.FacultyDAO" %>
<%@ page import="com.democratech.model.Faculty" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - DemocraTech</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8f9fa; color: #333; line-height: 1.6; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .header { background-color: #003366; color: white; padding: 1rem 2rem; position: fixed; top: 0; left: 0; right: 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center; }
        .header h1 { font-size: 1.5rem; font-weight: 600; }
        .register-container { background: white; padding: 2.5rem; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 100%; max-width: 500px; margin-top: 4rem; }
        .register-header { text-align: center; margin-bottom: 2rem; }
        .register-header h2 { color: #003366; font-size: 1.8rem; margin-bottom: 0.5rem; }
        .register-header p { color: #6c757d; }
        .form-group { margin-bottom: 1.5rem; }
        .form-row { display: flex; gap: 1rem; margin-bottom: 1.5rem; }
        .form-row .form-group { flex: 1; margin-bottom: 0; }
        .form-group label { display: block; margin-bottom: 0.5rem; color: #003366; font-weight: 500; }
        .form-control { width: 100%; padding: 0.75rem; border: 1px solid #dee2e6; border-radius: 4px; font-size: 1rem; transition: border-color 0.3s; }
        .form-control:focus { outline: none; border-color: #003366; box-shadow: 0 0 0 2px rgba(0, 51, 102, 0.1); }
        .form-hint { font-size: 0.875rem; color: #6c757d; margin-top: 0.25rem; }
        .register-btn { width: 100%; background-color: #003366; color: white; padding: 0.875rem; border: none; border-radius: 4px; font-size: 1rem; font-weight: 600; cursor: pointer; transition: all 0.3s; margin-bottom: 1rem; }
        .register-btn:hover { background-color: #002244; }
        .login-link { text-align: center; color: #6c757d; }
        .login-link a { color: #003366; text-decoration: none; font-weight: 500; }
        .login-link a:hover { text-decoration: underline; }
        .message-box { padding: 0.75rem; border-radius: 4px; margin-bottom: 1rem; }
        .success-message { background-color: #d4edda; color: #155724; border-left: 4px solid #28a745; }
        .error-message { background-color: #f8d7da; color: #721c24; border-left: 4px solid #dc3545; }
        .footer { text-align: center; color: #6c757d; font-size: 0.875rem; margin-top: 2rem; padding-top: 1rem; border-top: 1px solid #dee2e6; }
    </style>
</head>
<body>
    <div class="header"><h1>DemocraTech - Student Election System</h1></div>
    <div class="register-container">
        <div class="register-header">
            <h2>Student Registration</h2>
            <p>Create your account to participate in elections</p>
        </div>
        <% String errorMessage = (String) request.getAttribute("errorMessage");
           String successMessage = (String) request.getAttribute("successMessage");
           if (successMessage != null) { %>
            <div class="message-box success-message"><%= successMessage %></div>
        <% } if (errorMessage != null) { %>
            <div class="message-box error-message"><%= errorMessage %></div>
        <% } %>
        <form method="POST" action="register">
            <div class="form-row">
                <div class="form-group">
                    <label for="firstName">First Name</label>
                    <input type="text" id="firstName" name="firstName" class="form-control" placeholder="Enter first name" required>
                </div>
                <div class="form-group">
                    <label for="lastName">Last Name</label>
                    <input type="text" id="lastName" name="lastName" class="form-control" placeholder="Enter last name" required>
                </div>
            </div>
            <div class="form-group">
                <label for="studentNumber">Student ID</label>
                <input type="text" id="studentNumber" name="studentNumber" class="form-control" placeholder="Enter student ID (numeric)" required>
                <div class="form-hint">Your official university student ID (numbers only)</div>
            </div>
            <div class="form-group">
                <label for="email">University Email</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="student@university.edu" required>
                <div class="form-hint">Use your university email address</div>
            </div>
            <div class="form-group">
                <label for="faculty">Faculty</label>
                <select id="faculty" name="faculty" class="form-control" required>
                    <option value="">Select Faculty</option>
                    <% 
                    try {
                        FacultyDAO facultyDAO = new FacultyDAO();
                        List<Faculty> faculties = facultyDAO.getAllFaculties();
                        if (faculties != null && !faculties.isEmpty()) {
                            for (Faculty faculty : faculties) { %>
                                <option value="<%= faculty.getFacultyId() %>"><%= faculty.getFacultyName() %></option>
                    <%      }
                        } else { %>
                            <option value="">No faculties available</option>
                    <%  }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<option value=''>Error loading faculties</option>");
                    }
                    %>
                </select>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Create a password" required>
                <div class="form-hint">Minimum 8 characters</div>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Confirm your password" required>
            </div>
            <button type="submit" class="register-btn">Register Account</button>
            <div class="login-link"><p>Already have an account? <a href="login">Login here</a></p></div>
        </form>
        <div class="footer"><p>© 2025 DemocraTech | Student Election System</p></div>
    </div>
</body>
</html>
