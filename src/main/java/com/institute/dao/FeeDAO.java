package com.institute.dao;

import com.institute.config.DatabaseConfig;
import com.institute.model.Fee;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FeeDAO {

    public boolean recordPayment(Fee fee) {
        String sql = "INSERT INTO fees (student_id, amount_paid, payment_date) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fee.getStudentId());
            ps.setDouble(2, fee.getAmountPaid());
            ps.setDate(3, fee.getPaymentDate());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Fee> getAllPayments() {
        List<Fee> list = new ArrayList<>();
        String sql = "SELECT f.*, s.student_name FROM fees f " +
                     "JOIN students s ON f.student_id = s.student_id " +
                     "ORDER BY f.payment_date DESC, f.payment_id DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Fee fee = new Fee();
                fee.setPaymentId(rs.getInt("payment_id"));
                fee.setStudentId(rs.getInt("student_id"));
                fee.setStudentName(rs.getString("student_name"));
                fee.setAmountPaid(rs.getDouble("amount_paid"));
                fee.setPaymentDate(rs.getDate("payment_date"));
                list.add(fee);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Fee> getPaymentsByStudentId(int studentId) {
        List<Fee> list = new ArrayList<>();
        String sql = "SELECT f.*, s.student_name FROM fees f " +
                     "JOIN students s ON f.student_id = s.student_id " +
                     "WHERE f.student_id = ? ORDER BY f.payment_date DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Fee fee = new Fee();
                    fee.setPaymentId(rs.getInt("payment_id"));
                    fee.setStudentId(rs.getInt("student_id"));
                    fee.setStudentName(rs.getString("student_name"));
                    fee.setAmountPaid(rs.getDouble("amount_paid"));
                    fee.setPaymentDate(rs.getDate("payment_date"));
                    list.add(fee);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getTotalRevenue() {
        String sql = "SELECT SUM(amount_paid) FROM fees";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public List<Map<String, Object>> getPendingFeesReport() {
        List<Map<String, Object>> report = new ArrayList<>();
        String sql = "SELECT s.student_id, s.student_name, s.course, c.fees as total_course_fee, " +
                     "COALESCE((SELECT SUM(f.amount_paid) FROM fees f WHERE f.student_id = s.student_id), 0) as paid_so_far " +
                     "FROM students s " +
                     "JOIN courses c ON s.course = c.course_name";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                double courseFee = rs.getDouble("total_course_fee");
                double paidSoFar = rs.getDouble("paid_so_far");
                double balance = courseFee - paidSoFar;
                
                if (balance > 0) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("student_id", rs.getInt("student_id"));
                    map.put("student_name", rs.getString("student_name"));
                    map.put("course", rs.getString("course"));
                    map.put("total_course_fee", courseFee);
                    map.put("paid_so_far", paidSoFar);
                    map.put("pending_balance", balance);
                    report.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return report;
    }
}
