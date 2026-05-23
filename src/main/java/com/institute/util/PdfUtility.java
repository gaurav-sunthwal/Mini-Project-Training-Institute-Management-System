package com.institute.util;

import com.institute.model.Student;
import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import java.awt.Color;
import java.io.OutputStream;
import java.util.List;

public class PdfUtility {
    
    public static void generateStudentsPdf(List<Student> students, OutputStream os) {
        Document document = new Document();
        try {
            PdfWriter.getInstance(document, os);
            document.open();
            
            // Fonts
            Font titleFont = new Font(Font.HELVETICA, 20, Font.BOLD, new Color(30, 41, 59));
            Font subtitleFont = new Font(Font.HELVETICA, 12, Font.ITALIC, new Color(100, 116, 139));
            Font headerFont = new Font(Font.HELVETICA, 10, Font.BOLD, Color.WHITE);
            Font bodyFont = new Font(Font.HELVETICA, 9, Font.NORMAL, new Color(51, 65, 85));

            // Title
            Paragraph title = new Paragraph("Tanishq Training Institute", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            
            Paragraph subtitle = new Paragraph("Student Roster & Profiles Report", subtitleFont);
            subtitle.setAlignment(Element.ALIGN_CENTER);
            subtitle.setSpacingAfter(20);
            document.add(subtitle);
            
            // Table (5 columns)
            PdfPTable table = new PdfPTable(5);
            table.setWidthPercentage(100);
            table.setWidths(new float[]{1.0f, 2.5f, 3.0f, 2.5f, 2.0f});
            
            // Table Headers
            String[] headers = {"ID", "Name", "Email", "Course", "Phone"};
            for (String header : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                cell.setBackgroundColor(new Color(79, 70, 229)); // Indigo accent header
                cell.setPadding(8);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(cell);
            }
            
            // Table Body
            for (Student s : students) {
                // ID
                PdfPCell idCell = new PdfPCell(new Phrase(String.valueOf(s.getStudentId()), bodyFont));
                idCell.setPadding(6);
                idCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(idCell);
                
                // Name
                PdfPCell nameCell = new PdfPCell(new Phrase(s.getStudentName(), bodyFont));
                nameCell.setPadding(6);
                table.addCell(nameCell);
                
                // Email
                PdfPCell emailCell = new PdfPCell(new Phrase(s.getEmail(), bodyFont));
                emailCell.setPadding(6);
                table.addCell(emailCell);
                
                // Course
                PdfPCell courseCell = new PdfPCell(new Phrase(s.getCourse(), bodyFont));
                courseCell.setPadding(6);
                table.addCell(courseCell);
                
                // Phone
                PdfPCell phoneCell = new PdfPCell(new Phrase(s.getPhone(), bodyFont));
                phoneCell.setPadding(6);
                phoneCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(phoneCell);
            }
            
            document.add(table);
            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
