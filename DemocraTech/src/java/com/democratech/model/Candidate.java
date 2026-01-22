package com.democratech.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Candidate implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int candidateId;
    private int positionId;
    private int studentId;
    private String manifesto;
    private boolean status;
    private Timestamp appliedAt;
    private Timestamp reviewedAt;
    private int voteCount;
    private double votePercentage;
    
    private String studentName;
    private String positionName;
    private String electionTitle;
    private int electionId;
    
    public Candidate() {}
    
    public Candidate(int positionId, int studentId, String manifesto) {
        this.positionId = positionId;
        this.studentId = studentId;
        this.manifesto = manifesto;
        this.status = false;
        this.appliedAt = new Timestamp(System.currentTimeMillis());
    }
    
    public Candidate(int candidateId, int positionId, int studentId, String manifesto, 
                    boolean status, Timestamp appliedAt, Timestamp reviewedAt, 
                    int voteCount, double votePercentage) {
        this.candidateId = candidateId;
        this.positionId = positionId;
        this.studentId = studentId;
        this.manifesto = manifesto;
        this.status = status;
        this.appliedAt = appliedAt;
        this.reviewedAt = reviewedAt;
        this.voteCount = voteCount;
        this.votePercentage = votePercentage;
    }
    
    public int getCandidateId() {
        return candidateId;
    }
    
    public void setCandidateId(int candidateId) {
        this.candidateId = candidateId;
    }
    
    public int getPositionId() {
        return positionId;
    }
    
    public void setPositionId(int positionId) {
        this.positionId = positionId;
    }
    
    public int getStudentId() {
        return studentId;
    }
    
    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }
    
    public String getManifesto() {
        return manifesto;
    }
    
    public void setManifesto(String manifesto) {
        this.manifesto = manifesto;
    }
    
    public boolean isStatus() {
        return status;
    }
    
    public void setStatus(boolean status) {
        this.status = status;
    }
    
    public Timestamp getAppliedAt() {
        return appliedAt;
    }
    
    public void setAppliedAt(Timestamp appliedAt) {
        this.appliedAt = appliedAt;
    }
    
    public Timestamp getReviewedAt() {
        return reviewedAt;
    }
    
    public void setReviewedAt(Timestamp reviewedAt) {
        this.reviewedAt = reviewedAt;
    }
    
    public int getVoteCount() {
        return voteCount;
    }
    
    public void setVoteCount(int voteCount) {
        this.voteCount = voteCount;
    }
    
    public double getVotePercentage() {
        return votePercentage;
    }
    
    public void setVotePercentage(double votePercentage) {
        this.votePercentage = votePercentage;
    }
    
    public String getStudentName() {
        return studentName;
    }
    
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }
    
    public String getPositionName() {
        return positionName;
    }
    
    public void setPositionName(String positionName) {
        this.positionName = positionName;
    }
    
    public String getElectionTitle() {
        return electionTitle;
    }
    
    public void setElectionTitle(String electionTitle) {
        this.electionTitle = electionTitle;
    }
    
    public int getElectionId() {
        return electionId;
    }
    
    public void setElectionId(int electionId) {
        this.electionId = electionId;
    }
    
    public String getStatusText() {
        return status ? "APPROVED" : "PENDING";
    }
}
