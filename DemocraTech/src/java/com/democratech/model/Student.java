package com.democratech.model;

public class Student {
    private int studentId;
    private String name;
    private String email;
    private String password;
    private int facultyId;
    
    public Student() {
    }
    
    public Student(int studentId, String name, String email, String password, int facultyId) {
        this.studentId = studentId;
        this.name = name;
        this.email = email;
        this.password = password;
        this.facultyId = facultyId;
    }
    
    public int getStudentId() {
        return studentId;
    }
    
    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public int getFacultyId() {
        return facultyId;
    }
    
    public void setFacultyId(int facultyId) {
        this.facultyId = facultyId;
    }
}
