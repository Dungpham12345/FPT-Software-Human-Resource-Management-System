
-- Chèn dữ liệu vào bảng JOB_DESCRIPTION
INSERT INTO JOB_DESCRIPTION (JOB_POSITION, DEPARTMENT, CAMPUS, REQUIREMENT, SALARY_RANGE, NUMBER_OF_RECRUITMENT, END_TIME)
VALUES
('Software Engineer', 'IT', 'Campus A', 'Bachelor degree in Computer Science', '8000-10000', 3, '2025-12-31'),
('HR Manager', 'HR', 'Campus B', '5 years of experience in HR', '6000-8000', 1, '2025-12-31'),
('Marketing Specialist', 'Marketing', 'Campus C', 'Bachelor in Marketing', '5000-7000', 2, '2025-12-31'),
('Product Manager', 'Product', 'Campus A', '5 years of product management experience', '7000-9000', 2, '2025-12-31'),
('Sales Executive', 'Sales', 'Campus B', 'Experience in sales', '4000-6000', 4, '2025-12-31'),
('UX Designer', 'Design', 'Campus A', 'Experience in UI/UX design', '6000-8000', 3, '2025-12-31'),
('Project Manager', 'IT', 'Campus C', '5 years in project management', '8000-10000', 2, '2025-12-31'),
('Business Analyst', 'Product', 'Campus B', 'Bachelor in Business Administration', '6000-8000', 2, '2025-12-31'),
('Sales Manager', 'Sales', 'Campus A', 'Experience managing sales teams', '7000-9000', 1, '2025-12-31'),
('Data Analyst', 'IT', 'Campus C', 'Bachelor in Data Science', '6000-8000', 3, '2025-12-31');

-- Chèn dữ liệu vào bảng APPLICANT
INSERT INTO APPLICANT (NAME, PHONE_NUMBER, E_MAIL_ADDRESS, GENDER, EDUCATION, CERTIFICATIONS, SKILLS, EXPERIENCE)
VALUES 
('John Doe', '0987654321', 'john.doe@email.com', 'Male', 'Bachelor in Computer Science', 'Certified Java Developer', 'Java, SQL', '3 years in software development'),
('Mary Jane', '0987654322', 'mary.jane@email.com', 'Female', 'Bachelor in Marketing', 'Google Analytics Certified', 'Digital Marketing, SEO', '4 years in digital marketing'),
('Michael Brown', '0987654323', 'michael.brown@email.com', 'Male', 'Bachelor in HR', 'Certified HR Professional', 'Employee Relations, Recruitment', '5 years in HR'),
('Sophia Wilson', '0987654324', 'sophia.wilson@email.com', 'Female', 'Bachelor in Data Science', 'Data Analysis Certification', 'Python, R, SQL', '2 years in data analysis'),
('David Lee', '0987654325', 'david.lee@email.com', 'Male', 'Bachelor in Business', 'PMP Certified', 'Project Management, Product Lifecycle', '3 years in product management'),
('Emily Kim', '0987654326', 'emily.kim@email.com', 'Female', 'Bachelor in Finance', 'CFA Level 1', 'Financial Analysis, Budgeting', '3 years in finance'),
('Brian Harris', '0987654327', 'brian.harris@email.com', 'Male', 'Bachelor in Sales', 'Certified Sales Professional', 'Sales Strategies, Negotiation', '4 years in sales'),
('Olivia Clark', '0987654328', 'olivia.clark@email.com', 'Female', 'Bachelor in Design', 'UX/UI Design Certified', 'Adobe XD, Sketch', '3 years in design'),
('James Taylor', '0987654329', 'james.taylor@email.com', 'Male', 'Bachelor in Customer Service', 'Customer Service Excellence Certified', 'Customer Support, Problem Solving', '5 years in customer support'),
('Isabella Lewis', '0987654330', 'isabella.lewis@email.com', 'Female', 'Bachelor in IT', 'CompTIA A+ Certified', 'Technical Support, Troubleshooting', '2 years in IT support');

-- Chèn dữ liệu vào bảng CONTRACT
INSERT INTO CONTRACT (APPLICANT_ID, REPRESENTATIVES_ID, START_DATE, END_DATE, SALARY)
VALUES
(1, 1, '2025-02-01 09:00:00', '2026-02-01 09:00:00', 15000),
(2, 2, '2025-03-01 09:00:00', '2026-03-01 09:00:00', 18000),
(3, 3, '2025-04-01 09:00:00', '2026-04-01 09:00:00', 16000),
(4, 4, '2025-05-01 09:00:00', '2026-05-01 09:00:00', 17000),
(5, 5, '2025-06-01 09:00:00', '2026-06-01 09:00:00', 20000),
(6, 6, '2025-07-01 09:00:00', '2026-07-01 09:00:00', 21000),
(7, 7, '2025-08-01 09:00:00', '2026-08-01 09:00:00', 19000),
(8, 8, '2025-09-01 09:00:00', '2026-09-01 09:00:00', 18500),
(9, 9, '2025-10-01 09:00:00', '2026-10-01 09:00:00', 22000),
(10, 10, '2025-11-01 09:00:00', '2026-11-01 09:00:00', 124000);

-- Chèn dữ liệu vào bảng EMPLOYEE
INSERT INTO EMPLOYEE (NAME, DEPARTMENT_ID, ROLE, PHONE_NUMBER, E_MAIL_ADDRESS, CONTRACT_ID)
VALUES
('Alice Nguyen', 1, 'Software Engineer', '0912345678', 'alice.nguyen@email.com', 1),
('Bob Tran', 2, 'Marketing Manager', '0912345679', 'bob.tran@email.com', 2),
('Charlie Le', 3, 'HR Specialist', '0912345680', 'charlie.le@email.com', 3),
('Diana Vu', 1, 'Data Analyst', '0912345681', 'diana.vu@email.com', 4),
('Ethan Pham', 4, 'Product Manager', '0912345682', 'ethan.pham@email.com', 5),
('Fiona Ho', 5, 'Finance Officer', '0912345683', 'fiona.ho@email.com', 6),
('George Bui', 6, 'Sales Executive', '0912345684', 'george.bui@email.com', 7),
('Hannah Dao', 7, 'Product Designer', '0912345685', 'hannah.dao@email.com', 8),
('Ivy Ngo', 8, 'Customer Support', '0912345686', 'ivy.ngo@email.com', 9),
('Jacky Mai', 9, 'Technical Support', '0912345687', 'jacky.mai@email.com', 10);

-- Chèn dữ liệu vào bảng PERSON_IN_CHARGE
INSERT INTO PERSON_IN_CHARGE (JOB_DESCRIPTION_ID, EMPLOYEE_ID)
VALUES
(5, 23),
(5, 33),
(5, 25),
(6, 30),
(6, 25),
(7, 28),
(8, 29),
(9, 30);

-- Chèn dữ liệu vào bảng APPLICATION
INSERT INTO APPLICATION (APPLICANT_ID, JOB_DESCRIPTION_ID, APPLICATION_STATUS)
VALUES
(11, 5, 'Pending'),
(12, 5, 'Accepted'),
(13, 6, 'Interview Scheduled'),
(14, 6, 'Rejected'),
(15, 7, 'Pending'),
(16, 8, 'Accepted'),
(17, 9, 'Pending'),
(18, 9, 'Interview Scheduled'),
(19, 7, 'Rejected'),
(20, 6, 'Pending');

-- Chèn dữ liệu vào bảng INTERVIEW
INSERT INTO INTERVIEW (APPLICATION_ID, INTERVIEW_STATUS, SCHEDULE_DATE, SIDE_NOTE)
VALUES
(1, 'Scheduled', '2025-01-15 10:00:00', 'First round of interview'),
(2, 'Completed',  '2025-01-16 14:00:00', 'Second round of interview'),
(3, 'Scheduled',  '2025-01-17 09:00:00', 'First round of interview'),
(4, 'Completed',  '2025-01-18 11:00:00', 'Rejected in interview'),
(5, 'Scheduled',  '2025-01-19 13:00:00', 'First round of interview'),
(6, 'Completed',  '2025-01-20 15:00:00', 'Second round of interview'),
(7, 'Scheduled',  '2025-01-21 10:00:00', 'First round of interview'),
(8, 'Scheduled',  '2025-01-22 16:00:00', 'First round of interview'),
(9, 'Completed',  '2025-01-23 17:00:00', 'Rejected after interview'),
(10, 'Scheduled',  '2025-01-24 18:00:00', 'First round of interview');


-- Chèn dữ liệu vào bảng INTERVIEW_DETAIL
INSERT INTO INTERVIEW_DETAIL (INTERVIEW_ID, INTERVIEWER_ID, PARTIAL_EVALUATION)
VALUES
(11, 23, 46),
(12, 24, 87),
(13, 25, 78),
(14, 26, 88),
(15, 27, 12),
(16, 28, 65),
(17, 29, 45),
(18, 30, 35),
(19, 31, 20),
(20, 32, 99),
(11, 33, 30),
(12, 23, 70),
(13, 24, 10),
(14, 25, 70),
(15, 26, 93),
(16, 27, 55),
(17, 28, 77);

