-- Solo superior

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q3;

-- You must not change this table definition.
CREATE TABLE q3 (
	assignment_id integer,
	description varchar(100), 
	num_solo integer, 
	average_solo real,
	num_collaborators integer, 
	average_collaborators real, 
	average_students_per_submission real
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

-- Not null percentage of each group.
CREATE VIEW not_null_percentage AS
SELECT group_id, assignment_id, 100 * mark/denominator AS grade
FROM denom NATURAL JOIN AssignmentGroup NATURAL JOIN Result;

-- Assignments without marks.
CREATE VIEW no_marks AS
(SELECT assignment_id FROM Assignment)
EXCEPT
(SELECT assignment_id FROM not_null_percentage);

-- Augmented no_marks.
CREATE VIEW a_no_marks AS
SELECT group_id, assignment_id, NULL as grade
FROM no_marks NATURAL JOIN AssignmentGroup;

-- Percentages.
CREATE VIEW percentage AS
(SELECT * FROM a_no_marks)
UNION
(SELECT * FROM not_null_percentage);

-- Number of group member.
CREATE VIEW num_group_member AS
SELECT group_id, count(username) as member_num
FROM Membership
GROUP BY group_id;

-- Groups of only 1 member.
CREATE VIEW solo_group AS
SELECT group_id
FROM num_group_member
WHERE member_num = 1;

-- Groups of multiple users.
CREATE VIEW non_solo_group AS
SELECT group_id
FROM num_group_member
WHERE member_num > 1;

-- Augmented non_solo_group with each username.
CREATE VIEW augmented_group AS
SELECT non_solo_group.group_id, username
FROM non_solo_group NATURAL JOIN Membership;

-- Average of solo groups.
CREATE VIEW solo_avg AS
SELECT assignment_id, avg(grade) AS average_solo, count(percentage.group_id) AS num_solo
FROM solo_group NATURAL JOIN percentage
GROUP BY assignment_id;

-- Non_solo_groups and the number of usernames, group_id.
CREATE VIEW group_info AS
SELECT assignment_id, count(username) AS member_count, count(DISTINCT group_id) as group_count
FROM percentage NATURAL JOIN non_solo_group NATURAL JOIN Membership
GROUP BY assignment_id;

-- Marks of non_solo users.
CREATE VIEW non_solo_grade AS
SELECT assignment_id, grade
FROM non_solo_group NATURAL JOIN percentage;

-- Average grade for non_solo groups.
CREATE VIEW non_solo_avg AS
SELECT assignment_id, avg(grade) AS group_avg
FROM non_solo_grade
GROUP BY assignment_id;

-- Augmented non_solo_avg with group_count and member_count
CREATE VIEW augmented_group_avg AS
SELECT assignment_id, group_avg, group_count, member_count
FROM group_info NATURAL JOIN non_solo_avg;

-- Average students per group.
CREATE VIEW avg_student AS
SELECT assignment_id, (count(username) * 1.0)/(count(DISTINCT group_id) * 1.0) AS average_students_per_group
FROM AssignmentGroup NATURAL JOIN Membership
GROUP BY assignment_id;

-- Result query.
CREATE VIEW Result_query AS
SELECT assignment_id, description, average_solo, coalesce(num_solo, 0) AS num_solo, group_avg AS average_collaborators,
coalesce(group_count, 0) AS group_count, coalesce(member_count, 0) AS num_collaborators,
average_students_per_group
FROM solo_avg NATURAL JOIN augmented_group_avg NATURAL JOIN avg_student NATURAL JOIN Assignment;

-- Final answer.
INSERT INTO q3 (SELECT assignment_id, description, num_solo, average_solo, num_collaborators, 
average_collaborators, average_students_per_group FROM result_query);
	-- put a final query here so that its results will go into the table.