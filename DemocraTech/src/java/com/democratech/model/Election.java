package com.democratech.model;

import java.io.Serializable;
import java.sql.Date;

public class Election implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int electionId;
    private String electionTitle;
    private String electionDescription;
    private int facultyId;
    private Date startDate;
    private Date endDate;
    private String status;
    private int totalVotes;
    private String position;
    
    public Election() {}
    
    public Election(int electionId, String electionTitle, String electionDescription, 
                   int facultyId, Date startDate, Date endDate, String status, int totalVotes) {
        this.electionId = electionId;
        this.electionTitle = electionTitle;
        this.electionDescription = electionDescription;
        this.facultyId = facultyId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.totalVotes = totalVotes;
    }
    
    public Election(int facultyId, String title, String description, String position,
                   Date startDate, Date endDate, String status) {
        this.facultyId = facultyId;
        this.electionTitle = title;
        this.electionDescription = description;
        this.position = position;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.totalVotes = 0;
    }
    
    public Election(int electionId, int facultyId, String title, String description, 
                   String position, Date startDate, Date endDate, String status) {
        this.electionId = electionId;
        this.facultyId = facultyId;
        this.electionTitle = title;
        this.electionDescription = description;
        this.position = position;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }
    
    public int getElectionId() {
        return electionId;
    }
    
    public void setElectionId(int electionId) {
        this.electionId = electionId;
    }
    
    public String getElectionTitle() {
        return electionTitle;
    }
    
    public void setElectionTitle(String electionTitle) {
        this.electionTitle = electionTitle;
    }
    
    public String getElectionDescription() {
        return electionDescription;
    }
    
    public void setElectionDescription(String electionDescription) {
        this.electionDescription = electionDescription;
    }
    
    public int getFacultyId() {
        return facultyId;
    }
    
    public void setFacultyId(int facultyId) {
        this.facultyId = facultyId;
    }
    
    public Date getStartDate() {
        return startDate;
    }
    
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }
    
    public Date getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public int getTotalVotes() {
        return totalVotes;
    }
    
    public void setTotalVotes(int totalVotes) {
        this.totalVotes = totalVotes;
    }
    
    public String getPosition() {
        return position;
    }
    
    public void setPosition(String position) {
        this.position = position;
    }
    
    public String getTitle() {
        return electionTitle;
    }
    
    public void setTitle(String title) {
        this.electionTitle = title;
    }
    
    public String getDescription() {
        return electionDescription;
    }
    
    public void setDescription(String description) {
        this.electionDescription = description;
    }
    
    public boolean isStatus() {
        return "ACTIVE".equalsIgnoreCase(this.status) || "ONGOING".equalsIgnoreCase(this.status);
    }
}
