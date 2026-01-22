<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.democratech.model.Admin, com.democratech.model.Election, com.democratech.model.Position, com.democratech.model.Candidate" %>
<%@ page import="com.democratech.dao.ElectionDAO, com.democratech.dao.CandidateDAO, com.democratech.dao.VoteDAO, com.democratech.dao.FacultyDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String userType = (String) session.getAttribute("userType");
    
    if (!"admin".equals(userType)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String adminName = (String) session.getAttribute("userName");
    Integer facultyId = (Integer) session.getAttribute("facultyId");
    
    if (adminName == null || facultyId == null) {
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
    
    SimpleDateFormat displayFormat = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Election Results - DemocraTech Admin</title>
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
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #dee2e6;
        }

        .meta-item {
            padding: 1rem;
            background-color: #f8f9fa;
            border-radius: 4px;
        }

        .meta-item strong {
            display: block;
            color: #003366;
            font-size: 1.5rem;
            margin-bottom: 0.25rem;
        }

        .meta-item span {
            color: #6c757d;
            font-size: 0.9rem;
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

        .no-candidates {
            text-align: center;
            padding: 2rem;
            color: #6c757d;
            background-color: #f8f9fa;
            border-radius: 4px;
        }

        .badge {
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.875rem;
            font-weight: 600;
            text-transform: capitalize;
        }

        .badge-ongoing {
            background-color: #d1e7dd;
            color: #0a3622;
        }

        .badge-upcoming {
            background-color: #cfe2ff;
            color: #052c65;
        }

        .badge-completed {
            background-color: #e2e3e5;
            color: #41464b;
        }

        .badge-cancelled {
            background-color: #f8d7da;
            color: #58151c;
        }
    </style>
    <script>
        function loadElection() {
            var select = document.getElementById('electionSelect');
            if (select.value) {
                window.location.href = 'election-results.jsp?electionId=' + select.value;
            }
        }
    </script>
</head>
<body>
    <div class="header">
        <h1>DemocraTech - Admin Panel</h1>
        <div class="user-info">
            <span>Admin: <%= adminName %></span>
            <form action="logout.jsp" method="post" style="margin: 0;">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </div>

    <nav class="nav">
        <ul>
            <li><a href="admin-dashboard.jsp">Dashboard</a></li>
            <li><a href="manage-elections.jsp">Elections</a></li>
            <li><a href="manage-candidates.jsp">Candidates</a></li>
            <li><a href="election-results.jsp" class="active">Results</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="page-header">
            <h2>Election Results</h2>
        </div>

        <% if (allElections.isEmpty()) { %>
            <div class="election-header">
                <div class="no-results">
                    <h3>No Elections</h3>
                    <p>There are no elections yet.</p>
                </div>
            </div>
        <% } else { %>
            <div class="election-selector">
                <label for="electionSelect">Select Election:</label>
                <select id="electionSelect" onchange="loadElection()">
                    <option value="">-- Choose an election --</option>
                    <% for (Election election : allElections) { %>
                        <option value="<%= election.getElectionId() %>" 
                                <%= selectedElection != null && election.getElectionId() == selectedElection.getElectionId() ? "selected" : "" %>>
                            <%= election.getTitle() %> - <%= election.getStatus() %> (<%= displayFormat.format(election.getEndDate()) %>)
                        </option>
                    <% } %>
                </select>
            </div>

            <% if (selectedElection != null) { 
                int totalVoters = selectedElection.getTotalVotes();
                int totalCandidates = candidateDAO.countCandidatesByElection(selectedElection.getElectionId());
                List<Position> positions = electionDAO.getPositionsByElection(selectedElection.getElectionId());
            %>
                <div class="election-header">
                    <h3><%= selectedElection.getTitle() %> 
                        <span class="badge badge-<%= selectedElection.getStatus().toLowerCase() %>">
                            <%= selectedElection.getStatus() %>
                        </span>
                    </h3>
                    <% if (selectedElection.getDescription() != null && !selectedElection.getDescription().isEmpty()) { %>
                        <p style="color: #6c757d; margin-top: 0.5rem;"><%= selectedElection.getDescription() %></p>
                    <% } %>
                    <div class="election-meta">
                        <div class="meta-item">
                            <strong><%= totalVoters %></strong>
                            <span>Total Voters</span>
                        </div>
                        <div class="meta-item">
                            <strong><%= totalCandidates %></strong>
                            <span>Total Candidates</span>
                        </div>
                        <div class="meta-item">
                            <strong><%= positions.size() %></strong>
                            <span>Positions</span>
                        </div>
                        <div class="meta-item">
                            <strong><%= displayFormat.format(selectedElection.getStartDate()) %></strong>
                            <span>Start Date</span>
                        </div>
                        <div class="meta-item">
                            <strong><%= displayFormat.format(selectedElection.getEndDate()) %></strong>
                            <span>End Date</span>
                        </div>
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
            <% } else if (!allElections.isEmpty()) { %>
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
