package com.libvault.servlet;
// FILE: src/com/libvault/servlet/AdminServlet.java

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.libvault.dao.BookDAO;
import com.libvault.dao.TransactionDAO;
import com.libvault.dao.UserDAO;
import com.libvault.model.Book;
import com.libvault.model.User;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private BookDAO bookDAO = new BookDAO();
    private UserDAO userDAO = new UserDAO();
    private TransactionDAO txnDAO = new TransactionDAO();

    private boolean notAdmin(HttpServletRequest req) {
        User u = (User) req.getSession().getAttribute("user");
        return u == null || !"ADMIN".equals(u.getRole());
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (notAdmin(req)) { resp.sendRedirect("login.jsp?error=Admin access only"); return; }
        String action = req.getParameter("action");
        if (action == null) action = "dashboard";

        switch (action) {
            case "dashboard": dashboard(req, resp); break;
            case "books": manageBooks(req, resp); break;
            case "editBook": editBookForm(req, resp); break;
            case "deleteBook": deleteBook(req, resp); break;
            case "users": manageUsers(req, resp); break;
            case "block": toggleUserStatus(req, resp, "BLOCKED"); break;
            case "unblock": toggleUserStatus(req, resp, "ACTIVE"); break;
            case "issue": issueBookForm(req, resp); break;
            case "return": adminReturn(req, resp); break;
            case "renew": adminRenew(req, resp); break;
            case "transactions": viewTransactions(req, resp); break;
            case "fines": manageFines(req, resp); break;
            case "payFine": payFine(req, resp); break;
            default: dashboard(req, resp);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (notAdmin(req)) { resp.sendRedirect("login.jsp?error=Admin access only"); return; }
        String action = req.getParameter("action");
        if ("addBook".equals(action)) addBook(req, resp);
        else if ("updateBook".equals(action)) updateBook(req, resp);
        else if ("issueBook".equals(action)) issueBook(req, resp);
        else resp.sendRedirect("admin?action=dashboard");
    }

    // ---------------- DASHBOARD ----------------
    private void dashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("totalBooks", bookDAO.countTotalBooks());
        req.setAttribute("availableBooks", bookDAO.countAvailableBooks());
        req.setAttribute("issuedBooks", txnDAO.countIssuedBooks());
        req.setAttribute("totalMembers", userDAO.countAllMembers());
        req.setAttribute("overdueBooks", txnDAO.countOverdue());
        req.setAttribute("totalFines", txnDAO.totalFinesCollected());
        req.getRequestDispatcher("admin/dashboard.jsp").forward(req, resp);
    }

    // ---------------- BOOKS ----------------
    private void manageBooks(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        req.setAttribute("books", bookDAO.search(keyword, null));
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher("admin/books.jsp").forward(req, resp);
    }

    private void editBookForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        req.setAttribute("book", bookDAO.getById(id));
        req.getRequestDispatcher("admin/editbook.jsp").forward(req, resp);
    }

    private void addBook(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Book b = readBookFromForm(req, false);
        bookDAO.addBook(b);
        resp.sendRedirect("admin?action=books&msg=Book added successfully");
    }

    private void updateBook(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Book b = readBookFromForm(req, true);
        bookDAO.updateBook(b);
        resp.sendRedirect("admin?action=books&msg=Book updated successfully");
    }

    private void deleteBook(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        bookDAO.deleteBook(id);
        resp.sendRedirect("admin?action=books&msg=Book deleted");
    }

    private Book readBookFromForm(HttpServletRequest req, boolean withId) {
        Book b = new Book();
        if (withId) b.setBookId(Integer.parseInt(req.getParameter("bookId")));
        b.setIsbn(req.getParameter("isbn"));
        b.setTitle(req.getParameter("title"));
        b.setAuthor(req.getParameter("author"));
        b.setCategory(req.getParameter("category"));
        b.setPublisher(req.getParameter("publisher"));
        b.setPubYear(parseIntSafe(req.getParameter("pubYear")));
        b.setQuantity(parseIntSafe(req.getParameter("quantity")));
        b.setShelfLocation(req.getParameter("shelfLocation"));
        b.setCoverUrl(req.getParameter("coverUrl"));
        b.setDescription(req.getParameter("description"));
        return b;
    }

    private int parseIntSafe(String s) {
        try { return Integer.parseInt(s); } catch (Exception e) { return 0; }
    }

    // ---------------- USERS ----------------
    private void manageUsers(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("users", userDAO.getAllUsers());
        req.getRequestDispatcher("admin/users.jsp").forward(req, resp);
    }

    private void toggleUserStatus(HttpServletRequest req, HttpServletResponse resp, String status) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        userDAO.updateStatus(id, status);
        resp.sendRedirect("admin?action=users&msg=User status updated");
    }

    // ---------------- ISSUE / RETURN / RENEW (admin counter) ----------------
    private void issueBookForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("users", userDAO.getAllUsers());
        req.setAttribute("books", bookDAO.getAll());
        req.getRequestDispatcher("admin/issuebook.jsp").forward(req, resp);
    }

    private void issueBook(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int bookId = Integer.parseInt(req.getParameter("bookId"));
        int userId = Integer.parseInt(req.getParameter("userId"));
        Book b = bookDAO.getById(bookId);
        if (b == null || b.getAvailableCopies() <= 0) {
            resp.sendRedirect("admin?action=issue&error=No copies available");
            return;
        }
        if (txnDAO.alreadyBorrowed(userId, bookId)) {
            resp.sendRedirect("admin?action=issue&error=User already has this book");
            return;
        }
        txnDAO.issueBook(bookId, userId);
        bookDAO.changeAvailableCopies(bookId, -1);
        resp.sendRedirect("admin?action=transactions&msg=Book issued successfully");
    }

    private void adminReturn(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int txnId = Integer.parseInt(req.getParameter("txnId"));
        int bookId = Integer.parseInt(req.getParameter("bookId"));
        txnDAO.returnBook(txnId);
        bookDAO.changeAvailableCopies(bookId, 1);
        resp.sendRedirect("admin?action=transactions&msg=Book returned");
    }

    private void adminRenew(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int txnId = Integer.parseInt(req.getParameter("txnId"));
        boolean ok = txnDAO.renewBook(txnId);
        String msg = ok ? "msg=Book renewed for 14 more days" : "error=Renewal limit reached (max 2)";
        resp.sendRedirect("admin?action=transactions&" + msg);
    }

    private void viewTransactions(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("transactions", txnDAO.getAllTransactions());
        req.getRequestDispatcher("admin/transactions.jsp").forward(req, resp);
    }

    // ---------------- FINES ----------------
    private void manageFines(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("transactions", txnDAO.getAllTransactions());
        req.getRequestDispatcher("admin/fines.jsp").forward(req, resp);
    }

    private void payFine(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int txnId = Integer.parseInt(req.getParameter("txnId"));
        txnDAO.markFinePaid(txnId);
        resp.sendRedirect("admin?action=fines&msg=Fine marked as paid");
    }
}
