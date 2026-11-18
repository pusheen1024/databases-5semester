INSERT INTO teachers (name, surname, patronymic, gender, birth_date, degree_id, rank_id)
SELECT 
    (ARRAY['Сергей', 'Иван', 'Алексей', 'Дмитрий', 'Андрей', 'Елена', 'Ирина', 'Марина', 'Анна', 'Ольга'])[floor(random() * 10 + 1)],
    (ARRAY['Смирнов', 'Иванов', 'Петров', 'Павлов', 'Кузнецов', 'Волков', 'Соколов', 'Лебедев', 'Козлов', 'Новиков'])[floor(random() * 10 + 1)] || '_' || gs,
    (ARRAY['Владимирович', 'Александрович', 'Сергеевич', 'Борисович', 'Иванович', 'Дмитриевна', 'Евгеньевна', 'Валентиновна'])[floor(random() * 8 + 1)],
    CASE WHEN random() > 0.5 THEN 'мужской' ELSE 'женский' END,
    DATE '1950-01-01' + (random() * 18000)::INT,
    CASE WHEN random() > 0.3 THEN floor(random() * 2 + 1)::INT ELSE NULL END,
    CASE WHEN random() > 0.4 THEN floor(random() * 2 + 1)::INT ELSE NULL END
FROM generate_series(1, 30000) AS gs;

INSERT INTO employment (hire_year, teacher_id, department_id)
SELECT 
    floor(random() * 45 + 1980)::INT,
    floor(random() * 30000 + 1)::INT,
    floor(random() * 5 + 1)::INT
FROM generate_series(1, 40000);

INSERT INTO study_plan_subject (semester, lecture_hours, practice_hours, study_plan_id, grading_type, subject_id)
SELECT 
    floor(random() * 10 + 1)::INT,
    (floor(random() * 4 + 1) * 16)::INT,
    (floor(random() * 4 + 1) * 16)::INT,
    floor(random() * 4 + 1)::INT,
    floor(random() * 3 + 1)::INT,
    floor(random() * 6 + 1)::INT
FROM generate_series(1, 10000);


