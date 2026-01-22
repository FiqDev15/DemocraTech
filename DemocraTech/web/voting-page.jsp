<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.democratech.model.Election, com.democratech.model.Position, com.democratech.model.Candidate, com.democratech.model.Vote" %>
<%@ page import="com.democratech.dao.ElectionDAO, com.democratech.dao.CandidateDAO, com.democratech.dao.VoteDAO" %>
<%@ page import="java.util.List, java.util.Map, java.util.HashMap" %>
<%@ page import="java.sql.Timestamp" %>
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
    
    ElectionDAO electionDAO = new ElectionDAO();
    CandidateDAO candidateDAO = new CandidateDAO();
    VoteDAO voteDAO = new VoteDAO();
    
    String message = "";
    String messageType = "";
    
    String electionIdStr = request.getParameter("electionId");
    
    if (electionIdStr == null) {
        response.sendRedirect("view-elections.jsp");
        return;
    }
    
    int electionId = Integer.parseInt(electionIdStr);
    Election election = electionDAO.getElectionById(electionId);
    
    if (election == null) {
        response.sendRedirect("view-elections.jsp");
        return;
    }
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if (voteDAO.hasVoted(studentId, electionId)) {
            message = "You have already voted in this election!";
            messageType = "error";
        } else {
            List<Position> positions = electionDAO.getPositionsByElection(electionId);
            List<Vote> votes = new java.util.ArrayList<>();
            boolean allSelected = true;
            
            for (Position position : positions) {
                String candidateIdStr = request.getParameter("position_" + position.getPositionId());
                
                if (candidateIdStr == null || candidateIdStr.isEmpty()) {
                    allSelected = false;
                    break;
                }
                
                int candidateId = Integer.parseInt(candidateIdStr);
                Vote vote = new Vote(studentId, electionId, candidateId);
                votes.add(vote);
            }
            
            if (!allSelected) {
                message = "Please select a candidate for all positions!";
                messageType = "error";
            } else {
                try {
                    if (voteDAO.castMultipleVotes(votes)) {
                        message = "Your vote has been submitted successfully!";
                        messageType = "success";
                        
                        response.setHeader("Refresh", "2; URL=view-elections.jsp");
                    } else {
                        message = "Failed to submit your vote. Please try again.";
                        messageType = "error";
                    }
                } catch (Exception e) {
                    message = "Error: " + e.getMessage();
                    messageType = "error";
                }
            }
        }
    }
    
    boolean hasVoted = voteDAO.hasVoted(studentId, electionId);
    
    List<Position> positions = electionDAO.getPositionsByElection(electionId);
    Map<Integer, List<Candidate>> candidatesByPosition = new HashMap<>();
    
    for (Position position : positions) {
        List<Candidate> candidates = candidateDAO.getCandidatesByPosition(position.getPositionId());
        candidatesByPosition.put(position.getPositionId(), candidates);
    }
    
    SimpleDateFormat displayFormat = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vote - <%= election.getTitle() %> - DemocraTech</title>
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
            max-width: 900px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .election-header {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            border-left: 4px solid #003366;
            margin-bottom: 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .election-header h2 {
            color: #003366;
            font-size: 1.75rem;
            margin-bottom: 0.5rem;
        }

        .election-header p {
            color: #6c757d;
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

        .warning-box {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 1rem;
            margin-bottom: 2rem;
            border-radius: 4px;
        }

        .warning-box h4 {
            color: #856404;
            margin-bottom: 0.5rem;
        }

        .warning-box ul {
            margin-left: 1.5rem;
            color: #856404;
        }

        .position-section {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            border: 1px solid #dee2e6;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .position-section h3 {
            color: #003366;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #FFB200;
        }

        .candidate-option {
            border: 2px solid #dee2e6;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: flex-start;
            gap: 1rem;
        }

        .candidate-option:hover {
            border-color: #FFB200;
            background-color: #fff8e6;
        }

        .candidate-option input[type="radio"] {
            margin-top: 0.25rem;
            width: 20px;
            height: 20px;
            cursor: pointer;
        }

        .candidate-option.selected {
            border-color: #003366;
            background-color: #e7f3ff;
        }

        .candidate-info {
            flex: 1;
        }

        .candidate-info h4 {
            color: #003366;
            margin-bottom: 0.5rem;
        }

        .candidate-info .manifesto {
            color: #495057;
            font-size: 0.95rem;
            line-height: 1.5;
            margin-top: 0.5rem;
        }

        .vote-actions {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            bottom: 1rem;
            box-shadow: 0 -2px 8px rgba(0,0,0,0.1);
        }

        .btn-primary {
            background-color: #003366;
            color: white;
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            font-size: 1rem;
        }

        .btn-primary:hover {
            background-color: #002244;
        }

        .btn-primary:disabled {
            background-color: #6c757d;
            cursor: not-allowed;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
        }

        .already-voted {
            text-align: center;
            padding: 3rem;
            background: white;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }

        .already-voted h3 {
            color: #28a745;
            margin-bottom: 1rem;
        }

        .already-voted p {
            color: #6c757d;
            margin-bottom: 1.5rem;
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
        function highlightSelection(radio) {
            var positionDiv = radio.closest('.position-section');
            var options = positionDiv.querySelectorAll('.candidate-option');
            options.forEach(function(option) {
                option.classList.remove('selected');
            });
            
            radio.closest('.candidate-option').classList.add('selected');
        }
        
        function confirmVote() {
            return confirm('Are you sure you want to submit your vote? This action cannot be undone.');
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
            <li><a href="apply-candidate.jsp">Apply As Candidates</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="election-header">
            <h2><%= election.getTitle() %></h2>
            <% if (election.getDescription() != null && !election.getDescription().isEmpty()) { %>
                <p><%= election.getDescription() %></p>
            <% } %>
            <div class="election-meta">
                <span><strong>Start:</strong> <%= displayFormat.format(election.getStartDate()) %></span>
                <span><strong>End:</strong> <%= displayFormat.format(election.getEndDate()) %></span>
                <span><strong>Status:</strong> <%= election.getStatus() %></span>
            </div>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="message <%= messageType %>">
                <%= message %>
            </div>
        <% } %>

        <% if (hasVoted) { %>
            <div class="already-voted">
                <h3>You have already voted!</h3>
                <p>Thank you for participating in this election.</p>
                <p>You can view your vote history or check other elections.</p>
                <a href="view-elections.jsp" class="btn-primary">Back to Elections</a>
            </div>
        <% } else if (!"ONGOING".equals(election.getStatus())) { %>
            <div class="already-voted">
                <h3>Election Not Available</h3>
                <p>This election is currently <%= election.getStatus() %>.</p>
                <a href="view-elections.jsp" class="btn-primary">Back to Elections</a>
            </div>
        <% } else { %>
            <div class="warning-box">
                <h4>⚠️ Important Voting Instructions</h4>
                <ul>
                    <li>You can select ONE candidate only</li>
                    <li>Once submitted, your vote CANNOT be changed</li>
                    <li>Keep your vote confidential</li>
                </ul>
            </div>

            <form action="voting-page.jsp?electionId=<%= electionId %>" method="post" onsubmit="return confirmVote()">
                <% for (Position position : positions) { 
                    List<Candidate> candidates = candidatesByPosition.get(position.getPositionId());
                %>
                    <div class="position-section">
                        <h3><%= position.getPositionName() %></h3>
                        
                        <% if (candidates == null || candidates.isEmpty()) { %>
                            <div class="no-candidates">
                                No approved candidates for this position yet.
                            </div>
                        <% } else { %>
                            <% for (Candidate candidate : candidates) { %>
                                <label class="candidate-option">
                                    <input type="radio" 
                                           name="position_<%= position.getPositionId() %>" 
                                           value="<%= candidate.getCandidateId() %>"
                                           onclick="highlightSelection(this)"
                                           required>
                                    <div class="candidate-info">
                                        <h4><%= candidate.getStudentName() %></h4>
                                        <div class="manifesto"><%= candidate.getManifesto() %></div>
                                    </div>
                                </label>
                            <% } %>
                        <% } %>
                    </div>
                <% } %>

                <div class="vote-actions">
                    <a href="view-elections.jsp" class="btn-secondary">Cancel</a>
                    <button type="submit" class="btn-primary">Submit Vote</button>
                </div>
            </form>
        <% } %>
    </div>
</body>
</html>
