package com.libvault.util;
// FILE: src/com/libvault/util/PasswordUtil.java

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Salted SHA-256 password hashing. Stored format: "salt$hash" (both Base64).
 * No external library required (unlike BCrypt), so it works out of the box.
 */
public class PasswordUtil {

    public static String hash(String plainPassword) {
        try {
            byte[] salt = new byte[16];
            new SecureRandom().nextBytes(salt);
            byte[] hashed = sha256(plainPassword, salt);
            return Base64.getEncoder().encodeToString(salt) + "$" + Base64.getEncoder().encodeToString(hashed);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Verifies a plain password against a stored value.
     * Supports legacy plaintext values too (old accounts created before hashing was added)
     * so nothing already in the database breaks.
     */
    public static boolean verify(String plainPassword, String stored) {
        if (stored == null) return false;
        if (!stored.contains("$")) {
            return stored.equals(plainPassword); // legacy plaintext row
        }
        try {
            String[] parts = stored.split("\\$", 2);
            byte[] salt = Base64.getDecoder().decode(parts[0]);
            byte[] expected = Base64.getDecoder().decode(parts[1]);
            byte[] actual = sha256(plainPassword, salt);
            return MessageDigest.isEqual(expected, actual);
        } catch (Exception e) {
            return false;
        }
    }

    public static boolean isLegacyPlaintext(String stored) {
        return stored != null && !stored.contains("$");
    }

    private static byte[] sha256(String password, byte[] salt) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(salt);
        return md.digest(password.getBytes("UTF-8"));
    }
}
