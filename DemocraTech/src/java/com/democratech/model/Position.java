package com.democratech.model;

import java.io.Serializable;

public class Position implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int positionId;
    private int electionId;
    private String positionName;
    private int displayOrder;
    
    public Position() {}
    
    public Position(int positionId, int electionId, String positionName, int displayOrder) {
        this.positionId = positionId;
        this.electionId = electionId;
        this.positionName = positionName;
        this.displayOrder = displayOrder;
    }
    
    public int getPositionId() {
        return positionId;
    }
    
    public void setPositionId(int positionId) {
        this.positionId = positionId;
    }
    
    public int getElectionId() {
        return electionId;
    }
    
    public void setElectionId(int electionId) {
        this.electionId = electionId;
    }
    
    public String getPositionName() {
        return positionName;
    }
    
    public void setPositionName(String positionName) {
        this.positionName = positionName;
    }
    
    public int getDisplayOrder() {
        return displayOrder;
    }
    
    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }
}
