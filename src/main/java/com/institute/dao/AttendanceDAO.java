package com.institute.dao;

import com.institute.config.DatabaseConfig;
import com.institute.model.Attendance;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDAO {

    public boolean markAttendance(int studentId, Date date, String status) {
        String checkSql = "SELECT attendance_id FROM attendance WHERE student_id = ? AND date = ?";
        String insertSql = "INSERT INTO attendance (student_id, date, status) VALUES (?, ?, ?)";
        String updateSql = "UPDATE attendance SET status = ? WHERE student_id = ? AND date = ?";
        
        try (Connection conn = DatabaseConfig.getConnection()) {
            boolean exists = false;
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setInt(1, studentId);
                psCheck.setDate(2, date);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        exists = true;
                    }
                }
            }

            if (exists) {
                try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                    psUpdate.setString(1, status);
                    psUpdate.setInt(2, studentId);
                    psUpdate.setDate(3, date);
                    return psUpdate.executeUpdate() > 0;
                }
            } else {
                try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                    psInsert.setInt(1, studentId);
                    psInsert.setDate(2, date);
                    psInsert.setString(3, status);
                    return psInsert.executeUpdate() > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Attendance> getAttendanceReport() {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT a.*, s.student_name FROM attendance a " +
                     "JOIN students s ON a.student_id = s.student_id " +
                     "ORDER BY a.date DESC, a.attendance_id DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Attendance att = new Attendance();
                att.setAttendanceId(rs.getInt("attendance_id"));
                att.setStudentId(rs.getInt("student_id"));
                att.setStudentName(rs.getString("student_name"));
                att.setDate(rs.getDate("date"));
                att.setStatus(rs.getString("status"));
                list.add(att);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Attendance> getAttendanceByStudentId(int studentId) {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT a.*, s.student_name FROM attendance a " +
                     "JOIN students s ON a.student_id = s.student_id " +
                     "WHERE a.student_id = ? ORDER BY a.date DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Attendance att = new Attendance();
                    att.setAttendanceId(rs.getInt("attendance_id"));
                    att.setStudentId(rs.getInt("student_id"));
                    att.setStudentName(rs.getString("student_name"));
                    att.setDate(rs.getDate("date"));
                    att.setStatus(rs.getString("status"));
                    list.add(att);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getAttendancePercentage(int studentId) {
        String sql = "SELECT " +
                     "SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) as present_count, " +
                     "COUNT(*) as total_count " +
                     "FROM attendance WHERE student_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double total = rs.getDouble("total_count");
                    if (total > 0) {
                        double present = rs.getDouble("present_count");
                        return (present / total) * 100.0;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 100.0; // Default to 100 if no classes logged
    }

    public double getOverallAttendanceRate() {
        String sql = "SELECT " +
                     "SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) as present_count, " +
                     "COUNT(*) as total_count " +
                     "FROM attendance";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                double total = rs.getDouble("total_count");
                if (total > 0) {
                    double present = rs.getDouble("present_count");
                    return (present / total) * 100.0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}
