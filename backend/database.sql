DROP DATABASE university;
CREATE DATABASE university;

USE university;

CREATE TABLE users (
  id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  firstname VARCHAR(30) NOT NULL,
  lastname VARCHAR(30) NOT NULL,
  department VARCHAR(50) NOT NULL,
  roles SET('user_admin', 'booking_admin', 'teacher','student') NOT NULL,
  type ENUM('DEP', 'ADJUNCT', 'VISITING')
);
DELIMITER //

CREATE TRIGGER check_teacher_role
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF (FIND_IN_SET('teacher', NEW.roles) > 0 AND NEW.type IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Type must be specified for teachers';
    END IF;
END //

DELIMITER ;

CREATE TABLE Classroom (
  id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  building VARCHAR(100) NOT NULL,
  address VARCHAR(200) NOT NULL,
  capacity INT NOT NULL,
  hourly_availability VARCHAR(200) NOT NULL,
  weekly_availability VARCHAR(200) NOT NULL,
  type ENUM('LECTURE', 'LAB') NOT NULL,
  num_computers INT DEFAULT NULL,
  projector BOOLEAN DEFAULT FALSE,
  locked BOOLEAN DEFAULT FALSE
);

CREATE TABLE Instructor (
  id INT(11) NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  type ENUM('Professor', 'Assistant Professor', 'Teaching Assistant') NOT NULL,
  department VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE Room (
  id INT(11) NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  building VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  capacity INT(11) NOT NULL,
  hourly_availability VARCHAR(255) NOT NULL,
  weekly_availability VARCHAR(255) NOT NULL,
  room_type ENUM('Lecture Hall', 'Laboratory') NOT NULL,
  computers INT(11),
  projector BOOLEAN NOT NULL,
  locked BOOLEAN NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE teaching (
    teaching_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    instructors VARCHAR(200) NOT NULL,
    teaching_type ENUM('theory', 'laboratory') NOT NULL,
    semester INT NOT NULL,
    department VARCHAR(50) NOT NULL,
    teaching_hours INT NOT NULL
);


#--Inserts 

INSERT INTO users (email, password, firstname, lastname, department, roles, type)
VALUES ('teacher1@example.com', 'teacher1password', 'John', 'Doe', 'Computer Science', 'teacher', 'DEP');

INSERT INTO users (email, password, firstname, lastname, department, roles, type)
VALUES ('teacher2@example.com', 'teacher2password', 'Jane', 'Smith', 'Physics', 'teacher', 'ADJUNCT');

INSERT INTO users (email, password, firstname, lastname, department, roles, type)
VALUES ('teacher3@example.com', 'teacher3password', 'Mark', 'Johnson', 'Mathematics', 'teacher', 'VISITING');

INSERT INTO users (email, password, firstname, lastname, department, roles, type)
VALUES ('admin@example.com', 'adminpassword', 'Admin', 'User', 'Administration', 'user_admin', NULL);

INSERT INTO users (email, password, firstname, lastname, department, roles, type)
VALUES ('bookingadmin@example.com', 'bookingadminpassword', 'Booking', 'Admin', 'Booking Department', 'booking_admin', NULL);

INSERT INTO users (email, password, firstname, lastname, department, roles, type)
VALUES ('student1@example.com', 'student1password', 'Michael', 'Brown', 'Chemistry', 'student', NULL);

INSERT INTO users (email, password, firstname, lastname, department, roles, type)
VALUES ('student2@example.com', 'student2password', 'Emily', 'Williams', 'Biology', 'student', NULL);

INSERT INTO users (email, password, firstname, lastname, department, roles, type)
VALUES ('student3@example.com', 'student3password', 'Sophia', 'Johnson', 'Physics', 'student', NULL);

INSERT INTO users (email, password, firstname, lastname, department, roles, type)
VALUES ('student4@example.com', 'student4password', 'Jacob', 'Smith', 'Mathematics', 'student', NULL);

INSERT INTO users (email, password, firstname, lastname, department, roles, type)
VALUES ('student5@example.com', 'student5password', 'Olivia', 'Davis', 'Computer Science', 'student', NULL);
