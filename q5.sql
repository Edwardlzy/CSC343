-- Uneven workloads

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q5;

-- You must not change this table definition.
CREATE TABLE q5 (
	assignment_id integer,
	username varchar(25), 
	num_assigned integer
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

-- Group per TA per assignment.
CREATE VIEW num_group AS
SELECT assignment_id, username, count(Grader.group_id) AS num_assigned
FROM Grader, AssignmentGroup
WHERE Grader.group_id = AssignmentGroup.group_id
GROUP BY assignment_id, username;

-- Min assigns per assignment.
CREATE VIEW min_assigns AS
SELECT assignment_id, min(num_assigned) AS minimum
FROM num_group
GROUP BY assignment_id;

-- Max assigns per assignment.
CREATE VIEW max_assigns AS
SELECT assignment_id, max(num_assigned) AS maximum
FROM num_group
GROUP BY assignment_id;

-- Assignments to be reported.
CREATE VIEW report AS
SELECT min_assigns.assignment_id
FROM min_assigns, max_assigns
WHERE min_assigns.assignment_id = max_assigns.assignment_id AND (maximum - minimum) > 10;

-- Result.
CREATE VIEW result_query AS
SELECT report.assignment_id, username, num_assigned
FROM report, num_group
WHERE report.assignment_id = num_group.assignment_id;

-- Final answer.
INSERT INTO q5 (SELECT * FROM result_query);
	-- put a final query here so that its results will go into the table.