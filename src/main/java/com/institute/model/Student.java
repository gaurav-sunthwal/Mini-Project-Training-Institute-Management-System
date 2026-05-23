package com.institute.model;

public class Student {
    private int studentId;
    private String studentName;
    private String email;
    private String course;
    private String phone;
    private String photoPath;

    public Student() {}

    public Student(int studentId, String studentName, String email, String course, String phone, String photoPath) {
        this.studentId = studentId;
        this.studentName = studentName;
        this.email = email;
        this.course = course;
        this.phone = phone;
        this.photoPath = photoPath;
    }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getCourse() { return course; }
    public void setCourse(String course) { this.course = course; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPhotoPath() { return photoPath; }
    public void setPhotoPath(String photoPath) { this.photoPath = photoPath; }
}
