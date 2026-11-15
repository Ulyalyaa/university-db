-- Создание таблиц
CREATE TABLE Universities (
  University_id integer PRIMARY KEY not null,
  Name varchar,
  Rector varchar,
  Address varchar
);

CREATE TABLE Faculties (
  Faculty_id integer PRIMARY KEY not null,
  University_id integer,
  Name varchar,
  Dean varchar
);

CREATE TABLE Departments (
  Department_id integer PRIMARY KEY not null,
  Name varchar,
  Chief varchar,
  Faculty_id integer
);

CREATE TABLE Specialties (
  Specialty_id integer PRIMARY KEY not null,
  Name varchar,
  Department_id integer
);

CREATE TABLE Groups (
  Group_id integer PRIMARY KEY not null,
  Course integer,
  Specialty_id integer
);

CREATE TABLE Students (
  Student_id integer PRIMARY KEY not null,
  First_Name varchar,
  Last_Name varchar,
  Patronymic varchar null,
  Date_of_brth date,
  number_of_phone varchar(20),
  Group_id integer
);

CREATE TABLE Teachers (
  Teacher_id integer PRIMARY KEY not null,
  Department_id integer,
  Post varchar,
  First_Name varchar,
  Last_Name varchar,
  Patronymic varchar null,
  Experience integer
);

CREATE TABLE Subjects (
  Subject_id integer PRIMARY KEY not null,
  Teacher_id integer,
  Name varchar
);

CREATE TABLE Curriculum (
  Curriculum_id integer PRIMARY KEY not null,
  Semester integer,
  Lecture_hours integer,
  Practice_hours integer,
  Year_of_signing integer,
  Specialty_id integer,
  Subject_id integer
);

CREATE TABLE Exams (
  Exam_id integer PRIMARY KEY not null,
  Subject_id integer,
  Date_of_exam date
);

CREATE TABLE Student_performance (
  Student_performance_id integer PRIMARY KEY not null,
  Student_id integer,
  Exam_id integer,
  Mark integer
);

-- Добавление внешних ключей
ALTER TABLE Faculties ADD FOREIGN KEY (University_id) REFERENCES Universities (University_id);

ALTER TABLE Departments ADD FOREIGN KEY (Faculty_id) REFERENCES Faculties (Faculty_id);

ALTER TABLE Specialties ADD FOREIGN KEY (Department_id) REFERENCES Departments (Department_id);

ALTER TABLE Teachers ADD FOREIGN KEY (Department_id) REFERENCES Departments (Department_id);

ALTER TABLE Groups ADD FOREIGN KEY (Specialty_id) REFERENCES Specialties (Specialty_id);

ALTER TABLE Subjects ADD FOREIGN KEY (Teacher_id) REFERENCES Teachers (Teacher_id);

ALTER TABLE Exams ADD FOREIGN KEY (Subject_id) REFERENCES Subjects (Subject_id);

ALTER TABLE Student_performance ADD FOREIGN KEY (Exam_id) REFERENCES Exams (Exam_id);

ALTER TABLE Student_performance ADD FOREIGN KEY (Student_id) REFERENCES Students (Student_id);

ALTER TABLE Curriculum ADD FOREIGN KEY (Subject_id) REFERENCES Subjects (Subject_id);

ALTER TABLE Curriculum ADD FOREIGN KEY (Specialty_id) REFERENCES Specialties (Specialty_id);

ALTER TABLE Students ADD FOREIGN KEY (Group_id) REFERENCES Groups (Group_id);