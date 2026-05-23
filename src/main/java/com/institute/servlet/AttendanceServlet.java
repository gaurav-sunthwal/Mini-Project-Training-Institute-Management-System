package com.institute.servlet;

import com.institute.dao.AttendanceDAO;
import com.institute.dao.StudentDAO;
import com.institute.model.Attendance;
import com.institute.model.Student;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/attendance/*")
public class AttendanceServlet extends HttpServlet {
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        List<Attendance> attendanceLogs = attendanceDAO.getAttendanceReport();
        List<Student> students = studentDAO.getAllStudents();

        // Calculate attendance percentages for each student to display in UI
        Map<Integer, Double> percentages = new HashMap<>();
        for (Student s : students) {
            percentages.put(s.getStudentId(), attendanceDAO.getAttendancePercentage(s.getStudentId()));
        }

        request.setAttribute("attendanceLogs", attendanceLogs);
        request.setAttribute("students", students);
        request.setAttribute("percentages", percentages);

        request.getRequestDispatcher("/jsp/attendance.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        if ("/mark".equals(pathInfo)) {
            int studentId = Integer.parseInt(request.getParameter("student_id"));
            String status = request.getParameter("status");
            String dateStr = request.getParameter("date");
            
            Date sqlDate;
            if (dateStr == null || dateStr.trim().isEmpty()) {
                sqlDate = new Date(System.currentTimeMillis());
            } else {
                try {
                    sqlDate = Date.valueOf(dateStr);
                } catch (IllegalArgumentException e) {
                    sqlDate = new Date(System.currentTimeMillis());
                }
            }

            attendanceDAO.markAttendance(studentId, sqlDate, status);
            response.sendRedirect(request.getContextPath() + "/attendance");
        }
    }
}
