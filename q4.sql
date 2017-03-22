-- Grader report

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q4;

-- You must not change this table definition.
CREATE TABLE q4 (
	assignment_id integer,
	username varchar(25), 
	num_marked integer, 
	num_not_marked integer,
	min_mark real,
	max_mark real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

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
--CREATE VIEW weighted_grade_table AS
--SELECT group_id, Grade.rubric_id, assignment_id, cast(grade AS real) * weight AS weighted_grade
--FROM RubricItem, Grade
--WHERE RubricItem.rubric_id = Grade.rubric_id;

-- Sum of the weighted_grade (num);
--CREATE VIEW num AS
--SELECT group_id, assignment_id, mark AS numerator
--FROM Result 
--GROUP BY group_id, assignment_id;

-- Percentage of each group.
CREATE VIEW percentage AS
SELECT group_id, assignment_id, 100 * mark/denominator AS mark
FROM denom NATURAL JOIN AssignmentGroup NATURAL JOIN Result;

--Graders linked with assignment_id.
CREATE VIEW grader_groups AS
SELECT Grader.group_id, assignment_id, username
FROM Grader NATURAL JOIN AssignmentGroup;

--Grades each grader has given.
CREATE VIEW grader_mark AS
SELECT assignment_id, group_id, username, mark
FROM grader_groups NATURAL FULL JOIN percentage;

--Number of marked groups per grader.
CREATE VIEW grader_marked AS
SELECT count(mark) AS num_marked, assignment_id, username
FROM grader_mark
GROUP BY assignment_id, username;

--Number of assigned groups per grader.
CREATE VIEW grader_assigned AS
SELECT count(*) AS assigned, assignment_id, username
FROM grader_groups
GROUP BY assignment_id, username;

--Number of marked and unmarked groups per grader.
CREATE VIEW grader_not_marked AS
SELECT (assigned - num_marked) AS num_not_marked, assignment_id, username, num_marked
FROM grader_marked NATURAL JOIN grader_assigned
GROUP BY assignment_id, username, num_marked, assigned;

--Minimum mark per grader.
CREATE VIEW grader_min AS
SELECT outerq.mark as min_mark, outerq.assignment_id, outerq.username
FROM grader_mark as outerq
WHERE mark = 
(SELECT min(innerq.mark)
FROM grader_mark as innerq
WHERE outerq.assignment_id = innerq.assignment_id AND outerq.username = innerq.username 
GROUP BY innerq.assignment_id, innerq.username);

--Maximum mark per grader.
CREATE VIEW grader_max AS
SELECT outerq.mark as max_mark, outerq.assignment_id, outerq.username
FROM grader_mark outerq
WHERE mark = 
(SELECT max(innerq.mark)
FROM grader_mark innerq
WHERE outerq.assignment_id = innerq.assignment_id AND outerq.username = innerq.username 
GROUP BY innerq.assignment_id, innerq.username);

-- Result
CREATE VIEW result_query AS
SELECT DISTINCT grader_not_marked.assignment_id, grader_not_marked.username, grader_not_marked.num_marked, grader_not_marked.num_not_marked, grader_min.min_mark, grader_max.max_mark
FROM grader_not_marked NATURAL JOIN grader_min NATURAL JOIN grader_max;
--WHERE grader_not_marked.assignment_id = grader_min.assignment_id and grader_not_marked.username = grader_min.username and
--grader_not_marked.assignment_id = grader_max.assignment_id and grader_not_marked.username = grader_max.username

-- Final answer.
INSERT INTO q4 (SELECT * FROM result_query);
	-- put a final query here so that its results will go into the table.
