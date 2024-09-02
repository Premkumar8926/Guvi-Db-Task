CREATE TABLE [Users] (
  [user_id] int PRIMARY KEY IDENTITY(1, 1),
  [name] varchar(255),
  [email] varchar(255) UNIQUE,
  [password] varchar(255),
  [role] enum(student,instructor,admin,mentor),
  [profile_picture] varchar(255),
  [created_at] timestamp DEFAULT (CURRENT_TIMESTAMP),
  [updated_at] timestamp DEFAULT (CURRENT_TIMESTAMP)
)
GO

CREATE TABLE [Courses] (
  [course_id] int PRIMARY KEY IDENTITY(1, 1),
  [title] varchar(255),
  [description] text,
  [instructor_id] int,
  [category] varchar(255),
  [created_at] timestamp DEFAULT (CURRENT_TIMESTAMP),
  [updated_at] timestamp DEFAULT (CURRENT_TIMESTAMP)
)
GO

CREATE TABLE [Batches] (
  [batch_id] int PRIMARY KEY IDENTITY(1, 1),
  [course_id] int,
  [mentor_id] int,
  [batch_name] varchar(255),
  [start_date] date,
  [end_date] date,
  [created_at] timestamp DEFAULT (CURRENT_TIMESTAMP),
  [updated_at] timestamp DEFAULT (CURRENT_TIMESTAMP)
)
GO

CREATE TABLE [Mentors] (
  [mentor_id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] int,
  [expertise_area] varchar(255),
  [experience_years] int,
  [created_at] timestamp DEFAULT (CURRENT_TIMESTAMP),
  [updated_at] timestamp DEFAULT (CURRENT_TIMESTAMP)
)
GO

CREATE TABLE [MockInterviews] (
  [interview_id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] int,
  [mentor_id] int,
  [scheduled_at] timestamp,
  [feedback] text,
  [score] int,
  [created_at] timestamp DEFAULT (CURRENT_TIMESTAMP),
  [updated_at] timestamp DEFAULT (CURRENT_TIMESTAMP)
)
GO

CREATE TABLE [Tasks] (
  [task_id] int PRIMARY KEY IDENTITY(1, 1),
  [course_id] int,
  [title] varchar(255),
  [description] text,
  [due_date] date,
  [created_at] timestamp DEFAULT (CURRENT_TIMESTAMP),
  [updated_at] timestamp DEFAULT (CURRENT_TIMESTAMP)
)
GO

CREATE TABLE [TaskSubmissions] (
  [submission_id] int PRIMARY KEY IDENTITY(1, 1),
  [task_id] int,
  [user_id] int,
  [submission_file] varchar(255),
  [submitted_at] timestamp,
  [grade] varchar(50),
  [feedback] text
)
GO

CREATE TABLE [Queries] (
  [query_id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] int,
  [batch_id] int,
  [query_text] text,
  [status] enum(open,resolved) DEFAULT 'open',
  [created_at] timestamp DEFAULT (CURRENT_TIMESTAMP),
  [updated_at] timestamp DEFAULT (CURRENT_TIMESTAMP)
)
GO

CREATE TABLE [Dashboards] (
  [dashboard_id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] int,
  [batch_id] int,
  [progress] decimal(5,2),
  [last_login] timestamp,
  [created_at] timestamp DEFAULT (CURRENT_TIMESTAMP),
  [updated_at] timestamp DEFAULT (CURRENT_TIMESTAMP)
)
GO

CREATE TABLE [Enrollments] (
  [enrollment_id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] int,
  [course_id] int,
  [batch_id] int,
  [enrollment_date] timestamp DEFAULT (CURRENT_TIMESTAMP)
)
GO

ALTER TABLE [Courses] ADD FOREIGN KEY ([instructor_id]) REFERENCES [Users] ([user_id])
GO

ALTER TABLE [Batches] ADD FOREIGN KEY ([course_id]) REFERENCES [Courses] ([course_id])
GO

ALTER TABLE [Batches] ADD FOREIGN KEY ([mentor_id]) REFERENCES [Users] ([user_id])
GO

ALTER TABLE [Mentors] ADD FOREIGN KEY ([user_id]) REFERENCES [Users] ([user_id])
GO

ALTER TABLE [MockInterviews] ADD FOREIGN KEY ([user_id]) REFERENCES [Users] ([user_id])
GO

ALTER TABLE [MockInterviews] ADD FOREIGN KEY ([mentor_id]) REFERENCES [Mentors] ([mentor_id])
GO

ALTER TABLE [Tasks] ADD FOREIGN KEY ([course_id]) REFERENCES [Courses] ([course_id])
GO

ALTER TABLE [TaskSubmissions] ADD FOREIGN KEY ([task_id]) REFERENCES [Tasks] ([task_id])
GO

ALTER TABLE [TaskSubmissions] ADD FOREIGN KEY ([user_id]) REFERENCES [Users] ([user_id])
GO

ALTER TABLE [Queries] ADD FOREIGN KEY ([user_id]) REFERENCES [Users] ([user_id])
GO

ALTER TABLE [Queries] ADD FOREIGN KEY ([batch_id]) REFERENCES [Batches] ([batch_id])
GO

ALTER TABLE [Dashboards] ADD FOREIGN KEY ([user_id]) REFERENCES [Users] ([user_id])
GO

ALTER TABLE [Dashboards] ADD FOREIGN KEY ([batch_id]) REFERENCES [Batches] ([batch_id])
GO

ALTER TABLE [Enrollments] ADD FOREIGN KEY ([user_id]) REFERENCES [Users] ([user_id])
GO

ALTER TABLE [Enrollments] ADD FOREIGN KEY ([course_id]) REFERENCES [Courses] ([course_id])
GO

ALTER TABLE [Enrollments] ADD FOREIGN KEY ([batch_id]) REFERENCES [Batches] ([batch_id])
GO


-- Sample Data Insertion
-- Inserting Users
INSERT INTO Users (name, email, password, role) VALUES 
('Alice Johnson', 'alice@example.com', 'password123', 'student'),
('Bob Smith', 'bob@example.com', 'password123', 'mentor'),
('Charles Lee', 'charles@example.com', 'password123', 'instructor'),
('Diana Patel', 'diana@example.com', 'password123', 'admin');

-- Inserting Courses
INSERT INTO Courses (title, description, instructor_id, category) VALUES 
('Full Stack Development', 'Learn to build web applications from scratch', 3, 'Web Development'),
('Data Science Bootcamp', 'Become a data scientist in 12 weeks', 3, 'Data Science');

-- Inserting Batches
INSERT INTO Batches (course_id, mentor_id, batch_name, start_date, end_date) VALUES 
(1, 2, 'FS Batch 2024', '2024-01-10', '2024-06-10'),
(2, 2, 'DS Batch 2024', '2024-02-15', '2024-08-15');

-- Inserting Mentors
INSERT INTO Mentors (user_id, expertise_area, experience_years) VALUES 
(2, 'Full Stack Development', 5),
(2, 'Data Science', 3);

-- Inserting Mock Interviews
INSERT INTO MockInterviews (user_id, mentor_id, scheduled_at, feedback, score) VALUES 
(1, 1, '2024-05-01 10:00:00', 'Great problem-solving skills.', 85);

-- Inserting Tasks
INSERT INTO Tasks (course_id, title, description, due_date) VALUES 
(1, 'Build a To-Do App', 'Create a simple To-Do app with authentication.', '2024-02-10'),
(2, 'Data Analysis Project', 'Analyze the given dataset and present your findings.', '2024-03-20');

-- Inserting Task Submissions
INSERT INTO TaskSubmissions (task_id, user_id, submission_file, submitted_at, grade, feedback) VALUES 
(1, 1, 'todo-app.zip', '2024-02-09', 'A', 'Well done!'),
(2, 1, 'data-analysis-report.pdf', '2024-03-18', 'B+', 'Good effort, needs improvement in visualization.');

-- Inserting Queries
INSERT INTO Queries (user_id, batch_id, query_text, status) VALUES 
(1, 1, 'How to deploy the To-Do app?', 'open'),
(1, 2, 'Which libraries are best for data visualization?', 'resolved');

-- Inserting Dashboards
INSERT INTO Dashboards (user_id, batch_id, progress, last_login) VALUES 
(1, 1, 50.00, '2024-05-01 09:00:00'),
(1, 2, 70.00, '2024-05-01 09:15:00');

-- Inserting Enrollments
INSERT INTO Enrollments (user_id, course_id, batch_id) VALUES 
(1, 1, 1),
(1, 2, 2);
