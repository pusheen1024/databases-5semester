DROP VIEW IF EXISTS view_teachers;
DROP VIEW IF EXISTS view_marks;
DROP VIEW IF EXISTS view_structure;
DROP VIEW IF EXISTS view_students;
DROP VIEW IF EXISTS view_students1;
DROP VIEW IF EXISTS view_students_2007;
DROP VIEW IF EXISTS view_students_2007_expelled;
DROP MATERIALIZED VIEW view_student_orders;
DROP INDEX idx_order_date;
DROP INDEX idx_orders;
DROP INDEX idx_surname_group_id;

CREATE OR REPLACE VIEW view_teachers AS
SELECT
  teachers.surname AS teacher_surname,
  teachers.name AS teacher_name,
  teachers.patronymic AS teacher_patronymic,
  departments.name AS department_name
FROM teachers
RIGHT JOIN departments
ON teachers.id = departments.head_teacher_id;

CREATE OR REPLACE VIEW view_marks AS
SELECT
  students.name AS student_name,
  students.surname AS student_surname,
  grades.points,
  COALESCE (grades.mark::VARCHAR, 'зачёт') AS mark,
  subjects.name AS subject_name
FROM grades
INNER JOIN students ON grades.student_id = students.id
INNER JOIN study_plan_subject ON grades.study_plan_subject_id = study_plan_subject.id
INNER JOIN subjects ON study_plan_subject.subject_id = subjects.id
WHERE students.is_expelled = FALSE;

CREATE OR REPLACE VIEW view_structure AS
SELECT
  REPLACE (departments.name, 'Кафедра', 'Подразделение'),
  faculties.name AS faculty_name,
  universities.name AS university_name
FROM departments
INNER JOIN faculties ON faculties.id = departments.faculty_id
INNER JOIN universities ON universities.id = faculties.university_id;

SELECT pg_get_viewdef('view_teachers', true);
SELECT pg_get_viewdef('view_marks', true);
SELECT pg_get_viewdef('view_structure', true);

SELECT * FROM view_teachers LIMIT 10;
SELECT * FROM view_marks LIMIT 20;
SELECT * FROM view_structure LIMIT 10;

CREATE OR REPLACE VIEW view_students AS
SELECT
  name, surname,
  patronymic,
  gender,
  birth_date,
  is_expelled,
  group_id,
  passport,
  OVERLAY (passport PLACING '******' FROM 5 FOR 6) AS hidden_passport,
  snils
FROM students
WHERE is_expelled = TRUE AND students.gender = 'мужской'
WITH CHECK OPTION;

SELECT pg_get_viewdef('view_students', true);

SELECT * FROM view_students LIMIT 10;

INSERT INTO view_students (name, surname, patronymic, gender, birth_date, passport, snils, group_id, is_expelled)
VALUES ('Иванов', 'Алексей', 'Петрович', 'мужской', '2007-02-09', '6321254567', '6756891254', 1, FALSE);

INSERT INTO view_students (name, surname, patronymic, gender, birth_date, passport, snils, group_id, is_expelled)
VALUES ('Петрова', 'Кристина', 'Олеговна', 'женский', '2005-04-24', '6320249823', '1234012745', 2, TRUE);

INSERT INTO view_students (name, surname, patronymic, gender, birth_date, passport, snils, group_id, is_expelled)
VALUES ('Ефимов', 'Станислав', 'Владимирович', 'мужской', '2006-05-12', '6320391468', '2325151234', 3, TRUE);

CREATE OR REPLACE VIEW view_students1 AS
SELECT
  name, surname,
  patronymic,
  gender,
  birth_date,
  is_expelled,
  group_id,
  passport,
  OVERLAY (passport PLACING '******' FROM 5 FOR 6) AS hidden_passport,
  snils
FROM students
WHERE is_expelled = TRUE AND students.gender = 'мужской';

CREATE VIEW view_students_2007 AS
SELECT * FROM view_students1
WHERE EXTRACT(YEAR FROM birth_date) = 2007
WITH LOCAL CHECK OPTION;

INSERT INTO view_students_2007 (surname, name, patronymic, gender, birth_date, passport, snils, group_id, is_expelled)
VALUES ('Иванов', 'Алексей', 'Петрович', 'мужской', '2007-02-09', '6321254567', '6756891254', 1, FALSE);

INSERT INTO view_students_2007 (surname, name, patronymic, gender, birth_date, passport, snils, group_id, is_expelled)
VALUES ('Петрова', 'Кристина', 'Олеговна', 'женский', '2005-04-24', '6320249823', '1234012745', 2, TRUE);

CREATE VIEW view_students_2007_expelled AS
SELECT * FROM view_students1
WHERE EXTRACT(YEAR FROM birth_date) = 2007
WITH CASCADED CHECK OPTION;

INSERT INTO view_students_2007_expelled (surname, name, patronymic, gender, birth_date, passport, snils, group_id, is_expelled)
VALUES ('Иванов', 'Алексей', 'Петрович', 'мужской', '2007-02-09', '6321254567', '6756891254', 1, FALSE);

INSERT INTO view_students_2007_expelled (surname, name, patronymic, gender, birth_date, passport, snils, group_id, is_expelled)
VALUES ('Афоничев', 'Иван', 'Алексеевич', 'мужской', '2007-01-13', '632125172', '1332067854', 3, TRUE);


CREATE MATERIALIZED VIEW view_student_orders AS
SELECT
  students.surname,
  students.name,
  COUNT(students.id) AS order_count,
  MAX(student_orders.order_date) AS last_order
FROM students
LEFT JOIN student_orders ON students.id = student_orders.student_id
GROUP BY students.surname, students.name;

CREATE MATERIALIZED VIEW view_student_orders AS
SELECT
  students.id,
  students.surname,
  students.name,
  COUNT(student_orders.id) AS order_count,
  MAX(student_orders.order_date) AS last_order
FROM students
LEFT JOIN student_orders ON students.id = student_orders.student_id
GROUP BY students.id, students.surname, students.name;

EXPLAIN ANALYZE
SELECT
  students.id,
  students.surname,
  students.name,
  COUNT(student_orders.id) AS order_count,
  MAX(student_orders.order_date) AS last_order
FROM students
LEFT JOIN student_orders ON students.id = student_orders.student_id
WHERE students.surname LIKE 'Иванов%'
GROUP BY students.id, students.surname, students.name;

CREATE INDEX idx_order_surname ON view_student_orders(surname varchar_pattern_ops);

EXPLAIN ANALYZE
SELECT * FROM view_student_orders
WHERE surname LIKE 'Иванов%';
