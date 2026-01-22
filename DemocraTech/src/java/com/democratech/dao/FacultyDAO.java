package com.democratech.dao;

import com.democratech.model.Faculty;
import com.democratech.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class FacultyDAO {
    
    public List<Faculty> getAllFaculties() {
        List<Faculty> faculties = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            stmt = conn.createStatement();
            
            String sql = "SELECT faculty_id, faculty_name, faculty_code FROM FACULTY ORDER BY faculty_name";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Faculty faculty = new Faculty();
                faculty.setFacultyId(rs.getInt("faculty_id"));
                faculty.setFacultyName(rs.getString("faculty_name"));
                faculty.setFacultyCode(rs.getString("faculty_code"));
                faculties.add(faculty);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeResources(conn, null, rs);
            try {
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return faculties;
    }
    
    public Faculty getFacultyById(int facultyId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "SELECT faculty_id, faculty_name, faculty_code FROM FACULTY WHERE faculty_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, facultyId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Faculty faculty = new Faculty();
                faculty.setFacultyId(rs.getInt("faculty_id"));
                faculty.setFacultyName(rs.getString("faculty_name"));
                faculty.setFacultyCode(rs.getString("faculty_code"));
                return faculty;
            }
            
            return null;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            DBUtil.closeResources(conn, pstmt, rs);
        }
    }
}
