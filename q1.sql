-- Distributions

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q1;

-- You must not change this table definition.
CREATE TABLE q1 (
	assignment_id integer,
	average_mark_percent real, 
	num_80_100 integer, 
	num_60_79 integer, 
	num_50_59 integer, 
	num_0_49 integer
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

-- Percentage of each group.
CREATE VIEW percentage AS
SELECT group_id, assignment_id, 100 * mark/denominator AS grade
FROM denom NATURAL JOIN AssignmentGroup NATURAL JOIN Result;

-- All grades with corresponding assignment_id including NULLs.
CREATE VIEW gradesheet AS
SELECT Assignment.assignment_id AS assignment_id, grade
FROM Assignment, percentage
WHERE Assignment.assignment_id = percentage.assignment_id;

-- The average grade for the assignment.
CREATE VIEW gradeavg AS
SELECT assignment_id, avg(cast(grade AS real)) AS average_mark_percent
FROM gradesheet
GROUP BY assignment_id;

-- The number of grades between 80 and 100 percent inclusive.
CREATE VIEW greaterthan80 AS
SELECT DISTINCT assignment_id, count(grade) AS num_80_100
FROM gradesheet
WHERE 80 <= grade AND 100 >= grade
GROUP BY assignment_id;

-- The number of grades between 60 and 79 percent inclusive.
CREATE VIEW greaterthan60 AS
SELECT DISTINCT assignment_id, count(grade) AS num_60_79
FROM gradesheet
WHERE 60 <= grade AND 80 > grade
GROUP BY assignment_id;

-- The number of grades between 50 and 59 percent inclusive.
CREATE VIEW greaterthan50 AS
SELECT DISTINCT assignment_id, count(grade) AS num_50_59
FROM gradesheet
WHERE 50 <= grade AND 60 > grade
GROUP BY assignment_id;

-- The number of grades between 0 and 49 percent inclusive.
CREATE VIEW greaterthan0 AS
SELECT DISTINCT assignment_id, count(grade) AS num_0_49
FROM gradesheet
WHERE 0 <= grade AND 50 > grade
GROUP BY assignment_id;

-- Final answer.
INSERT INTO q1 (SELECT DISTINCT gradeavg.assignment_id AS assignment_id, 
average_mark_percent, coalesce(num_80_100, 0) as num_80_100, coalesce(num_60_79, 0) as num_60_79, coalesce(num_50_59, 0) as num_50_59, coalesce(num_0_49, 0) as num_0_49
FROM gradeavg NATURAL FULL JOIN greaterthan80 NATURAL FULL JOIN greaterthan60
NATURAL FULL JOIN greaterthan50 NATURAL FULL JOIN greaterthan0);
	-- put a final query here so that its results will go into the table.