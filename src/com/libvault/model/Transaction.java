package com.libvault.model;
// FILE: src/com/libvault/model/Transaction.java

import java.sql.Date;

public class Transaction {
    private int txnId;
    private int bookId;
    private int userId;
    private Date issueDate;
    private Date dueDate;
    private Date returnDate;
    private String status; // ISSUED / RETURNED
    private double fineAmount;
    private boolean finePaid;
    private int renewedCount;

    // extra fields filled by joins (for display)
    private String bookTitle;
    private String userName;

    public int getTxnId() { return txnId; }
    public void setTxnId(int txnId) { this.txnId = txnId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Date getIssueDate() { return issueDate; }
    public void setIssueDate(Date issueDate) { this.issueDate = issueDate; }

    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }

    public Date getReturnDate() { return returnDate; }
    public void setReturnDate(Date returnDate) { this.returnDate = returnDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public double getFineAmount() { return fineAmount; }
    public void setFineAmount(double fineAmount) { this.fineAmount = fineAmount; }

    public boolean isFinePaid() { return finePaid; }
    public void setFinePaid(boolean finePaid) { this.finePaid = finePaid; }

    public int getRenewedCount() { return renewedCount; }
    public void setRenewedCount(int renewedCount) { this.renewedCount = renewedCount; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public boolean isOverdue() {
        if (!"ISSUED".equals(status)) return false;
        return dueDate.toLocalDate().isBefore(java.time.LocalDate.now());
    }
}
