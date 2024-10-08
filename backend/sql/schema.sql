CREATE DATABASE social;
USE social;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(6) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,
    profile_picture LONGBLOB
);

CREATE TABLE timelines (
    timeline_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    title VARCHAR(20) NOT NULL,
    is_private BOOLEAN NOT NULL DEFAULT FALSE,
    timeline_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    timeline_last_edit_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	text_font VARCHAR(50) DEFAULT 'Arial',
    bg_color VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE memories (
    memory_id INT AUTO_INCREMENT PRIMARY KEY,
    timeline_id INT,
    memory_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    memory_last_edit_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    memory_description VARCHAR(255),
    picture LONGBLOB,
    FOREIGN KEY (timeline_id) REFERENCES timelines(timeline_id) ON DELETE CASCADE
);

CREATE TABLE timeline_visits (
    visit_id INT AUTO_INCREMENT PRIMARY KEY,
    timeline_id INT,
    visitor_id INT,
    FOREIGN KEY (timeline_id) REFERENCES timelines(timeline_id),
    FOREIGN KEY (visitor_id) REFERENCES users(user_id)
);

DELIMITER //
CREATE TRIGGER update_memories_last_edit_at
BEFORE UPDATE ON memories
FOR EACH ROW
BEGIN
    IF NEW.memory_description <=> OLD.memory_description
        OR NEW.picture <=> OLD.picture THEN
        SET NEW.memory_last_edit_at = CURRENT_TIMESTAMP;
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_timelines_last_edit_at
BEFORE UPDATE ON timelines
FOR EACH ROW
BEGIN
    IF NEW.title <=> OLD.title
        OR NEW.is_private <=> OLD.is_private
        OR NEW.text_font <=> OLD.text_font 
        OR NEW.bg_color <=> OLD.bg_color THEN
        SET NEW.timeline_last_edit_at = CURRENT_TIMESTAMP;
    END IF;
END;
//
DELIMITER ;
