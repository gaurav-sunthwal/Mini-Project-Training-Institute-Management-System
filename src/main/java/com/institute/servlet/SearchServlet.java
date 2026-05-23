package com.institute.servlet;

import com.google.gson.Gson;
import com.institute.dao.CourseDAO;
import com.institute.dao.StudentDAO;
import com.institute.model.Course;
import com.institute.model.Student;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/api/search")
public class SearchServlet extends HttpServlet {
    private final StudentDAO studentDAO = new StudentDAO();
    private final CourseDAO courseDAO = new CourseDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String query = request.getParameter("q");
        String type = request.getParameter("type"); // "student" or "course"
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (query == null) query = "";
        query = query.trim();

        if ("student".equalsIgnoreCase(type)) {
            List<Student> students = studentDAO.searchStudents(query);
            response.getWriter().write(gson.toJson(students));
        } else if ("course".equalsIgnoreCase(type)) {
            List<Course> courses = courseDAO.searchCourses(query);
            response.getWriter().write(gson.toJson(courses));
        } else {
            response.getWriter().write(gson.toJson(Collections.emptyList()));
        }
    }
}
