package com.libvault.util;
// FILE: src/com/libvault/util/MailUtil.java
// Requires javax.mail jar in WEB-INF/lib (see README - "javax.mail-1.6.2.jar")

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class MailUtil {

    // ==== EDIT THESE TO YOUR OWN GMAIL + APP PASSWORD (see README for setup) ====
    private static final String HOST = "smtp.gmail.com";
    private static final int PORT = 587;
    private static final String USERNAME = "your-library-email@gmail.com";
    private static final String APP_PASSWORD = "your-16-char-app-password";

    // Where "Contact Us" messages are delivered
    public static final String ADMIN_EMAIL = "your-library-email@gmail.com";

    private static final boolean ENABLED = true; // set false to silently disable all email sending

    public static void send(String to, String subject, String body) {
        if (!ENABLED || to == null || to.isEmpty()) return;
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", HOST);
            props.put("mail.smtp.port", String.valueOf(PORT));

            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(USERNAME, APP_PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USERNAME, "LibVault Library"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
        } catch (Exception e) {
            // Never let a mail failure break borrowing/returning/contact flow
            System.out.println("LibVault mail send failed (check MailUtil credentials): " + e.getMessage());
        }
    }
}
