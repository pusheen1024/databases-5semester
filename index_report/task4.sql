CREATE INDEX idx_surname ON students(surname);
CREATE INDEX idx_student_id ON grades(student_id);
--DROP INDEX idx_surname;
--DROP INDEX idx_student_id;
EXPLAIN ANALYZE
SELECT students.name, students.surname, grades.mark
FROM students
LEFT JOIN grades ON grades.student_id = students.id 
WHERE students.surname = 'Иванов_778';

CREATE INDEX idx_birth_date ON students USING HASH(birth_date);
--DROP INDEX idx_birth_date;
EXPLAIN ANALYZE
SELECT s1.surname, s2.surname, s1.birth_date
FROM students s1
INNER JOIN students s2 ON s1.birth_date = s2.birth_date AND s1.id < s2.id
WHERE s1.birth_date = '2004-05-12';

CREATE INDEX idx_points ON grades(points) INCLUDE (student_id);
CREATE INDEX idx_orders ON student_orders(order_date) INCLUDE (student_id);
--DROP INDEX idx_points;
--DROP INDEX idx_orders;
EXPLAIN ANALYZE
SELECT student_id FROM grades WHERE points = 94
UNION
SELECT student_id FROM student_orders WHERE order_date = '2025-10-26';

CREATE INDEX idx_birth_date ON students(birth_date);
--DROP INDEX idx_birth_date;
EXPLAIN ANALYZE
SELECT name, surname, birth_date
FROM students
WHERE birth_date = (SELECT MIN (birth_date) FROM students);

CREATE UNIQUE INDEX idx_teachers_surname ON teachers(surname);
--DROP INDEX idx_teachers_surname;
EXPLAIN ANALYZE
SELECT name, surname, patronymic
FROM teachers
WHERE surname IN ('Колдунов', 'Сахно', 'Миронов');

CREATE INDEX idx_passport ON students(passport varchar_pattern_ops) INCLUDE (name, surname);
--DROP INDEX idx_passport;
EXPLAIN ANALYZE
SELECT name, surname, OVERLAY (passport PLACING '******' FROM 5 FOR 6) as hidden_passport FROM students
WHERE passport LIKE '63%';

CREATE INDEX idx_birth_year ON students(DATE_PART('year', birth_date));
--DROP INDEX idx_birth_year;
EXPLAIN ANALYZE
SELECT REPLACE(CAST(birth_date as VARCHAR), '-', '.') as str_date FROM students
WHERE DATE_PART('year', birth_date) = 2000;

CREATE INDEX idx_snils ON students USING HASH(SUBSTRING(snils FROM 5 FOR 2));
--DROP INDEX idx_snils;
EXPLAIN ANALYZE
SELECT name, surname, snils FROM students
WHERE SUBSTRING(snils FROM 5 FOR 2) = '01';

CREATE INDEX idx_lecture_hours ON study_plan_subject(lecture_hours)
WHERE lecture_hours >= 30;
--DROP INDEX idx_lecture_hours;
--DROP INDEX idx_lecture_hours1;
EXPLAIN ANALYZE
SELECT subject_id, lecture_hours FROM study_plan_subject
WHERE lecture_hours BETWEEN 32 AND 40;

CREATE INDEX idx_subject_id ON study_plan_subject(subject_id) INCLUDE (lecture_hours);
--DROP INDEX idx_subject_id;
EXPLAIN ANALYZE
SELECT subject_id, lecture_hours FROM study_plan_subject
WHERE study_plan_subject.subject_id = SOME (SELECT id FROM subjects WHERE name ILIKE '%мат%');

CREATE INDEX idx_surname_group_id ON students(group_id, name, surname varchar_pattern_ops);
--DROP INDEX idx_surname_group_id;
EXPLAIN ANALYZE
SELECT surname, name FROM students
WHERE group_id = ANY (SELECT id FROM groups WHERE course_number = 3) AND name = 'Иван' AND surname LIKE 'Иванов%';*

CREATE INDEX idx_birth_month ON students(DATE_PART('month', birth_date)) INCLUDE (surname, name);
--DROP INDEX idx_birth_month;
EXPLAIN ANALYZE
SELECT surname, name, birth_date
FROM students
WHERE DATE_PART('month', birth_date) = EXTRACT (MONTH FROM CURRENT_DATE + INTERVAL '1 month');

CREATE INDEX idx_order_date ON student_orders(order_date) INCLUDE (student_id, order_type)
WHERE student_id <= 1000;
--DROP INDEX idx_order_date;
EXPLAIN ANALYZE
SELECT student_id, order_type,
       CURRENT_TIME AS access_time,
       CURRENT_TIMESTAMP AS access_timestamp,
       CURRENT_TIMESTAMP::TIMESTAMP WITHOUT TIME ZONE AS access_timestamp_without_tz 
FROM student_orders
WHERE order_date >= LOCALTIMESTAMP - INTERVAL '7 days' AND student_id BETWEEN 100 AND 1000;

CREATE INDEX idx_group_id ON students(group_id);
--DROP INDEX idx_group_id;
EXPLAIN ANALYZE
SELECT groups.group_number, s1.students_count
FROM ( SELECT group_id, COUNT(*) AS students_count
       FROM students
       GROUP BY group_id
       HAVING COUNT(*) > 1) s1
INNER JOIN groups ON groups.id = s1.group_id;

CREATE INDEX idx_name_partial ON students USING HASH (name)
WHERE group_id = 1;
--DROP INDEX idx_name_partial;
EXPLAIN ANALYZE
SELECT name, surname, passport
FROM students
WHERE group_id = 1 AND name = 'Иван';
