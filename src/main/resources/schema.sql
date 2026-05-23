CREATE TABLE IF NOT EXISTS courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    fees DECIMAL(10, 2) NOT NULL,
    faculty_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    course VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    photo_path VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS fees (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    amount_paid DECIMAL(10, 2) NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS users (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    ref_id INT
);
INSERT INTO users (username, password, role, ref_id) SELECT 'admin', 'admin123', 'admin', NULL WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin');
INSERT INTO users (username, password, role, ref_id) SELECT 'faculty', 'faculty123', 'faculty', NULL WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'faculty');
INSERT INTO users (username, password, role, ref_id) SELECT 'student', 'student123', 'student', 1 WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'student');
INSERT INTO users (username, password, role, ref_id) SELECT 'tanishq@institute.com', 'student123', 'student', 1 WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'tanishq@institute.com');

INSERT INTO courses (course_id, course_name, duration, fees, faculty_name) 
SELECT 1, 'Java Full Stack Development', '6 Months', 50000.00, 'Dr. Sarah Connor' 
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE course_id = 1);

INSERT INTO courses (course_id, course_name, duration, fees, faculty_name) 
SELECT 2, 'Python Data Science & ML', '4 Months', 40000.00, 'Prof. Charles Xavier' 
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE course_id = 2);

INSERT INTO courses (course_id, course_name, duration, fees, faculty_name) 
SELECT 3, 'React Native Mobile Apps', '3 Months', 30000.00, 'Mr. Bruce Wayne' 
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE course_id = 3);

INSERT INTO students (student_id, student_name, email, course, phone, photo_path) 
SELECT 1, 'Tanishq Sunthwal', 'tanishq@institute.com', 'Java Full Stack Development', '+91 9876543210', 'uploads/avatar_demo.png' 
WHERE NOT EXISTS (SELECT 1 FROM students WHERE student_id = 1);

INSERT INTO students (student_id, student_name, email, course, phone, photo_path) 
SELECT 2, 'John Doe', 'john.doe@gmail.com', 'Python Data Science & ML', '+1 555-0199', NULL 
WHERE NOT EXISTS (SELECT 1 FROM students WHERE student_id = 2);

INSERT INTO students (student_id, student_name, email, course, phone, photo_path) 
SELECT 3, 'Jane Watson', 'jane.watson@yahoo.com', 'React Native Mobile Apps', '+44 20 7946 0958', NULL 
WHERE NOT EXISTS (SELECT 1 FROM students WHERE student_id = 3);

INSERT INTO fees (payment_id, student_id, amount_paid, payment_date) 
SELECT 1, 1, 25000.00, CURRENT_DATE() 
WHERE NOT EXISTS (SELECT 1 FROM fees WHERE payment_id = 1);

INSERT INTO fees (payment_id, student_id, amount_paid, payment_date) 
SELECT 2, 2, 40000.00, CURRENT_DATE() 
WHERE NOT EXISTS (SELECT 1 FROM fees WHERE payment_id = 2);

INSERT INTO attendance (attendance_id, student_id, date, status) 
SELECT 1, 1, CURRENT_DATE(), 'Present' 
WHERE NOT EXISTS (SELECT 1 FROM attendance WHERE attendance_id = 1);

INSERT INTO attendance (attendance_id, student_id, date, status) 
SELECT 2, 2, CURRENT_DATE(), 'Absent' 
WHERE NOT EXISTS (SELECT 1 FROM attendance WHERE attendance_id = 2);

INSERT INTO attendance (attendance_id, student_id, date, status) 
SELECT 3, 3, CURRENT_DATE(), 'Present' 
WHERE NOT EXISTS (SELECT 1 FROM attendance WHERE attendance_id = 3);
