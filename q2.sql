-- Getting soft

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q2;

-- You must not change this table definition.
CREATE TABLE q2 (
	ta_name varchar(100),
	average_mark_all_assignments real,
	mark_change_first_last real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Weighted out of.
CREATE VIEW weighted_out_of_table AS
SELECT rubric_id, assignment_id, cast(out_of AS real) * weight AS weighted_out_of
FROM RubricItem;

-- Sum of the weighted_out_of (the denom).
CREATE VIEW denom AS
SELECT assignment_id, sum(weighted_out_of) AS denominator
FROM weighted_out_of_table
GROUP BY assignment_id;

-- Weighted actual grade.
CREATE VIEW weighted_grade_table AS
SELECT group_id, Grade.rubric_id, assignment_id, cast(grade AS real) * weight AS weighted_grade
FROM RubricItem, Grade
WHERE RubricItem.rubric_id = Grade.rubric_id;

-- Sum of the weighted_grade (num);
CREATE VIEW num AS
SELECT group_id, assignment_id, sum(weighted_grade) AS numerator
FROM weighted_grade_table
GROUP BY group_id, assignment_id;

-- Percentage of each group.
CREATE VIEW percentage AS
SELECT num.group_id, num.assignment_id, 100 * numerator/denominator AS grade
FROM denom, num
WHERE denom.assignment_id = num.assignment_id;

-- First need to find out the TAs who have graded on every assignment.
-- Table of each ta, the groups assigned to them and the corresponding assignment.
CREATE VIEW augmented_grader AS
SELECT DISTINCT username, assignment_id
FROM Grader NATURAL JOIN AssignmentGroup;

-- Each ta with all assignments.
CREATE VIEW fake_ta AS
SELECT DISTINCT username, assignment_id
FROM (SELECT username FROM Grader) AS G, (SELECT assignment_id FROM Assignment) AS A;

-- TAs who have not graded all assignments.
CREATE VIEW not_graded_all AS
(SELECT * FROM fake_ta)
EXCEPT
(SELECT * FROM augmented_grader);

-- TAs who have graded on every assignment.
CREATE VIEW graded_all AS
(SELECT * FROM augmented_grader)
EXCEPT
(SELECT * FROM not_graded_all);

-- Those TAs who have graded every assignment with number of marks.
CREATE VIEW augmented_graded_all AS
SELECT username, assignment_id, count(mark) AS num_mark
FROM graded_all NATURAL JOIN AssignmentGroup NATURAL JOIN Result
GROUP BY username, assignment_id;

-- TAs who have graded >= 10 groups on each assignment.
CREATE VIEW at_least_10_on_each AS
SELECT username, assignment_id
FROM augmented_graded_all
WHERE num_mark >= 10;

---- TAs who have graded >= 10 groups on each assignment.
--CREATE VIEW at_least_10_on_each AS
--SELECT username, assignment_id
--FROM graded_all NATURAL JOIN AssignmentGroup NATURAL JOIN Result
--GROUP BY username, assignment_id
--HAVING count(mark) >= 10;

-- All those TAs with group_id and due_date.
CREATE VIEW raw AS
SELECT username, group_id, assignment_id, due_date, grade
FROM at_least_10_on_each NATURAL JOIN AssignmentGroup
NATURAL JOIN Assignment NATURAL JOIN percentage;

-- All those TAs with each assignment average grades.
CREATE VIEW raw_avg AS
SELECT username, assignment_id, due_date, avg(grade) AS avg_grade
FROM raw
GROUP BY username, assignment_id, due_date;

-- Those TAs whose average grades have not gone up consistently.
CREATE VIEW not_gone_up AS
SELECT a.username
FROM raw_avg a, raw_avg b
WHERE a.username = b.username AND a.due_date < b.due_date 
AND a.avg_grade > b.avg_grade;

-- TAs whose average has gone up consistently.
CREATE VIEW gone_up AS
(SELECT username FROM raw_avg)
EXCEPT
(SELECT username FROM not_gone_up);

-- Join back the gone_up to raw_avg to get more information of those qualified TAs.
CREATE VIEW filtered_raw_avg AS
SELECT gone_up.username, due_date, avg_grade
FROM gone_up NATURAL JOIN raw_avg;

-- Average mark all assignment.
CREATE VIEW avg_mark_all AS
SELECT username, avg(avg_grade) as average_mark_all_assignments
FROM filtered_raw_avg
GROUP BY username;

-- First assignment due_date.
CREATE VIEW first_due_date AS
SELECT min(due_date) AS due_date
FROM Assignment;

-- Last assignment due_date.
CREATE VIEW last_due_date AS
SELECT max(due_date) AS due_date
FROM Assignment;

-- First due avg
CREATE VIEW first_due_avg AS
SELECT username, avg_grade
FROM filtered_raw_avg, first_due_date
WHERE first_due_date.due_date = filtered_raw_avg.due_date;

-- Last due avg
CREATE VIEW last_due_avg AS
SELECT username, avg_grade
FROM filtered_raw_avg, last_due_date
WHERE last_due_date.due_date = filtered_raw_avg.due_date;

-- Change in first and last assignment average.
CREATE VIEW change_first_last AS
SELECT first_due_avg.username, (last_due_avg.avg_grade - first_due_avg.avg_grade) AS mark_change_first_last
FROM first_due_avg, last_due_avg
WHERE first_due_avg.username = last_due_avg.username;

-- Result.
CREATE VIEW result_query AS
SELECT avg_mark_all.username, average_mark_all_assignments, mark_change_first_last
FROM avg_mark_all NATURAL JOIN change_first_last;

-- Refined result.
CREATE VIEW good_result AS
SELECT CONCAT(firstname, ' ', surname) AS ta_name, average_mark_all_assignments, mark_change_first_last
FROM result_query NATURAL JOIN MarkusUser;

-- Final answer.
INSERT INTO q2 (SELECT * FROM good_result);
	-- put a final query here so that its results will go into the table.