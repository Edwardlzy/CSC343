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
INSERT INTO MarkusUser VALUES ('s3', 'sln1', 'sfn1', 'student');
INSERT INTO MarkusUser VALUES ('s4', 'sln2', 'sfn2', 'student');
INSERT INTO MarkusUser VALUES ('s5', 'sln1', 'sfn1', 'student');
INSERT INTO MarkusUser VALUES ('s6', 'sln2', 'sfn2', 'student');
-- student never in group
INSERT INTO MarkusUser VALUES ('s7', 'sln2', 'sfn2', 'student');
-- USE FOR PART2 RECORDMEMBER
INSERT INTO MarkusUser VALUES ('s8', 'sln2', 'sfn2', 'student');


INSERT INTO MarkusUser VALUES ('t1', 'tln1', 'tfn1', 'TA');
INSERT INTO MarkusUser VALUES ('t2', 'tln2', 'tfn2', 'TA');
INSERT INTO MarkusUser VALUES ('t3', 'tln3', 'tfn3', 'TA');


INSERT INTO Assignment VALUES (1000, 'A1', '2017-02-08 20:00', 1, 2);
INSERT INTO Assignment VALUES (1001, 'A2', '2017-02-19 20:00', 1, 2);
INSERT INTO Assignment VALUES (1002, 'A3', '2017-03-09 20:00', 1, 1);

INSERT INTO Required VALUES (1000, 'A1.pdf');

-- A1
INSERT INTO AssignmentGroup VALUES (2000, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0001, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0002, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0003, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0004, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0005, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0006, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0007, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0008, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0009, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0010, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0011, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0012, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0013, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0014, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0015, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (0016, 1000, 'repo_url');

--A2
INSERT INTO AssignmentGroup VALUES (1001, 1001, 'repo_url');
INSERT INTO AssignmentGroup VALUES (1002, 1001, 'repo_url');
INSERT INTO AssignmentGroup VALUES (1003, 1001, 'repo_url');
INSERT INTO AssignmentGroup VALUES (1004, 1001, 'repo_url');
INSERT INTO AssignmentGroup VALUES (1005, 1001, 'repo_url');
INSERT INTO AssignmentGroup VALUES (1006, 1001, 'repo_url');
INSERT INTO AssignmentGroup VALUES (1007, 1001, 'repo_url');
INSERT INTO AssignmentGroup VALUES (1008, 1001, 'repo_url');
INSERT INTO AssignmentGroup VALUES (1009, 1001, 'repo_url');
INSERT INTO AssignmentGroup VALUES (1010, 1001, 'repo_url');
INSERT INTO AssignmentGroup VALUES (1011, 1001, 'repo_url');
INSERT INTO AssignmentGroup VALUES (1012, 1001, 'repo_url');
INSERT INTO AssignmentGroup VALUES (1013, 1001, 'repo_url');
INSERT INTO AssignmentGroup VALUES (1014, 1001, 'repo_url');
INSERT INTO AssignmentGroup VALUES (1015, 1001, 'repo_url');
INSERT INTO AssignmentGroup VALUES (1016, 1001, 'repo_url');

--A3
INSERT INTO AssignmentGroup VALUES (2001, 1002, 'repo_url');
INSERT INTO AssignmentGroup VALUES (2002, 1002, 'repo_url');
INSERT INTO AssignmentGroup VALUES (2003, 1002, 'repo_url');
INSERT INTO AssignmentGroup VALUES (2004, 1002, 'repo_url');
INSERT INTO AssignmentGroup VALUES (2005, 1002, 'repo_url');
INSERT INTO AssignmentGroup VALUES (2006, 1002, 'repo_url');
INSERT INTO AssignmentGroup VALUES (2007, 1002, 'repo_url');
INSERT INTO AssignmentGroup VALUES (2008, 1002, 'repo_url');
INSERT INTO AssignmentGroup VALUES (2009, 1002, 'repo_url');
INSERT INTO AssignmentGroup VALUES (2010, 1002, 'repo_url');


--A1 memebership
INSERT INTO Membership VALUES ('s1', 2000);
INSERT INTO Membership VALUES ('s2', 2000);

INSERT INTO Membership VALUES ('s3', 0001);
INSERT INTO Membership VALUES ('s4', 0001);

INSERT INTO Membership VALUES ('s5', 0002);

INSERT INTO Membership VALUES ('s6', 0003);



-- A2 membership
INSERT INTO Membership VALUES ('s1', 1001);
INSERT INTO Membership VALUES ('s2', 1001);

INSERT INTO Membership VALUES ('s3', 1002);

INSERT INTO Membership VALUES ('s4', 1003);
INSERT INTO Membership VALUES ('s5', 1003);



INSERT INTO Membership VALUES ('s6', 1004);

-- A3 membership must solo assignment
INSERT INTO Membership VALUES ('s1', 2001);
INSERT INTO Membership VALUES ('s2', 2002);
INSERT INTO Membership VALUES ('s3', 2003);
INSERT INTO Membership VALUES ('s4', 2004);
INSERT INTO Membership VALUES ('s5', 2005);
INSERT INTO Membership VALUES ('s6', 2006);
INSERT INTO Membership VALUES ('s6', 2007);
INSERT INTO Membership VALUES ('s6', 2008);
INSERT INTO Membership VALUES ('s6', 2009);
INSERT INTO Membership VALUES ('s6', 2010);


-- GROUP 2000 SUBMISSION (A1)
INSERT INTO Submissions VALUES (3000, 'A1.pdf', 's1', 2000, '2017-02-08 19:59');
INSERT INTO Submissions VALUES (3001, 'A1.pdf', 's1', 2000, '2017-02-08 20:30');
INSERT INTO Submissions VALUES (3002, 'A1.pdf', 's2', 2000, '2017-02-08 21:30');
INSERT INTO Submissions VALUES (3003, 'A1.pdf', 's2', 2000, '2017-02-09 20:30');
INSERT INTO Submissions VALUES (3004, 'A1.pdf', 's1', 2000, '2017-02-09 22:30');

--GROUP 0001 SUBMISSION (A1)
INSERT INTO Submissions VALUES (3005, 'A1.pdf', 's3', 2000, '2017-02-08 19:59');
INSERT INTO Submissions VALUES (3006, 'A1.pdf', 's3', 2000, '2017-02-08 20:30');
INSERT INTO Submissions VALUES (3007, 'A1.pdf', 's4', 2000, '2017-02-08 21:30');

-- group 0003 submission (a1)
INSERT INTO Submissions VALUES (3100, 'A1.pdf', 's6', 2000, '2017-02-08 19:59');

-- GROUP 1001 submission (A2)
INSERT INTO Submissions VALUES (3008, 'A2.pdf', 's1', 1001, '2017-02-08 19:59');

-- group 1003 submission (A2)
INSERT INTO Submissions VALUES (3009, 'A2.pdf', 's4', 1003, '2017-02-08 19:59');

--group 1004 submission(A2)
INSERT INTO Submissions VALUES (3200, 'A2.pdf', 's6', 1004, '2017-02-08 19:59');


-- a3 submission all group (must solo assignment)
INSERT INTO Submissions VALUES (3010, 'A3.pdf', 's1', 2001, '2017-02-08 21:30');
INSERT INTO Submissions VALUES (3011, 'A3.pdf', 's2', 2002, '2017-02-02 21:30');
INSERT INTO Submissions VALUES (3012, 'A3.pdf', 's3', 2003, '2017-02-04 21:30');
INSERT INTO Submissions VALUES (3013, 'A3.pdf', 's4', 2004, '2017-02-06 21:30');
INSERT INTO Submissions VALUES (3014, 'A3.pdf', 's5', 2005, '2017-02-01 21:30');
INSERT INTO Submissions VALUES (3015, 'A3.pdf', 's6', 2006, '2017-02-07 21:30');


INSERT INTO Grader VALUES (2000, 't1');
INSERT INTO Grader VALUES (0001, 't1');
INSERT INTO Grader VALUES (0002, 't1');
INSERT INTO Grader VALUES (0003, 't1');
INSERT INTO Grader VALUES (0004, 't1');
INSERT INTO Grader VALUES (0005, 't1');
INSERT INTO Grader VALUES (0006, 't1');
INSERT INTO Grader VALUES (0007, 't1');
INSERT INTO Grader VALUES (0008, 't1');
INSERT INTO Grader VALUES (0009, 't1');
INSERT INTO Grader VALUES (0010, 't1');
-- INSERT INTO Grader VALUES (0011, 't1');
-- INSERT INTO Grader VALUES (0012, 't1');
-- INSERT INTO Grader VALUES (0013, 't1');
-- INSERT INTO Grader VALUES (0014, 't1');
-- INSERT INTO Grader VALUES (0015, 't2');
-- INSERT INTO Grader VALUES (0016, 't2');
-- INSERT INTO Grader VALUES (2001, 't1');

INSERT INTO Grader VALUES (1001, 't1');
INSERT INTO Grader VALUES (1002, 't1');
-- INSERT INTO Grader VALUES (1003, 't2');
-- INSERT INTO Grader VALUES (1004, 't2');
-- INSERT INTO Grader VALUES (1005, 't2');
-- INSERT INTO Grader VALUES (1006, 't2');
-- INSERT INTO Grader VALUES (1007, 't2');
-- INSERT INTO Grader VALUES (1008, 't2');
-- INSERT INTO Grader VALUES (1009, 't2');
-- INSERT INTO Grader VALUES (1010, 't2');
-- INSERT INTO Grader VALUES (1011, 't2');
-- INSERT INTO Grader VALUES (1012, 't2');
-- INSERT INTO Grader VALUES (1013, 't2');
-- INSERT INTO Grader VALUES (1014, 't2');
-- INSERT INTO Grader VALUES (1015, 't2');
-- INSERT INTO Grader VALUES (1016, 't2');

INSERT INTO Grader VALUES (1003, 't1');
INSERT INTO Grader VALUES (1004, 't1');
INSERT INTO Grader VALUES (1005, 't1');
INSERT INTO Grader VALUES (1006, 't1');
INSERT INTO Grader VALUES (1007, 't1');
INSERT INTO Grader VALUES (1008, 't1');
INSERT INTO Grader VALUES (1009, 't1');
INSERT INTO Grader VALUES (1010, 't1');

INSERT INTO Grader VALUES (2001, 't1');
INSERT INTO Grader VALUES (2002, 't1');
INSERT INTO Grader VALUES (2003, 't1');
INSERT INTO Grader VALUES (2004, 't1');
INSERT INTO Grader VALUES (2005, 't1');
INSERT INTO Grader VALUES (2006, 't1');
INSERT INTO Grader VALUES (2007, 't1');
INSERT INTO Grader VALUES (2008, 't1');
INSERT INTO Grader VALUES (2009, 't1');
INSERT INTO Grader VALUES (2010, 't1');


-- RUBRIC FOR A1
-- 4, total grade is 10
-- change to 10, total is 11.5
INSERT INTO RubricItem VALUES (4000, 1000, 'style', 4, 0.25);
INSERT INTO RubricItem VALUES (4001, 1000, 'tester', 12, 0.75);

-- for A2
--total 8
INSERT INTO RubricItem VALUES (4002, 1001, 'style', 4, 0.5);
INSERT INTO RubricItem VALUES (4003, 1001, 'tester', 12, 0.5);

--for A3
-- total 10
INSERT INTO RubricItem VALUES (4004, 1002, 'style', 10, 1);


-- GRADE FOR EACH GROUP A1
-- 2000: 75%
INSERT INTO Grade VALUES (2000, 4000, 3);
INSERT INTO Grade VALUES (2000, 4001, 9);

-- INSERT INTO Grade VALUES (0001, 4000, 4);
-- INSERT INTO Grade VALUES (0001, 4001, 0);

-- INSERT INTO Grade VALUES (0002, 4000, 4);
-- INSERT INTO Grade VALUES (0002, 4001, 10);

-- INSERT INTO Grade VALUES (0003, 4000, 2);
-- INSERT INTO Grade VALUES (0003, 4001, 5);

--grade for each group A2
INSERT INTO Grade VALUES (1001, 4002, 4);
INSERT INTO Grade VALUES (1001, 4003, 10);

INSERT INTO Grade VALUES (1002, 4002, 4);
INSERT INTO Grade VALUES (1002, 4003, 6);

--INSERT INTO Grade VALUES (1003, 4002, 4);
--INSERT INTO Grade VALUES (1003, 4003, 12);

-- INSERT INTO Grade VALUES (1004, 4002, 2);
-- INSERT INTO Grade VALUES (1004, 4003, 10);

-- grade for each group A3
INSERT INTO Grade VALUES (2001, 4004, 10);
-- INSERT INTO Grade VALUES (2002, 4004, 5);
-- INSERT INTO Grade VALUES (2003, 4004, 6);
-- --INSERT INTO Grade VALUES (2004, 4004, 9);
-- INSERT INTO Grade VALUES (2005, 4004, 8);
-- INSERT INTO Grade VALUES (2006, 4004, 7);


--RESULT FOR A1 GROUP 
-- grade 7.5
INSERT INTO Result VALUES (2000, 12, true);
--grade 1
INSERT INTO Result VALUES (0001, 4, true);
--grade 8.5
INSERT INTO Result VALUES (0002, 14, true);
-- grade 4.25
INSERT INTO Result VALUES (0003, 7, true);

--RESULT FOR A2 GROUP
-- grade 2
INSERT INTO Result VALUES (1001, 4, true);
--grade 5
INSERT INTO Result VALUES (1002, 10, true);
--grade 8
INSERT INTO Result VALUES (1003, 16, true);
-- grade 6
INSERT INTO Result VALUES (1004, 12, true);

--result for A3 group
INSERT INTO Result VALUES (2001, 4, true);
INSERT INTO Result VALUES (2002, 5, true);
INSERT INTO Result VALUES (2003, 6, true);
INSERT INTO Result VALUES (2004, 9, true);
INSERT INTO Result VALUES (2005, 8, true);
INSERT INTO Result VALUES (2006, 7, true);
