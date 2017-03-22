-- A1 report

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q10;

-- You must not change this table definition.
CREATE TABLE q10 (
	group_id integer,
	mark real,
	compared_to_average real,
	status varchar(5)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

-- Assignment 1 info.
CREATE VIEW a1 AS
SELECT assignment_id, group_id
FROM Assignment NATURAL JOIN AssignmentGroup
WHERE description = 'A1';

-- The weight out_of the rubric.
CREATE VIEW weighted_out_of_table AS
SELECT group_id, out_of::real * weight AS weighted_out_of, 
grade::real * weight AS weighted_grade
FROM Grade NATURAL JOIN RubricItem;

-- All A1 mark.
CREATE VIEW a1_mark AS
SELECT group_id, (sum(weighted_grade)::real / sum(weighted_out_of)::real) * 100 as mark
FROM weighted_out_of_table NATURAL FULL JOIN a1
GROUP BY group_id;

-- Average grade of A1.
CREATE VIEW a1_avg AS
SELECT DISTINCT avg(mark) AS avg_a1
FROM a1_mark;

-- -- Average difference between the actual mark and average.
-- CREATE VIEW mark_difference AS
-- SELECT group_id, mark, (mark - avg_a1) AS compared_to_average
-- FROM a1_avg NATURAL JOIN a1_mark;

-- -- Adding NULL to the result if the mark column is null.
-- CREATE VIEW null_status AS
-- SELECT group_id, mark, compared_to_average, cast(NULL as varchar(5)) AS status
-- FROM mark_difference
-- WHERE compared_to_average is NULL;

-- Result.
CREATE VIEW result_query AS
SELECT a1.group_id, mark, (mark - avg_a1) as compared_to_average, CASE WHEN (mark - avg_a1) > 0 THEN 'above' 
																							WHEN (mark - avg_a1) = 0 THEN 'at' 
																							WHEN (mark-avg_a1) < 0 THEN 'below' 
																							ELSE NULL END as status
FROM a1_avg, a1 NATURAL LEFT JOIN a1_mark;

-- Final answer.
INSERT INTO q10 (SELECT * FROM result_query);
	-- put a final query here so that its results will go into the table.