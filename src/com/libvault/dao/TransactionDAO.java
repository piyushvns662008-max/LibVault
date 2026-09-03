package com.libvault.dao;
// FILE: src/com/libvault/dao/TransactionDAO.java

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import com.libvault.model.Transaction;
import com.libvault.util.DBConnection;
import com.libvault.util.FineUtil;

public class TransactionDAO {

    private static final int BORROW_DAYS = 14; // loan period

    // ---------- Issue a book to a user ----------
    public boolean issueBook(int bookId, int userId) {
        String sql = "INSERT INTO transactions (book_id, user_id, issue_date, due_date, status) VALUES (?,?,?,?,'ISSUED')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            LocalDate today = LocalDate.now();
            ps.setInt(1, bookId);
            ps.setInt(2, userId);
            ps.setDate(3, Date.valueOf(today));
            ps.setDate(4, Date.valueOf(today.plusDays(BORROW_DAYS)));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ---------- Return a book ----------
    public boolean returnBook(int txnId) {
        Transaction t = getById(txnId);
        if (t == null) return false;
        double fine = FineUtil.calculateFine(t.getDueDate(), Date.valueOf(LocalDate.now()));
        String sql = "UPDATE transactions SET return_date=?, status='RETURNED', fine_amount=? WHERE txn_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(LocalDate.now()));
            ps.setDouble(2, fine);
            ps.setInt(3, txnId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ---------- Renew a book (extends due date by BORROW_DAYS, max 2 renewals) ----------
    public boolean renewBook(int txnId) {
        String sql = "UPDATE transactions SET due_date = DATE_ADD(due_date, INTERVAL ? DAY), renewed_count = renewed_count+1 WHERE txn_id=? AND status='ISSUED' AND renewed_count < 2";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, BORROW_DAYS);
            ps.setInt(2, txnId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public Transaction getById(int txnId) {
        String sql = "SELECT * FROM transactions WHERE txn_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, txnId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs, con);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // Currently borrowed books for a user (status = ISSUED)
    public List<Transaction> getCurrentByUser(int userId) {
        return listByQuery("SELECT * FROM transactions WHERE user_id=? AND status='ISSUED' ORDER BY due_date ASC", userId);
    }

    // Full history for a user (returned books)
    public List<Transaction> getHistoryByUser(int userId) {
        return listByQuery("SELECT * FROM transactions WHERE user_id=? AND status='RETURNED' ORDER BY return_date DESC", userId);
    }

    // Check if a specific user already has a specific book issued (to prevent duplicate borrow)
    public boolean alreadyBorrowed(int userId, int bookId) {
        String sql = "SELECT COUNT(*) FROM transactions WHERE user_id=? AND book_id=? AND status='ISSUED'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // All issued books (admin view)
    public List<Transaction> getAllIssued() {
        return listByQuery("SELECT * FROM transactions WHERE status='ISSUED' ORDER BY due_date ASC", -1);
    }

    // All transactions (admin history view)
    public List<Transaction> getAllTransactions() {
        return listByQuery("SELECT * FROM transactions ORDER BY txn_id DESC", -1);
    }

    public int countIssuedBooks() {
        return singleCount("SELECT COUNT(*) FROM transactions WHERE status='ISSUED'");
    }

    public int countOverdue() {
        return singleCount("SELECT COUNT(*) FROM transactions WHERE status='ISSUED' AND due_date < CURDATE()");
    }

    public double totalFinesCollected() {
        String sql = "SELECT COALESCE(SUM(fine_amount),0) FROM transactions WHERE fine_amount > 0";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public boolean markFinePaid(int txnId) {
        String sql = "UPDATE transactions SET fine_paid=TRUE WHERE txn_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, txnId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private List<Transaction> listByQuery(String sql, int userId) {
        List<Transaction> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (userId != -1) ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs, con));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private int singleCount(String sql) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // Maps row + fetches book title / user name for display convenience
    private Transaction mapRow(ResultSet rs, Connection con) throws SQLException {
        Transaction t = new Transaction();
        t.setTxnId(rs.getInt("txn_id"));
        t.setBookId(rs.getInt("book_id"));
        t.setUserId(rs.getInt("user_id"));
        t.setIssueDate(rs.getDate("issue_date"));
        t.setDueDate(rs.getDate("due_date"));
        t.setReturnDate(rs.getDate("return_date"));
        t.setStatus(rs.getString("status"));
        t.setFineAmount(rs.getDouble("fine_amount"));
        t.setFinePaid(rs.getBoolean("fine_paid"));
        t.setRenewedCount(rs.getInt("renewed_count"));

        try (PreparedStatement ps2 = con.prepareStatement("SELECT title FROM books WHERE book_id=?")) {
            ps2.setInt(1, t.getBookId());
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) t.setBookTitle(rs2.getString("title"));
        }
        try (PreparedStatement ps3 = con.prepareStatement("SELECT name FROM users WHERE user_id=?")) {
            ps3.setInt(1, t.getUserId());
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) t.setUserName(rs3.getString("name"));
        }
        return t;
    }
}
