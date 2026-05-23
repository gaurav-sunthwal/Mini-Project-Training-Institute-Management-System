package com.institute.servlet;

import com.institute.dao.AttendanceDAO;
import com.institute.dao.CourseDAO;
import com.institute.dao.FeeDAO;
import com.institute.dao.StudentDAO;
import com.institute.model.User;
import com.institute.util.EmailUtility;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private final StudentDAO studentDAO = new StudentDAO();
    private final CourseDAO courseDAO = new CourseDAO();
    private final FeeDAO feeDAO = new FeeDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        // Aggregate statistics metrics
        int totalStudents = studentDAO.getTotalStudentsCount();
        int totalCourses = courseDAO.getTotalCoursesCount();
        double totalRevenue = feeDAO.getTotalRevenue();
        double attendanceRate = attendanceDAO.getOverallAttendanceRate();

        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalCourses", totalCourses);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("attendanceRate", attendanceRate);
        request.setAttribute("emailLogs", EmailUtility.getEmailLogs());

        request.getRequestDispatcher("/jsp/dashboard.jsp").forward(request, response);
    }
}
