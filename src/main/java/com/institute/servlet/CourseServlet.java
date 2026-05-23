package com.institute.servlet;

import com.institute.dao.CourseDAO;
import com.institute.model.Course;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/courses/*")
public class CourseServlet extends HttpServlet {
    private final CourseDAO courseDAO = new CourseDAO();

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
            int courseId = Integer.parseInt(request.getParameter("id"));
            courseDAO.deleteCourse(courseId);
            response.sendRedirect(request.getContextPath() + "/courses");
        } else {
            List<Course> courses = courseDAO.getAllCourses();
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("/jsp/courses.jsp").forward(request, response);
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
            String name = request.getParameter("course_name");
            String duration = request.getParameter("duration");
            double fees = Double.parseDouble(request.getParameter("fees"));
            String faculty = request.getParameter("faculty_name");

            Course course = new Course();
            course.setCourseName(name);
            course.setDuration(duration);
            course.setFees(fees);
            course.setFacultyName(faculty);
            
            courseDAO.addCourse(course);
            response.sendRedirect(request.getContextPath() + "/courses");
        } else if ("/update".equals(pathInfo)) {
            int id = Integer.parseInt(request.getParameter("course_id"));
            String name = request.getParameter("course_name");
            String duration = request.getParameter("duration");
            double fees = Double.parseDouble(request.getParameter("fees"));
            String faculty = request.getParameter("faculty_name");

            Course course = new Course(id, name, duration, fees, faculty);
            courseDAO.updateCourse(course);
            response.sendRedirect(request.getContextPath() + "/courses");
        }
    }
}
