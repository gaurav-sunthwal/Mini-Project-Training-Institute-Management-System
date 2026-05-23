package com.institute.servlet;

import com.institute.dao.StudentDAO;
import com.institute.model.Student;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;

@WebServlet("/students/upload-photo")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 5,       // 5MB
    maxRequestSize = 1024 * 1024 * 10     // 10MB
)
public class PhotoUploadServlet extends HttpServlet {
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        try {
            int studentId = Integer.parseInt(request.getParameter("student_id"));
            Part part = request.getPart("photo");
            
            if (part != null && part.getSize() > 0) {
                // Establish upload folder directory
                String uploadPath = request.getServletContext().getRealPath("/") + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                // File extension handling
                String fileName = part.getSubmittedFileName();
                String extension = "";
                int i = fileName.lastIndexOf('.');
                if (i > 0) {
                    extension = fileName.substring(i);
                }
                
                // Formulate unique file name
                String uniqueName = "student_" + studentId + "_" + System.currentTimeMillis() + extension;
                String filePath = uploadPath + File.separator + uniqueName;
                part.write(filePath);

                // Update database record mapping
                Student student = studentDAO.getStudentById(studentId);
                if (student != null) {
                    student.setPhotoPath("uploads/" + uniqueName);
                    studentDAO.updateStudent(student);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/students");
    }
}
