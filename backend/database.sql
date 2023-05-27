DROP DATABASE IF EXISTS university;
CREATE DATABASE university;
USE university;

CREATE TABLE users (
  firstname VARCHAR(30) NOT NULL,
  lastname VARCHAR(30) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  department VARCHAR(50) NOT NULL,
  roles SET('user_admin', 'booking_admin', 'teacher', 'student') NOT NULL,
  type ENUM('STLS', 'LTS', 'SSS'),
  PRIMARY KEY (firstname, lastname) UNIQUE
);

CREATE TABLE classroom (
  name VARCHAR(100) PRIMARY KEY UNIQUE,
  building VARCHAR(100) NOT NULL,
  address VARCHAR(200) NOT NULL,
  capacity INT NOT NULL,
  hourly_availability VARCHAR(200) NOT NULL,
  weekly_availability VARCHAR(200) NOT NULL,
  type ENUM('LECTURE', 'LAB') NOT NULL,
  num_computers INT,
  projector BOOLEAN DEFAULT FALSE,
  locked BOOLEAN DEFAULT FALSE,
  CONSTRAINT chk_num_computers CHECK (type = 'LECTURE' OR (type = 'LAB' AND num_computers IS NOT NULL))
);

CREATE TABLE teaching (
  teaching_id VARCHAR(100) PRIMARY KEY,
  course_code VARCHAR(10) NOT NULL,
  course_name VARCHAR(100) NOT NULL,
  instructors VARCHAR(200) NOT NULL,
  teaching_type ENUM('theory', 'laboratory') NOT NULL,
  semester INT NOT NULL,
  department VARCHAR(50) NOT NULL,
  teaching_hours INT NOT NULL,
  teacher_firstname VARCHAR(30),
  teacher_lastname VARCHAR(30),
  FOREIGN KEY (teacher_firstname, teacher_lastname) REFERENCES users(firstname, lastname) ON DELETE SET NULL
);

CREATE TABLE reservation (
  id INT AUTO_INCREMENT PRIMARY KEY,
  classroom_name VARCHAR(100) NOT NULL,
  teaching_id VARCHAR(100) NOT NULL,
  reservation_date DATE NOT NULL,
  reservation_hour_start TIME NOT NULL,
  reservation_hour_end TIME NOT NULL,
  CONSTRAINT unique_reservation_hour UNIQUE (classroom_name, reservation_date, reservation_hour)
);

CREATE TABLE reservation_teacher (
  reservation_id INT,
  teacher_firstname VARCHAR(30),
  teacher_lastname VARCHAR(30),
  FOREIGN KEY (reservation_id) REFERENCES reservation(id),
  FOREIGN KEY (teacher_firstname, teacher_lastname) REFERENCES users(firstname, lastname) ON DELETE SET NULL
);

DELIMITER //

CREATE TRIGGER check_teacher_type
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
  IF FIND_IN_SET('teacher', NEW.roles) > 0 AND NEW.type IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Type must be specified for teachers';
  END IF;
END //

CREATE TRIGGER check_teacher_role
BEFORE INSERT ON teaching
FOR EACH ROW
BEGIN
  DECLARE teacher_role_count INT;
  
  IF NEW.teacher_firstname IS NOT NULL AND NEW.teacher_lastname IS NOT NULL THEN
    SELECT COUNT(*) INTO teacher_role_count
    FROM users
    WHERE firstname = NEW.teacher_firstname
    AND lastname = NEW.teacher_lastname
    AND FIND_IN_SET('teacher', roles) > 0;
    
    IF teacher_role_count = 0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid teacher role';
    END IF;
  END IF;
END //

DELIMITER ;


INSERT INTO users (firstname, lastname, email, password, department, roles, type)
VALUES
('test', 'test', 'test@test.com', 'test', 'Computer Science', 'user_admin,teacher', 'Professor'),
('John', 'Doe', 'johndoe@example.com', 'password123', 'Computer Science', 'user_admin,teacher', 'Professor'),
('Jane', 'Smith', 'janesmith@example.com', 'password456', 'Chemistry', 'teacher', 'Assistant Professor'),
('Michael', 'Johnson', 'michaeljohnson@example.com', 'password789', 'Biology', 'teacher', 'Teaching Assistant'),
('Emily', 'Davis', 'emilydavis@example.com', 'password123', 'Physics', 'student', NULL),
('Robert', 'Anderson', 'robertanderson@example.com', 'password456', 'Mathematics', 'student', NULL),
('Jessica', 'Wilson', 'jessicawilson@example.com', 'password789', 'Computer Science', 'booking_admin', NULL),
('David', 'Taylor', 'davidtaylor@example.com', 'password123', 'Chemistry', 'booking_admin', NULL),
('Jennifer', 'Brown', 'jenniferbrown@example.com', 'password456', 'Biology', 'student', NULL),
('Christopher', 'Thomas', 'christopherthomas@example.com', 'password789', 'Physics', 'student', NULL),
('Melissa', 'Robinson', 'melissarobinson@example.com', 'password123', 'Mathematics', 'student', NULL),
('Daniel', 'Miller', 'danielmiller@example.com', 'password456', 'Computer Science', 'teacher', 'Professor'),
('Laura', 'Martinez', 'lauramartinez@example.com', 'password789', 'Chemistry', 'teacher', 'Assistant Professor'),
('Matthew', 'Clark', 'matthewclark@example.com', 'password123', 'Biology', 'teacher', 'Teaching Assistant'),
('Sophia', 'Harris', 'sophiaharris@example.com', 'password456', 'Physics', 'student', NULL),
('William', 'Lee', 'williamlee@example.com', 'password789', 'Mathematics', 'student', NULL),
('Olivia', 'White', 'oliviawhite@example.com', 'password123', 'Computer Science', 'booking_admin', NULL),
('Ethan', 'Turner', 'ethanturner@example.com', 'password456', 'Chemistry', 'booking_admin', NULL),
('Ava', 'Scott', 'avascott@example.com', 'password789', 'Biology', 'student', NULL),
('Alexander', 'Hall', 'alexanderhall@example.com', 'password123', 'Physics', 'student', NULL),
('Mia', 'Young', 'miayoung@example.com', 'password456', 'Mathematics', 'student', NULL);

INSERT INTO classroom (name, building, address, capacity, hourly_availability, weekly_availability, type, num_computers, projector, locked)
VALUES
('C101', 'Engineering Building', '123 Main St', 50, '08:00-18:00', 'Monday-Friday', 'LECTURE', NULL, FALSE, FALSE),
('C102', 'Engineering Building', '123 Main St', 30, '08:00-18:00', 'Monday-Friday', 'LAB', 20, TRUE, FALSE),
('C201', 'Science Building', '456 Oak Ave', 40, '08:00-20:00', 'Monday-Saturday', 'LECTURE', NULL, FALSE, FALSE),
('C202', 'Science Building', '456 Oak Ave', 25, '08:00-20:00', 'Monday-Saturday', 'LAB', 15, TRUE, FALSE),
('C301', 'Arts Building', '789 Elm St', 60, '09:00-17:00', 'Monday-Friday', 'LECTURE', NULL, FALSE, FALSE),
('C302', 'Arts Building', '789 Elm St', 35, '09:00-17:00', 'Monday-Friday', 'LAB', 25, TRUE, FALSE),
('C401', 'Business Building', '567 Pine Ave', 50, '08:00-22:00', 'Monday-Sunday', 'LECTURE', NULL, FALSE, FALSE),
('C402', 'Business Building', '567 Pine Ave', 30, '08:00-22:00', 'Monday-Sunday', 'LAB', 20, TRUE, FALSE),
('C501', 'Library Building', '321 Cedar St', 70, '08:00-19:00', 'Monday-Saturday', 'LECTURE', NULL, FALSE, FALSE),
('C502', 'Library Building', '321 Cedar St', 40, '08:00-19:00', 'Monday-Saturday', 'LAB', 30, TRUE, FALSE);

INSERT INTO teaching (teaching_id, course_code, course_name, instructors, teaching_type, semester, department, teaching_hours, teacher_firstname, teacher_lastname)
VALUES
('T001', 'CS101', 'Introduction to Computer Science', 'John Doe', 'theory', 1, 'Computer Science', 4, 'John', 'Doe'),
('T002', 'CH101', 'General Chemistry', 'Jane Smith', 'theory', 1, 'Chemistry', 3, 'Jane', 'Smith'),
('T003', 'BIO101', 'Biology Basics', 'Michael Johnson', 'theory', 2, 'Biology', 3, 'Michael', 'Johnson'),
('T004', 'PH201', 'Physics I', 'Daniel Miller', 'theory', 1, 'Physics', 4, 'Daniel', 'Miller'),
('T005', 'MATH101', 'Calculus I', 'Laura Martinez', 'theory', 1, 'Mathematics', 4, 'Laura', 'Martinez'),
('T006', 'CS201', 'Data Structures', 'John Doe', 'theory', 2, 'Computer Science', 4, 'John', 'Doe'),
('T007', 'CH202', 'Organic Chemistry', 'Jane Smith', 'theory', 2, 'Chemistry', 3, 'Jane', 'Smith'),
('T008', 'BIO201', 'Genetics', 'Michael Johnson', 'theory', 3, 'Biology', 3, 'Michael', 'Johnson'),
('T009', 'PH301', 'Physics II', 'Daniel Miller', 'theory', 2, 'Physics', 4, 'Daniel', 'Miller'),
('T010', 'MATH201', 'Linear Algebra', 'Laura Martinez', 'theory', 2, 'Mathematics', 4, 'Laura', 'Martinez'),
('T011', 'CS301', 'Algorithms', 'John Doe', 'theory', 3, 'Computer Science', 4, 'John', 'Doe'),
('T012', 'CH303', 'Physical Chemistry', 'Jane Smith', 'theory', 3, 'Chemistry', 3, 'Jane', 'Smith'),
('T013', 'BIO301', 'Cell Biology', 'Michael Johnson', 'theory', 4, 'Biology', 3, 'Michael', 'Johnson'),
('T014', 'PH401', 'Quantum Mechanics', 'Daniel Miller', 'theory', 3, 'Physics', 4, 'Daniel', 'Miller'),
('T015', 'MATH301', 'Probability Theory', 'Laura Martinez', 'theory', 3, 'Mathematics', 4, 'Laura', 'Martinez'),
('T016', 'CS401', 'Database Systems', 'John Doe', 'theory', 4, 'Computer Science', 4, 'John', 'Doe'),
('T017', 'CH404', 'Inorganic Chemistry', 'Jane Smith', 'theory', 4, 'Chemistry', 3, 'Jane', 'Smith'),
('T018', 'BIO401', 'Molecular Biology', 'Michael Johnson', 'theory', 5, 'Biology', 3, 'Michael', 'Johnson'),
('T019', 'PH501', 'Astrophysics', 'Daniel Miller', 'theory', 4, 'Physics', 4, 'Daniel', 'Miller'),
('T020', 'MATH401', 'Number Theory', 'Laura Martinez', 'theory', 4, 'Mathematics', 4, 'Laura', 'Martinez');

INSERT INTO reservation (classroom_name, teaching_id, reservation_date, reservation_hour, teacher_firstname, teacher_lastname)
VALUES
('C101', 'T001', '2023-06-01', '09:00:00', 'John', 'Doe'),
('C102', 'T001', '2023-06-02', '13:30:00', 'John', 'Doe'),
('C201', 'T002', '2023-06-03', '10:00:00', 'Jane', 'Smith'),
('C202', 'T002', '2023-06-04', '14:00:00', 'Jane', 'Smith'),
('C301', 'T003', '2023-06-05', '11:30:00', 'Michael', 'Johnson'),
('C302', 'T003', '2023-06-06', '15:30:00', 'Michael', 'Johnson'),
('C401', 'T004', '2023-06-07', '12:00:00', 'Daniel', 'Miller'),
('C402', 'T004', '2023-06-08', '16:00:00', 'Daniel', 'Miller'),
('C501', 'T005', '2023-06-09', '13:30:00', 'Laura', 'Martinez'),
('C502', 'T005', '2023-06-10', '17:30:00', 'Laura', 'Martinez'),
('C101', 'T006', '2023-06-11', '09:00:00', 'John', 'Doe'),
('C102', 'T006', '2023-06-12', '13:30:00', 'John', 'Doe'),
('C201', 'T007', '2023-06-13', '10:00:00', 'Jane', 'Smith'),
('C202', 'T007', '2023-06-14', '14:00:00', 'Jane', 'Smith'),
('C301', 'T008', '2023-06-15', '11:30:00', 'Michael', 'Johnson'),
('C302', 'T008', '2023-06-16', '15:30:00', 'Michael', 'Johnson'),
('C401', 'T009', '2023-06-17', '12:00:00', 'Daniel', 'Miller'),
('C402', 'T009', '2023-06-18', '16:00:00', 'Daniel', 'Miller'),
('C501', 'T010', '2023-06-19', '13:30:00', 'Laura', 'Martinez'),
('C502', 'T010', '2023-06-20', '17:30:00', 'Laura', 'Martinez');