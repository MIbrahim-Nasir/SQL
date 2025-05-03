CREATE DATABASE IMDB;
GO

USE IMDB;
GO

CREATE SCHEMA Foundation;
GO

CREATE TABLE Foundation.Producers(
Id int IDENTITY(1,1) NOT NULL PRIMARY KEY, 
Name nvarchar(50) NOT NULL,
Gender nchar(1) NOT NULL,
Dob Date NOT NULL,
Photo nvarchar(255) NOT NULL,
Nationality nvarchar(50) NOT NULL,
Bio nvarchar(100) NOT NULL
)

CREATE TABLE Foundation.Movies(
Id int IDENTITY(1,1) NOT NULL PRIMARY KEY, 
Name nvarchar(50) NOT NULL,
YearOfRelease DATE NOT NULL,
Plot nvarchar(100) NOT NULL,
Poster nvarchar(255) NOT NULL,
ProducerId int NOT NULL,
Genre nvarchar(20) NOT NULL,
Language nvarchar(30) NOT NULL,
Country nvarchar(50) NOT NULL,
Rating float,
FOREIGN KEY (ProducerId) REFERENCES Foundation.Producers(Id)
)

CREATE TABLE Foundation.Actors (
    Id int IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    Name nvarchar(255) NOT NULL,
    Gender NCHAR(1) NOT NULL,
    Dob DATE NOT NULL,
    Photo nvarchar(255), -- Changed from IMAGE to NVARCHAR(50) for URL
    Nationality NVARCHAR(50) NOT NULL,
    Bio nvarchar(100) NOT NULL,
);

CREATE TABLE Foundation.Movies_Actors(
Id int IDENTITY(1,1) NOT NULL PRIMARY KEY, 
MovieId int NOT NULL,
ActorId int NOT NULL,
CharacterName nvarchar(50) NOT NULL,
ScreenTime Time NOT NULL,
FOREIGN KEY (MovieId) REFERENCES Foundation.Movies(Id),
FOREIGN KEY (ActorId) REFERENCES Foundation.Actors(Id),
)

-- Insert Producers
INSERT INTO Foundation.Producers (Name, Gender, Dob, Photo, Nationality, Bio) VALUES
('Steven Spielberg', 'M', '1946-12-18', 'https://example.com/spielberg.jpg', 'American', 'Renowned director and producer.'),
('Kathleen Kennedy', 'F', '1953-06-05', 'https://example.com/kennedy.jpg', 'American', 'Prolific film producer.'),
('George Lucas', 'M', '1944-05-14', 'https://example.com/lucas.jpg', 'American', 'Creator of Star Wars.'),
('Jerry Bruckheimer', 'M', '1943-09-21', 'https://example.com/bruckheimer.jpg', 'American', 'Producer of action films.'),
('Christopher Nolan', 'M', '1970-07-30', 'https://example.com/christopher_nolan.jpg', 'British-American', 'Acclaimed director known for Inception and The Dark Knight trilogy.');


-- Insert Actors
INSERT INTO Foundation.Actors (Name, Gender, Dob, Photo, Nationality, Bio) VALUES
('Harrison Ford', 'M', '1942-07-13', 'https://example.com/ford.jpg', 'American', 'Iconic actor.'),
('Mark Hamill', 'M', '1951-09-25', 'https://example.com/hamill.jpg', 'American', 'Best known for Star Wars.'),
('Carrie Fisher', 'F', '1956-10-21', 'https://example.com/fisher.jpg', 'American', 'Princess Leia.'),
('Tom Cruise', 'M', '1962-07-03', 'https://example.com/cruise.jpg', 'American', 'Action movie star.'),
('Val Kilmer', 'M', '1959-12-31', 'https://example.com/kilmer.jpg', 'American', 'Known for Top Gun.'),
('Leonardo DiCaprio', 'M', '1974-11-11', 'https://example.com/dicaprio.jpg', 'American', 'Award-winning actor known for diverse roles.'),
('Joseph Gordon-Levitt', 'M', '1981-02-17', 'https://example.com/gordonlevitt.jpg', 'American', 'Versatile actor and filmmaker.');


-- Insert Movies
INSERT INTO Foundation.Movies (Name, YearOfRelease, Plot, Poster, ProducerId, Genre, Language, Country, Rating) VALUES
('Star Wars: A New Hope', '1977-05-25', 'Luke Skywalker joins the Rebel Alliance.', 'https://example.com/starwars1.jpg', 3, 'Sci-Fi', 'English', 'USA', 8.6),
('Star Wars: The Empire Strikes Back', '1980-05-21', 'The Rebels are attacked by the Empire.', 'https://example.com/starwars2.jpg', 3, 'Sci-Fi', 'English', 'USA', 8.7),
('Raiders of the Lost Ark', '1981-06-12', 'Indiana Jones searches for the Ark of the Covenant.', 'https://example.com/raiders.jpg', 1, 'Action', 'English', 'USA', 8.4),
('Top Gun', '1986-05-16', 'Navy pilots train at an elite school.', 'https://example.com/topgun1.jpg', 4, 'Action', 'English', 'USA', 6.9),
('Top Gun: Maverick', '2022-05-27', 'Maverick trains a new group of pilots.', 'https://example.com/topgun2.jpg', 4, 'Action', 'English', 'USA', 8.3),
('E.T. the Extra-Terrestrial', '1982-06-11', 'A boy befriends an alien.', 'https://example.com/et.jpg', 1, 'Sci-Fi', 'English', 'USA', 7.8),
('Jurassic Park', '1993-06-11', 'Dinosaurs are cloned.', 'https://example.com/jurassic.jpg', 1, 'Sci-Fi', 'English', 'USA', 8.1),
('Schindlers List', '1993-12-15', 'A man saves jews during the holocaust.', 'https://example.com/schindlers.jpg', 1, 'Drama', 'English', 'USA', 8.9),
('Inception', '2010-07-16', 'Inception Plot', 'https://example.com/inception.jpg', 5, 'Sci-Fi', 'English', 'USA', 8.8);

INSERT INTO Foundation.Movies_Actors (MovieId, ActorId, CharacterName, ScreenTime) VALUES
(1, 1, 'Han Solo', '02:00:00'),
(1, 2, 'Luke Skywalker', '02:00:00'),
(1, 3, 'Princess Leia', '01:30:00'),
(2, 1, 'Han Solo', '02:00:00'),
(2, 2, 'Luke Skywalker', '02:00:00'),
(2, 3, 'Princess Leia', '01:30:00'),
(3, 1, 'Indiana Jones', '01:55:00'),
(4, 4, 'Maverick', '01:50:00'),
(4, 5, 'Iceman', '01:10:00'),
(5, 4, 'Maverick', '02:00:00'),
(5, 5, 'Iceman', '00:50:00'),
(6, 3, 'Mary', '01:40:00'),
(7, 1, 'Dr. Alan Grant', '02:00:00'),
(8, 1, 'Oskar Schindler', '03:15:00'),
(9, 6, 'Dom Cobb', '02:28:00'),
(9, 7, 'Arthur', '02:28:00');


ALTER TABLE Foundation.Actors ADD CreatedAt DATETIME2, UpdatedAt DATETIME2

ALTER TABLE Foundation.Producers ADD CreatedAt DATETIME2, UpdatedAt DATETIME2

ALTER TABLE Foundation.Movies ADD CreatedAt DATETIME2, UpdatedAt DATETIME2

ALTER TABLE Foundation.Movies_Actors ADD CreatedAt DATETIME2, UpdatedAt DATETIME2


ALTER TABLE Foundation.Producers
ADD CONSTRAINT DF_FoundationProducers_CreatedAt
DEFAULT GETDATE() FOR CreatedAt;


ALTER TABLE Foundation.Movies
ADD CONSTRAINT DF_FoundationMovies_CreatedAt
DEFAULT GETDATE() FOR CreatedAt;


ALTER TABLE Foundation.Movies_Actors
ADD CONSTRAINT DF_FoundationMoviesActors_CreatedAt
DEFAULT GETDATE() FOR CreatedAt;


ALTER TABLE Foundation.Actors
ADD CONSTRAINT DF_FoundationActors_CreatedAt
DEFAULT GETDATE() FOR CreatedAt;

ALTER TABLE Foundation.Movies ADD Profit int;