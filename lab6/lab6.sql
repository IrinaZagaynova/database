--1. �������� ������� �����.

ALTER TABLE student
ADD FOREIGN KEY (id_group) REFERENCES [group](id_group)

ALTER TABLE lesson
ADD FOREIGN KEY (id_teacher) REFERENCES teacher(id_teacher)

ALTER TABLE lesson
ADD FOREIGN KEY (id_subject) REFERENCES [subject](id_subject)

ALTER TABLE lesson
ADD FOREIGN KEY (id_group) REFERENCES [group](id_group)

ALTER TABLE mark
ADD FOREIGN KEY (id_lesson) REFERENCES lesson(id_lesson)

ALTER TABLE mark
ADD FOREIGN KEY (id_student) REFERENCES student(id_student)

--2. ������ ������ ��������� �� ����������� ���� ��� ��������� ������� ��������. �������� ������ ������ � �������������� view.

CREATE VIEW computer_science_marks AS
SELECT student.name, mark.mark FROM student
JOIN mark ON student.id_student = mark.id_student
JOIN lesson ON mark.id_lesson = lesson.id_lesson
WHERE lesson.id_subject = 2
GO

SELECT * FROM computer_science_marks

DROP VIEW IF EXISTS dbo.computer_science_marks
GO

--3. ���� ���������� � ��������� � ��������� ������� �������� � �������� ��������. ���������� ��������� ��������, �� ������� ������ �� ��������,
--������� ������� � ������. �������� � ���� ���������, �� ����� ������������� ������.

CREATE PROCEDURE get_debtors
@id_group AS INT
AS
	SELECT student.name, [subject].name FROM student
	JOIN [group] ON student.id_group = [group].id_group
	JOIN lesson ON [group].id_group = lesson.id_group
	JOIN [subject] ON lesson.id_subject = [subject].id_subject
	LEFT JOIN mark ON student.id_student = mark.id_student AND lesson.id_lesson = mark.id_lesson
	WHERE [group].id_group = @id_group
	GROUP BY student.name, [subject].name
	HAVING COUNT(mark.mark) = 0
GO
 
EXECUTE get_debtors @id_group = 1;
EXECUTE get_debtors @id_group = 2;
EXECUTE get_debtors @id_group = 3;
EXECUTE get_debtors @id_group = 4;

--4. ���� ������� ������ ��������� �� ������� �������� ��� ��� ���������, �� ������� ���������� �� ����� 35 ���������.

SELECT subject.name, AVG(mark.mark) AS avg_mark FROM mark
JOIN student ON  mark.id_student = student.id_student
JOIN lesson ON  mark.id_lesson = lesson.id_lesson
JOIN [subject] ON lesson.id_subject = [subject].id_subject
GROUP BY [subject].name
HAVING COUNT(student.id_student) >= 35

--5. ���� ������ ��������� ������������� �� �� ���� ���������� ��������� � ��������� ������, �������, ��������, ����. ��� ���������� ������ ���������
--���������� NULL ���� ������.

SELECT student.name, [group].name, subject.name, lesson.date, mark.mark FROM student
JOIN [group] ON student.id_group = [group].id_group
JOIN lesson ON [group].id_group = lesson.id_group
JOIN [subject] ON lesson.id_subject = [subject].id_subject
LEFT JOIN mark ON student.id_student = mark.id_student AND lesson.id_lesson = mark.id_lesson
WHERE [group].name =  N'��'
ORDER BY student.name;

--6. ���� ��������� ������������� ��, ���������� ������ ������� 5 �� �������� �� �� 12.05, �������� ��� ������ �� 1 ����.

BEGIN TRANSACTION 

SELECT mark.mark FROM mark
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN [subject] ON lesson.id_subject = [subject].id_subject
JOIN [group] ON lesson.id_group = [group].id_group
WHERE [group].name = N'��' AND 
	subject.name = N'��' AND
	lesson.date < '12.05.2019'

UPDATE mark
SET mark.mark += 1 
FROM mark
JOIN lesson ON mark.id_lesson = lesson.id_lesson
JOIN [subject] ON lesson.id_subject = [subject].id_subject
JOIN [group] ON lesson.id_group = [group].id_group
WHERE [group].name = N'��' AND 
	subject.name = N'��' AND
	mark.mark < 5 AND 
	lesson.date < '12.05.2019'

ROLLBACK;

--7. �������� ����������� �������.

CREATE NONCLUSTERED INDEX [IX_student_id_group] ON [dbo].[student]
(
	[id_group] ASC
)

CREATE NONCLUSTERED INDEX [IX_lesson_id_group] ON [dbo].[lesson]
(
	[id_group] ASC
)

CREATE NONCLUSTERED INDEX [IX_lesson_id_subject] ON [dbo].[lesson]
(
	[id_subject] ASC
)

CREATE NONCLUSTERED INDEX [IX_lesson_date] ON [dbo].[lesson]
(
	[date] ASC
)

CREATE NONCLUSTERED INDEX [IX_mark_id_lesson] ON [dbo].[mark]
(
	[id_lesson] ASC
)

CREATE NONCLUSTERED INDEX [IX_mark_id_student] ON [dbo].[mark]
(
	[id_student] ASC
)

CREATE NONCLUSTERED INDEX [IX_subject_name] ON [dbo].[subject]
(
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_group_name] ON [dbo].[group]
(
	[name] ASC
)