<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.democratech.model.Vote" %>
<%@ page import="com.democratech.dao.VoteDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
    
    VoteDAO voteDAO = new VoteDAO();
    
    List<Vote> votes = voteDAO.getVotesByStudent(studentId);
    
    SimpleDateFormat displayFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vote History - DemocraTech</title>
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

        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            border-left: 4px solid #003366;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .stat-card h3 {
            font-size: 2rem;
            color: #003366;
            margin-bottom: 0.5rem;
        }

        .stat-card p {
            color: #6c757d;
            font-size: 0.9rem;
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

        tr:hover {
            background-color: #f8f9fa;
        }

        .no-history {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }

        .no-history h3 {
            margin-bottom: 1rem;
        }

        .btn-primary {
            background-color: #003366;
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary:hover {
            background-color: #002244;
        }

        .vote-icon {
            color: #28a745;
            font-size: 1.2rem;
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
            <li><a href="vote-history.jsp" class="active">Vote History</a></li>
            <li><a href="election-results-student.jsp">Election Result</a></li>
            <li><a href="apply-candidate.jsp">Apply As Candidates</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="page-header">
            <h2>My Vote History</h2>
            <p>View all elections you have participated in</p>
        </div>

        <div class="stats">
            <div class="stat-card">
                <h3><%= votes.size() %></h3>
                <p>Total Votes Cast</p>
            </div>
            <div class="stat-card">
                <h3><%= voteDAO.getVotedElectionIds(studentId).size() %></h3>
                <p>Elections Participated</p>
            </div>
        </div>

        <div class="table-container">
            <% if (votes.isEmpty()) { %>
                <div class="no-history">
                    <h3>No Voting History</h3>
                    <p>You haven't voted in any elections yet.</p>
                    <p style="margin-top: 1rem;">
                        <a href="view-elections.jsp" class="btn-primary">View Available Elections</a>
                    </p>
                </div>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>Election</th>
                            <th>Position</th>
                            <th>Candidate Voted</th>
                            <th>Vote Date & Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Vote vote : votes) { %>
                            <tr>
                                <td><strong><%= vote.getElectionTitle() %></strong></td>
                                <td><%= vote.getPositionName() %></td>
                                <td>
                                    <span class=></span> <%= vote.getCandidateName() %>
                                </td>
                                <td><%= displayFormat.format(vote.getVoteTime()) %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
</body>
</html>
