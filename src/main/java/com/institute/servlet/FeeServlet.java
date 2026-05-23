package com.institute.servlet;

import com.institute.dao.CourseDAO;
import com.institute.dao.FeeDAO;
import com.institute.dao.StudentDAO;
import com.institute.model.Course;
import com.institute.model.Fee;
import com.institute.model.Student;
import com.institute.util.EmailUtility;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;

@WebServlet("/fees/*")
public class FeeServlet extends HttpServlet {
    private final FeeDAO feeDAO = new FeeDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        List<Fee> payments = feeDAO.getAllPayments();
        List<Map<String, Object>> pendingReport = feeDAO.getPendingFeesReport();
        List<Student> students = studentDAO.getAllStudents();

        request.setAttribute("payments", payments);
        request.setAttribute("pendingReport", pendingReport);
        request.setAttribute("students", students);

        request.getRequestDispatcher("/jsp/fees.jsp").forward(request, response);
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
        if ("/pay".equals(pathInfo)) {
            int studentId = Integer.parseInt(request.getParameter("student_id"));
            double amountPaid = Double.parseDouble(request.getParameter("amount_paid"));
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

            Student student = studentDAO.getStudentById(studentId);
            if (student != null) {
                Fee fee = new Fee();
                fee.setStudentId(studentId);
                fee.setAmountPaid(amountPaid);
                fee.setPaymentDate(sqlDate);

                boolean success = feeDAO.recordPayment(fee);
                if (success) {
                    // Calculate outstanding balance for automated email log receipt
                    double totalCourseFee = 0.0;
                    List<Course> courses = courseDAO.getAllCourses();
                    for (Course c : courses) {
                        if (c.getCourseName().equals(student.getCourse())) {
                            totalCourseFee = c.getFees();
                            break;
                        }
                    }

                    // Get total paid so far
                    double paidSoFar = 0.0;
                    List<Fee> studentPayments = feeDAO.getPaymentsByStudentId(studentId);
                    for (Fee p : studentPayments) {
                        paidSoFar += p.getAmountPaid();
                    }
                    
                    double outstandingBalance = totalCourseFee - paidSoFar;
                    if (outstandingBalance < 0) outstandingBalance = 0;

                    // Trigger simulated payment receipt email notification
                    EmailUtility.sendFeePaymentEmail(
                        student.getStudentName(), 
                        student.getEmail(), 
                        amountPaid, 
                        outstandingBalance
                    );
                }
            }
            response.sendRedirect(request.getContextPath() + "/fees");
        }
    }
}
