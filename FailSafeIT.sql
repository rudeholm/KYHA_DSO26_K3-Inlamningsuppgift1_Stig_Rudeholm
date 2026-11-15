/********************************************************************
 * FAILSAFE IT                                                      *
 * DSO26 K3 Databaser och SQL, Inlämningsuppgift 1                  *
 * Stig Rudeholm                                                    *
 * ---------------------------------------------------------------- *
 * Beskrivning: Detta skript nollställer databasen, skapar tabeller *
 *              för FailSafeIT, samt lägger in testdata.            *
 ********************************************************************/

-- SETUP - Steg 1: Om databasen redan finns, radera den och skapa en ny
-- för att säkerställa idempotens.

-- Se till att vi inte f.n. använder databasen vi vill radera.
USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'FailSafeIT')
BEGIN
    ALTER DATABASE FailSafeIT SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE FailSafeIT;
END
GO

CREATE DATABASE FailSafeIT;
GO

-- Byt till den aktuella databasen.
USE FailSafeIT;
GO



-- SETUP - Steg 2: Skapa tabeller
-- Exporterad kod från Lucidchart, med ändringar
CREATE TABLE Consultants (
    Id INT IDENTITY(1,1) NOT NULL,
    PersonalNumber VARCHAR(20) NOT NULL,
    FirstName NVARCHAR(40) NOT NULL,
    LastName NVARCHAR(40) NOT NULL,
    HourlyRate DECIMAL(7,2) NOT NULL,
    Specialty NVARCHAR(100) DEFAULT NULL,
    CONSTRAINT PK_Consultants PRIMARY KEY CLUSTERED (Id),
    CONSTRAINT UQ_PersonalNumber UNIQUE (PersonalNumber)
);

CREATE TABLE Clients (
    Id INT IDENTITY(1,1) NOT NULL,
    OrgNumber VARCHAR(20) NOT NULL,
    CompanyName NVARCHAR(120) NOT NULL,
    Email NVARCHAR(200) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Clients PRIMARY KEY CLUSTERED (Id),
    CONSTRAINT UQ_OrgNumber UNIQUE (OrgNumber)
);

CREATE TABLE Projects (
    Id INT IDENTITY(1,1) NOT NULL,
    ClientId INT,
    Name NVARCHAR(120) NOT NULL,
    CONSTRAINT PK_Projects PRIMARY KEY CLUSTERED (Id),
    CONSTRAINT FK_Projects_Clients
        FOREIGN KEY (ClientId) REFERENCES Clients (Id) ON DELETE SET NULL
);

CREATE TABLE Assignments (
    Id INT IDENTITY(1,1) NOT NULL,
    ProjectId INT,
    ConsultantId INT,
    StartDate DATETIME2 NOT NULL,
    EndDate DATETIME2 NOT NULL,
    RoleDescription NVARCHAR(120) NOT NULL,
    CONSTRAINT PK_Assignments PRIMARY KEY CLUSTERED (Id),
    CONSTRAINT FK_Assignments_Projects
        FOREIGN KEY (ProjectId)
            REFERENCES Projects (Id) ON DELETE SET NULL,
    CONSTRAINT FK_Assignments_Consultants
        FOREIGN KEY (ConsultantId)
            REFERENCES Consultants (Id) ON DELETE SET NULL,
);

-- Lägg till NONCLUSTERED INDEX på Foreing Keys för att underlätta sökning
CREATE NONCLUSTERED INDEX IX_Projects_ClientId
    ON Projects (ClientId);
GO

CREATE NONCLUSTERED INDEX IX_Assignments_ConsultantId
    ON Assignments (ConsultantId)
        INCLUDE (ProjectId);
GO


-- SETUP - Steg 3: Lägg in testdata
-- Konsulter och klienter genererade med mockaroo.com, med små ändringar
INSERT INTO Consultants (PersonalNumber, FirstName, LastName, HourlyRate, Specialty)
    VALUES
        ('880-24-2717', 'Vonny', 'Budden', 900.00, 'C# Developer'),
        ('311-98-2768', 'Dom', 'Bearns', 900.00, 'C# Developer'),
        ('198-60-9544', 'Ally', 'Meekin', 1250.00, 'C# Developer'),
        ('472-80-7976', 'Claudette', 'Haggart', 1200.00, 'Web Designer'),
        ('682-73-1724', 'Ware', 'Haskew', 950.00, 'Software Test Engineer'),
        ('265-83-6038', 'Calypso', 'Golda', 1400.00, 'Design Engineer'),
        ('454-49-5740', 'Hilliard', 'Gotthard', 1200.00, 'Database Engineer'),
        ('133-02-5189', 'Nickolas', 'Seabrook', 1000.00, 'Cloud Engineer'),
        ('609-21-8658', 'Alta', 'Barczynski', 1500.00, 'Cybersecurity'),
        ('536-49-8959', 'Brandise', 'Trees', 1250.00, 'UX/UI'),
        ('361-67-1492', 'Maribel', 'Kilmartin', 1100.00, 'Quality Assurance'),
        ('348-28-5974', 'Yvonne', 'Hessay', 1250.00, 'Network Admin'),
        ('765-06-6725', 'Juli', 'Daudray', 1400.00, 'C# Developer'),
        ('825-73-7268', 'Rosina', 'Brownlow', 1200.00, 'Sysadmin'),
        ('345-73-4234', 'Belle', 'Ninnis', 1000.00, 'DevOps'),
        ('634-65-6165', 'Jennie', 'O''Nowlan', 1450.00, 'Blockchain Engineer'),
        ('451-62-1310', 'Huey', 'Huff', 1400.00, 'Network Engineer'),
        ('111-70-7712', 'Wilmette', 'Steventon', 1250.00, 'Web Developer'),
        ('169-75-7628', 'Remington', 'Hughf', 1400.00, 'Cybersecurity Analyst'),
        ('267-05-0685', 'Helen', 'Flag', 1200.00, 'SysAdmin'),
        ('526-74-9071', 'Horatio', 'McEwan', 1200.00, 'Network Admin'),
        ('563-35-5808', 'Tracie', 'Matterdace', 1250.00, 'Network Engineer'),
        ('812-62-1811', 'Kamilah', 'Stork', 1500.00, 'Database Specialist');

INSERT INTO Clients (CompanyName, OrgNumber, Email, Phone)
    VALUES
        ('Lajo', '752-06-1538', 'rjanicijevic0@lajocorp.com', '381-377-9577'),
        ('Buzzster', '125-45-1748', 'cmatschuk1@buzzster.com', '755-863-2122'),
        ('Meejo', '858-54-1209', 'sgeorgins2@meejo.com', '791-168-9496'),
        ('Blogtags', '424-36-2260', 'rlevesque3@blogtagsco.com', '329-958-4612'),
        ('Innotype', '820-19-9588', 'halbany4@inno.type', '397-591-6254');

INSERT INTO Projects (ClientId, Name)
    VALUES
        (1, 'Delta'),
        (1, 'Sierra'),
        (1, 'Oscar'),
        (2, 'Romeo'),
        (5, 'Hotel'),
        (2, 'Whiskey'),
        (4, 'November');

INSERT INTO Assignments (ProjectId, ConsultantId, StartDate, EndDate, RoleDescription)
    VALUES
        (1, 23, '2026-11-01', '2027-05-25', 'Database architecture'),
        (1, 2, '2026-11-01', '2027-05-25', 'Software development'),
        (3, 5, '2027-01-01', '2027-12-31', 'Testing'),
        (4, 6, '2027-01-01', '2027-12-31', 'Design'),
        (7, 3, '2027-01-01', '2027-12-31', 'Software development'),
        (5, 11, '2027-01-01', '2027-12-31', 'QA'),
        (5, 13, '2027-01-01', '2027-12-31', 'DevOps'),
        (5, 10, '2027-01-01', '2027-12-31', 'UI/UX'),
        (2, 9, '2027-01-01', '2027-12-31', 'Cybersecurity');

-- QUERIES
-- Fråga A: Lista namn och timpris på alla konsulter som har ett timpris högre än
-- 1200 kr, sorterat efter pris (högst först).
SELECT FirstName, LastName, HourlyRate
    FROM Consultants
        WHERE HourlyRate > 1200.00
            ORDER BY HourlyRate DESC;

-- Fråga B: Visa en sammanställning över alla uppdrag. Listan måste innehålla
-- kundens företagsnamn, konsultens namn, samt start- och slutdatum för
-- uppdraget (Tips: Använd JOIN).
SELECT p.Name as [Project Name], cl.CompanyName, co.FirstName, co.LastName, a.RoleDescription, a.StartDate, a.EndDate
    FROM Assignments a
    LEFT JOIN Consultants co ON co.Id = a.ConsultantId
    INNER JOIN Projects p ON p.Id = a.ProjectId
    INNER JOIN Clients cl ON cl.Id = p.ClientId;

-- Fråga C: Visa en lista på alla kunder och hur många uppdrag respektive kund
-- har aktiva i systemet totalt (Tips: Använd COUNT och GROUP BY).
SELECT c.CompanyName, COUNT(a.ConsultantId) as [Number of Assignments], COUNT(DISTINCT p.Id) as [Number of Projects]
    FROM Clients c
    LEFT JOIN Projects p ON p.ClientId = c.Id
    LEFT JOIN Assignments a ON a.ProjectId = p.Id
    GROUP BY c.CompanyName
    ORDER BY COUNT(a.ConsultantId) DESC;

-- Fråga D: Uppdatera timpriset för en specifik konsult genom en UPDATE-fråga.
-- Vonny höjer sitt timpris
UPDATE Consultants SET HourlyRate = 1250.00
    WHERE Id = 1;

-- Fråga E: Skriv en DELETE-fråga som tar bort en kund (förutsatt att kunden inte
-- har några aktiva uppdrag kopplade till sig).
DELETE FROM Clients WHERE Id = 3;


select * from Consultants;
select * from Clients;
select * from Projects;
select * from Assignments;
