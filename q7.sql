-- High coverage

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q7;

-- You must not change this table definition.
CREATE TABLE q7 (
	ta varchar(100)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.
-- TAs' usernames corresponding with the assignments they have graded.
CREATE VIEW graded_all AS
SELECT username, AssignmentGroup.assignment_id
FROM Grader, AssignmentGroup
WHERE Grader.group_id = AssignmentGroup.group_id;

-- TAs and all assignments.
CREATE VIEW should_grade AS
SELECT username, assignment_id
FROM Grader, AssignmentGroup;

-- TAs who have not graded all assignments.
CREATE VIEW incomplete_graders AS
SELECT *
FROM should_grade
EXCEPT
SELECT *
FROM graded_all;

-- TAs who have graded all assignments.
CREATE VIEW complete_graders AS
SELECT g.username
FROM (SELECT * FROM should_grade
EXCEPT
SELECT * FROM incomplete_graders) AS g;

-- TAs and the groups they graded on each assignment.
CREATE VIEW ta_relation AS
SELECT username, assignment_id, count(Grader.group_id) AS num_group
FROM Grader, AssignmentGroup
WHERE Grader.group_id = AssignmentGroup.group_id
GROUP BY username, assignment_id;

-- Each assignment and number of groups.
CREATE VIEW assignment_group_relation AS
SELECT assignment_id, count(group_id) AS num_group
FROM AssignmentGroup
GROUP BY assignment_id;

-- TAs who have graded all students in at least one assignment.
CREATE VIEW thorough_graders AS
SELECT username
FROM assignment_group_relation, ta_relation
WHERE assignment_group_relation.assignment_id = ta_relation.assignment_id
AND ta_relation.num_group = assignment_group_relation.num_group;

-- Result.
CREATE VIEW Result_Query AS
SELECT * FROM complete_graders
INTERSECT
SELECT * FROM thorough_graders;

-- Final answer.
INSERT INTO q7 (SELECT username AS ta FROM Result_Query);
	-- put a final query here so that its results will go into the table.