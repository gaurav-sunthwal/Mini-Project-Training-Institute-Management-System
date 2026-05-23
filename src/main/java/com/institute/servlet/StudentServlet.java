package com.institute.servlet;

import com.institute.dao.StudentDAO;
import com.institute.model.Student;
import com.institute.model.User;
import com.institute.util.EmailUtility;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/students/*")
public class StudentServlet extends HttpServlet {
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
        if ("/delete".equals(pathInfo)) {
            int studentId = Integer.parseInt(request.getParameter("id"));
            studentDAO.deleteStudent(studentId);
            response.sendRedirect(request.getContextPath() + "/students");
        } else {
            List<Student> students = studentDAO.getAllStudents();
            request.setAttribute("students", students);
            request.getRequestDispatcher("/jsp/students.jsp").forward(request, response);
        }
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
        if ("/add".equals(pathInfo)) {
            String name = request.getParameter("student_name");
            String email = request.getParameter("email");
            String course = request.getParameter("course");
            String phone = request.getParameter("phone");

            Student student = new Student();
            student.setStudentName(name);
            student.setEmail(email);
            student.setCourse(course);
            student.setPhone(phone);
            
            boolean success = studentDAO.addStudent(student);
            if (success) {
                // Trigger simulated SMTP welcome email notification
                EmailUtility.sendRegistrationEmail(name, email, course);
            }
            response.sendRedirect(request.getContextPath() + "/students?success=" + success);
        } else if ("/update".equals(pathInfo)) {
            int id = Integer.parseInt(request.getParameter("student_id"));
            String name = request.getParameter("student_name");
            String email = request.getParameter("email");
            String course = request.getParameter("course");
            String phone = request.getParameter("phone");
            String photoPath = request.getParameter("photo_path");

            Student student = studentDAO.getStudentById(id);
            if (student != null) {
                student.setStudentName(name);
                student.setEmail(email);
                student.setCourse(course);
                student.setPhone(phone);
                if (photoPath != null && !photoPath.trim().isEmpty()) {
                    student.setPhotoPath(photoPath);
                }
                studentDAO.updateStudent(student);
            }
            response.sendRedirect(request.getContextPath() + "/students");
        }
    }
}
