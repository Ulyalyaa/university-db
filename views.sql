-- Представление 1: Список специальностей и их кафедр
CREATE OR REPLACE VIEW V1_1 AS
SELECT 
    Specialties.Name AS "Название специальности", 
    Specialties.Department_id AS "Номер кафедры"
FROM Specialties;

-- Представление 2: Специальности с привязкой к кафедрам и факультетам
CREATE OR REPLACE VIEW V1_2 AS
SELECT 
    Specialties.Name AS "Название специальности", 
    Departments.Name AS "Название кафедры", 
    Faculties.Name AS "Название факультета"
FROM Specialties
JOIN Departments ON Departments.Department_id = Specialties.Department_id
JOIN Faculties ON Faculties.Faculty_id = Departments.Faculty_id;

-- Представление 3: Объединенная информация о студентах, специальностях и преподавателях
CREATE OR REPLACE VIEW V1_3 AS
SELECT 
    Students.Last_Name AS "Фамилия студента", 
    Students.First_Name AS "Имя студента", 
    Groups.Course AS "Курс", 
    Specialties.Name AS "Название специальности", 
    Faculties.Name AS "Название факультета",
    Teachers.First_Name AS "Имя преподавателя", 
    Teachers.Last_Name AS "Фамилия преподавателя"
FROM Students 
JOIN Groups ON Students.Group_id = Groups.Group_id
JOIN Specialties ON Groups.Specialty_id = Specialties.Specialty_id
JOIN Departments ON Specialties.Department_id = Departments.Department_id
JOIN Faculties ON Departments.Faculty_id = Faculties.Faculty_id
JOIN Teachers ON Departments.Department_id = Teachers.Department_id;

-- Создаем представление только для опытных преподавателей
CREATE OR REPLACE VIEW ExperiencedTeachers AS   
SELECT 
    Teacher_id, 
    First_Name, 
    Last_Name, 
    Experience
FROM Teachers
WHERE Experience > 10
WITH CHECK OPTION;

-- Создаем материализованное представление
CREATE MATERIALIZED VIEW TeacherDepartmentView AS
SELECT 
    t.Teacher_id, 
    d.Name AS Department_Name, 
    t.First_Name, 
    t.Last_Name, 
    t.Experience
FROM Teachers t
JOIN Departments d ON t.Department_id = d.Department_id
WHERE t.Experience > 10;

-- Создаем индекс для быстрого поиска по Teacher_id в материализованном представлении
CREATE INDEX idx_teacher_department_view ON TeacherDepartmentView (Teacher_id);