CREATE TABLE universities (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL UNIQUE,
	address VARCHAR(200)
);

CREATE TABLE faculties (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	university_id INT NOT NULL REFERENCES universities(id)
);

create TABLE degrees (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

create TABLE ranks (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

CREATE TABLE teachers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	surname VARCHAR(50) NOT NULL,
	patronymic VARCHAR(50),
	gender VARCHAR(7),
	birth_date DATE,
	degree_id INT REFERENCES degrees(id),
	rank_id INT REFERENCES ranks(id)
);

CREATE TABLE departments (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	faculty_id INT NOT NULL REFERENCES faculties(id),
	head_teacher_id INT NOT NULL UNIQUE REFERENCES teachers(id)
);

CREATE TABLE employment (
	id SERIAL PRIMARY KEY,
	hire_year INT,
	teacher_id INT NOT NULL REFERENCES teachers(id),
	department_id INT NOT NULL REFERENCES departments(id)
);

CREATE TABLE specialties (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

CREATE TABLE department_specialty (
	id SERIAL PRIMARY KEY,
	department_id INT NOT NULL REFERENCES departments(id),
	specialty_id INT NOT NULL REFERENCES specialties(id),
	starting_year INT
);

CREATE TABLE groups (
	id SERIAL PRIMARY KEY,
	group_number INT NOT NULL,
	course_number INT NOT NULL,
	specialty_id INT NOT NULL REFERENCES specialties(id)
);

CREATE TABLE students (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	surname VARCHAR(50) NOT NULL,
	patronymic VARCHAR(50),
	gender VARCHAR(7),
	birth_date DATE,
	snils VARCHAR(11) UNIQUE NOT NULL,
	passport VARCHAR(10) UNIQUE NOT NULL,
	is_expelled BOOLEAN DEFAULT FALSE,
	group_id INT NOT NULL REFERENCES groups(id)
);

create TABLE order_types (
	id SERIAL PRIMARY KEY,
	name VARCHAR(200) NOT NULL
);

CREATE TABLE student_orders (
	id SERIAL PRIMARY KEY,
	order_date DATE NOT NULL,
    student_id INT NOT NULL REFERENCES students(id),
	order_type INT NOT NULL REFERENCES order_types(id),
	university_id INT REFERENCES universities(id),
	faculty_id INT REFERENCES faculties(id),
	group_id INT REFERENCES groups(id),
	new_university_id INT REFERENCES universities(id),
	new_faculty_id INT REFERENCES faculties(id),
	new_group_id INT REFERENCES groups(id)
);

CREATE TABLE subjects (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

CREATE TABLE grading_types (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

CREATE TABLE study_plans (
	id SERIAL PRIMARY KEY,
	specialty_id INT NOT NULL REFERENCES specialties(id),
	creation_date DATE NOT NULL
);

CREATE TABLE study_plan_subject (
	id SERIAL PRIMARY KEY,
	semester INT NOT NULL,
	lecture_hours INT NOT NULL,
	practice_hours INT NOT NULL,
	study_plan_id INT NOT NULL REFERENCES study_plans(id),
	grading_type INT NOT NULL REFERENCES grading_types(id),
	subject_id INT NOT NULL REFERENCES subjects(id)
);

CREATE TABLE teacher_subject (
	id SERIAL PRIMARY KEY,
	teacher_id INT NOT NULL REFERENCES teachers(id),
	subject_id INT NOT NULL REFERENCES subjects(id),
	study_plan_id INT NOT NULL REFERENCES study_plans(id)
);

CREATE TABLE grades (
	id SERIAL PRIMARY KEY,
	points INT NOT NULL,
	passed BOOLEAN NOT NULL,
	mark INT,
	student_id INT NOT NULL REFERENCES students(id),
	study_plan_subject_id INT NOT NULL REFERENCES study_plan_subject(id)
);

-- ЗАПОЛНЕНИЕ БАЗЫ

INSERT INTO universities (name, address) VALUES
('Саратовский государственный университет', 'г. Саратов, ул. Астраханская, 83'),
('Университет ИТМО', 'г. Санкт-Петербург, Кронверкский проспект, 49, лит. А'),
('Московский физико-технический институт','Московская область, г. Долгопрудный, Институтский переулок, д.9');

INSERT INTO degrees (name) VALUES
('Кандидат физико-математических наук'),
('Доктор физико-математических наук');

INSERT INTO ranks (name) VALUES
('Доцент'), 
('Профессор');

INSERT INTO order_types (name) VALUES
('Зачисление'),
('Отчисление'),
('Перевод'),
('Академический отпуск');

INSERT INTO grading_types (name) VALUES
('Зачёт'),
('Экзамен'),
('Дифференцированный зачёт');

INSERT INTO subjects (name) VALUES 
('Языки программирования'),
('Математический анализ'),
('Базы данных'),
('Дискретная математика'),
('Дополнительные главы фундаментальной подготовки'),
('Информационные технологии и программирование');

INSERT INTO faculties (name, university_id) VALUES
('Факультет КНиИТ', 1),
('Механико-математический факультет', 1),
('Факультет общей и прикладной физики', 2);

INSERT INTO teachers (name, surname, patronymic, gender, birth_date, degree_id, rank_id) VALUES
('Сергей', 'Миронов', 'Владимирович', 'мужской', NULL, 1, 1),
('Инна', 'Батраева', 'Александровна', 'женский', NULL, 1, 1),
('Ирина', 'Сагаева', 'Дмитриевна', 'женский', '1959-09-05', 1, 1),
('Ливат', 'Тяпаев', 'Борисович', 'мужской', NULL, 1, 1),
('Людмила', 'Сахно', 'Владимировна', 'женский', NULL, 1, 1),
('Елена', 'Лапшева', 'Евгеньевна', 'женский', NULL, NULL, NULL),
('Антонина', 'Фёдорова', 'Гавриловна', 'женский', '1946-09-04', 1, 1),
('Марина', 'Огнева', 'Валентиновна', 'женский', NULL, 1, 1),
('Елена', 'Разумовская', 'Владимировна', 'женский', NULL, 1, 1),
('Леонид', 'Колдунов', 'Модестович', 'мужской', '1988-08-08', 1, NULL),
('Валерий', 'Киселёв', 'Валерьевич', 'мужской', '1963-01-21', 2, 2);

INSERT INTO departments (name, faculty_id, head_teacher_id) VALUES
('Кафедра МКиКН', 1, 1),
('Кафедра ДМиИТ', 1, 4),
('Кафедра ИиП', 1, 8),
('Кафедра математического анализа', 2, 9),
('Кафедра теоретической физики', 3, 11);

INSERT INTO employment (hire_year, teacher_id, department_id) VALUES 
(1994, 1, 1),
(2002, 2, 1),
(NULL, 3, 2),
(2008, 4, 2),
(1987, 5, 4),
(1992, 6, 3),
(1979, 7, 1),
(2005, 7, 3),
(2000, 8, 1),
(2004, 8, 3),
(2003, 9, 4),
(2011, 10, 5),
(2003, 11, 5);

INSERT INTO specialties (name) VALUES
('Программная инженерия (ПИ)'),
('Математическое обеспечение и администрирование операционных систем (МОАИС)'),
('Информатика и вычислительная техника (ИВТ)'),
('Математика');

INSERT INTO department_specialty (starting_year, department_id, specialty_id) VALUES
(1978, 1, 1),
(2000, 2, 3),
(2004, 3, 2),
(1935, 4, 4);

INSERT INTO study_plans (specialty_id, creation_date) VALUES
(1, '2015-02-09'),
(2, '2021-09-01'),
(3, '2019-08-30'),
(4, '2001-09-01');

INSERT INTO groups (group_number, course_number, specialty_id) VALUES
(351, 3, 1),
(251, 2, 1),
(273, 6, 2),
(171, 3, 3),
(121, 1, 3),
(111, 1, 4);

INSERT INTO study_plan_subject (semester, lecture_hours, practice_hours, study_plan_id, grading_type, subject_id) VALUES
(5, 32, 32, 1, 2, 1),
(1, 32, 32, 1, 2, 2),
(2, 32, 48, 1, 2, 6),
(9, 32, 64, 2, 2, 5),
(3, 32, 16, 1, 2, 2),
(5, 32, 32, 2, 2, 3),
(5, 32, 32, 1, 2, 3),
(1, 64, 64, 4, 2, 2), 
(2, 32, 32, 1, 1, 4);

INSERT INTO teacher_subject (teacher_id, subject_id, study_plan_id) VALUES
(1, 1, 1),
(2, 3, 1),
(2, 3, 2),
(3, 4, 1),
(4, 5, 2),
(4, 5, 3);

-- ДАЛЬШЕ ВЫДУМАННЫЕ ДАННЫЕ

INSERT INTO students (name, surname, patronymic, gender, birth_date, snils, passport, is_expelled, group_id) VALUES
('Алексей', 'Иванов', 'Петрович', 'мужской', '2004-03-12', '12345678901', '6314123456', FALSE, 1),
('Дмитрий', 'Петров', 'Сергеевич', 'мужской', '2005-07-22', '23456789012', '6315234567', FALSE, 1),
('Екатерина', 'Смирнова', 'Андреевна', 'женский', '2004-11-05', '34567890123', '6314345678', FALSE, 2),
('Анна', 'Кузнецова', 'Игоревна', 'женский', '2003-01-19', '45678901234', '6313456789', FALSE, 3),
('Сергей', 'Попов', 'Васильевич', 'мужской', '2002-09-30', '56789012345', '6312567890', TRUE, 3),
('Мария', 'Васильева', 'Николаевна', 'женский', '2005-05-14', '67890123456', '6315678901', FALSE, 4),
('Павел', 'Соколов', 'Александрович', 'мужской', '2006-02-02', '78901234567', '6316789012', FALSE, 5),
('Елена', 'Новикова', 'Михайловна', 'женский', '2006-08-25', '89012345678', '6316890123', FALSE, 6);

INSERT INTO student_orders (order_date, student_id, order_type, university_id, faculty_id, group_id, new_university_id, new_faculty_id, new_group_id) VALUES
('2022-09-01', 1, 1, 1, 1, 1, 2, 1, 2),
('2022-09-01', 2, 1, 1, 1, 1, NULL, NULL, 3),
('2022-09-01', 3, 1, 1, 1, 2, NULL, NULL, 4),
('2021-09-01', 4, 1, 1, 1, 3, NULL, NULL, 2),
('2021-09-01', 5, 1, 1, 1, 3, NULL, NULL, 1),
('2024-06-15', 5, 2, 1, 1, 3, NULL, NULL, 1),
('2024-09-01', 6, 1, 1, 1, 4, NULL, NULL, 3),
('2025-09-01', 7, 1, 1, 2, 5, NULL, NULL, 2),
('2025-09-01', 8, 1, 2, 3, 6, 1, 3, 3);

INSERT INTO grades (points, passed, mark, student_id, study_plan_subject_id) VALUES
(85, TRUE, 4, 1, 1),
(95, TRUE, 5, 1, 2),
(40, FALSE, 2, 2, 1),
(72, TRUE, 3, 3, 3),
(90, TRUE, 5, 4, 4),
(55, TRUE, 3, 6, 6), 
(81, TRUE, 4, 7, 8),
(61, TRUE, 3, 8, 9);

-- ЗАПРОСЫ УДАЛЕНИЯ
s
DELETE FROM grades WHERE points < 60;
DELETE FROM student_orders WHERE order_type = 4;
