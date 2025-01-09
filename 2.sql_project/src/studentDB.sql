CREATE DATABASE StudentsInfo;
USE StudentsInfo;

CREATE TABLE Departments (name VARCHAR(20), campus VARCHAR(20), PRIMARY KEY (name));
INSERT INTO Departments
	VALUES ('Bio', 'Busch'), ('Chem', 'CAC'), ('CS', 'Livi'), ('Eng', 'CD'), ('Math', 'Busch'), ('Phys', 'CAC');

CREATE TABLE Students (first_name VARCHAR(20), last_name VARCHAR(20), id INT, PRIMARY KEY (id));
Insert Into Students 
	VALUES ('Estelle', 'Graves', 0), ('Willard', 'Reed', 1), ('Joshua', 'Yates', 2), ('Kristy', 'Carlson', 3), 
    ('Jim', 'Henderson', 4), ('Brian', 'Torres', 5), ('Lucia', 'Stone', 6), ('Harvey', 'Andrews', 7), 
    ('Sabrina', 'Potter', 8), ('Seth', 'Russell', 9), ('Kenny', 'Obrien', 10), ('Ernestine', 'Dean', 11), 
    ('Violet', 'Rivera', 12), ('Nancy', 'Barber', 13), ('Lauren', 'Castro', 14), ('Clifford', 'Steele', 15), 
    ('Ricardo', 'Bowen', 16), ('Ted', 'Lowe', 17), ('Leon', 'Garrett', 18), ('Dolores', 'Alexander', 19), 
    ('Bert', 'Wells', 20), ('Marshall', 'Pena', 21), ('Valerie', 'Moreno', 22), ('Daisy', 'Harvey', 23), 
    ('Courtney', 'Glover', 24), ('Lowell', 'Sparks', 25), ('Roger', 'Wheeler', 26), ('Alfonso', 'Shaw', 27), 
    ('Kayla', 'Ruiz', 28), ('Arnold', 'Santiago', 29), ('Jessica', 'Williamson', 30), ('Carole', 'Casey', 31), 
    ('Lora', 'Hoffman', 32), ('Colleen', 'Fernandez', 33), ('Kim', 'Keller', 34), ('Nadine', 'Vasquez', 35), 
    ('Lindsay', 'Brock', 36), ('Erin', 'Ball', 37), ('Jeannie', 'Boyd', 38), ('Francis', 'Singleton', 39), 
    ('Vincent', 'Hamilton', 40), ('Wendell', 'Owen', 41), ('Whitney', 'Vaughn', 42), ('Madeline', 'Thomas', 43), 
    ('Blanche', 'Henry', 44), ('Francis', 'Cohen', 45), ('Scott', 'Williams', 46), ('Preston', 'Tyler', 47), 
    ('Pearl', 'Sutton', 48), ('Guadalupe', 'Walsh', 49), ('Bill', 'Mcguire', 50), ('Orville', 'Harmon', 51), 
    ('Owen', 'Newton', 52), ('Leo', 'Brady', 53), ('Ron', 'Munoz', 54), ('Ruben', 'Lindsey', 55), 
    ('Gail', 'Cortez', 56), ('Ismael', 'Sanchez', 57), ('Elbert', 'Brewer', 58), ('Zachary', 'Warren', 59), 
    ('Kathleen', 'Hines', 60), ('Myra', 'Carroll', 61), ('Stanley', 'Richards', 62), ('Meredith', 'Chavez', 63), 
    ('Kerry', 'Daniels', 64), ('Dana', 'Murray', 65), ('Andres', 'Lamb', 66), ('Darin', 'Mason', 67), 
    ('Johnnie', 'Padilla', 68), ('Thomas', 'Gordon', 69), ('Conrad', 'Hale', 70), ('Perry', 'Parks', 71), 
    ('Clark', 'Schneider', 72), ('Debbie', 'Chandler', 73), ('Troy', 'Richardson', 74), ('Marian', 'Schmidt', 75), 
    ('Gustavo', 'Wolfe', 76), ('Lamar', 'May', 77), ('Irving', 'Parsons', 78), ('Tammy', 'Wright', 79), 
    ('Arturo', 'Porter', 80), ('Sonia', 'Hansen', 81), ('Bessie', 'Abbott', 82), ('Cory', 'Robinson', 83), 
    ('Jaime', 'Hodges', 84), ('John', 'Hunter', 85), ('Courtney', 'Carson', 86), ('Eunice', 'Phillips', 87), 
    ('Irma', 'West', 88), ('Charlie', 'Johnson', 89), ('Drew', 'Pope', 90), ('Luke', 'Davidson', 91), 
    ('Dawn', 'Maxwell', 92), ('Kay', 'Holloway', 93), ('Jeffery', 'Dunn', 94), ('Leah', 'Lambert', 95), 
    ('Josh', 'Gibbs', 96), ('Bernadette', 'Hawkins', 97), ('Barry', 'Cooper', 98), ('Regina', 'Patton', 99);

CREATE TABLE Classes (name VARCHAR(20), credits INT, PRIMARY KEY (name));
INSERT INTO Classes 
	VALUES ('Intro to CS', 4), ('Intro to Math', 3), ('Intro to Physics', 3), ('CS336', 4), ('CS206', 4),
		   ('MA336', 4), ('MA206', 4), ('PHYS336', 4), ('PHYS206', 4);

CREATE TABLE Majors (sid INT, dname VARCHAR(20), FOREIGN KEY (sid) REFERENCES Students (id),
												 FOREIGN KEY (dname) REFERENCES Departments (name));
INSERT INTO Majors 
	VALUES (0, 'CS'), (1, 'Math'), (2, 'Phys'), (3, 'CS'), (4, 'Math'), (5, 'Phys'), (6, 'CS'), (7, 'Math'), (8, 'Phys');
INSERT INTO Majors VALUES (0, 'Math'), (0, 'Phys');
SELECT*FROM Majors;

CREATE TABLE Minors (sid INT, dname VARCHAR(20), FOREIGN KEY (sid) REFERENCES Students (id),
												 FOREIGN KEY (dname) REFERENCES Departments (name));
DROP TABLE Minors;
INSERT INTO Minors
	VALUES (1, 'CS'), (2, 'CS'), (3, 'Phys'), (4, 'Phys'), (5, 'Math'), (6, 'Math'), (7, 'CS'), (8, 'CS');
SELECT*FROM Minors;

CREATE TABLE IsTaking (sid INT, name VARCHAR(30), FOREIGN KEY (sid) REFERENCES Students (id),
												  FOREIGN KEY (name) REFERENCES Classes (name));
INSERT INTO IsTaking
	VALUES (0, 'CS336'), (0, 'CS206'), (0, 'PHYS336'), (1, 'Intro to Math'), (1, 'Intro to CS'), (2, 'Intro to Physics'),
		   (2, 'Intro to Math'), (3, 'Intro to CS'), (4, 'Math336'), (4, 'Math206'), (5, 'PHYS336'), (6, 'Intro to CS'),
           (7, 'Math336'), (7, 'CS336'), (8, 'PHYS206'), (8, 'Intro to CS');
DROP TABLE IsTaking;
SELECT*FROM IsTaking;

CREATE TABLE HasTaken (sid INT, name VARCHAR(20), grade char(1), FOREIGN KEY (sid) REFERENCES students (id),
																 FOREIGN KEY (name) REFERENCES Classes (name));
DROP TABLE HasTaken;
INSERT INTO HasTaken
	VALUES (0, 'Intro to CS', 'A'), (0, 'Intro to Math', 'B'), (0, 'Intro to Physics', 'B'), (0, 'MA206', 'F');
INSERT INTO HasTaken
	VALUES (1, 'Intro to Physics', 'C');
INSERT INTO HasTaken
	VALUES (2, 'CS336', 'A');
SELECT*FROM Hastaken;

SELECT SUM(CASE 
                      WHEN ht.grade = 'A' THEN 4.0
                      WHEN ht.grade = 'B' THEN 3.0
                      WHEN ht.grade = 'C' THEN 2.0
                      WHEN ht.grade = 'D' THEN 1.0
                      WHEN ht.grade = 'F' THEN 0.0
                      ELSE NULL END * c.credits) / SUM(c.credits) AS avg_gpa
FROM Students s
INNER JOIN HasTaken ht ON s.id = ht.sid AND s.id = 0
INNER JOIN Classes c ON ht.name = c.name;

SELECT SUM(credits) AS total_credits FROM HasTaken INNER JOIN Classes ON HasTaken.name = Classes.name AND HasTaken.grade != 'F' WHERE HasTaken.sid = 0;

SELECT s.id, SUM(CASE 
                      WHEN ht.grade = 'A' THEN 4.0
                      WHEN ht.grade = 'B' THEN 3.0
                      WHEN ht.grade = 'C' THEN 2.0
                      WHEN ht.grade = 'D' THEN 1.0
                      WHEN ht.grade = 'F' THEN 0.0
                      ELSE NULL END * c.credits) / SUM(c.credits) AS gpa
FROM Students s
INNER JOIN HasTaken ht ON s.id = ht.sid
INNER JOIN Classes c ON ht.name = c.name
GROUP BY s.id
HAVING gpa >= 2.0;

SELECT d.name, COUNT(DISTINCT m.sid) AS num_students, 
       SUM(CASE 
             WHEN ht.grade = 'A' THEN 4.0
             WHEN ht.grade = 'B' THEN 3.0
             WHEN ht.grade = 'C' THEN 2.0
             WHEN ht.grade = 'D' THEN 1.0
             WHEN ht.grade = 'F' THEN 0.0
             ELSE NULL END * c.credits) / SUM(c.credits) AS avg_gpa
FROM Departments d
LEFT JOIN Majors m ON d.name = m.dname
LEFT JOIN HasTaken ht ON m.sid = ht.sid
LEFT JOIN Classes c ON ht.name = c.name
WHERE d.name = ?
GROUP BY d.name
HAVING COUNT(DISTINCT m.sid) > 0;

SELECT COUNT(DISTINCT sid) AS num_students
FROM IsTaking
WHERE name = 'Intro to CS';