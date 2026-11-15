-- Средний балл по каждой учебной группе. Оценим общую успеваемость групп для выявления отстающих.
SELECT 
    g.Group_id AS "Номер группы", 
    g.Course AS "Курс",
    ROUND(AVG(sp.Mark), 2) AS "Средний балл группы",
    COUNT(DISTINCT s.Student_id) AS "Количество студентов"
FROM Groups g
JOIN Students s ON g.Group_id = s.Group_id
JOIN Student_performance sp ON s.Student_id = sp.Student_id
GROUP BY g.Group_id, g.Course
ORDER BY "Средний балл группы" DESC;

-- Поиск проблемных предметов. Выявим предметы, где средний балл ниже 4.0 (для деканата).
SELECT 
    sub.Name AS "Название предмета", 
    ROUND(AVG(sp.Mark), 2) AS "Средний балл"
FROM Student_performance sp
JOIN Exams e ON sp.Exam_id = e.Exam_id
JOIN Subjects sub ON e.Subject_id = sub.Subject_id
GROUP BY sub.Name
HAVING AVG(sp.Mark) < 4.0;

-- Рейтинг студентов по успеваемости. Сформируем список лучших студентов для повышенной стипендии.
SELECT 
    s.Last_Name AS "Фамилия", 
    s.First_Name AS "Имя",
    ROUND(AVG(sp.Mark), 2) AS "Средний балл",
    RANK() OVER (ORDER BY AVG(sp.Mark) DESC) AS "Место в рейтинге"
FROM Students s
JOIN Student_performance sp ON s.Student_id = sp.Student_id
GROUP BY s.Student_id, s.Last_Name, s.First_Name
ORDER BY "Место в рейтинге";

-- ЗАПРОС 4: Поиск должников. Найдем студентов, у которых есть хотя бы одна двойка (оценка < 3).
SELECT 
    s.Last_Name AS "Фамилия", 
    s.First_Name AS "Имя"
FROM Students s
WHERE s.Student_id IN (
    SELECT sp.Student_id 
    FROM Student_performance sp 
    WHERE sp.Mark < 3
);

-- Нагрузка преподавателей. Посмотрим, какие преподаватели ведут предметы и на каких кафедрах они работают.
SELECT 
    t.Last_Name AS "Фамилия преподавателя", 
    t.Post AS "Должность",
    d.Name AS "Кафедра",
    sub.Name AS "Предмет"
FROM Teachers t
LEFT JOIN Departments d ON t.Department_id = d.Department_id
LEFT JOIN Subjects sub ON t.Teacher_id = sub.Teacher_id
ORDER BY t.Last_Name;