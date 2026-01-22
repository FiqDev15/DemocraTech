<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.democratech.model.Admin, com.democratech.model.Election, com.democratech.model.Faculty" %>
<%@ page import="com.democratech.dao.ElectionDAO, com.democratech.dao.FacultyDAO, com.democratech.dao.ResultDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Date" %>
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
    FacultyDAO facultyDAO = new FacultyDAO();
    
    String message = "";
    String messageType = "";
    String action = request.getParameter("action");
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if ("create".equals(action)) {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String position = request.getParameter("position");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String statusStr = request.getParameter("status");
            
            if (title != null && !title.trim().isEmpty() && 
                startDateStr != null && endDateStr != null) {
                
                try {
                    Date startDate = Date.valueOf(startDateStr);
                    Date endDate = Date.valueOf(endDateStr);
                    String status = statusStr != null ? statusStr : "UPCOMING";
                    
                    Election election = new Election(facultyId, title, description, position, 
                                                    startDate, endDate, status);
                    
                    if (electionDAO.createElection(election)) {
                        message = "Election created successfully!";
                        messageType = "success";
                    } else {
                        message = "Failed to create election.";
                        messageType = "error";
                    }
                } catch (java.sql.SQLException sqlEx) {
                    message = "Database Error: " + sqlEx.getMessage();
                    messageType = "error";
                } catch (Exception e) {
                    message = "Error: " + e.getMessage();
                    messageType = "error";
                }
            } else {
                message = "Please fill all required fields.";
                messageType = "error";
            }
            
        } else if ("update".equals(action)) {
            String electionIdStr = request.getParameter("electionId");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String position = request.getParameter("position");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String statusStr = request.getParameter("status");
            
            if (electionIdStr != null && title != null && !title.trim().isEmpty()) {
                try {
                    int electionId = Integer.parseInt(electionIdStr);
                    Date startDate = Date.valueOf(startDateStr);
                    Date endDate = Date.valueOf(endDateStr);
                    String status = statusStr != null ? statusStr : "UPCOMING";
                    
                    Election election = new Election(electionId, facultyId, title, description, 
                                                    position, startDate, endDate, status);
                    
                    if (electionDAO.updateElection(election)) {
                        if ("COMPLETED".equals(status)) {
                            ResultDAO resultDAO = new ResultDAO();
                            resultDAO.generateElectionResults(electionId);
                        }
                        message = "Election updated successfully!";
                        messageType = "success";
                    } else {
                        message = "Failed to update election.";
                        messageType = "error";
                    }
                } catch (java.sql.SQLException sqlEx) {
                    message = "Database Error: " + sqlEx.getMessage();
                    messageType = "error";
                } catch (Exception e) {
                    message = "Error: " + e.getMessage();
                    messageType = "error";
                }
            }
            
        } else if ("delete".equals(action)) {
            String electionIdStr = request.getParameter("electionId");
            
            if (electionIdStr != null) {
                try {
                    int electionId = Integer.parseInt(electionIdStr);
                    
                    if (electionDAO.deleteElection(electionId)) {
                        message = "Election deleted successfully!";
                        messageType = "success";
                    } else {
                        message = "Failed to delete election.";
                        messageType = "error";
                    }
                } catch (java.sql.SQLException sqlEx) {
                    message = "Database Error: " + sqlEx.getMessage();
                    messageType = "error";
                } catch (Exception e) {
                    message = "Error: " + e.getMessage();
                    messageType = "error";
                }
            }
        }
    }
    
    List<Election> elections = electionDAO.getElectionsByFaculty(facultyId);
    Faculty faculty = facultyDAO.getFacultyById(facultyId);
    
    String editIdStr = request.getParameter("editId");
    Election editElection = null;
    if (editIdStr != null) {
        try {
            int editId = Integer.parseInt(editIdStr);
            editElection = electionDAO.getElectionById(editId);
        } catch (Exception e) {
        }
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat displayFormat = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Elections - DemocraTech</title>
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-header h2 {
            color: #003366;
            font-size: 1.75rem;
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

        .modal {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            margin-bottom: 2rem;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .modal h3 {
            color: #003366;
            margin-bottom: 1.5rem;
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

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 1rem;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
            padding: 0.75rem 1.5rem;
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

        .actions {
            display: flex;
            gap: 0.5rem;
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

        .btn-edit {
            background-color: #FFB200;
            color: #003366;
        }

        .btn-edit:hover {
            background-color: #e6a000;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }

        .btn-delete:hover {
            background-color: #bb2d3b;
        }

        .show-form-btn {
            margin-bottom: 1rem;
        }

        .hidden {
            display: none;
        }
    </style>
    <script>
        function toggleForm() {
            var form = document.getElementById('electionForm');
            var btn = document.getElementById('toggleBtn');
            if (form.classList.contains('hidden')) {
                form.classList.remove('hidden');
                btn.textContent = '− Hide Form';
            } else {
                form.classList.add('hidden');
                btn.textContent = '+ Create New Election';
            }
        }

        function confirmDelete(electionId, title) {
            if (confirm('Are you sure you want to delete "' + title + '"? This action cannot be undone.')) {
                document.getElementById('deleteElectionId').value = electionId;
                document.getElementById('deleteForm').submit();
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
            <li><a href="manage-elections.jsp" class="active">Elections</a></li>
            <li><a href="manage-candidates.jsp">Candidates</a></li>
            <li><a href="election-results.jsp">Results</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="page-header">
            <h2>Manage Elections</h2>
            <button id="toggleBtn" class="btn-primary" onclick="toggleForm()">
                <%= editElection != null ? "− Edit Election" : "+ Create New Election" %>
            </button>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="message <%= messageType %>">
                <%= message %>
            </div>
        <% } %>

        <div id="electionForm" class="modal <%= editElection == null ? "hidden" : "" %>">
            <h3><%= editElection != null ? "Edit Election" : "Create New Election" %></h3>
            <form action="manage-elections.jsp" method="post">
                <input type="hidden" name="action" value="<%= editElection != null ? "update" : "create" %>">
                <% if (editElection != null) { %>
                    <input type="hidden" name="electionId" value="<%= editElection.getElectionId() %>">
                <% } %>
                
                <div class="form-group">
                    <label for="title">Election Title *</label>
                    <input type="text" id="title" name="title" 
                           placeholder="e.g., MPP Election 2026" 
                           value="<%= editElection != null ? editElection.getTitle() : "" %>" 
                           required>
                </div>

                <div class="form-group">
                    <label for="position">Position *</label>
                    <input type="text" id="position" name="position" 
                           placeholder="e.g., President, Vice President" 
                           value="<%= editElection != null && editElection.getPosition() != null ? editElection.getPosition() : "" %>" 
                           required>
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" 
                              placeholder="Enter election details..."><%= editElection != null && editElection.getDescription() != null ? editElection.getDescription() : "" %></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="startDate">Start Date *</label>
                        <input type="date" id="startDate" name="startDate" 
                               value="<%= editElection != null ? dateFormat.format(editElection.getStartDate()) : "" %>" 
                               required>
                    </div>

                    <div class="form-group">
                        <label for="endDate">End Date *</label>
                        <input type="date" id="endDate" name="endDate" 
                               value="<%= editElection != null ? dateFormat.format(editElection.getEndDate()) : "" %>" 
                               required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="status">Status *</label>
                    <select id="status" name="status" required>
                        <option value="UPCOMING" <%= editElection != null && "UPCOMING".equals(editElection.getStatus()) ? "selected" : "" %>>Upcoming</option>
                        <option value="ONGOING" <%= editElection != null && "ONGOING".equals(editElection.getStatus()) ? "selected" : "" %>>Ongoing (Active)</option>
                        <option value="COMPLETED" <%= editElection != null && "COMPLETED".equals(editElection.getStatus()) ? "selected" : "" %>>Completed</option>
                        <option value="CANCELLED" <%= editElection != null && "CANCELLED".equals(editElection.getStatus()) ? "selected" : "" %>>Cancelled</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-primary">
                        <%= editElection != null ? "Update Election" : "Create Election" %>
                    </button>
                    <a href="manage-elections.jsp" class="btn-secondary">Cancel</a>
                </div>
            </form>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Position</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    if (elections.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: #6c757d; padding: 2rem;">
                                No elections found. Create your first election to get started!
                            </td>
                        </tr>
                    <%
                    } else {
                        for (Election election : elections) {
                    %>
                        <tr>
                            <td><%= election.getElectionId() %></td>
                            <td><strong><%= election.getTitle() %></strong></td>
                            <td><%= election.getPosition() != null ? election.getPosition() : "-" %></td>
                            <td><%= displayFormat.format(election.getStartDate()) %></td>
                            <td><%= displayFormat.format(election.getEndDate()) %></td>
                            <td>
                                <span class="badge badge-<%= election.getStatus().toLowerCase() %>">
                                    <%= election.getStatus() %>
                                </span>
                            </td>
                            <td>
                                <div class="actions">
                                    <a href="manage-elections.jsp?editId=<%= election.getElectionId() %>" class="btn-sm btn-edit">Edit</a>
                                    <button onclick="confirmDelete(<%= election.getElectionId() %>, '<%= election.getTitle() %>')" 
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

        <form id="deleteForm" action="manage-elections.jsp" method="post" style="display: none;">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" id="deleteElectionId" name="electionId">
        </form>
    </div>
</body>
</html>
