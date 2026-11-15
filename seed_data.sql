INSERT INTO Universities (Name, Rector, Address) VALUES
('Государственный Университет', 'Иванов Иван Иванович', 'г. Тестоград, ул. Университетская, д. 1');

INSERT INTO Faculties (University_id, Name, Dean) VALUES
(1, 'Факультет Информационных Технологий', 'Петров Петр Петрович');

INSERT INTO Departments (Name, Chief, Faculty_id) VALUES
('Кафедра Программирования', 'Сидоров Сидор Сидорович', 1);

INSERT INTO Specialties (Name, Department_id) VALUES
('Прикладная информатика', 1);

INSERT INTO Groups (Course, Specialty_id) VALUES
(1, 1),
(2, 1);

INSERT INTO Students (First_Name, Last_Name, Patronymic, Date_of_brth, number_of_phone, Group_id) VALUES
('Анна', 'Смирнова', 'Алексеевна', '2005-05-15', '89990001122', 1),
('Олег', 'Кузнецов', 'Игоревич', '2004-08-20', '89990003344', 2);

INSERT INTO Teachers (Department_id, Post, First_Name, Last_Name, Patronymic, Experience) VALUES
(1, 'Доцент', 'Мария', 'Волкова', 'Сергеевна', 10);

INSERT INTO Subjects (Teacher_id, Name) VALUES
(1, 'Базы данных');

INSERT INTO Curriculum (Semester, Lecture_hours, Practice_hours, Year_of_signing, Specialty_id, Subject_id) VALUES
(1, 72, 72, 2023, 1, 1);

INSERT INTO Exams (Subject_id, Date_of_exam) VALUES
(1, '2025-01-15');

INSERT INTO Student_performance (Student_id, Exam_id, Mark) VALUES
(1, 1, 5),
(2, 1, 4);