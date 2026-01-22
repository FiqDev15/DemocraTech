package com.democratech.dao;

import com.democratech.model.Vote;
import com.democratech.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoteDAO {
    
    public boolean castVote(Vote vote) throws SQLException {
        String sql = "INSERT INTO VOTE (student_id, election_id, candidate_id, vote_time) " +
                     "VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, vote.getStudentId());
            pstmt.setInt(2, vote.getElectionId());
            pstmt.setInt(3, vote.getCandidateId());
            pstmt.setTimestamp(4, vote.getVoteTime());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    public boolean castMultipleVotes(List<Vote> votes) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            String sql = "INSERT INTO VOTE (student_id, election_id, candidate_id, vote_time) " +
                         "VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            
            for (Vote vote : votes) {
                pstmt.setInt(1, vote.getStudentId());
                pstmt.setInt(2, vote.getElectionId());
                pstmt.setInt(3, vote.getCandidateId());
                pstmt.setTimestamp(4, vote.getVoteTime());
                pstmt.addBatch();
            }
            
            pstmt.executeBatch();
            
            updateCandidateVoteCounts(conn, votes.get(0).getElectionId());
            
            updateElectionTotalVotes(conn, votes.get(0).getElectionId());
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public boolean hasVoted(int studentId, int electionId) {
        String sql = "SELECT COUNT(*) as count FROM VOTE WHERE student_id = ? AND election_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, electionId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    public List<Vote> getVotesByStudent(int studentId) {
        List<Vote> votes = new ArrayList<>();
        String sql = "SELECT v.vote_id, v.student_id, v.election_id, v.candidate_id, v.vote_time, " +
                     "e.election_title, s.name as candidate_name, p.position_name " +
                     "FROM VOTE v " +
                     "JOIN ELECTION e ON v.election_id = e.election_id " +
                     "JOIN CANDIDATE c ON v.candidate_id = c.candidate_id " +
                     "JOIN STUDENT s ON c.student_id = s.student_id " +
                     "JOIN POSITION p ON c.position_id = p.position_id " +
                     "WHERE v.student_id = ? " +
                     "ORDER BY v.vote_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Vote vote = new Vote();
                vote.setVoteId(rs.getInt("vote_id"));
                vote.setStudentId(rs.getInt("student_id"));
                vote.setElectionId(rs.getInt("election_id"));
                vote.setCandidateId(rs.getInt("candidate_id"));
                vote.setVoteTime(rs.getTimestamp("vote_time"));
                vote.setElectionTitle(rs.getString("election_title"));
                vote.setCandidateName(rs.getString("candidate_name"));
                vote.setPositionName(rs.getString("position_name"));
                votes.add(vote);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return votes;
    }
    
    public List<Vote> getVotesByElection(int electionId) {
        List<Vote> votes = new ArrayList<>();
        String sql = "SELECT v.vote_id, v.student_id, v.election_id, v.candidate_id, v.vote_time, " +
                     "st.name as student_name, s.name as candidate_name, p.position_name " +
                     "FROM VOTE v " +
                     "JOIN STUDENT st ON v.student_id = st.student_id " +
                     "JOIN CANDIDATE c ON v.candidate_id = c.candidate_id " +
                     "JOIN STUDENT s ON c.student_id = s.student_id " +
                     "JOIN POSITION p ON c.position_id = p.position_id " +
                     "WHERE v.election_id = ? " +
                     "ORDER BY v.vote_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Vote vote = new Vote();
                vote.setVoteId(rs.getInt("vote_id"));
                vote.setStudentId(rs.getInt("student_id"));
                vote.setElectionId(rs.getInt("election_id"));
                vote.setCandidateId(rs.getInt("candidate_id"));
                vote.setVoteTime(rs.getTimestamp("vote_time"));
                vote.setStudentName(rs.getString("student_name"));
                vote.setCandidateName(rs.getString("candidate_name"));
                vote.setPositionName(rs.getString("position_name"));
                votes.add(vote);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return votes;
    }
    
    public int countVotesByElection(int electionId) {
        String sql = "SELECT COUNT(*) as count FROM VOTE WHERE election_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    private void updateCandidateVoteCounts(Connection conn, int electionId) throws SQLException {
        String sql = "UPDATE CANDIDATE SET vote_count = (" +
                     "SELECT COUNT(*) FROM VOTE WHERE candidate_id = CANDIDATE.candidate_id" +
                     ") WHERE position_id IN (" +
                     "SELECT position_id FROM POSITION WHERE election_id = ?" +
                     ")";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, electionId);
            int rowsUpdated = pstmt.executeUpdate();
            System.out.println("Updated vote counts for " + rowsUpdated + " candidates in election " + electionId);
        }
    }
    
    private void updateElectionTotalVotes(Connection conn, int electionId) throws SQLException {
        String sql = "UPDATE ELECTION SET total_votes = (" +
                     "SELECT COUNT(DISTINCT student_id) FROM VOTE WHERE election_id = ?" +
                     ") WHERE election_id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, electionId);
            pstmt.setInt(2, electionId);
            int rowsUpdated = pstmt.executeUpdate();
            System.out.println("Updated total votes for election " + electionId + ": " + rowsUpdated + " row(s) affected");
        }
    }
    
    public List<Integer> getVotedElectionIds(int studentId) {
        List<Integer> electionIds = new ArrayList<>();
        String sql = "SELECT DISTINCT election_id FROM VOTE WHERE student_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                electionIds.add(rs.getInt("election_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return electionIds;
    }
    
    public Timestamp getVoteTimeByStudentAndElection(int studentId, int electionId) {
        String sql = "SELECT vote_time FROM VOTE WHERE student_id = ? AND election_id = ? " +
                     "ORDER BY vote_time DESC FETCH FIRST 1 ROWS ONLY";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, electionId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getTimestamp("vote_time");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
}
