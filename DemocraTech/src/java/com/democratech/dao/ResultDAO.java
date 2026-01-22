package com.democratech.dao;

import com.democratech.model.Result;
import com.democratech.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ResultDAO {
    
    public boolean generateElectionResults(int electionId) {
        Connection conn = null;
        PreparedStatement deleteStmt = null;
        PreparedStatement insertStmt = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            String deleteSql = "DELETE FROM RESULT WHERE election_id = ?";
            deleteStmt = conn.prepareStatement(deleteSql);
            deleteStmt.setInt(1, electionId);
            deleteStmt.executeUpdate();
            
            String insertSql = 
                "INSERT INTO RESULT (election_id, candidate_id, total_votes, is_winner) " +
                "SELECT ?, c.candidate_id, c.vote_count, " +
                "CASE WHEN c.vote_count = (SELECT MAX(c2.vote_count) FROM CANDIDATE c2 " +
                "                          WHERE c2.position_id = c.position_id AND c2.vote_count > 0) " +
                "THEN true ELSE false END " +
                "FROM CANDIDATE c " +
                "JOIN POSITION p ON c.position_id = p.position_id " +
                "WHERE p.election_id = ? AND c.status = true";
            
            insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setInt(1, electionId);
            insertStmt.setInt(2, electionId);
            int rowsInserted = insertStmt.executeUpdate();
            
            conn.commit();
            System.out.println("Generated results for election " + electionId + ": " + rowsInserted + " records inserted");
            return true;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (deleteStmt != null) deleteStmt.close();
                if (insertStmt != null) insertStmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public List<Result> getResultsByElection(int electionId) {
        List<Result> results = new ArrayList<>();
        String sql = "SELECT r.result_id, r.election_id, r.candidate_id, r.total_votes, r.is_winner, " +
                     "e.election_title, s.name as candidate_name, p.position_name " +
                     "FROM RESULT r " +
                     "JOIN ELECTION e ON r.election_id = e.election_id " +
                     "JOIN CANDIDATE c ON r.candidate_id = c.candidate_id " +
                     "JOIN STUDENT s ON c.student_id = s.student_id " +
                     "JOIN POSITION p ON c.position_id = p.position_id " +
                     "WHERE r.election_id = ? " +
                     "ORDER BY p.position_id, r.total_votes DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Result result = new Result();
                result.setResultId(rs.getInt("result_id"));
                result.setElectionId(rs.getInt("election_id"));
                result.setCandidateId(rs.getInt("candidate_id"));
                result.setTotalVotes(rs.getInt("total_votes"));
                result.setWinner(rs.getBoolean("is_winner"));
                result.setElectionTitle(rs.getString("election_title"));
                result.setCandidateName(rs.getString("candidate_name"));
                result.setPositionName(rs.getString("position_name"));
                results.add(result);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return results;
    }
    
    public boolean hasResults(int electionId) {
        String sql = "SELECT COUNT(*) as count FROM RESULT WHERE election_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    public List<Result> getWinnersByElection(int electionId) {
        List<Result> winners = new ArrayList<>();
        String sql = "SELECT r.result_id, r.election_id, r.candidate_id, r.total_votes, r.is_winner, " +
                     "e.election_title, s.name as candidate_name, p.position_name " +
                     "FROM RESULT r " +
                     "JOIN ELECTION e ON r.election_id = e.election_id " +
                     "JOIN CANDIDATE c ON r.candidate_id = c.candidate_id " +
                     "JOIN STUDENT s ON c.student_id = s.student_id " +
                     "JOIN POSITION p ON c.position_id = p.position_id " +
                     "WHERE r.election_id = ? AND r.is_winner = true " +
                     "ORDER BY p.position_id";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Result result = new Result();
                result.setResultId(rs.getInt("result_id"));
                result.setElectionId(rs.getInt("election_id"));
                result.setCandidateId(rs.getInt("candidate_id"));
                result.setTotalVotes(rs.getInt("total_votes"));
                result.setWinner(rs.getBoolean("is_winner"));
                result.setElectionTitle(rs.getString("election_title"));
                result.setCandidateName(rs.getString("candidate_name"));
                result.setPositionName(rs.getString("position_name"));
                winners.add(result);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return winners;
    }
}
