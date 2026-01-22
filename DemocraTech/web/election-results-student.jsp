<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.democratech.model.Election, com.democratech.model.Position, com.democratech.model.Candidate" %>
<%@ page import="com.democratech.dao.ElectionDAO, com.democratech.dao.CandidateDAO, com.democratech.dao.VoteDAO" %>
<%@ page import="java.util.List, java.util.Map, java.util.HashMap" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String userType = (String) session.getAttribute("userType");
    
    if (!"student".equals(userType)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String studentName = (String) session.getAttribute("userName");
    Integer facultyId = (Integer) session.getAttribute("facultyId");
    
    if (studentName == null || facultyId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    ElectionDAO electionDAO = new ElectionDAO();
    CandidateDAO candidateDAO = new CandidateDAO();
    VoteDAO voteDAO = new VoteDAO();
    
    String electionIdStr = request.getParameter("electionId");
    Election selectedElection = null;
    
    if (electionIdStr != null) {
        int electionId = Integer.parseInt(electionIdStr);
        selectedElection = electionDAO.getElectionById(electionId);
    }
    
    List<Election> allElections = electionDAO.getElectionsByFaculty(facultyId);
    List<Election> completedElections = new java.util.ArrayList<Election>();
    
    for (Election election : allElections) {
        if ("COMPLETED".equals(election.getStatus())) {
            completedElections.add(election);
        }
    }
    
    SimpleDateFormat displayFormat = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Election Results - DemocraTech</title>
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

        .election-selector {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            border: 1px solid #dee2e6;
        }

        .election-selector label {
            display: block;
            color: #003366;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .election-selector select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 1rem;
        }

        .election-header {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            border-left: 4px solid #003366;
            margin-bottom: 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .election-header h3 {
            color: #003366;
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }

        .election-meta {
            display: flex;
            gap: 2rem;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #dee2e6;
            font-size: 0.9rem;
        }

        .election-meta span {
            color: #495057;
        }

        .election-meta strong {
            color: #003366;
        }

        .position-results {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            border: 1px solid #dee2e6;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .position-results h4 {
            color: #003366;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #FFB200;
        }

        .candidate-result {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            margin-bottom: 0.75rem;
            border-radius: 8px;
            background-color: #f8f9fa;
            border-left: 4px solid #dee2e6;
        }

        .candidate-result.winner {
            background-color: #d1e7dd;
            border-left-color: #28a745;
        }

        .candidate-rank {
            font-size: 1.5rem;
            font-weight: bold;
            color: #6c757d;
            min-width: 40px;
            text-align: center;
        }

        .candidate-result.winner .candidate-rank {
            color: #28a745;
        }

        .winner-badge {
            background-color: #ffc107;
            color: #000;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.875rem;
            font-weight: 600;
            margin-left: auto;
        }

        .candidate-details {
            flex: 1;
        }

        .candidate-name {
            font-weight: 600;
            color: #003366;
            margin-bottom: 0.25rem;
        }

        .vote-stats {
            display: flex;
            gap: 1.5rem;
            font-size: 0.9rem;
            color: #6c757d;
        }

        .vote-bar {
            height: 8px;
            background-color: #dee2e6;
            border-radius: 4px;
            margin-top: 0.5rem;
            overflow: hidden;
        }

        .vote-bar-fill {
            height: 100%;
            background-color: #003366;
            border-radius: 4px;
            transition: width 0.3s;
        }

        .candidate-result.winner .vote-bar-fill {
            background-color: #28a745;
        }

        .no-results {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }

        .no-results h3 {
            margin-bottom: 1rem;
        }

        .no-candidates {
            text-align: center;
            padding: 2rem;
            color: #6c757d;
            background-color: #f8f9fa;
            border-radius: 4px;
        }
    </style>
    <script>
        function loadElection() {
            var select = document.getElementById('electionSelect');
            if (select.value) {
                window.location.href = 'election-results-student.jsp?electionId=' + select.value;
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
            <li><a href="election-results-student.jsp" class="active">Election Result</a></li>
            <li><a href="apply-candidate.jsp">Apply As Candidates</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="page-header">
            <h2>Election Results</h2>
            <p>View results of completed elections</p>
        </div>

        <% if (completedElections.isEmpty()) { %>
            <div class="election-header">
                <div class="no-results">
                    <h3>No Completed Elections</h3>
                    <p>There are no completed elections with results yet.</p>
                </div>
            </div>
        <% } else { %>
            <div class="election-selector">
                <label for="electionSelect">Select Election:</label>
                <select id="electionSelect" onchange="loadElection()">
                    <option value="">-- Choose an election --</option>
                    <% for (Election election : completedElections) { %>
                        <option value="<%= election.getElectionId() %>" 
                                <%= selectedElection != null && election.getElectionId() == selectedElection.getElectionId() ? "selected" : "" %>>
                            <%= election.getTitle() %> (<%= displayFormat.format(election.getEndDate()) %>)
                        </option>
                    <% } %>
                </select>
            </div>

            <% if (selectedElection != null) { 
                int totalVoters = voteDAO.countVotesByElection(selectedElection.getElectionId());
                List<Position> positions = electionDAO.getPositionsByElection(selectedElection.getElectionId());
            %>
                <div class="election-header">
                    <h3><%= selectedElection.getTitle() %></h3>
                    <% if (selectedElection.getDescription() != null && !selectedElection.getDescription().isEmpty()) { %>
                        <p><%= selectedElection.getDescription() %></p>
                    <% } %>
                    <div class="election-meta">
                        <span><strong>Start Date:</strong> <%= displayFormat.format(selectedElection.getStartDate()) %></span>
                        <span><strong>End Date:</strong> <%= displayFormat.format(selectedElection.getEndDate()) %></span>
                        <span><strong>Total Voters:</strong> <%= selectedElection.getTotalVotes() %></span>
                    </div>
                </div>

                <% for (Position position : positions) { 
                    List<Candidate> candidates = candidateDAO.getCandidatesByPositionSortedByVotes(position.getPositionId());
                    
                    int maxVotes = 0;
                    if (!candidates.isEmpty()) {
                        maxVotes = candidates.get(0).getVoteCount();
                    }
                %>
                    <div class="position-results">
                        <h4><%= position.getPositionName() %></h4>
                        
                        <% if (candidates.isEmpty()) { %>
                            <div class="no-candidates">
                                No candidates participated in this position.
                            </div>
                        <% } else { 
                            int rank = 1;
                            for (Candidate candidate : candidates) { 
                                boolean isWinner = (rank == 1 && candidate.getVoteCount() > 0);
                                double percentage = totalVoters > 0 ? (candidate.getVoteCount() * 100.0 / totalVoters) : 0;
                                double barPercentage = maxVotes > 0 ? (candidate.getVoteCount() * 100.0 / maxVotes) : 0;
                        %>
                                <div class="candidate-result <%= isWinner ? "winner" : "" %>">
                                    <div class="candidate-rank"><%= rank %></div>
                                    <div class="candidate-details">
                                        <div class="candidate-name"><%= candidate.getStudentName() %> (ID: <%= candidate.getStudentId() %>)</div>
                                        <div class="vote-stats">
                                            <span><strong><%= candidate.getVoteCount() %></strong> votes</span>
                                            <span><%= String.format("%.1f", percentage) %>% of total voters</span>
                                        </div>
                                        <div class="vote-bar">
                                            <div class="vote-bar-fill" style="width: <%= barPercentage %>%"></div>
                                        </div>
                                    </div>
                                    <% if (isWinner) { %>
                                        <span class="winner-badge">WINNER</span>
                                    <% } %>
                                </div>
                        <%
                                rank++;
                            }
                        } %>
                    </div>
                <% } %>
            <% } else if (!completedElections.isEmpty()) { %>
                <div class="election-header">
                    <div class="no-results">
                        <p>Please select an election from the dropdown above to view results.</p>
                    </div>
                </div>
            <% } %>
        <% } %>
    </div>
</body>
</html>
