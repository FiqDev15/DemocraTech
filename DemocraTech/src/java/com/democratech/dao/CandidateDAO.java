package com.democratech.dao;

import com.democratech.model.Candidate;
import com.democratech.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CandidateDAO {

    public boolean applyAsCandidate(Candidate candidate) throws SQLException {
        String sql = "INSERT INTO CANDIDATE (position_id, student_id, manifesto, status, applied_at) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, candidate.getPositionId());
            pstmt.setInt(2, candidate.getStudentId());
            pstmt.setString(3, candidate.getManifesto());
            pstmt.setBoolean(4, false);
            pstmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            
            return pstmt.executeUpdate() > 0;
        }
    }

    public List<Candidate> getCandidatesByFaculty(int facultyId) {
        List<Candidate> candidates = new ArrayList<>();
        String sql = "SELECT c.candidate_id, c.position_id, c.student_id, c.manifesto, c.status, " +
                     "c.applied_at, c.reviewed_at, c.vote_count, c.vote_percentage, " +
                     "s.name as student_name, p.position_name, e.election_title, e.election_id " +
                     "FROM CANDIDATE c " +
                     "JOIN STUDENT s ON c.student_id = s.student_id " +
                     "JOIN POSITION p ON c.position_id = p.position_id " +
                     "JOIN ELECTION e ON p.election_id = e.election_id " +
                     "WHERE e.faculty_id = ? " +
                     "ORDER BY c.applied_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, facultyId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Candidate candidate = new Candidate();
                candidate.setCandidateId(rs.getInt("candidate_id"));
                candidate.setPositionId(rs.getInt("position_id"));
                candidate.setStudentId(rs.getInt("student_id"));
                candidate.setManifesto(rs.getString("manifesto"));
                candidate.setStatus(rs.getBoolean("status"));
                candidate.setAppliedAt(rs.getTimestamp("applied_at"));
                candidate.setReviewedAt(rs.getTimestamp("reviewed_at"));
                candidate.setVoteCount(rs.getInt("vote_count"));
                candidate.setVotePercentage(rs.getDouble("vote_percentage"));
                candidate.setStudentName(rs.getString("student_name"));
                candidate.setPositionName(rs.getString("position_name"));
                candidate.setElectionTitle(rs.getString("election_title"));
                candidate.setElectionId(rs.getInt("election_id"));
                candidates.add(candidate);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return candidates;
    }

    public List<Candidate> getCandidatesByElection(int electionId) {
        List<Candidate> candidates = new ArrayList<>();
        String sql = "SELECT c.candidate_id, c.position_id, c.student_id, c.manifesto, c.status, " +
                     "c.applied_at, c.reviewed_at, c.vote_count, c.vote_percentage, " +
                     "s.name as student_name, p.position_name " +
                     "FROM CANDIDATE c " +
                     "JOIN STUDENT s ON c.student_id = s.student_id " +
                     "JOIN POSITION p ON c.position_id = p.position_id " +
                     "WHERE p.election_id = ? AND c.status = true " +
                     "ORDER BY p.display_order, s.name";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, electionId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Candidate candidate = new Candidate();
                candidate.setCandidateId(rs.getInt("candidate_id"));
                candidate.setPositionId(rs.getInt("position_id"));
                candidate.setStudentId(rs.getInt("student_id"));
                candidate.setManifesto(rs.getString("manifesto"));
                candidate.setStatus(rs.getBoolean("status"));
                candidate.setAppliedAt(rs.getTimestamp("applied_at"));
                candidate.setReviewedAt(rs.getTimestamp("reviewed_at"));
                candidate.setVoteCount(rs.getInt("vote_count"));
                candidate.setVotePercentage(rs.getDouble("vote_percentage"));
                candidate.setStudentName(rs.getString("student_name"));
                candidate.setPositionName(rs.getString("position_name"));
                candidates.add(candidate);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return candidates;
    }

    public List<Candidate> getCandidatesByPosition(int positionId) {
        List<Candidate> candidates = new ArrayList<>();
        String sql = "SELECT c.candidate_id, c.position_id, c.student_id, c.manifesto, c.status, " +
                     "c.applied_at, c.vote_count, s.name as student_name " +
                     "FROM CANDIDATE c " +
                     "JOIN STUDENT s ON c.student_id = s.student_id " +
                     "WHERE c.position_id = ? AND c.status = true " +
                     "ORDER BY s.name";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, positionId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Candidate candidate = new Candidate();
                candidate.setCandidateId(rs.getInt("candidate_id"));
                candidate.setPositionId(rs.getInt("position_id"));
                candidate.setStudentId(rs.getInt("student_id"));
                candidate.setManifesto(rs.getString("manifesto"));
                candidate.setStatus(rs.getBoolean("status"));
                candidate.setAppliedAt(rs.getTimestamp("applied_at"));
                candidate.setVoteCount(rs.getInt("vote_count"));
                candidate.setStudentName(rs.getString("student_name"));
                candidates.add(candidate);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return candidates;
    }

    public List<Candidate> getCandidatesByPositionSortedByVotes(int positionId) {
        List<Candidate> candidates = new ArrayList<>();
        String sql = "SELECT c.candidate_id, c.position_id, c.student_id, c.manifesto, c.status, " +
                     "c.applied_at, c.vote_count, s.name as student_name " +
                     "FROM CANDIDATE c " +
                     "JOIN STUDENT s ON c.student_id = s.student_id " +
                     "WHERE c.position_id = ? AND c.status = true " +
                     "ORDER BY c.vote_count DESC, s.name";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, positionId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Candidate candidate = new Candidate();
                candidate.setCandidateId(rs.getInt("candidate_id"));
                candidate.setPositionId(rs.getInt("position_id"));
                candidate.setStudentId(rs.getInt("student_id"));
                candidate.setManifesto(rs.getString("manifesto"));
                candidate.setStatus(rs.getBoolean("status"));
                candidate.setAppliedAt(rs.getTimestamp("applied_at"));
                candidate.setVoteCount(rs.getInt("vote_count"));
                candidate.setStudentName(rs.getString("student_name"));
                candidates.add(candidate);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return candidates;
    }

    public boolean approveCandidate(int candidateId) throws SQLException {
        String sql = "UPDATE CANDIDATE SET status = true, reviewed_at = ? WHERE candidate_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(2, candidateId);
            
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean rejectCandidate(int candidateId) throws SQLException {
        String sql = "UPDATE CANDIDATE SET status = false, reviewed_at = ? WHERE candidate_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(2, candidateId);
            
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteCandidate(int candidateId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            String deleteResults = "DELETE FROM RESULT WHERE candidate_id = ?";
            pstmt = conn.prepareStatement(deleteResults);
            pstmt.setInt(1, candidateId);
            pstmt.executeUpdate();
            pstmt.close();

            String deleteVotes = "DELETE FROM VOTE WHERE candidate_id = ?";
            pstmt = conn.prepareStatement(deleteVotes);
            pstmt.setInt(1, candidateId);
            pstmt.executeUpdate();
            pstmt.close();

            String deleteCandidate = "DELETE FROM CANDIDATE WHERE candidate_id = ?";
            pstmt = conn.prepareStatement(deleteCandidate);
            pstmt.setInt(1, candidateId);
            int rows = pstmt.executeUpdate();

            conn.commit();
            return rows > 0;

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
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public boolean updateCandidateStatus(int candidateId, boolean status) throws SQLException {
        String sql = "UPDATE CANDIDATE SET status = ?, reviewed_at = ? WHERE candidate_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setBoolean(1, status);
            pstmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(3, candidateId);
            
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean hasApplied(int studentId, int positionId) {
        String sql = "SELECT COUNT(*) as count FROM CANDIDATE WHERE student_id = ? AND position_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, positionId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Count approved candidates by election
     */
    public int countCandidatesByElection(int electionId) {
        String sql = "SELECT COUNT(*) as count FROM CANDIDATE c " +
                     "JOIN POSITION p ON c.position_id = p.position_id " +
                     "WHERE p.election_id = ? AND c.status = true";
        
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
    
    /**
     * Get all applications by a specific student
     */
    public List<Candidate> getApplicationsByStudent(int studentId) {
        List<Candidate> candidates = new ArrayList<>();
        String sql = "SELECT c.candidate_id, c.position_id, c.student_id, c.manifesto, c.status, " +
                     "c.applied_at, c.reviewed_at, p.position_name, e.election_title, e.election_id, e.status as election_status " +
                     "FROM CANDIDATE c " +
                     "JOIN POSITION p ON c.position_id = p.position_id " +
                     "JOIN ELECTION e ON p.election_id = e.election_id " +
                     "WHERE c.student_id = ? " +
                     "ORDER BY c.applied_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Candidate candidate = new Candidate();
                candidate.setCandidateId(rs.getInt("candidate_id"));
                candidate.setPositionId(rs.getInt("position_id"));
                candidate.setStudentId(rs.getInt("student_id"));
                candidate.setManifesto(rs.getString("manifesto"));
                candidate.setStatus(rs.getBoolean("status"));
                candidate.setAppliedAt(rs.getTimestamp("applied_at"));
                candidate.setReviewedAt(rs.getTimestamp("reviewed_at"));
                candidate.setPositionName(rs.getString("position_name"));
                candidate.setElectionTitle(rs.getString("election_title"));
                candidate.setElectionId(rs.getInt("election_id"));
                candidates.add(candidate);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return candidates;
    }
}
