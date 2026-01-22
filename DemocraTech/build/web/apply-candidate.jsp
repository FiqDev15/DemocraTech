<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.democratech.model.Election, com.democratech.model.Position" %>
<%@ page import="com.democratech.dao.ElectionDAO, com.democratech.dao.CandidateDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Date" %>
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
    
    ElectionDAO electionDAO = new ElectionDAO();
    CandidateDAO candidateDAO = new CandidateDAO();
    
    String message = "";
    String messageType = "";
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String positionIdStr = request.getParameter("positionId");
        String manifesto = request.getParameter("manifesto");
        
        if (positionIdStr != null && manifesto != null && !manifesto.trim().isEmpty()) {
            try {
                int positionId = Integer.parseInt(positionIdStr);
                
                if (candidateDAO.hasApplied(studentId, positionId)) {
                    message = "You have already applied for this position!";
                    messageType = "error";
                } else {
                    com.democratech.model.Candidate candidate = 
                        new com.democratech.model.Candidate(positionId, studentId, manifesto);
                    
                    if (candidateDAO.applyAsCandidate(candidate)) {
                        message = "Application submitted successfully! Waiting for admin approval.";
                        messageType = "success";
                    } else {
                        message = "Failed to submit application. Please try again.";
                        messageType = "error";
                    }
                }
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
                messageType = "error";
            }
        } else {
            message = "Please fill all required fields.";
            messageType = "error";
        }
    }
    
    List<Election> elections = electionDAO.getElectionsByFaculty(facultyId);
    
    List<com.democratech.model.Candidate> myApplications = candidateDAO.getApplicationsByStudent(studentId);
    
    java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apply as Candidate - DemocraTech</title>
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
            max-width: 1200px;
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
            border-bottom: 2px solid #FFB200;
            padding-bottom: 0.5rem;
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

        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 1rem;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 150px;
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

        .info-box h4 {
            color: #0056b3;
            margin-bottom: 0.5rem;
        }

        .info-box ul {
            margin-left: 1.5rem;
            color: #004085;
        }

        .election-info {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 4px;
            margin-top: 0.5rem;
            font-size: 0.9rem;
            color: #6c757d;
        }

        .no-elections {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }
        
        .applications-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }
        
        .applications-table th {
            background-color: #f8f9fa;
            padding: 0.75rem;
            text-align: left;
            border-bottom: 2px solid #dee2e6;
            color: #003366;
            font-weight: 600;
        }
        
        .applications-table td {
            padding: 0.75rem;
            border-bottom: 1px solid #dee2e6;
        }
        
        .applications-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .badge {
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.875rem;
            font-weight: 600;
        }
        
        .badge-approved {
            background-color: #d1e7dd;
            color: #0a3622;
        }
        
        .badge-pending {
            background-color: #fff3cd;
            color: #664d03;
        }
        
        .badge-rejected {
            background-color: #f8d7da;
            color: #58151c;
        }
    </style>
    <script>
        function showElectionInfo() {
            var select = document.getElementById('positionId');
            var infoDiv = document.getElementById('electionInfo');
            
            if (select.value) {
                var selectedOption = select.options[select.selectedIndex];
                var electionTitle = selectedOption.getAttribute('data-election');
                var positionName = selectedOption.getAttribute('data-position');
                
                infoDiv.innerHTML = '<strong>Election:</strong> ' + electionTitle + 
                                   '<br><strong>Position:</strong> ' + positionName;
                infoDiv.style.display = 'block';
            } else {
                infoDiv.style.display = 'none';
            }
        }
    </script>
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
            <li><a href="apply-candidate.jsp" class="active">Apply As Candidates</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="page-header">
            <h2>Apply as Candidate</h2>
            <p>Submit your candidacy for upcoming elections</p>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="message <%= messageType %>">
                <%= message %>
            </div>
        <% } %>

        <div class="info-box">
            <h4>Application Guidelines</h4>
            <ul>
                <li>You can apply for positions in upcoming or ongoing elections</li>
                <li>Write a clear manifesto explaining your goals and vision</li>
                <li>Your application will be reviewed by the admin</li>
                <li>You can only apply once per position</li>
            </ul>
        </div>
        
        <% if (!myApplications.isEmpty()) { %>
        <div class="card">
            <h3>📋 My Applications</h3>
            <table class="applications-table">
                <thead>
                    <tr>
                        <th>Election</th>
                        <th>Position</th>
                        <th>Applied On</th>
                        <th>Status</th>
                        <th>Reviewed On</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (com.democratech.model.Candidate app : myApplications) { 
                        String statusClass = app.isStatus() ? "badge-approved" : "badge-pending";
                        String statusText = app.isStatus() ? "APPROVED" : "PENDING";
                        
                        if (!app.isStatus() && app.getReviewedAt() != null) {
                            statusClass = "badge-rejected";
                            statusText = "REJECTED";
                        }
                    %>
                    <tr>
                        <td><strong><%= app.getElectionTitle() %></strong></td>
                        <td><%= app.getPositionName() %></td>
                        <td><%= dateFormat.format(app.getAppliedAt()) %></td>
                        <td>
                            <span class="badge <%= statusClass %>">
                                <%= statusText %>
                            </span>
                        </td>
                        <td>
                            <%= app.getReviewedAt() != null ? dateFormat.format(app.getReviewedAt()) : "-" %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } %>

        <% 
        List<Election> availableElections = new java.util.ArrayList<>();
        for (Election election : elections) {
            if ("UPCOMING".equals(election.getStatus()) || "ONGOING".equals(election.getStatus())) {
                availableElections.add(election);
            }
        }
        
        if (availableElections.isEmpty()) { 
        %>
            <div class="card">
                <div class="no-elections">
                    <h3>No Elections Available</h3>
                    <p>There are currently no elections accepting candidate applications.</p>
                    <p>Please check back later or contact your admin.</p>
                </div>
            </div>
        <% } else { %>
            <div class="card">
                <h3>Candidate Application Form</h3>
                
                <form action="apply-candidate.jsp" method="post">
                    <div class="form-group">
                        <label for="positionId">Select Position *</label>
                        <select id="positionId" name="positionId" required onchange="showElectionInfo()">
                            <option value="">-- Choose a position --</option>
                            <%
                            for (Election election : availableElections) {
                                List<Position> positions = electionDAO.getPositionsByElection(election.getElectionId());
                                for (Position position : positions) {
                                    boolean alreadyApplied = candidateDAO.hasApplied(studentId, position.getPositionId());
                            %>
                                <option value="<%= position.getPositionId() %>" 
                                        data-election="<%= election.getTitle() %>"
                                        data-position="<%= position.getPositionName() %>"
                                        <%= alreadyApplied ? "disabled" : "" %>>
                                    <%= election.getTitle() %> - <%= position.getPositionName() %>
                                    <%= alreadyApplied ? "(Already Applied)" : "" %>
                                </option>
                            <%
                                }
                            }
                            %>
                        </select>
                        <div id="electionInfo" class="election-info" style="display: none;"></div>
                    </div>

                    <div class="form-group">
                        <label for="manifesto">Your Manifesto *</label>
                        <textarea id="manifesto" name="manifesto" 
                                  placeholder="Describe your vision, goals, and why you should be elected. Be specific and persuasive." 
                                  required></textarea>
                        <small style="color: #6c757d;">Maximum 2000 characters</small>
                    </div>

                    <button type="submit" class="btn-primary">Submit Application</button>
                </form>
            </div>
        <% } %>
    </div>
</body>
</html>
