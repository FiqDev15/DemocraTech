package com.democratech.dao;

import com.democratech.model.Admin;
import com.democratech.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDAO {

    public Admin validateLogin(String email, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "SELECT admin_id, name, email, faculty_id FROM ADMIN WHERE email = ? AND password = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setName(rs.getString("name"));
                admin.setEmail(rs.getString("email"));
                admin.setFacultyId(rs.getInt("faculty_id"));
                return admin;
            }
            
            return null;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            DBUtil.closeResources(conn, pstmt, rs);
        }
    }

    public Admin loginAdmin(String email, String password) {
        return validateLogin(email, password);
    }

    public Admin getAdminById(int adminId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "SELECT admin_id, name, email, faculty_id FROM ADMIN WHERE admin_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, adminId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setName(rs.getString("name"));
                admin.setEmail(rs.getString("email"));
                admin.setFacultyId(rs.getInt("faculty_id"));
                return admin;
            }
            
            return null;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            DBUtil.closeResources(conn, pstmt, rs);
        }
    }

    public int getStudentCountByFaculty(int facultyId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "SELECT COUNT(*) as count FROM STUDENT WHERE faculty_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, facultyId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
            return 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            DBUtil.closeResources(conn, pstmt, rs);
        }
    }

    public int getElectionCountByFaculty(int facultyId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "SELECT COUNT(*) as count FROM ELECTION WHERE faculty_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, facultyId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
            return 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            DBUtil.closeResources(conn, pstmt, rs);
        }
    }

    public int getPendingCandidatesCountByFaculty(int facultyId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "SELECT COUNT(*) as count FROM CANDIDATE c " +
                        "INNER JOIN POSITION p ON c.position_id = p.position_id " +
                        "INNER JOIN ELECTION e ON p.election_id = e.election_id " +
                        "WHERE e.faculty_id = ? AND c.status = false";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, facultyId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
            return 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            DBUtil.closeResources(conn, pstmt, rs);
        }
    }

    public int getTotalVotesCountByFaculty(int facultyId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "SELECT COUNT(*) as count FROM VOTE v " +
                        "INNER JOIN ELECTION e ON v.election_id = e.election_id " +
                        "WHERE e.faculty_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, facultyId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
            return 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            DBUtil.closeResources(conn, pstmt, rs);
        }
    }
}
