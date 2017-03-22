-- If there is already any data in these tables, empty it out.

TRUNCATE TABLE Result CASCADE;
TRUNCATE TABLE Grade CASCADE;
TRUNCATE TABLE RubricItem CASCADE;
TRUNCATE TABLE Grader CASCADE;
TRUNCATE TABLE Submissions CASCADE;
TRUNCATE TABLE Membership CASCADE;
TRUNCATE TABLE AssignmentGroup CASCADE;
TRUNCATE TABLE Required CASCADE;
TRUNCATE TABLE Assignment CASCADE;
TRUNCATE TABLE MarkusUser CASCADE;


-- Now insert data from scratch.

INSERT INTO MarkusUser VALUES ('i1', 'iln1', 'ifn1', 'instructor');
INSERT INTO MarkusUser VALUES ('s1', 'sln1', 'sfn1', 'student');
INSERT INTO MarkusUser VALUES ('s2', 'sln2', 'sfn2', 'student');
INSERT INTO MarkusUser VALUES ('s3', 'sln3', 'sfn3', 'student');
INSERT INTO MarkusUser VALUES ('s4', 'sln4', 'sfn4', 'student');
INSERT INTO MarkusUser VALUES ('s5', 'sln5', 'sfn5', 'student');
INSERT INTO MarkusUser VALUES ('s6', 'sln6', 'sfn6', 'student');
INSERT INTO MarkusUser VALUES ('t1', 'tln1', 'tfn1', 'TA');

INSERT INTO Assignment VALUES (1000, 'A1', '2017-02-08 20:00', 1, 4);
INSERT INTO Assignment VALUES (1001, 'A2', '2017-03-08 20:00', 1, 2);


INSERT INTO Required VALUES (1000, 'A1.pdf');

INSERT INTO AssignmentGroup VALUES (2000, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (2001, 1000, 'repo_url');

INSERT INTO Membership VALUES ('s1', 2000);
INSERT INTO Membership VALUES ('s2', 2000);
INSERT INTO Membership VALUES ('s4', 2001);
INSERT INTO Membership VALUES ('s5', 2001);
INSERT INTO Membership VALUES ('s6', 2001);

INSERT INTO Submissions VALUES (3000, 'A1.pdf', 's1', 2000, '2017-02-08 19:59');
INSERT INTO Submissions VALUES (4000, 'A1.pdf', 's4', 2001, '2017-02-08 19:59');

INSERT INTO Grader VALUES (2000, 't1');
INSERT INTO Grader VALUES (2001, 't1');

INSERT INTO RubricItem VALUES (4000, 1000, 'style', 4, 0.25);
INSERT INTO RubricItem VALUES (4001, 1000, 'tester', 12, 0.75);
INSERT INTO RubricItem VALUES (5000, 1001, 'style', 4, 1);

INSERT INTO Grade VALUES (2000, 4000, 3);
INSERT INTO Grade VALUES (2000, 4001, 9);
INSERT INTO Grade VALUES (2001, 4000, 4);
INSERT INTO Grade VALUES (2001, 4001, 12);

INSERT INTO Result VALUES (2000, 7.5, true);
INSERT INTO Result VALUES (2001, 10, true);
