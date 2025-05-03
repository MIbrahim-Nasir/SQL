--Write a query to get the age of the Actors in Days(Number of days).
SELECT Name, DATEDIFF(DAY, Dob, GETDATE()) AS AgeInDays from Foundation.Actors 

--Write a query to get the list of Actors who have worked with a given producer X.
SELECT
    A.Name AS ActorName
FROM
    Foundation.Actors A
JOIN
    Foundation.Movies_Actors MA ON A.Id = MA.ActorId
JOIN
    Foundation.Movies M ON MA.MovieId = M.Id
JOIN
    Foundation.Producers P ON M.ProducerId = P.Id
WHERE
    P.Id = 1
GROUP BY
    A.Name;

--	Write a query to get the list of actors who have acted together in two or more movies.
SELECT 
	A1.Name AS Actor1,
	A2.Name AS Actor2,
	COUNT(MA1.MovieId) AS MovieCount
FROM
	Foundation.Movies_Actors MA1
JOIN
	Foundation.Movies_Actors MA2 ON MA1.MovieId = MA2.MovieId AND MA1.ActorId < MA2.ActorId
JOIN
	Foundation.Actors A1 ON MA1.ActorId = A1.Id
JOIN
	Foundation.Actors A2 ON MA2.ActorId = A2.Id
GROUP BY
	A1.Name, A2.Name
HAVING
	COUNT(MA1.MovieId) >=2
	
--Write a query to get the youngest actor.
SELECT Name, DATEDIFF(YEAR, Dob, GETDATE()) from Foundation.Actors WHERE Dob = (SELECT MAX(Dob) FROM Foundation.Actors)

--	Write a query to get the actors who have never worked together.
SELECT
	A1.Name AS Actor1,
	A2.Name AS Actor2
FROM
	Foundation.Actors A1
JOIN
	Foundation.Actors A2 ON A1.Id < A2.Id
JOIN
	Foundation.Movies_Actors MA1 ON A1.Id = MA1.Id
JOIN
	Foundation.Movies_Actors MA2 ON A2.Id = MA2.Id
WHERE
	MA1.MovieId != MA2.MovieId 


--Write a query to get the number of movies in each language.
SELECT Language, COUNT(Id) AS MovieCount FROM Foundation.Movies GROUP BY Language

--Write a query to get me the total profit of all the movies in each language separately.
SELECT Language, SUM(Profit) AS TotalProfit FROM Foundation.Movies GROUP BY Language


--Write a query to get the total profit of movies which have actor X in each language.
SELECT 
	M.Language, 
	SUM(M.Profit) AS TotalProfit
FROM 
	Foundation.Movies M
JOIN 
	Foundation.Movies_Actors MA ON MA.MovieId = M.Id
WHERE
	MA.ActorId = 1
GROUP BY 
	M.Language

--Write a query to get the Total profit by year of release and language
SELECT YearOfRelease, Language, SUM(Profit) AS TotalProfit FROM Foundation.Movies GROUP BY YearOfRelease, Language


--Write a query to get number of movies in each language produced by each producer
SELECT
	P.Name,
	M.Language,
	COUNT(M.Id) AS MovieCount
FROM 
	Foundation.Movies M
JOIN
	Foundation.Producers P ON M.ProducerId = P.Id
GROUP BY
	Language ,P.Name;







