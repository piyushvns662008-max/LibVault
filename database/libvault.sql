-- ============================================
-- LibVault Database Schema
-- Run this whole file in MySQL Workbench / CLI
-- FILE: database/libvault.sql
--
-- If you already ran an OLDER version of this file and don't want to
-- start over, just run this one line instead of the whole script:
--   ALTER TABLE users MODIFY password VARCHAR(255) NOT NULL;
-- (passwords are now stored as salted hashes, which need more room)
-- ============================================

CREATE DATABASE IF NOT EXISTS libvault;
USE libvault;

-- ---------- USERS ----------
CREATE TABLE users (
    user_id     INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,  -- stores "salt:hash" (SHA-256), see PasswordUtil.java
    phone       VARCHAR(20),
    role        ENUM('USER','ADMIN') DEFAULT 'USER',
    status      ENUM('ACTIVE','BLOCKED') DEFAULT 'ACTIVE',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------- BOOKS ----------
CREATE TABLE books (
    book_id           INT AUTO_INCREMENT PRIMARY KEY,
    isbn              VARCHAR(30),
    title             VARCHAR(200) NOT NULL,
    author            VARCHAR(150) NOT NULL,
    category          VARCHAR(100),
    publisher         VARCHAR(150),
    pub_year          INT,
    quantity          INT DEFAULT 1,
    available_copies  INT DEFAULT 1,
    shelf_location    VARCHAR(50),
    cover_url         VARCHAR(300),
    description       TEXT
);

-- ---------- TRANSACTIONS ----------
CREATE TABLE transactions (
    txn_id        INT AUTO_INCREMENT PRIMARY KEY,
    book_id       INT NOT NULL,
    user_id       INT NOT NULL,
    issue_date    DATE NOT NULL,
    due_date      DATE NOT NULL,
    return_date   DATE NULL,
    status        ENUM('ISSUED','RETURNED') DEFAULT 'ISSUED',
    fine_amount   DECIMAL(10,2) DEFAULT 0,
    fine_paid     BOOLEAN DEFAULT FALSE,
    renewed_count INT DEFAULT 0,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ---------- Default admin login: admin@libvault.com / admin123 ----------
-- (password below is the salted SHA-256 hash of "admin123", format "base64salt$base64hash" - matches PasswordUtil.java)
INSERT INTO users (name, email, password, phone, role, status)
VALUES ('Administrator', 'admin@libvault.com', 'w1pLzphg6tnoh0b5q+7i6w==$ZPO5i1ZVxF6Qf10QyRZNbXB8UkESzTHgKBvjJ5/Z67I=', '9999999999', 'ADMIN', 'ACTIVE');

-- ---------- Sample books ----------
INSERT INTO books (isbn, title, author, category, publisher, pub_year, quantity, available_copies, shelf_location, cover_url, description) VALUES
('9780132350884','Clean Code','Robert C. Martin','Programming','Prentice Hall',2008,4,4,'A1','https://covers.openlibrary.org/b/isbn/9780132350884-M.jpg','A handbook of agile software craftsmanship.'),
('9780439708180','Harry Potter and the Sorcerers Stone','J.K. Rowling','Fiction','Scholastic',1998,5,5,'B2','https://covers.openlibrary.org/b/isbn/9780439708180-M.jpg','A young wizard begins his journey at Hogwarts.'),
('9780061120084','To Kill a Mockingbird','Harper Lee','Fiction','Harper Perennial',1960,3,3,'B3','https://covers.openlibrary.org/b/isbn/9780061120084-M.jpg','A classic of modern American literature.'),
('9780345391803','The Hitchhikers Guide to the Galaxy','Douglas Adams','Sci-Fi','Del Rey',1979,2,2,'C1','https://covers.openlibrary.org/b/isbn/9780345391803-M.jpg','A comic science fiction series.'),
('9780134685991','Effective Java','Joshua Bloch','Programming','Addison-Wesley',2017,3,3,'A2','https://covers.openlibrary.org/b/isbn/9780134685991-M.jpg','Best practices for the Java platform.');
