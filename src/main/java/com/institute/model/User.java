package com.institute.model;

public class User {
    private String username;
    private String password;
    private String role; // 'admin', 'faculty', 'student'
    private Integer refId; // Maps to student_id or faculty_id if needed

    public User() {}

    public User(String username, String password, String role, Integer refId) {
        this.username = username;
        this.password = password;
        this.role = role;
        this.refId = refId;
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Integer getRefId() { return refId; }
    public void setRefId(Integer refId) { this.refId = refId; }
}
