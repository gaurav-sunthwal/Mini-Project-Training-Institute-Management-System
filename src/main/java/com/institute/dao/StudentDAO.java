package com.institute.dao;

import com.institute.config.DatabaseConfig;
import com.institute.model.Student;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    public boolean addStudent(Student student) {
        String studentSql = "INSERT INTO students (student_name, email, course, phone, photo_path) VALUES (?, ?, ?, ?, ?)";
        String userSql = "INSERT INTO users (username, password, role, ref_id) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DatabaseConfig.getConnection();
            conn.setAutoCommit(false); // Begin ACID Transaction

            try (PreparedStatement psStudent = conn.prepareStatement(studentSql, Statement.RETURN_GENERATED_KEYS)) {
                psStudent.setString(1, student.getStudentName());
                psStudent.setString(2, student.getEmail());
                psStudent.setString(3, student.getCourse());
                psStudent.setString(4, student.getPhone());
                psStudent.setString(5, student.getPhotoPath());
                
                int rows = psStudent.executeUpdate();
                if (rows == 0) {
                    conn.rollback();
                    return false;
                }

                int studentId = 0;
                try (ResultSet generatedKeys = psStudent.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        studentId = generatedKeys.getInt(1);
                        student.setStudentId(studentId);
                    }
                }

                // Automatically seed their user account
                try (PreparedStatement psUser = conn.prepareStatement(userSql)) {
                    psUser.setString(1, student.getEmail()); // Username is their email
                    psUser.setString(2, "student123"); // Default password
                    psUser.setString(3, "student"); // Role
                    psUser.setInt(4, studentId);
                    psUser.executeUpdate();
                }

                conn.commit(); // Commit ACID Transaction
                return true;
            } catch (Exception e) {
                if (conn != null) {
                    conn.rollback();
                }
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (Exception ignored) {}
            }
        }
        return false;
    }

    public boolean updateStudent(Student student) {
        String sql = "UPDATE students SET student_name = ?, email = ?, course = ?, phone = ?, photo_path = ? WHERE student_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, student.getStudentName());
            ps.setString(2, student.getEmail());
            ps.setString(3, student.getCourse());
            ps.setString(4, student.getPhone());
            ps.setString(5, student.getPhotoPath());
            ps.setInt(6, student.getStudentId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteStudent(int studentId) {
        String studentSql = "DELETE FROM students WHERE student_id = ?";
        String userSql = "DELETE FROM users WHERE ref_id = ? AND role = 'student'";
        Connection conn = null;
        try {
            conn = DatabaseConfig.getConnection();
            conn.setAutoCommit(false); // Begin Transaction to ensure user credentials match deletion
            try (PreparedStatement psUser = conn.prepareStatement(userSql)) {
                psUser.setInt(1, studentId);
                psUser.executeUpdate();
            }
            try (PreparedStatement psStudent = conn.prepareStatement(studentSql)) {
                psStudent.setInt(1, studentId);
                psStudent.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ignored) {}
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (Exception ignored) {}
            }
        }
        return false;
    }

    public Student getStudentById(int studentId) {
        String sql = "SELECT * FROM students WHERE student_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToStudent(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY student_id DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToStudent(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Student> searchStudents(String query) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM students WHERE LOWER(student_name) LIKE ? OR LOWER(email) LIKE ? OR LOWER(course) LIKE ? ORDER BY student_id DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + query.toLowerCase() + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToStudent(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalStudentsCount() {
        String sql = "SELECT COUNT(*) FROM students";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Student mapResultSetToStudent(ResultSet rs) throws Exception {
        Student s = new Student();
        s.setStudentId(rs.getInt("student_id"));
        s.setStudentName(rs.getString("student_name"));
        s.setEmail(rs.getString("email"));
        s.setCourse(rs.getString("course"));
        s.setPhone(rs.getString("phone"));
        s.setPhotoPath(rs.getString("photo_path"));
        return s;
    }
}
