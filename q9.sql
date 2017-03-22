-- Inseparable

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q9;

-- You must not change this table definition.
CREATE TABLE q9 (
	student1 varchar(25),
	student2 varchar(25)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

-- Group assignments.
CREATE VIEW group_assignments AS
SELECT assignment_id
FROM Assignment
WHERE group_max > 1;

-- People in the groups.
CREATE VIEW group_member AS
SELECT assignment_id, group_id, username
FROM group_assignments NATURAL JOIN (AssignmentGroup NATURAL JOIN Membership);

-- Pairs ever exists.
CREATE VIEW existed_pairs AS
SELECT a.username AS student1, b.username AS student2, a.assignment_id
FROM group_member a, group_member b
WHERE a.group_id = b.group_id AND a.username < b.username;

-- All group people.
CREATE VIEW group_people AS
SELECT DISTINCT username
FROM group_member;

-- All possible pairs.
CREATE VIEW all_pairs AS
SELECT c.username AS student1, d.username AS student2, assignment_id
FROM group_people c, group_people d, group_assignments
WHERE c.username < d.username;

-- Pairs that are not in the same group for all assignments.
CREATE VIEW separable AS
(SELECT * FROM all_pairs)
EXCEPT
(SELECT * FROM existed_pairs);

-- Inseparable pairs.
CREATE VIEW inseparable AS
(SELECT DISTINCT student1, student2 FROM existed_pairs)
EXCEPT
(SELECT DISTINCT student1, student2 FROM separable);

-- Final answer.
INSERT INTO q9 (SELECT student1, student2 FROM inseparable);
	-- put a final query here so that its results will go into the table.