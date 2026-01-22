<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.democratech.model.Admin, com.democratech.model.Candidate, com.democratech.model.Election" %>
<%@ page import="com.democratech.dao.CandidateDAO, com.democratech.dao.FacultyDAO, com.democratech.dao.ElectionDAO" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
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
    
    CandidateDAO candidateDAO = new CandidateDAO();
    FacultyDAO facultyDAO = new FacultyDAO();
    ElectionDAO electionDAO = new ElectionDAO();
    
    String filterElectionId = request.getParameter("filterElectionId");
    
    String message = "";
    String messageType = "";
    String action = request.getParameter("action");
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String candidateIdStr = request.getParameter("candidateId");
        
        if (candidateIdStr != null) {
            try {
                int candidateId = Integer.parseInt(candidateIdStr);
                
                if ("approve".equals(action)) {
                    if (candidateDAO.approveCandidate(candidateId)) {
                        message = "Candidate approved successfully!";
                        messageType = "success";
                    } else {
                        message = "Failed to approve candidate.";
                        messageType = "error";
                    }
                } else if ("reject".equals(action)) {
                    if (candidateDAO.rejectCandidate(candidateId)) {
                        message = "Candidate rejected successfully!";
                        messageType = "success";
                    } else {
                        message = "Failed to reject candidate.";
                        messageType = "error";
                    }
                } else if ("delete".equals(action)) {
                    if (candidateDAO.deleteCandidate(candidateId)) {
                        message = "Candidate application deleted successfully!";
                        messageType = "success";
                    } else {
                        message = "Failed to delete candidate application.";
                        messageType = "error";
                    }
                } else if ("update".equals(action)) {
                    String newStatus = request.getParameter("newStatus");
                    boolean status = "approved".equals(newStatus);
                    if (candidateDAO.updateCandidateStatus(candidateId, status)) {
                        message = "Candidate status updated to " + newStatus.toUpperCase() + " successfully!";
                        messageType = "success";
                    } else {
                        message = "Failed to update candidate status.";
                        messageType = "error";
                    }
                }
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
                messageType = "error";
            }
        }
    }
    
    List<Candidate> allCandidates = candidateDAO.getCandidatesByFaculty(facultyId);
    List<Candidate> candidates = new ArrayList<>();
    
    if (filterElectionId != null && !filterElectionId.isEmpty() && !"all".equals(filterElectionId)) {
        int electionId = Integer.parseInt(filterElectionId);
        for (Candidate candidate : allCandidates) {
            if (candidate.getElectionId() == electionId) {
                candidates.add(candidate);
            }
        }
    } else {
        candidates = allCandidates;
    }
    
    List<Election> elections = electionDAO.getElectionsByFaculty(facultyId);
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Candidates - DemocraTech</title>
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
            max-width: 1400px;
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

        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            border-left: 4px solid;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .stat-card.total {
            border-left-color: #0056b3;
        }

        .stat-card.approved {
            border-left-color: #28a745;
        }

        .stat-card.pending {
            border-left-color: #ffc107;
        }

        .stat-card.rejected {
            border-left-color: #dc3545;
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
            vertical-align: top;
        }

        tr:hover {
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
            color: #721c24;
        }
        .manifesto {
            max-width: 400px;
            max-height: 100px;
            overflow-y: auto;
            font-size: 0.9rem;
            color: #495057;
            line-height: 1.5;
            padding: 0.5rem;
            background-color: #f8f9fa;
            border-radius: 4px;
        }

        .actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
        }

        .btn-approve {
            background-color: #28a745;
            color: white;
        }

        .btn-approve:hover {
            background-color: #218838;
        }

        .btn-reject {
            background-color: #ffc107;
            color: #000;
        }

        .btn-reject:hover {
            background-color: #e0a800;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }

        .btn-delete:hover {
            background-color: #bb2d3b;
        }
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 2rem;
            border-radius: 8px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .modal-header {
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #dee2e6;
        }

        .modal-header h3 {
            color: #003366;
            margin: 0;
        }

        .modal-body {
            margin-bottom: 1.5rem;
        }

        .modal-body p {
            margin-bottom: 1rem;
            color: #495057;
        }

        .modal-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
        }

        .btn-modal {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 600;
            transition: background-color 0.3s;
        }

        .btn-modal-approve {
            background-color: #28a745;
            color: white;
        }

        .btn-modal-approve:hover {
            background-color: #218838;
        }

        .btn-modal-reject {
            background-color: #dc3545;
            color: white;
        }

        .btn-modal-reject:hover {
            background-color: #c82333;
        }

        .btn-modal-cancel {
            background-color: #6c757d;
            color: white;
        }

        .btn-modal-cancel:hover {
            background-color: #5a6268;
        }
        .no-data {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }
    </style>
    <script>
        function confirmAction(action, candidateId, studentName) {
            var actionText = action.charAt(0).toUpperCase() + action.slice(1);
            if (confirm('Are you sure you want to ' + action + ' ' + studentName + '\'s application?')) {
                document.getElementById(action + 'CandidateId').value = candidateId;
                document.getElementById(action + 'Form').submit();
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
            <li><a href="manage-candidates.jsp" class="active">Candidates</a></li>
            <li><a href="election-results.jsp">Results</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="page-header">
            <h2>Manage Candidates</h2>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="message <%= messageType %>">
                <%= message %>
            </div>
        <% } %>
        
        <div style="margin-bottom: 1.5rem; background: white; padding: 1rem; border-radius: 8px; border: 1px solid #dee2e6;">
            <form method="get" action="manage-candidates.jsp" style="display: flex; align-items: center; gap: 1rem;">
                <label for="filterElectionId" style="font-weight: 600; color: #003366;">Filter by Election:</label>
                <select name="filterElectionId" id="filterElectionId" onchange="this.form.submit()" 
                        style="padding: 0.5rem 1rem; border: 1px solid #ced4da; border-radius: 4px; font-size: 1rem; min-width: 300px;">
                    <option value="all" <%= (filterElectionId == null || "all".equals(filterElectionId)) ? "selected" : "" %>>All Elections</option>
                    <% for (Election election : elections) { %>
                        <option value="<%= election.getElectionId() %>" 
                                <%= (filterElectionId != null && filterElectionId.equals(String.valueOf(election.getElectionId()))) ? "selected" : "" %>>
                            <%= election.getElectionTitle() %> (<%= election.getStatus() %>)
                        </option>
                    <% } %>
                </select>
                <% if (filterElectionId != null && !"all".equals(filterElectionId)) { %>
                    <a href="manage-candidates.jsp" style="color: #dc3545; text-decoration: none; font-weight: 500;">Clear Filter</a>
                <% } %>
            </form>
        </div>

        <%
        int totalCandidates = candidates.size();
        int approvedCount = 0;
        int pendingCount = 0;
        int rejectedCount = 0;
        
        for (Candidate c : candidates) {
            if (c.isStatus()) {
                approvedCount++;
            } else if (c.getReviewedAt() != null) {
                rejectedCount++;
            } else {
                pendingCount++;
            }
        }
        %>

        <div class="stats">
            <div class="stat-card total">
                <h3><%= totalCandidates %></h3>
                <p>Total Applications</p>
            </div>
            <div class="stat-card approved">
                <h3><%= approvedCount %></h3>
                <p>Approved Candidates</p>
            </div>
            <div class="stat-card pending">
                <h3><%= pendingCount %></h3>
                <p>Pending Review</p>
            </div>
            <div class="stat-card rejected">
                <h3><%= rejectedCount %></h3>
                <p>Rejected</p>
            </div>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Student</th>
                        <th>Election</th>
                        <th>Position</th>
                        <th>Manifesto</th>
                        <th>Applied</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    if (candidates.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="7" class="no-data">
                                No candidate applications yet.
                            </td>
                        </tr>
                    <%
                    } else {
                        for (Candidate candidate : candidates) {
                    %>
                        <tr>
                            <td><strong><%= candidate.getStudentName() %></strong><br>
                                <small style="color: #6c757d;">ID: <%= candidate.getStudentId() %></small>
                            </td>
                            <td><%= candidate.getElectionTitle() %></td>
                            <td><%= candidate.getPositionName() %></td>
                            <td>
                                <div class="manifesto"><%= candidate.getManifesto() %></div>
                            </td>
                            <td><%= dateFormat.format(candidate.getAppliedAt()) %></td>
                            <td>
                                <%
                                    String statusText, statusClass;
                                    if (candidate.isStatus()) {
                                        statusText = "APPROVED";
                                        statusClass = "badge-approved";
                                    } else if (candidate.getReviewedAt() != null) {
                                        statusText = "REJECTED";
                                        statusClass = "badge-rejected";
                                    } else {
                                        statusText = "PENDING";
                                        statusClass = "badge-pending";
                                    }
                                %>
                                <span class="badge <%= statusClass %>">
                                    <%= statusText %>
                                </span>
                            </td>
                            <td>
                                <div class="actions">
                                    <% if (candidate.getReviewedAt() == null) { %>
                                        <button onclick="confirmAction('approve', <%= candidate.getCandidateId() %>, '<%= candidate.getStudentName() %>')" 
                                                class="btn-sm btn-approve">Approve</button>
                                        <button onclick="confirmAction('reject', <%= candidate.getCandidateId() %>, '<%= candidate.getStudentName() %>')" 
                                                class="btn-sm btn-reject">Reject</button>
                                    <% } else { %>
                                        <button onclick="openEditModal(<%= candidate.getCandidateId() %>, '<%= candidate.getStudentName() %>')" 
                                                class="btn-sm btn-approve">Edit Status</button>
                                    <% } %>
                                    <button onclick="confirmAction('delete', <%= candidate.getCandidateId() %>, '<%= candidate.getStudentName() %>')" 
                                            class="btn-sm btn-delete">Delete</button>
                                </div>
                            </td>
                        </tr>
                    <%
                        }
                    }
                    %>
                </tbody>
            </table>
        </div>

        <form id="approveForm" action="manage-candidates.jsp" method="post" style="display: none;">
            <input type="hidden" name="action" value="approve">
            <input type="hidden" id="approveCandidateId" name="candidateId">
        </form>

        <form id="rejectForm" action="manage-candidates.jsp" method="post" style="display: none;">
            <input type="hidden" name="action" value="reject">
            <input type="hidden" id="rejectCandidateId" name="candidateId">
        </form>

        <form id="deleteForm" action="manage-candidates.jsp" method="post" style="display: none;">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" id="deleteCandidateId" name="candidateId">
        </form>

        <form id="updateForm" action="manage-candidates.jsp" method="post" style="display: none;">
            <input type="hidden" name="action" value="update">
            <input type="hidden" id="updateCandidateId" name="candidateId">
            <input type="hidden" id="newStatus" name="newStatus">
        </form>
    </div>

    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Candidate Status</h3>
            </div>
            <div class="modal-body">
                <p>Change status for: <strong id="editCandidateName"></strong></p>
                <p>Select new status:</p>
            </div>
            <div class="modal-actions">
                <button class="btn-modal btn-modal-approve" onclick="updateStatus('approved')">Approve</button>
                <button class="btn-modal btn-modal-reject" onclick="updateStatus('rejected')">Reject</button>
                <button class="btn-modal btn-modal-cancel" onclick="closeEditModal()">Cancel</button>
            </div>
        </div>
    </div>

    <script>
        let currentEditCandidateId = null;

        function openEditModal(candidateId, candidateName) {
            currentEditCandidateId = candidateId;
            document.getElementById('editCandidateName').textContent = candidateName;
            document.getElementById('editModal').style.display = 'block';
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
            currentEditCandidateId = null;
        }

        function updateStatus(newStatus) {
            if (currentEditCandidateId) {
                document.getElementById('updateCandidateId').value = currentEditCandidateId;
                document.getElementById('newStatus').value = newStatus;
                document.getElementById('updateForm').submit();
            }
        }

        window.onclick = function(event) {
            const modal = document.getElementById('editModal');
            if (event.target == modal) {
                closeEditModal();
            }
        }
    </script>
</body>
</html>
