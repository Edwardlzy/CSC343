-- Steady work

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q6;

-- You must not change this table definition.
CREATE TABLE q6 (
	group_id integer,
	first_file varchar(25),
	first_time timestamp,
	first_submitter varchar(25),
	last_file varchar(25),
	last_time timestamp, 
	last_submitter varchar(25),
	elapsed_time interval
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

-- Groups with no submissions for a1.
CREATE VIEW no_submission AS
(SELECT group_id FROM Assignment NATURAL JOIN AssignmentGroup WHERE description = 'A1')
EXCEPT
(SELECT group_id FROM Submissions NATURAL JOIN AssignmentGroup NATURAL JOIN Assignment WHERE description = 'A1');

-- result of no submissions.
CREATE VIEW all_no_submission AS
SELECT group_id, NULL AS first_file, NULL AS first_time, NULL AS first_submitter, NULL AS last_file, NULL AS last_time,
NULL AS last_submitter, NULL AS elapsed_time
FROM no_submission;

-- Not first submission for each group and each assignment.
CREATE VIEW not_first_submission AS
SELECT s1.submission_id
FROM Submissions s1, Submissions s2
WHERE s1.submission_id <> s2.submission_id AND s1.submission_date > s2.submission_date
AND s1.group_id = s2.group_id;

-- First submission.
CREATE VIEW first_submission AS
(SELECT Submissions.submission_id
FROM Submissions)
EXCEPT
(SELECT *
FROM not_first_submission);

-- Not last submission for each group and each assignment.
CREATE VIEW not_last_submission AS
SELECT s1.submission_id
FROM Submissions s1, Submissions s2
WHERE s1.submission_id <> s2.submission_id AND s1.submission_date < s2.submission_date
AND s1.group_id = s2.group_id;

-- Last submission.
CREATE VIEW last_submission AS
(SELECT Submissions.submission_id
FROM Submissions)
EXCEPT
(SELECT *
FROM not_last_submission);

-- Augmented first submission.
CREATE VIEW augmented_first_submission AS
SELECT group_id, file_name AS first_file, submission_date AS first_time, username AS first_submitter
FROM first_submission NATURAL JOIN Submissions;

--Augmented last submission.
CREATE VIEW augmented_last_submission AS
SELECT group_id, file_name AS last_file, submission_date AS last_time, username AS last_submitter
FROM last_submission NATURAL JOIN Submissions;

-- Result without A1 filter.
CREATE VIEW result_without_a1 AS
SELECT augmented_first_submission.group_id, first_file, first_time, first_submitter,
last_file, last_time, last_submitter, (last_time - first_time) AS elapsed_time
FROM augmented_first_submission, augmented_last_submission
WHERE augmented_last_submission.group_id = augmented_first_submission.group_id;

-- Result.
CREATE VIEW result_query AS
(SELECT result_without_a1.group_id, first_file, first_time, first_submitter, last_file, last_time, last_submitter, elapsed_time
FROM result_without_a1, AssignmentGroup, Assignment
WHERE result_without_a1.group_id = AssignmentGroup.group_id AND AssignmentGroup.assignment_id = Assignment.assignment_id 
AND Assignment.description = 'A1')
UNION
(SELECT * FROM all_no_submission);

-- Final answer.
INSERT INTO q6 (SELECT * FROM result_query);
	-- put a final query here so that its results will go into the table.