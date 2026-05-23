package com.institute.model;

import java.sql.Date;

public class Attendance {
    private int attendanceId;
    private int studentId;
    private String studentName; // Helper for UI reporting
    private Date date;
    private String status; // 'Present', 'Absent'

    public Attendance() {}

    public Attendance(int attendanceId, int studentId, String studentName, Date date, String status) {
        this.attendanceId = attendanceId;
        this.studentId = studentId;
        this.studentName = studentName;
        this.date = date;
        this.status = status;
    }

    public int getAttendanceId() { return attendanceId; }
    public void setAttendanceId(int attendanceId) { this.attendanceId = attendanceId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
