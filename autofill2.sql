WITH existing_groups AS (
    SELECT array_agg(id) AS ids FROM groups
)
INSERT INTO students (name, surname, patronymic, gender, birth_date, snils, passport, is_expelled, group_id)
SELECT 
    (ARRAY['Алексей', 'Дмитрий', 'Иван', 'Сергей', 'Андрей', 'Екатерина', 'Анна', 'Мария', 'Елена', 'Ольга'])[floor(random() * 10 + 1)],
    (ARRAY['Иванов', 'Петров', 'Сидоров', 'Смирнов', 'Кузнецов', 'Попов', 'Васильев', 'Соколов', 'Михайлов', 'Новиков'])[floor(random() * 10 + 1)] || '_' || gs,
    (ARRAY['Александрович', 'Сергеевич', 'Дмитриевич', 'Андреевич', 'Алексеевич', 'Ивановна', 'Петровна', 'Сергеевна'])[floor(random() * 8 + 1)],
    CASE WHEN random() > 0.5 THEN 'мужской' ELSE 'женский' END,
    DATE '1998-01-01' + (random() * 3000)::INT,
    LPAD(gs::TEXT, 11, '0'),
    LPAD(gs::TEXT, 10, '0'),
    (random() > 0.85),
    eg.ids[floor(random() * array_length(eg.ids, 1) + 1)]
FROM generate_series(100, 100099) AS gs
CROSS JOIN existing_groups eg;

WITH refs AS (
    SELECT 
        (SELECT array_agg(id) FROM students) AS s_ids,
        (SELECT array_agg(id) FROM order_types) AS ot_ids,
        (SELECT array_agg(id) FROM universities) AS u_ids,
        (SELECT array_agg(id) FROM faculties) AS f_ids,
        (SELECT array_agg(id) FROM groups) AS g_ids
)
INSERT INTO student_orders (order_date, student_id, order_type, university_id, faculty_id, group_id)
SELECT 
    DATE '2020-09-01' + (random() * 2000)::INT,
    r.s_ids[floor(random() * array_length(r.s_ids, 1) + 1)],
    r.ot_ids[floor(random() * array_length(r.ot_ids, 1) + 1)],
    r.u_ids[floor(random() * array_length(r.u_ids, 1) + 1)],
    r.f_ids[floor(random() * array_length(r.f_ids, 1) + 1)],
    r.g_ids[floor(random() * array_length(r.g_ids, 1) + 1)]
FROM generate_series(1, 150000)
CROSS JOIN refs r;

WITH refs AS (
    SELECT 
        (SELECT array_agg(id) FROM students) AS s_ids,
        (SELECT array_agg(id) FROM study_plan_subject) AS sps_ids
)
INSERT INTO grades (points, passed, mark, student_id, study_plan_subject_id)
SELECT 
    floor(random() * 101)::INT,
    (random() > 0.2),
    floor(random() * 4 + 2)::INT,
    r.s_ids[floor(random() * array_length(r.s_ids, 1) + 1)],
    r.sps_ids[floor(random() * array_length(r.sps_ids, 1) + 1)]
FROM generate_series(1, 200000)
CROSS JOIN refs r;
