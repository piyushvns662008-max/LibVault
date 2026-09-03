package com.libvault.servlet;
// FILE: src/com/libvault/servlet/ContactServlet.java

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.libvault.util.MailUtil;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String message = req.getParameter("message");

        if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty()
                || message == null || message.trim().isEmpty()) {
            resp.sendRedirect("contact.jsp?error=Please fill in all fields");
            return;
        }

        String body = "New message from LibVault contact form\n\n"
                + "Name: " + name + "\n"
                + "Email: " + email + "\n\n"
                + "Message:\n" + message;

        MailUtil.send(MailUtil.ADMIN_EMAIL, "LibVault Contact Form - " + name, body);

        resp.sendRedirect("contact.jsp?msg=Thanks for reaching out! We'll get back to you soon.");
    }
}
