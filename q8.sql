-- Never solo by choice

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q8;

-- You must not change this table definition.
CREATE TABLE q8 (
	username varchar(25),
	group_average real,
	solo_average real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.
-- Assignments that allow students to work in groups.
CREATE VIEW group_assignments AS
SELECT assignment_id
FROM Assignment
WHERE group_max > 1;

-- Solo assignments.
CREATE VIEW solo_assignments AS
SELECT assignment_id
FROM Assignment
WHERE group_max = 1;

-- The groups of all those assignments.
CREATE VIEW allow_group AS
SELECT DISTINCT group_id
FROM group_assignments NATURAL JOIN AssignmentGroup;

-- Group assignments solo worker.
CREATE VIEW solo_group AS
SELECT group_id
FROM allow_group NATURAL JOIN Membership
GROUP BY group_id
HAVING count(username) = 1;

-- All students who have been a solo worker in a group assignment.
CREATE VIEW solo_user AS
SELECT DISTINCT username, group_id
FROM solo_group NATURAL JOIN Membership;

-- Those who always work in groups when possible.
CREATE VIEW always_group AS
(SELECT username FROM Membership NATURAL JOIN group_assignments)
EXCEPT
(SELECT username FROM solo_user);

-- Augmented always_group with group_id.
CREATE VIEW augmented_always_group AS
SELECT username, group_id
FROM always_group NATURAL JOIN Membership;

-- Those who always work in group but didn't commit for at least one assignment.
CREATE VIEW free_rider AS
(SELECT username, group_id FROM augmented_always_group)
EXCEPT
(SELECT username, group_id FROM Submissions);

-- Active group users.
CREATE VIEW active_non_solo_user AS
(SELECT DISTINCT username FROM always_group)
EXCEPT
(SELECT DISTINCT username FROM free_rider);

-- Augmented active group users with group_id.
CREATE VIEW augmented_active_user AS
SELECT username, group_id
FROM active_non_solo_user NATURAL JOIN Membership;

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

-- Group average.
CREATE VIEW group_average_table AS
SELECT username, avg(grade) AS group_average
FROM group_assignments NATURAL JOIN augmented_active_user NATURAL JOIN percentage
GROUP BY username;

-- All groups that are in the solo assignments.
CREATE VIEW solo_assignments_groups AS
SELECT group_id, username
FROM solo_assignments NATURAL JOIN AssignmentGroup NATURAL JOIN active_non_solo_user;

-- Solo average.
CREATE VIEW solo_average_table AS
SELECT username, avg(grade) AS solo_average
FROM percentage NATURAL JOIN solo_assignments_groups
GROUP BY username;

-- Result.
CREATE VIEW result_query AS
SELECT group_average_table.username, group_average, solo_average
FROM active_non_solo_user NATURAL LEFT JOIN group_average_table NATURAL FULL JOIN solo_average_table;

-- Final answer.
INSERT INTO q8 (SELECT * FROM result_query);
	-- put a final query here so that its results will go into the table.