<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.democratech.model.Student, com.democratech.model.Election, com.democratech.model.Position" %>
<%@ page import="com.democratech.dao.ElectionDAO, com.democratech.dao.CandidateDAO, com.democratech.dao.VoteDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String userType = (String) session.getAttribute("userType");
    
    if (!"student".equals(userType)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String studentName = (String) session.getAttribute("userName");
    Integer facultyId = (Integer) session.getAttribute("facultyId");
    Integer studentId = (Integer) session.getAttribute("userId");
    
    if (studentName == null || facultyId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    ElectionDAO electionDAO = new ElectionDAO();
    CandidateDAO candidateDAO = new CandidateDAO();
    VoteDAO voteDAO = new VoteDAO();
    
    List<Election> elections = electionDAO.getElectionsByFaculty(facultyId);
    
    SimpleDateFormat displayFormat = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Elections - DemocraTech</title>
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

        .table-container {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background-color: #f8f9fa;
        }

        th {
            padding: 1rem;
            text-align: left;
            color: #003366;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
        }

        td {
            padding: 1rem;
            border-bottom: 1px solid #dee2e6;
        }

        tbody tr:hover {
            background-color: #f8f9fa;
        }

        .badge {
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.875rem;
            font-weight: 600;
        }

        .badge-upcoming {
            background-color: #fff3cd;
            color: #856404;
        }

        .badge-ongoing {
            background-color: #d1e7dd;
            color: #0a3622;
        }

        .badge-completed {
            background-color: #e2e3e5;
            color: #383d41;
        }

        .badge-cancelled {
            background-color: #f8d7da;
            color: #58151c;
        }

        .btn-vote {
            background-color: #003366;
            color: white;
            padding: 0.5rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
        }

        .btn-vote:hover {
            background-color: #002244;
        }

        .btn-vote:disabled {
            background-color: #6c757d;
            cursor: not-allowed;
        }

        .btn-voted {
            background-color: #28a745;
            color: white;
            padding: 0.5rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
        }

        .btn-voted:hover {
            background-color: #218838;
        }

        .btn-view {
            background-color: #6c757d;
            color: white;
            padding: 0.5rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
        }

        .btn-view:hover {
            background-color: #5a6268;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }

        .empty-state h3 {
            margin-bottom: 0.5rem;
        }

        .position-list {
            margin: 0;
            padding-left: 1.2rem;
        }

        .position-list li {
            margin: 0.25rem 0;
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
            <li><a href="view-elections.jsp" class="active">Elections</a></li>
            <li><a href="vote-history.jsp">Vote History</a></li>
            <li><a href="election-results-student.jsp">Election Result</a></li>
            <li><a href="apply-candidate.jsp">Apply As Candidates</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="page-header">
            <h2>Available Elections</h2>
            <p>View and participate in ongoing elections for your faculty</p>
        </div>

        <div class="table-container">
            <% if (elections.isEmpty()) { %>
                <div class="empty-state">
                    <h3>No elections available</h3>
                    <p>There are currently no elections scheduled for your faculty.</p>
                </div>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>Election Name</th>
                            <th>Status</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Positions</th>
                            <th>Candidates</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Election election : elections) {
                            List<Position> positions = electionDAO.getPositionsByElection(election.getElectionId());
                            String statusClass = "badge-" + election.getStatus().toLowerCase();
                            boolean isOngoing = "ONGOING".equalsIgnoreCase(election.getStatus());
                            boolean isActive = "ACTIVE".equalsIgnoreCase(election.getStatus());
                        %>
                            <tr>
                                <td>
                                    <strong><%= election.getTitle() %></strong>
                                    <% if (election.getDescription() != null && !election.getDescription().isEmpty()) { %>
                                        <br><small style="color: #6c757d;"><%= election.getDescription() %></small>
                                    <% } %>
                                </td>
                                <td>
                                    <span class="badge <%= statusClass %>">
                                        <%= election.getStatus() %>
                                    </span>
                                </td>
                                <td><%= displayFormat.format(election.getStartDate()) %></td>
                                <td><%= displayFormat.format(election.getEndDate()) %></td>
                                <td>
                                    <% if (positions.isEmpty()) { %>
                                        <em>No positions</em>
                                    <% } else { %>
                                        <ul class="position-list">
                                            <% for (Position pos : positions) { %>
                                                <li><%= pos.getPositionName() %></li>
                                            <% } %>
                                        </ul>
                                    <% } %>
                                </td>
                                <td style="text-align: center;">
                                    <strong><%= candidateDAO.countCandidatesByElection(election.getElectionId()) %></strong>
                                </td>
                                <td>
                                    <% if (isOngoing || isActive) { 
                                        boolean hasVoted = voteDAO.hasVoted(studentId, election.getElectionId());
                                        if (hasVoted) {
                                    %>
                                        <a href="voting-page.jsp?electionId=<%= election.getElectionId() %>" class="btn-voted"> VOTED</a>
                                    <% } else { %>
                                        <a href="voting-page.jsp?electionId=<%= election.getElectionId() %>" class="btn-vote">Vote Now</a>
                                    <% } 
                                    } else if ("COMPLETED".equalsIgnoreCase(election.getStatus())) { %>
                                        <a href="election-results-student.jsp?electionId=<%= election.getElectionId() %>" class="btn-view">View Results</a>
                                    <% } else { %>
                                        <button class="btn-vote" disabled>Not Available</button>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
</body>
</html>
