package com.democratech.model;

public class Faculty {
    private int facultyId;
    private String facultyName;
    private String facultyCode;
    
    public Faculty() {
    }
    
    public Faculty(int facultyId, String facultyName, String facultyCode) {
        this.facultyId = facultyId;
        this.facultyName = facultyName;
        this.facultyCode = facultyCode;
    }
    
    public int getFacultyId() {
        return facultyId;
    }
    
    public void setFacultyId(int facultyId) {
        this.facultyId = facultyId;
    }
    
    public String getFacultyName() {
        return facultyName;
    }
    
    public void setFacultyName(String facultyName) {
        this.facultyName = facultyName;
    }
    
    public String getFacultyCode() {
        return facultyCode;
    }
    
    public void setFacultyCode(String facultyCode) {
        this.facultyCode = facultyCode;
    }
}
