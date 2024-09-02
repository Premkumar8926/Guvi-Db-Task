# Guvi Zen Class Database Schema

This README provides detailed documentation for the SQL database schema used in the Guvi Zen Class project. It includes descriptions of the tables, relationships, and sample SQL queries for managing the data.

## Table of Contents

1. [Database Schema Overview](#database-schema-overview)
2. [Tables and Their Descriptions](#tables-and-their-descriptions)
3. [Sample SQL Queries](#sample-sql-queries)
4. [Data Insertion Examples](#data-insertion-examples)
5. [Relationships and Foreign Keys](#relationships-and-foreign-keys)
6. [Additional Notes](#additional-notes)

## Database Schema Overview

The database schema is designed to manage users, courses, batches, mentors, mock interviews, tasks, task submissions, queries, dashboards, and enrollments for the Guvi Zen Class platform.

## Tables and Their Descriptions

### Users Table

Stores user information.

```sql
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('student', 'instructor', 'admin', 'mentor') NOT NULL,
    profile_picture VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

Courses Table
Stores information about courses.
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    instructor_id INT,
    category VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (instructor_id) REFERENCES Users(user_id)
);

Batches Table
Stores information about batches.
CREATE TABLE Batches (
    batch_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    mentor_id INT,
    batch_name VARCHAR(255) NOT NULL,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (mentor_id) REFERENCES Users(user_id)
);

Mentors Table
Stores mentor-specific information.
CREATE TABLE Mentors (
    mentor_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    expertise_area VARCHAR(255),
    experience_years INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

MockInterviews Table
Stores information about mock interviews.
CREATE TABLE MockInterviews (
    interview_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    mentor_id INT,
    scheduled_at TIMESTAMP,
    feedback TEXT,
    score INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (mentor_id) REFERENCES Mentors(mentor_id)
);

Tasks Table
Stores tasks related to courses.
CREATE TABLE Tasks (
    task_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

TaskSubmissions Table
Stores information about task submissions.
CREATE TABLE TaskSubmissions (
    submission_id INT PRIMARY KEY AUTO_INCREMENT,
    task_id INT,
    user_id INT,
    submission_file VARCHAR(255),
    submitted_at TIMESTAMP,
    grade VARCHAR(50),
    feedback TEXT,
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

Queries Table
Stores user queries related to batches.
CREATE TABLE Queries (
    query_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    batch_id INT,
    query_text TEXT,
    status ENUM('open', 'resolved') DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (batch_id) REFERENCES Batches(batch_id)
);

Dashboards Table
Stores user dashboard information.
CREATE TABLE Dashboards (
    dashboard_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    batch_id INT,
    progress DECIMAL(5,2),
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (batch_id) REFERENCES Batches(batch_id)
);

Enrollments Table
Stores information about course enrollments.
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    course_id INT,
    batch_id INT,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (batch_id) REFERENCES Batches(batch_id)
);

Sample SQL Queries
Inserting Data
Insert a New User
INSERT INTO Users (name, email, password, role, profile_picture) VALUES
('Alice Johnson', 'alice.johnson@example.com', 'hashed_password', 'student', 'alice.jpg');

Insert a New Course
INSERT INTO Courses (title, description, instructor_id, category) VALUES
('Introduction to Python', 'Learn Python from scratch.', 1, 'Programming');

Insert a New Batch
INSERT INTO Batches (course_id, mentor_id, batch_name, start_date, end_date) VALUES
(1, 1, 'Batch 1', '2024-01-01', '2024-06-30');

Insert a New Mentor
INSERT INTO Mentors (user_id, expertise_area, experience_years) VALUES
(1, 'Web Development', 8);

Insert a New Task
INSERT INTO Tasks (course_id, title, description, due_date) VALUES
(1, 'Build a Web App', 'Create a web application using Flask.', '2024-03-01');

Insert a New Task Submission
INSERT INTO TaskSubmissions (task_id, user_id, submission_file, submitted_at, grade, feedback) VALUES
(1, 1, 'webapp.zip', '2024-02-28', 'A', 'Excellent submission!');

Insert a New Query
INSERT INTO Queries (user_id, batch_id, query_text, status) VALUES
(1, 1, 'How to integrate a database with Flask?', 'open');

Insert Dashboard Data
INSERT INTO Dashboards (user_id, batch_id, progress, last_login) VALUES
(1, 1, 75.00, '2024-03-01 10:00:00');

Insert Enrollment
INSERT INTO Enrollments (user_id, course_id, batch_id) VALUES
(1, 1, 1);

Querying Data
Retrieve All Users
SELECT * FROM Users;

Retrieve All Courses with Their Instructors
SELECT Courses.title, Courses.description, Users.name AS instructor_name
FROM Courses
JOIN Users ON Courses.instructor_id = Users.user_id;

Retrieve Batches for a Specific Course
SELECT * FROM Batches WHERE course_id = 1;

Retrieve All Tasks and Their Submissions
SELECT Tasks.title, TaskSubmissions.submission_file, TaskSubmissions.grade
FROM Tasks
LEFT JOIN TaskSubmissions ON Tasks.task_id = TaskSubmissions.task_id;

Retrieve Queries for a Specific Batch
SELECT * FROM Queries WHERE batch_id = 1;

Updating Data
Update User Profile Picture
UPDATE Users SET profile_picture = 'new_picture.jpg' WHERE user_id = 1;

Update Task Due Date
UPDATE Tasks SET due_date = '2024-04-01' WHERE task_id = 1;

Deleting Data
Delete a Task
DELETE FROM Tasks WHERE task_id = 1;

Delete a User
DELETE FROM Users WHERE user_id = 1;

## Relationships and Foreign Keys
1. Users can be instructors, mentors, or students.
1. Courses are taught by Users (instructors).
1. Batches are associated with Courses and Users (mentors).
1. Mentors are also Users.
1. MockInterviews link Users with Mentors.
1. Tasks are associated with Courses.
1. TaskSubmissions are linked to Tasks and Users.
1. Queries are associated with Users and Batches.
1. Dashboards track Users and their Batches progress.
1. Enrollments link Users to Courses and Batches.

## Additional Notes
Ensure that all foreign key constraints are correctly managed to maintain referential integrity.
Indexing frequently queried columns (e.g., user_id, course_id) can improve query performance.
Regularly back up your database to prevent data loss.
