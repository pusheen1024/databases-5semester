SELECT student_orders.order_date, students.surname, students.name, groups.group_number
FROM student_orders
INNER JOIN students ON students.id = student_orders.student_id
INNER JOIN groups ON groups.id = student_orders.new_group_id;

SELECT teachers.surname, teachers.name, teachers.patronymic, departments.name
FROM teachers
LEFT JOIN departments
ON teachers.id = departments.head_teacher_id;

SELECT teachers.surname, teachers.name, teachers.patronymic, departments.name
FROM teachers
RIGHT JOIN departments
ON teachers.id = departments.head_teacher_id;

SELECT teachers.surname, teachers.name, teachers.patronymic, degrees.name, ranks.name
FROM teachers
FULL JOIN degrees ON teachers.degree_id = degrees.id
FULL JOIN ranks ON teachers.rank_id = ranks.id;

SELECT degrees.name, ranks.name
FROM degrees
CROSS JOIN ranks;

SELECT groups.group_number, students.surname, students.name
FROM groups
CROSS JOIN LATERAL 
(SELECT surname, name FROM students WHERE group_id = groups.id LIMIT 1)
students;

SELECT g1.group_number, g2.group_number, g1.specialty_id
FROM groups g1
INNER JOIN groups g2 ON g1.specialty_id = g2.specialty_id AND g1.id < g2.id;


SELECT surname, name FROM teachers
UNION ALL
SELECT surname, name FROM students;

SELECT employment.teacher_id, teachers.name, teachers.patronymic, teachers.surname 
FROM employment
JOIN teachers ON employment.teacher_id = teachers.id
UNION
SELECT departments.head_teacher_id, teachers.name, teachers.patronymic, teachers.surname 
FROM departments
JOIN teachers ON departments.head_teacher_id = teachers.id;

SELECT id FROM students
EXCEPT
SELECT student_id FROM student_orders WHERE order_type = 2;

SELECT student_id FROM grades WHERE passed = TRUE
INTERSECT
SELECT student_id FROM student_orders;


SELECT name, patronymic, surname FROM teachers
WHERE EXISTS (SELECT departments.id FROM departments WHERE departments.head_teacher_id = teachers.id);

SELECT group_number FROM groups
WHERE specialty_id IN (SELECT id FROM specialties WHERE name = 'Программная инженерия (ПИ)');

SELECT subject_id, subjects.name, lecture_hours FROM study_plan_subject 
INNER JOIN subjects ON subjects.id = study_plan_subject.subject_id
WHERE lecture_hours >= ALL (SELECT lecture_hours FROM study_plan_subject);

SELECT surname, name FROM students
WHERE group_id = ANY (SELECT id FROM groups WHERE course_number = 3);

SELECT group_number FROM groups
WHERE course_number BETWEEN 3 AND 4;

SELECT name, address FROM universities
WHERE address LIKE '%Саратов%';

SELECT name FROM specialties
WHERE name ILIKE '%матема%';


SELECT order_date, student_id,
CASE
	WHEN new_university_id != NULL THEN 'Перевод в другой университет'
	ELSE 'Перевод в рамках университета'
END AS order_status
FROM student_orders
WHERE order_type = 2;


SELECT name, surname, REPLACE(CAST(birth_date as VARCHAR), '-', '.') as str_date FROM students;

SELECT students.name, students.surname, grades.points, COALESCE (grades.mark::VARCHAR, 'зачёт') AS mark
FROM grades
INNER JOIN students ON grades.student_id = students.id;

SELECT DISTINCT teachers.name, teachers.surname, teachers.patronymic, NULLIF (subjects.name, 'Языки программирования')
FROM teacher_subject
INNER JOIN teachers ON teachers.id = teacher_subject.teacher_id
INNER JOIN subjects ON subjects.id = teacher_subject.subject_id;

SELECT GREATEST (grades.points, 50) AS improved_grade, students.name, students.surname
FROM grades
INNER JOIN students ON students.id = grades.student_id;

SELECT subject_id, subjects.name, LEAST (lecture_hours, 32) AS upd_lecture_hours FROM study_plan_subject 
INNER JOIN subjects ON subjects.id = study_plan_subject.subject_id;


SELECT name, surname, OVERLAY (passport PLACING '******' FROM 5 FOR 6) as hidden_passport FROM students;
    
SELECT student_id, study_plan_subject_id,
CASE
	WHEN passed = TRUE THEN CHR (128578)
	ELSE CHR (128577)
END AS funny_exam_result
FROM grades;

SELECT 'Вуз: ' || 
CASE
	WHEN STRPOS ('университет', LOWER (name)) = 0 THEN name
	ELSE LTRIM ( SUBSTRING (name FROM 1 FOR POSITION ('университет' in LOWER(name)) - 1)
	      	   	 || SUBSTRING (name FROM (POSITION ('университет' IN LOWER(NAME)) + LENGTH ('университет'))))
END AS official_university
FROM universities;

SELECT REPLACE (departments.name, 'Кафедра', 'Подразделение'), faculties.name
FROM departments
INNER JOIN faculties ON faculties.id = departments.faculty_id;

SELECT UPPER (name) FROM faculties;

SELECT name, BTRIM (address, 'г. ') FROM universities;


SELECT surname, name, AGE (birth_date) FROM students;

SELECT * FROM student_orders
WHERE order_date >= NOW() - INTERVAL '2 years';

SELECT surname, name, birth_date
FROM students
WHERE EXTRACT (MONTH FROM birth_date) = DATE_PART ('month', CURRENT_DATE + INTERVAL '1 month');

SELECT student_id, order_type, CURRENT_TIME AS access_time FROM student_orders;
SELECT student_id, order_type, CURRENT_TIMESTAMP AS access_timestamp FROM student_orders;
SELECT student_id, order_type, CURRENT_TIMESTAMP::TIMESTAMP WITHOUT TIME ZONE AS access_timestamp FROM student_orders;

SELECT name, surname, LOCALTIMESTAMP as access_date FROM students;


SELECT COUNT (*) AS student_count FROM students;

SELECT name, surname, birth_date
FROM students
WHERE birth_date = (SELECT MIN (birth_date) FROM students);

SELECT name, surname, birth_date
FROM students
WHERE birth_date = (SELECT MAX (birth_date) FROM students);

SELECT MIN (points) FROM grades;
SELECT AVG (points) FROM grades;
SELECT MAX (points) FROM grades;

SELECT SUM (lecture_hours) AS sum_lectures, SUM (practice_hours) AS sum_practices FROM study_plan_subject;

SELECT groups.group_number, COUNT (students.id) AS students_count
FROM students
INNER JOIN groups ON students.group_id = groups.id
GROUP BY groups.group_number
HAVING COUNT (students.id) > 1;

SELECT gender, COUNT (*)
FROM teachers
GROUP BY gender;
