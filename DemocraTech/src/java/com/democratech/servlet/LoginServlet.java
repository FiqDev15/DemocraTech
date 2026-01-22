package com.democratech.servlet;

import com.democratech.dao.StudentDAO;
import com.democratech.dao.AdminDAO;
import com.democratech.model.Student;
import com.democratech.model.Admin;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    
    private StudentDAO studentDAO;
    private AdminDAO adminDAO;
    
    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
        adminDAO = new AdminDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userType = request.getParameter("userType");
        String userId = request.getParameter("userId");
        String password = request.getParameter("password");
        
        if (userId == null || password == null || userType == null ||
            userId.trim().isEmpty() || password.trim().isEmpty() || userType.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Please enter all required fields!");
            request.setAttribute("userType", userType);
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        try {
            if ("student".equalsIgnoreCase(userType)) {
                int studentId = Integer.parseInt(userId);
                Student student = studentDAO.validateLogin(studentId, password);
                
                if (student != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", student.getStudentId());
                    session.setAttribute("userName", student.getName());
                    session.setAttribute("userEmail", student.getEmail());
                    session.setAttribute("facultyId", student.getFacultyId());
                    session.setAttribute("userType", "STUDENT");
                    
                    response.sendRedirect("student-dashboard.jsp");
                } else {
                    request.setAttribute("errorMessage", "Invalid Student ID or Password!");
                    request.setAttribute("userType", "student");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
                
            } else if ("admin".equalsIgnoreCase(userType)) {
                String email = userId;
                Admin admin = adminDAO.validateLogin(email, password);
                
                if (admin != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", admin.getAdminId());
                    session.setAttribute("userName", admin.getName());
                    session.setAttribute("userEmail", admin.getEmail());
                    session.setAttribute("facultyId", admin.getFacultyId());
                    session.setAttribute("userType", "ADMIN");
                    
                    response.sendRedirect("admin-dashboard.jsp");
                } else {
                    request.setAttribute("errorMessage", "Invalid Email or Password!");
                    request.setAttribute("userType", "admin");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Invalid user type!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid Student ID format!");
            request.setAttribute("userType", "student");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
