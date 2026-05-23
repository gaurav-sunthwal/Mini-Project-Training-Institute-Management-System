package com.institute.servlet;

import com.institute.dao.StudentDAO;
import com.institute.model.Student;
import com.institute.util.PdfUtility;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/reports/*")
public class ReportServlet extends HttpServlet {
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        if ("/download".equals(pathInfo)) {
            List<Student> students = studentDAO.getAllStudents();
            
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"Student_Roster_Report.pdf\"");
            
            try {
                PdfUtility.generateStudentsPdf(students, response.getOutputStream());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            request.getRequestDispatcher("/jsp/reports.jsp").forward(request, response);
        }
    }
}
