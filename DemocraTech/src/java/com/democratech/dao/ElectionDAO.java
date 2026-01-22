package com.democratech.dao;

import com.democratech.model.Election;
import com.democratech.model.Position;
import com.democratech.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ElectionDAO {
    
    public List<Election> getElectionsByFaculty(int facultyId) {
        List<Election> elections = new ArrayList<>();
        Connection conn = null;
        PreparedStatement electionStmt = null;
        PreparedStatement positionStmt = null;
        ResultSet electionRs = null;
        ResultSet positionRs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "SELECT election_id, election_title, election_description, faculty_id, " +
                        "start_date, end_date, status, total_votes " +
                        "FROM ELECTION WHERE faculty_id = ? ORDER BY start_date DESC";
            electionStmt = conn.prepareStatement(sql);
            electionStmt.setInt(1, facultyId);
            
            electionRs = electionStmt.executeQuery();
            
            while (electionRs.next()) {
                Election election = new Election();
                election.setElectionId(electionRs.getInt("election_id"));
                election.setElectionTitle(electionRs.getString("election_title"));
                election.setElectionDescription(electionRs.getString("election_description"));
                election.setFacultyId(electionRs.getInt("faculty_id"));
                election.setStartDate(electionRs.getDate("start_date"));
                election.setEndDate(electionRs.getDate("end_date"));
                election.setStatus(electionRs.getString("status"));
                election.setTotalVotes(electionRs.getInt("total_votes"));
                

                String positionSql = "SELECT position_name FROM POSITION WHERE election_id = ? ORDER BY display_order";
                positionStmt = conn.prepareStatement(positionSql);
                positionStmt.setInt(1, election.getElectionId());
                positionRs = positionStmt.executeQuery();
                if (positionRs.next()) {
                    election.setPosition(positionRs.getString("position_name"));
                }
                if (positionRs != null) positionRs.close();
                if (positionStmt != null) positionStmt.close();
                
                elections.add(election);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeResources(conn, electionStmt, electionRs);
        }
        
        return elections;
    }
    
    public Election getElectionById(int electionId) {
        Connection conn = null;
        PreparedStatement electionStmt = null;
        PreparedStatement positionStmt = null;
        ResultSet electionRs = null;
        ResultSet positionRs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "SELECT election_id, election_title, election_description, faculty_id, " +
                        "start_date, end_date, status, total_votes " +
                        "FROM ELECTION WHERE election_id = ?";
            electionStmt = conn.prepareStatement(sql);
            electionStmt.setInt(1, electionId);
            
            electionRs = electionStmt.executeQuery();
            
            if (electionRs.next()) {
                Election election = new Election();
                election.setElectionId(electionRs.getInt("election_id"));
                election.setElectionTitle(electionRs.getString("election_title"));
                election.setElectionDescription(electionRs.getString("election_description"));
                election.setFacultyId(electionRs.getInt("faculty_id"));
                election.setStartDate(electionRs.getDate("start_date"));
                election.setEndDate(electionRs.getDate("end_date"));
                election.setStatus(electionRs.getString("status"));
                election.setTotalVotes(electionRs.getInt("total_votes"));
                
                String positionSql = "SELECT position_name FROM POSITION WHERE election_id = ? ORDER BY display_order";
                positionStmt = conn.prepareStatement(positionSql);
                positionStmt.setInt(1, electionId);
                positionRs = positionStmt.executeQuery();
                if (positionRs.next()) {
                    election.setPosition(positionRs.getString("position_name"));
                }
                if (positionRs != null) positionRs.close();
                if (positionStmt != null) positionStmt.close();
                
                return election;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeResources(conn, electionStmt, electionRs);
        }
        
        return null;
    }
    
    public int createElection(Election election, List<String> positionNames) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int electionId = -1;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            String sql = "INSERT INTO ELECTION (election_title, election_description, faculty_id, " +
                        "start_date, end_date, status, total_votes) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, election.getElectionTitle());
            pstmt.setString(2, election.getElectionDescription());
            pstmt.setInt(3, election.getFacultyId());
            pstmt.setDate(4, election.getStartDate());
            pstmt.setDate(5, election.getEndDate());
            pstmt.setString(6, election.getStatus());
            pstmt.setInt(7, 0);
            
            int rows = pstmt.executeUpdate();
            
            if (rows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    electionId = rs.getInt(1);
                }
            }
            
            if (electionId > 0 && positionNames != null && !positionNames.isEmpty()) {
                pstmt.close();
                String posSql = "INSERT INTO POSITION (election_id, position_name, display_order) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(posSql);
                
                for (int i = 0; i < positionNames.size(); i++) {
                    pstmt.setInt(1, electionId);
                    pstmt.setString(2, positionNames.get(i));
                    pstmt.setInt(3, i + 1);
                    pstmt.addBatch();
                }
                pstmt.executeBatch();
            }
            
            conn.commit();
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return -1;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.closeResources(conn, pstmt, rs);
        }
        
        return electionId;
    }
    
    public boolean createElection(Election election) throws SQLException {
        Connection conn = null;
        PreparedStatement electionStmt = null;
        PreparedStatement positionStmt = null;
        ResultSet rs = null;
        
        conn = DBUtil.getConnection();
        if (conn == null) {
            throw new SQLException("Failed to get database connection");
        }
        
        try {
            conn.setAutoCommit(false);
            
            String electionSql = "INSERT INTO ELECTION (election_title, election_description, faculty_id, " +
                        "start_date, end_date, status, total_votes) VALUES (?, ?, ?, ?, ?, ?, ?)";
            electionStmt = conn.prepareStatement(electionSql, Statement.RETURN_GENERATED_KEYS);
            electionStmt.setString(1, election.getElectionTitle());
            electionStmt.setString(2, election.getElectionDescription());
            electionStmt.setInt(3, election.getFacultyId());
            electionStmt.setDate(4, election.getStartDate());
            electionStmt.setDate(5, election.getEndDate());
            electionStmt.setString(6, election.getStatus());
            electionStmt.setInt(7, 0);
            
            int rows = electionStmt.executeUpdate();
            
            if (rows > 0) {
                rs = electionStmt.getGeneratedKeys();
                if (rs.next()) {
                    int electionId = rs.getInt(1);
                    
                    if (election.getPosition() != null && !election.getPosition().trim().isEmpty()) {
                        String positionSql = "INSERT INTO POSITION (election_id, position_name, display_order) VALUES (?, ?, ?)";
                        positionStmt = conn.prepareStatement(positionSql);
                        positionStmt.setInt(1, electionId);
                        positionStmt.setString(2, election.getPosition().trim());
                        positionStmt.setInt(3, 1);
                        positionStmt.executeUpdate();
                    }
                }
                
                conn.commit();
                return true;
            }
            
            conn.rollback();
            throw new SQLException("Election insert affected 0 rows");
            
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
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.closeResources(conn, electionStmt, rs);
            if (positionStmt != null) {
                try {
                    positionStmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    public boolean updateElection(Election election) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "UPDATE ELECTION SET election_title = ?, election_description = ?, " +
                        "start_date = ?, end_date = ?, status = ? WHERE election_id = ? AND faculty_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, election.getElectionTitle());
            pstmt.setString(2, election.getElectionDescription());
            pstmt.setDate(3, election.getStartDate());
            pstmt.setDate(4, election.getEndDate());
            pstmt.setString(5, election.getStatus());
            pstmt.setInt(6, election.getElectionId());
            pstmt.setInt(7, election.getFacultyId());
            
            int rows = pstmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            throw e;
        } finally {
            DBUtil.closeResources(conn, pstmt, null);
        }
    }
    
    public boolean updateElectionStatus(int electionId, String status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "UPDATE ELECTION SET status = ? WHERE election_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, electionId);
            
            int rows = pstmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.closeResources(conn, pstmt, null);
        }
    }
    
    public boolean deleteElection(int electionId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            String deleteVotes = "DELETE FROM VOTE WHERE election_id = ?";
            pstmt = conn.prepareStatement(deleteVotes);
            pstmt.setInt(1, electionId);
            pstmt.executeUpdate();
            pstmt.close();
            
            String deleteResults = "DELETE FROM RESULT WHERE election_id = ?";
            pstmt = conn.prepareStatement(deleteResults);
            pstmt.setInt(1, electionId);
            pstmt.executeUpdate();
            pstmt.close();
            
            String deleteCandidates = "DELETE FROM CANDIDATE WHERE position_id IN " +
                                     "(SELECT position_id FROM POSITION WHERE election_id = ?)";
            pstmt = conn.prepareStatement(deleteCandidates);
            pstmt.setInt(1, electionId);
            pstmt.executeUpdate();
            pstmt.close();
            
            String deletePositions = "DELETE FROM POSITION WHERE election_id = ?";
            pstmt = conn.prepareStatement(deletePositions);
            pstmt.setInt(1, electionId);
            pstmt.executeUpdate();
            pstmt.close();
            
            String deleteElection = "DELETE FROM ELECTION WHERE election_id = ?";
            pstmt = conn.prepareStatement(deleteElection);
            pstmt.setInt(1, electionId);
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
            DBUtil.closeResources(conn, pstmt, null);
        }
    }
    
    public List<Position> getPositionsByElection(int electionId) {
        List<Position> positions = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "SELECT position_id, election_id, position_name, display_order " +
                        "FROM POSITION WHERE election_id = ? ORDER BY display_order";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, electionId);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Position position = new Position();
                position.setPositionId(rs.getInt("position_id"));
                position.setElectionId(rs.getInt("election_id"));
                position.setPositionName(rs.getString("position_name"));
                position.setDisplayOrder(rs.getInt("display_order"));
                positions.add(position);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeResources(conn, pstmt, rs);
        }
        
        return positions;
    }
}
