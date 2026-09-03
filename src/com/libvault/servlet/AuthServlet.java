package com.libvault.servlet;
// FILE: src/com/libvault/servlet/AuthServlet.java

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.libvault.dao.UserDAO;
import com.libvault.model.User;
import com.libvault.util.MailUtil;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("register".equals(action)) {
            handleRegister(req, resp);
        } else if ("login".equals(action)) {
            handleLogin(req, resp);
        } else if ("updateProfile".equals(action)) {
            handleUpdateProfile(req, resp);
        } else {
            resp.sendRedirect("index.jsp");
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("logout".equals(action)) {
            req.getSession().invalidate();
            resp.sendRedirect("index.jsp?msg=Logged out successfully");
        } else {
            resp.sendRedirect("index.jsp");
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");

        if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty()
                || password == null || password.length() < 4) {
            resp.sendRedirect("register.jsp?error=Please fill all fields correctly (password min 4 chars)");
            return;
        }

        User u = new User();
        u.setName(name);
        u.setEmail(email);
        u.setPassword(password);
        u.setPhone(phone);

        boolean ok = userDAO.register(u);
        if (ok) {
            MailUtil.send(email, "Welcome to LibVault",
                "Hi " + name + ",\n\n"
                + "Your LibVault account has been created successfully.\n"
                + "You can now log in and start borrowing books.\n\n"
                + "- LibVault Library");
            resp.sendRedirect("login.jsp?msg=Registration successful. Please login.");
        } else {
            resp.sendRedirect("register.jsp?error=Email already registered or DB error");
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        User u = userDAO.login(email, password);
        if (u == null) {
            resp.sendRedirect("login.jsp?error=Invalid email or password");
            return;
        }
        if ("BLOCKED".equals(u.getStatus())) {
            resp.sendRedirect("login.jsp?error=Your account is blocked. Contact admin.");
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("user", u);
        session.setAttribute("role", u.getRole());

        if ("ADMIN".equals(u.getRole())) {
            resp.sendRedirect("admin/dashboard.jsp");
        } else {
            resp.sendRedirect("index.jsp?msg=Welcome back, " + u.getName());
        }
    }

    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        User u = (User) session.getAttribute("user");
        if (u == null) { resp.sendRedirect("login.jsp"); return; }

        u.setName(req.getParameter("name"));
        u.setPhone(req.getParameter("phone"));
        userDAO.updateProfile(u);
        session.setAttribute("user", u);
        resp.sendRedirect("profile.jsp?msg=Profile updated successfully");
    }
}
