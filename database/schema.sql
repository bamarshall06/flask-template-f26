-- The tables this project needs.
--
-- Run this against your database once, after your instructor gives you a
-- connection string. In Module 4 you replace the `examples` table below with
-- tables of your own.

CREATE TABLE IF NOT EXISTS examples (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    description TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
