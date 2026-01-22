<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.democratech.dao.ElectionDAO, com.democratech.dao.CandidateDAO, com.democratech.dao.VoteDAO, com.democratech.dao.FacultyDAO, com.democratech.dao.StudentDAO" %>
<%@ page import="com.democratech.model.Election, com.democratech.model.Candidate, com.democratech.model.Faculty, com.democratech.model.Student" %>
<%@ page import="java.util.List, java.time.LocalDate" %>
<%
    String userType = (String) session.getAttribute("userType");
    if (userType == null || !"student".equals(userType)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String userName = (String) session.getAttribute("userName");
    Integer userId = (Integer) session.getAttribute("userId");
    
    StudentDAO studentDAO = new StudentDAO();
    Student student = studentDAO.getStudentById(userId);
    Integer facultyId = (student != null) ? student.getFacultyId() : null;
    
    FacultyDAO facultyDAO = new FacultyDAO();
    Faculty faculty = (facultyId != null) ? facultyDAO.getFacultyById(facultyId) : null;
    String facultyName = (faculty != null) ? faculty.getFacultyName() : "Unknown Faculty";
    
    ElectionDAO electionDAO = new ElectionDAO();
    VoteDAO voteDAO = new VoteDAO();
    CandidateDAO candidateDAO = new CandidateDAO();
    
    List<Election> allElections = electionDAO.getElectionsByFaculty(facultyId);
    
    int availableElections = 0;
    int ongoingElections = 0;
    int upcomingElections = 0;
    Election nextElection = null;
    
    for (Election election : allElections) {
        String status = election.getStatus();
        if ("ONGOING".equals(status)) {
            ongoingElections++;
            availableElections++;
        } else if ("UPCOMING".equals(status)) {
            upcomingElections++;
            availableElections++;
            if (nextElection == null || election.getStartDate().before(nextElection.getStartDate())) {
                nextElection = election;
            }
        }
    }
    
    List<Integer> votedElectionIds = voteDAO.getVotedElectionIds(userId);
    int votedElectionsCount = votedElectionIds.size();
    
    int completedElectionsVoted = 0;
    for (Integer electionId : votedElectionIds) {
        Election election = electionDAO.getElectionById(electionId);
        if (election != null && "COMPLETED".equals(election.getStatus())) {
            completedElectionsVoted++;
        }
    }
    
    java.util.List<Election> activeElections = new java.util.ArrayList<Election>();
    for (Election election : allElections) {
        if ("ONGOING".equals(election.getStatus())) {
            activeElections.add(election);
        }
    }
    
    List<Candidate> myApplications = candidateDAO.getApplicationsByStudent(userId);
    
    java.util.List<Object[]> recentActivity = new java.util.ArrayList<Object[]>();
    
    for (Integer electionId : votedElectionIds) {
        Election election = electionDAO.getElectionById(electionId);
        if (election != null) {
            java.sql.Timestamp voteTime = voteDAO.getVoteTimeByStudentAndElection(userId, electionId);
            if (voteTime != null) {
                recentActivity.add(new Object[]{"vote", election.getTitle(), voteTime});
            }
        }
    }
    
    for (Candidate candidate : myApplications) {
        if (candidate.getAppliedAt() != null) {
            recentActivity.add(new Object[]{"application", candidate.getPositionName() + " - " + candidate.getElectionTitle(), candidate.getAppliedAt()});
        }
    }
    
    java.util.Collections.sort(recentActivity, new java.util.Comparator<Object[]>() {
        public int compare(Object[] a, Object[] b) {
            java.sql.Timestamp timeA = (java.sql.Timestamp) a[2];
            java.sql.Timestamp timeB = (java.sql.Timestamp) b[2];
            return timeB.compareTo(timeA);
        }
    });
    
    if (recentActivity.size() > 10) {
        recentActivity = recentActivity.subList(0, 10);
    }
    
    java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("MMM dd, yyyy");
    java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - DemocraTech</title>
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

        .welcome-banner {
            background: linear-gradient(135deg, #003366 0%, #004080 100%);
            color: white;
            padding: 2rem;
            border-radius: 8px;
            margin-bottom: 2rem;
        }

        .welcome-banner h2 {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }

        .welcome-banner p {
            opacity: 0.9;
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

        .elections-section {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            margin-bottom: 2rem;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .section-header h2 {
            color: #003366;
            font-size: 1.25rem;
        }

        .view-all {
            color: #003366;
            text-decoration: none;
            font-weight: 500;
        }

        .view-all:hover {
            text-decoration: underline;
        }
        .election-card {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            background-color: #f8f9fa;
            transition: box-shadow 0.3s;
        }

        .election-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .election-card:last-child {
            margin-bottom: 0;
        }

        .election-title {
            color: #003366;
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .election-meta {
            display: flex;
            gap: 1.5rem;
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .election-description {
            color: #495057;
            margin-bottom: 1rem;
            line-height: 1.5;
        }

        .election-status {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 4px;
            font-size: 0.875rem;
            font-weight: 600;
            background-color: #28a745;
            color: white;
        }

        .btn-vote {
            background-color: #FFB200;
            color: #003366;
            padding: 0.5rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            margin-top: 0.5rem;
        }

        .btn-vote:hover {
            background-color: #e6a000;
        }

        .no-data {
            text-align: center;
            padding: 2rem;
            color: #6c757d;
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

        .activity-icon {
            display: inline-block;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            text-align: center;
            line-height: 24px;
            margin-right: 0.5rem;
            font-size: 0.75rem;
        }

        .icon-vote {
            background-color: #28a745;
            color: white;
        }

        .icon-application {
            background-color: #17a2b8;
            color: white;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>DemocraTech - Student Dashboard</h1>
        <div class="user-info">
            <span>Student: <%= userName %></span>
            <form action="logout.jsp" method="post" style="margin: 0;">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </div>

    <nav class="nav">
        <ul>
            <li><a href="student-dashboard.jsp" class="active">Dashboard</a></li>
            <li><a href="view-elections.jsp">Elections</a></li>
            <li><a href="vote-history.jsp">Vote History</a></li>
            <li><a href="election-results-student.jsp">Election Result</a></li>
            <li><a href="apply-candidate.jsp">Apply As Candidates</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="welcome-banner">
            <h2>Welcome back, <%= userName %>!</h2>
            <p>Participate in ongoing elections and make your voice heard</p>
        </div>

        <div class="stats-grid">
            <div class="stat-card primary">
                <h3>Active Elections</h3>
                <div class="number"><%= ongoingElections %></div>
                <div class="label">Elections you can vote in now</div>
            </div>

            <div class="stat-card info">
                <h3>Upcoming Elections</h3>
                <div class="number"><%= upcomingElections %></div>
                <div class="label">Starting soon</div>
            </div>

            <div class="stat-card warning">
                <h3>Votes Cast</h3>
                <div class="number"><%= votedElectionsCount %></div>
                <div class="label">Total votes participate</div>
            </div>

            <div class="stat-card success">
                <h3>Completed Elections</h3>
                <div class="number"><%= completedElectionsVoted %></div>
                <div class="label">Elections you participated in</div>
            </div>
        </div>

        <div class="elections-section">
            <div class="section-header">
                <h2>Active Elections</h2>
                <a href="view-elections.jsp" class="view-all">View All →</a>
            </div>
            <% if (activeElections.size() > 0) { %>
                <% for (Election election : activeElections) { 
                    boolean hasVotedInElection = votedElectionIds.contains(election.getElectionId());
                %>
                    <div class="election-card">
                        <div class="election-title"><%= election.getTitle() %></div>
                        <div class="election-meta">
                            <span>📅 Start: <%= dateFormat.format(election.getStartDate()) %></span>
                            <span>🗓️ End: <%= dateFormat.format(election.getEndDate()) %></span>
                            <span class="election-status">ONGOING</span>
                        </div>
                        <% if (election.getDescription() != null && !election.getDescription().isEmpty()) { %>
                            <div class="election-description"><%= election.getDescription() %></div>
                        <% } %>
                        <% if (hasVotedInElection) { %>
                            <span style="color: #28a745; font-weight: 600;">You have voted in this election</span>
                        <% } else { %>
                            <a href="voting-page.jsp?electionId=<%= election.getElectionId() %>" class="btn-vote">Vote Now</a>
                        <% } %>
                    </div>
                <% } %>
            <% } else { %>
                <div class="no-data">
                    <p>No active elections at the moment</p>
                </div>
            <% } %>
        </div>

        <div class="recent-activity">
            <h2>Recent Activity</h2>
            <% if (recentActivity.size() > 0) { %>
                <% for (Object[] activity : recentActivity) { 
                    String activityType = (String) activity[0];
                    String activityText = (String) activity[1];
                    java.sql.Timestamp activityTime = (java.sql.Timestamp) activity[2];
                    
                    String icon = activityType.equals("vote") ? "icon-vote" : "icon-application";
                    String iconSymbol = activityType.equals("vote") ? "✓" : "📝";
                    String actionText = activityType.equals("vote") ? "Voted in" : "Applied for";
                %>
                    <div class="activity-item">
                        <p>
                            <span class="activity-icon <%= icon %>"><%= iconSymbol %></span>
                            <strong><%= actionText %></strong>: <%= activityText %>
                        </p>
                        <div class="activity-time"><%= timeFormat.format(activityTime) %></div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="no-data">
                    <p>No recent activity</p>
                    <div class="activity-time">Start participating in elections!</div>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
