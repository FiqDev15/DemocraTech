package com.democratech.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Vote implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int voteId;
    private int studentId;
    private int electionId;
    private int candidateId;
    private Timestamp voteTime;
    
    private String studentName;
    private String electionTitle;
    private String candidateName;
    private String positionName;
    
    public Vote() {}
    
    public Vote(int studentId, int electionId, int candidateId) {
        this.studentId = studentId;
        this.electionId = electionId;
        this.candidateId = candidateId;
        this.voteTime = new Timestamp(System.currentTimeMillis());
    }
    
    public Vote(int voteId, int studentId, int electionId, int candidateId, Timestamp voteTime) {
        this.voteId = voteId;
        this.studentId = studentId;
        this.electionId = electionId;
        this.candidateId = candidateId;
        this.voteTime = voteTime;
    }
    
    public int getVoteId() {
        return voteId;
    }
    
    public void setVoteId(int voteId) {
        this.voteId = voteId;
    }
    
    public int getStudentId() {
        return studentId;
    }
    
    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }
    
    public int getElectionId() {
        return electionId;
    }
    
    public void setElectionId(int electionId) {
        this.electionId = electionId;
    }
    
    public int getCandidateId() {
        return candidateId;
    }
    
    public void setCandidateId(int candidateId) {
        this.candidateId = candidateId;
    }
    
    public Timestamp getVoteTime() {
        return voteTime;
    }
    
    public void setVoteTime(Timestamp voteTime) {
        this.voteTime = voteTime;
    }
    
    public String getStudentName() {
        return studentName;
    }
    
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }
    
    public String getElectionTitle() {
        return electionTitle;
    }
    
    public void setElectionTitle(String electionTitle) {
        this.electionTitle = electionTitle;
    }
    
    public String getCandidateName() {
        return candidateName;
    }
    
    public void setCandidateName(String candidateName) {
        this.candidateName = candidateName;
    }
    
    public String getPositionName() {
        return positionName;
    }
    
    public void setPositionName(String positionName) {
        this.positionName = positionName;
    }
}
