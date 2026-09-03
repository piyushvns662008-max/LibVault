package com.libvault.dao;
// FILE: src/com/libvault/dao/BookDAO.java

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.libvault.model.Book;
import com.libvault.util.DBConnection;

public class BookDAO {

    public List<Book> search(String keyword, String category) {
        List<Book> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM books WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (title LIKE ? OR author LIKE ? OR isbn LIKE ?) ");
        }
        if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("All")) {
            sql.append("AND category = ? ");
        }
        sql.append("ORDER BY title ASC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String k = "%" + keyword.trim() + "%";
                ps.setString(idx++, k);
                ps.setString(idx++, k);
                ps.setString(idx++, k);
            }
            if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("All")) {
                ps.setString(idx++, category);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Book> getAll() {
        return search(null, null);
    }

    public Book getById(int id) {
        String sql = "SELECT * FROM books WHERE book_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<String> getAllCategories() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM books WHERE category IS NOT NULL ORDER BY category";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(rs.getString(1));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean addBook(Book b) {
        String sql = "INSERT INTO books (isbn,title,author,category,publisher,pub_year,quantity,available_copies,shelf_location,cover_url,description) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, b.getIsbn());
            ps.setString(2, b.getTitle());
            ps.setString(3, b.getAuthor());
            ps.setString(4, b.getCategory());
            ps.setString(5, b.getPublisher());
            ps.setInt(6, b.getPubYear());
            ps.setInt(7, b.getQuantity());
            ps.setInt(8, b.getQuantity()); // available = quantity on add
            ps.setString(9, b.getShelfLocation());
            ps.setString(10, b.getCoverUrl());
            ps.setString(11, b.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateBook(Book b) {
        String sql = "UPDATE books SET isbn=?,title=?,author=?,category=?,publisher=?,pub_year=?,quantity=?,shelf_location=?,cover_url=?,description=? WHERE book_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, b.getIsbn());
            ps.setString(2, b.getTitle());
            ps.setString(3, b.getAuthor());
            ps.setString(4, b.getCategory());
            ps.setString(5, b.getPublisher());
            ps.setInt(6, b.getPubYear());
            ps.setInt(7, b.getQuantity());
            ps.setString(8, b.getShelfLocation());
            ps.setString(9, b.getCoverUrl());
            ps.setString(10, b.getDescription());
            ps.setInt(11, b.getBookId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteBook(int bookId) {
        String sql = "DELETE FROM books WHERE book_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean changeAvailableCopies(int bookId, int delta) {
        String sql = "UPDATE books SET available_copies = available_copies + ? WHERE book_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, delta);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int countTotalBooks() {
        return singleCount("SELECT COALESCE(SUM(quantity),0) FROM books");
    }

    public int countAvailableBooks() {
        return singleCount("SELECT COALESCE(SUM(available_copies),0) FROM books");
    }

    private int singleCount(String sql) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Book mapRow(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setBookId(rs.getInt("book_id"));
        b.setIsbn(rs.getString("isbn"));
        b.setTitle(rs.getString("title"));
        b.setAuthor(rs.getString("author"));
        b.setCategory(rs.getString("category"));
        b.setPublisher(rs.getString("publisher"));
        b.setPubYear(rs.getInt("pub_year"));
        b.setQuantity(rs.getInt("quantity"));
        b.setAvailableCopies(rs.getInt("available_copies"));
        b.setShelfLocation(rs.getString("shelf_location"));
        b.setCoverUrl(rs.getString("cover_url"));
        b.setDescription(rs.getString("description"));
        return b;
    }
}
