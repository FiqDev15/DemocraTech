package com.democratech.model;

import java.io.Serializable;

public class Result implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int resultId;
    private int electionId;
    private int candidateId;
    private int totalVotes;
    private boolean isWinner;
    
    private String electionTitle;
    private String candidateName;
    private String positionName;
    
    public Result() {}
    
    public Result(int electionId, int candidateId, int totalVotes, boolean isWinner) {
        this.electionId = electionId;
        this.candidateId = candidateId;
        this.totalVotes = totalVotes;
        this.isWinner = isWinner;
    }
    
    public int getResultId() {
        return resultId;
    }
    
    public void setResultId(int resultId) {
        this.resultId = resultId;
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
    
    public int getTotalVotes() {
        return totalVotes;
    }
    
    public void setTotalVotes(int totalVotes) {
        this.totalVotes = totalVotes;
    }
    
    public boolean isWinner() {
        return isWinner;
    }
    
    public void setWinner(boolean winner) {
        isWinner = winner;
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
