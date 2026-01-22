package com.democratech.servlet;

import com.democratech.dao.StudentDAO;
import com.democratech.dao.FacultyDAO;
import com.democratech.model.Student;
import com.democratech.model.Faculty;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    private StudentDAO studentDAO;
    private FacultyDAO facultyDAO;
    
    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
        facultyDAO = new FacultyDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Faculty> faculties = facultyDAO.getAllFaculties();
        request.setAttribute("faculties", faculties);
        
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String studentNumber = request.getParameter("studentNumber");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String facultyIdStr = request.getParameter("faculty");
        
        List<Faculty> faculties = facultyDAO.getAllFaculties();
        request.setAttribute("faculties", faculties);
        
        if (studentNumber == null || studentNumber.trim().isEmpty() ||
            firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            facultyIdStr == null || facultyIdStr.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All fields are required");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (password.length() < 8) {
            request.setAttribute("errorMessage", "Password must be at least 8 characters long");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        try {
            int facultyId = Integer.parseInt(facultyIdStr);
            int studentId = Integer.parseInt(studentNumber);
            
            if (studentDAO.studentIdExists(studentId)) {
                request.setAttribute("errorMessage", "Student ID already registered");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            if (studentDAO.emailExists(email)) {
                request.setAttribute("errorMessage", "Email already registered");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            String fullName = firstName + " " + lastName;
            Student student = new Student(studentId, fullName, email, password, facultyId);
            
            boolean success = studentDAO.registerStudent(student);
            
            if (success) {
                request.setAttribute("successMessage", "Registration successful! You can now login.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid faculty selection");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
