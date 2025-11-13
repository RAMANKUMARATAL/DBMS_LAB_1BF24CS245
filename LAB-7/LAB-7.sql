create database if not exists Supplierr ;
use supplierr;

CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    city VARCHAR(50)
);
desc supplier;

CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(50),
    color VARCHAR(20)
);
desc parts ;


CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost INT,
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Supplier(sid),
    FOREIGN KEY (pid) REFERENCES Parts(pid)
);
desc catalog;
INSERT INTO Supplier VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');
select * from supplier ;

INSERT INTO Parts VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');
select * from parts ;

INSERT INTO Catalog VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10002, 20001, 10),
(10002, 20002, 10),
(10003, 20003, 30),
(10004, 20003, 40);
select * from catalog ;

SELECT DISTINCT P.PNAME
FROM PARTS P
JOIN CATALOG C ON P.PID = C.PID;

SELECT S.SNAME
FROM SUPPLIER S
WHERE NOT EXISTS (
    SELECT P.PID
    FROM PARTS P
    WHERE P.PID NOT IN (
        SELECT C.PID
        FROM CATALOG C
        WHERE C.SID = S.SID
    )
);

SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Parts p
    WHERE p.color = 'Red'
    AND p.pid NOT IN (
        SELECT c.pid
        FROM Catalog c
        WHERE c.sid = s.sid
    )
);

SELECT p.pname
FROM Parts p
JOIN Catalog c ON p.pid = c.pid
JOIN Supplier s ON s.sid = c.sid
WHERE s.sname = 'Acme Widget'
AND p.pid NOT IN (
    SELECT c2.pid
    FROM Catalog c2
    JOIN Supplier s2 ON c2.sid = s2.sid
    WHERE s2.sname <> 'Acme Widget'
);

SELECT DISTINCT c1.sid
FROM Catalog c1
WHERE c1.cost > (
    SELECT AVG(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = c1.pid
);

SELECT p.pname, s.sname
FROM Parts p
JOIN Catalog c ON p.pid = c.pid
JOIN Supplier s ON s.sid = c.sid
WHERE c.cost = (
    SELECT MAX(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = p.pid
);


