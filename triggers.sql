-- Валидация данных. Проверяет, что количество часов не превышает допустимый лимит
CREATE OR REPLACE FUNCTION check_individual_hours_limit()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.Lecture_hours > 144 THEN
    RAISE EXCEPTION 'Количество лекционных часов не должно превышать 144';
  END IF;
  IF NEW.Practice_hours > 144 THEN
    RAISE EXCEPTION 'Количество практических часов не должно превышать 144';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_curriculum_insert_or_update
BEFORE INSERT OR UPDATE ON Curriculum
FOR EACH ROW EXECUTE FUNCTION check_individual_hours_limit();

-- Защита от удаления связанных данных. Нельзя удалить предмет, если он уже добавлен в учебный план
CREATE OR REPLACE FUNCTION prevent_subject_delete_if_used_in_curriculum()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (SELECT 1 FROM Curriculum WHERE Subject_id = OLD.Subject_id) THEN
    RAISE EXCEPTION 'Невозможно удалить предмет: он используется в учебных планах';
  END IF;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_subject_delete
BEFORE DELETE ON Subjects
FOR EACH ROW EXECUTE FUNCTION prevent_subject_delete_if_used_in_curriculum();

-- Аудит: Логирование добавления преподавателей
CREATE TABLE Teacher_log ( 
    Log_id SERIAL PRIMARY KEY, 
    Teacher_id INT, 
    Action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    Action_description TEXT 
); 

CREATE OR REPLACE FUNCTION log_teacher_insert() 
RETURNS TRIGGER AS $$ 
BEGIN 
    INSERT INTO Teacher_log (Teacher_id, Action_description) 
    VALUES (NEW.Teacher_id, 'Добавлен новый преподаватель'); 
    RETURN NEW; 
END; 
$$ LANGUAGE plpgsql; 

CREATE TRIGGER log_teacher_insert_trigger 
AFTER INSERT ON Teachers 
FOR EACH ROW EXECUTE FUNCTION log_teacher_insert();

-- Аудит: Логирование отчисления студентов
CREATE TABLE Students_Expelled (
  Log_id SERIAL PRIMARY KEY,
  Action VARCHAR(50),
  Student_ID INTEGER,
  Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_student_deletion()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO Students_Expelled (Action, Student_ID)
  VALUES ('EXPELLED', OLD.Student_id);
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_student_deletion_trigger
AFTER DELETE ON Students
FOR EACH ROW EXECUTE FUNCTION log_student_deletion();