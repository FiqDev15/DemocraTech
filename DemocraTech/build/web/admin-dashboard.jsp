<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.democratech.dao.ElectionDAO, com.democratech.dao.CandidateDAO, com.democratech.dao.VoteDAO, com.democratech.dao.FacultyDAO, com.democratech.dao.StudentDAO" %>
<%@ page import="com.democratech.model.Faculty, com.democratech.model.Election" %>
<%@ page import="java.util.List" %>
<%
    String userType = (String) session.getAttribute("userType");
    if (userType == null || !"admin".equals(userType)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String userName = (String) session.getAttribute("userName");
    Integer userId = (Integer) session.getAttribute("userId");
    Integer facultyId = (Integer) session.getAttribute("facultyId");
    
    FacultyDAO facultyDAO = new FacultyDAO();
    Faculty faculty = facultyDAO.getFacultyById(facultyId);
    String facultyName = (faculty != null) ? faculty.getFacultyName() : "Unknown Faculty";
    
    ElectionDAO electionDAO = new ElectionDAO();
    CandidateDAO candidateDAO = new CandidateDAO();
    VoteDAO voteDAO = new VoteDAO();
    StudentDAO studentDAO = new StudentDAO();
    
    List<Election> allElections = electionDAO.getElectionsByFaculty(facultyId);
    
    int totalElections = allElections.size();
    int ongoingElections = 0;
    int upcomingElections = 0;
    int completedElections = 0;
    int totalVotes = 0;
    
    for (Election election : allElections) {
        String status = election.getStatus();
        if ("ONGOING".equals(status)) {
            ongoingElections++;
        } else if ("UPCOMING".equals(status)) {
            upcomingElections++;
        } else if ("COMPLETED".equals(status)) {
            completedElections++;
        }
        totalVotes += election.getTotalVotes();
    }
    
    List<com.democratech.model.Candidate> allCandidates = candidateDAO.getCandidatesByFaculty(facultyId);
    int totalCandidates = allCandidates.size();
    int approvedCandidates = 0;
    int pendingCandidates = 0;
    
    java.util.List<com.democratech.model.Candidate> pendingCandidatesList = new java.util.ArrayList<com.democratech.model.Candidate>();
    
    for (com.democratech.model.Candidate candidate : allCandidates) {
        if (candidate.isStatus()) {
            approvedCandidates++;
        } else if (candidate.getReviewedAt() == null) {
            pendingCandidates++;
            pendingCandidatesList.add(candidate);
        }
    }
    
    int studentCount = studentDAO.getStudentCountByFaculty(facultyId);
    
    java.util.List<com.democratech.model.Candidate> recentCandidates = new java.util.ArrayList<com.democratech.model.Candidate>();
    java.util.Collections.sort(allCandidates, new java.util.Comparator<com.democratech.model.Candidate>() {
        public int compare(com.democratech.model.Candidate c1, com.democratech.model.Candidate c2) {
            if (c1.getAppliedAt() == null || c2.getAppliedAt() == null) return 0;
            return c2.getAppliedAt().compareTo(c1.getAppliedAt());
        }
    });
    
    for (int i = 0; i < Math.min(10, allCandidates.size()); i++) {
        recentCandidates.add(allCandidates.get(i));
    }
    
    java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - DemocraTech</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #ffffff;
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .stat-card h3 {
            color: #6c757d;
            font-size: 0.875rem;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 0.5rem;
        }

        .stat-card .number {
            font-size: 2rem;
            font-weight: 700;
            color: #003366;
            margin-bottom: 0.5rem;
        }

        .stat-card .label {
            color: #6c757d;
            font-size: 0.875rem;
        }

        .stat-card.primary {
            border-left: 4px solid #003366;
        }

        .stat-card.warning {
            border-left: 4px solid #FFB200;
        }

        .stat-card.success {
            border-left: 4px solid #28a745;
        }

        .stat-card.info {
            border-left: 4px solid #17a2b8;
        }

        .quick-actions {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            margin-bottom: 2rem;
        }

        .quick-actions h2 {
            color: #003366;
            margin-bottom: 1rem;
            font-size: 1.25rem;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .action-btn {
            display: block;
            padding: 1rem;
            background-color: #003366;
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 4px;
            transition: all 0.3s;
            font-weight: 500;
        }

        .action-btn:hover {
            background-color: #002244;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .alerts {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            margin-bottom: 2rem;
        }

        .alerts h2 {
            color: #003366;
            margin-bottom: 1rem;
            font-size: 1.25rem;
        }

        .alert-item {
            padding: 1rem;
            background-color: #fff3cd;
            border-left: 4px solid #FFB200;
            margin-bottom: 0.75rem;
            border-radius: 4px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .alert-item.info {
            background-color: #d1ecf1;
            border-left-color: #17a2b8;
        }

        .alert-item:last-child {
            margin-bottom: 0;
        }

        .alert-item strong {
            color: #003366;
        }

        .alert-content {
            flex: 1;
        }

        .alert-action {
            margin-left: 1rem;
        }

        .btn-small {
            padding: 0.5rem 1rem;
            background-color: #003366;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 0.875rem;
        }

        .btn-small:hover {
            background-color: #00509e;
        }

        .recent-activity {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }

        .recent-activity h2 {
            color: #003366;
            margin-bottom: 1rem;
            font-size: 1.25rem;
        }

        .activity-item {
            padding: 0.75rem 0;
            border-bottom: 1px solid #dee2e6;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-time {
            color: #6c757d;
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }

        .activity-status {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-left: 0.5rem;
        }

        .status-approved {
            background-color: #d4edda;
            color: #155724;
        }

        .status-rejected {
            background-color: #f8d7da;
            color: #721c24;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .no-data {
            text-align: center;
            padding: 2rem;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>DemocraTech - Admin Panel</h1>
        <div class="user-info">
            <span>Admin: <%= userName %> (<%= facultyName %>)</span>
            <form action="logout.jsp" method="post" style="margin: 0;">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </div>

    <nav class="nav">
        <ul>
            <li><a href="admin-dashboard.jsp" class="active">Dashboard</a></li>
            <li><a href="manage-elections.jsp">Elections</a></li>
            <li><a href="manage-candidates.jsp">Candidates</a></li>
            <li><a href="election-results.jsp">Results</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="stats-grid">
            <div class="stat-card primary">
                <h3>Total Elections</h3>
                <div class="number"><%= totalElections %></div>
                <div class="label">Elections for <%= facultyName %></div>
            </div>

            <div class="stat-card warning">
                <h3>Ongoing Elections</h3>
                <div class="number"><%= ongoingElections %></div>
                <div class="label">Currently active elections</div>
            </div>

            <div class="stat-card success">
                <h3>Total Votes Cast</h3>
                <div class="number"><%= totalVotes %></div>
                <div class="label">Across all faculty elections</div>
            </div>

            <div class="stat-card info">
                <h3>Registered Students</h3>
                <div class="number"><%= studentCount %></div>
                <div class="label">Students in <%= facultyName %></div>
            </div>
        </div>

        <div class="alerts">
            <h2>⚠️ Pending Actions</h2>
            <% if (pendingCandidates > 0) { %>
                <div class="alert-item">
                    <div class="alert-content">
                        <strong><%= pendingCandidates %> Candidate Application<%= pendingCandidates > 1 ? "s" : "" %></strong> waiting for review
                    </div>
                    <div class="alert-action">
                        <a href="manage-candidates.jsp" class="btn-small">Review Now</a>
                    </div>
                </div>
            <% } %>
            
            <% if (ongoingElections > 0) { %>
                <div class="alert-item info">
                    <div class="alert-content">
                        <strong><%= ongoingElections %> Election<%= ongoingElections > 1 ? "s" : "" %></strong> currently ongoing
                    </div>
                    <div class="alert-action">
                        <a href="manage-elections.jsp" class="btn-small">View Elections</a>
                    </div>
                </div>
            <% } %>
            
            <% if (pendingCandidates == 0 && ongoingElections == 0) { %>
                <div class="alert-item info">
                    <div class="alert-content">
                        No pending actions - All systems normal
                    </div>
                </div>
            <% } %>
        </div>

        <div class="recent-activity">
            <h2>Recent Activity</h2>
            <% if (recentCandidates.size() > 0) { %>
                <% for (com.democratech.model.Candidate candidate : recentCandidates) { 
                    String statusClass, statusText;
                    if (candidate.isStatus()) {
                        statusClass = "status-approved";
                        statusText = "APPROVED";
                    } else if (candidate.getReviewedAt() != null) {
                        statusClass = "status-rejected";
                        statusText = "REJECTED";
                    } else {
                        statusClass = "status-pending";
                        statusText = "PENDING";
                    }
                %>
                    <div class="activity-item">
                        <p>
                            <strong><%= candidate.getStudentName() %></strong> applied for 
                            <strong><%= candidate.getPositionName() %></strong> in <%= candidate.getElectionTitle() %>
                            <span class="activity-status <%= statusClass %>"><%= statusText %></span>
                        </p>
                        <div class="activity-time"><%= timeFormat.format(candidate.getAppliedAt()) %></div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="no-data">
                    <p>No recent activity</p>
                    <div class="activity-time">System is ready for administration</div>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
