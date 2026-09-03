package com.libvault.servlet;
// FILE: src/com/libvault/servlet/BookServlet.java

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.libvault.dao.BookDAO;
import com.libvault.dao.TransactionDAO;
import com.libvault.model.Book;
import com.libvault.model.Transaction;
import com.libvault.model.User;
import com.libvault.util.MailUtil;

@WebServlet("/book")
public class BookServlet extends HttpServlet {
    private BookDAO bookDAO = new BookDAO();
    private TransactionDAO txnDAO = new TransactionDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list": listBooks(req, resp); break;
            case "details": bookDetails(req, resp); break;
            case "myBooks": myBooks(req, resp); break;
            case "history": history(req, resp); break;
            default: listBooks(req, resp);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("borrow".equals(action)) borrow(req, resp);
        else if ("return".equals(action)) returnBook(req, resp);
        else resp.sendRedirect("book?action=list");
    }

    private void listBooks(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String category = req.getParameter("category");
        List<Book> books = bookDAO.search(keyword, category);
        req.setAttribute("books", books);
        req.setAttribute("categories", bookDAO.getAllCategories());
        req.setAttribute("keyword", keyword);
        req.setAttribute("category", category);
        req.getRequestDispatcher("books.jsp").forward(req, resp);
    }

    private void bookDetails(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Book b = bookDAO.getById(id);
        req.setAttribute("book", b);
        req.getRequestDispatcher("bookdetails.jsp").forward(req, resp);
    }

    private void borrow(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User u = (User) req.getSession().getAttribute("user");
        if (u == null) { resp.sendRedirect("login.jsp"); return; }

        int bookId = Integer.parseInt(req.getParameter("bookId"));
        Book b = bookDAO.getById(bookId);

        if (b == null || b.getAvailableCopies() <= 0) {
            resp.sendRedirect("bookdetails.jsp?id=" + bookId + "&error=No copies available right now");
            return;
        }
        if (txnDAO.alreadyBorrowed(u.getUserId(), bookId)) {
            resp.sendRedirect("bookdetails.jsp?id=" + bookId + "&error=You already have this book issued");
            return;
        }

        boolean ok = txnDAO.issueBook(bookId, u.getUserId());
        if (ok) {
            bookDAO.changeAvailableCopies(bookId, -1);
            MailUtil.send(u.getEmail(), "Book Borrowed - " + b.getTitle(),
                "Hi " + u.getName() + ",\n\n"
                + "You have successfully borrowed \"" + b.getTitle() + "\".\n"
                + "Please return it within 14 days to avoid a late fine of Rs. "
                + com.libvault.util.FineUtil.FINE_PER_DAY + "/day.\n\n"
                + "- LibVault Library");
            resp.sendRedirect("book?action=myBooks&msg=Book borrowed successfully. Due in 14 days.");
        } else {
            resp.sendRedirect("bookdetails.jsp?id=" + bookId + "&error=Something went wrong. Try again.");
        }
    }

    private void returnBook(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User u = (User) req.getSession().getAttribute("user");
        if (u == null) { resp.sendRedirect("login.jsp"); return; }

        int txnId = Integer.parseInt(req.getParameter("txnId"));
        int bookId = Integer.parseInt(req.getParameter("bookId"));

        boolean ok = txnDAO.returnBook(txnId);
        if (ok) {
            bookDAO.changeAvailableCopies(bookId, 1);
            Transaction t = txnDAO.getById(txnId);
            String fineNote = (t != null && t.getFineAmount() > 0)
                ? ("A late fine of Rs. " + t.getFineAmount() + " applies - please settle it at the desk.\n\n")
                : "";
            MailUtil.send(u.getEmail(), "Book Returned - " + (t != null ? t.getBookTitle() : ""),
                "Hi " + u.getName() + ",\n\n"
                + "Thanks for returning your book. " + fineNote
                + "- LibVault Library");
            resp.sendRedirect("book?action=myBooks&msg=Book returned successfully");
        } else {
            resp.sendRedirect("book?action=myBooks&error=Could not process return");
        }
    }

    private void myBooks(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User u = (User) req.getSession().getAttribute("user");
        if (u == null) { resp.sendRedirect("login.jsp"); return; }
        req.setAttribute("myBooks", txnDAO.getCurrentByUser(u.getUserId()));
        req.getRequestDispatcher("myborrowed.jsp").forward(req, resp);
    }

    private void history(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User u = (User) req.getSession().getAttribute("user");
        if (u == null) { resp.sendRedirect("login.jsp"); return; }
        req.setAttribute("history", txnDAO.getHistoryByUser(u.getUserId()));
        req.getRequestDispatcher("history.jsp").forward(req, resp);
    }
}
