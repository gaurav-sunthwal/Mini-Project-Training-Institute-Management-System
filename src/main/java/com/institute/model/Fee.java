package com.institute.model;

import java.sql.Date;

public class Fee {
    private int paymentId;
    private int studentId;
    private String studentName; // Helper for UI reporting
    private double amountPaid;
    private Date paymentDate;

    public Fee() {}

    public Fee(int paymentId, int studentId, String studentName, double amountPaid, Date paymentDate) {
        this.paymentId = paymentId;
        this.studentId = studentId;
        this.studentName = studentName;
        this.amountPaid = amountPaid;
        this.paymentDate = paymentDate;
    }

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public double getAmountPaid() { return amountPaid; }
    public void setAmountPaid(double amountPaid) { this.amountPaid = amountPaid; }

    public Date getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Date paymentDate) { this.paymentDate = paymentDate; }
}
