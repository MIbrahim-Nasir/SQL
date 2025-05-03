--Write an SP to insert a movie:
-----Take the movie details
-----Take the Actor Details ( Actors IDs)
-----Takes the producer Details (Producer IDs)
-----Adds to the required tables.

CREATE PROC usp_check_actor_exists
@ActorId INT,
@Exists INT OUTPUT
AS
BEGIN

	IF EXISTS (SELECT 1 FROM Foundation.Actors WHERE Id = @ActorId)
	BEGIN
		SET @Exists = 1;
	END
	ELSE
	BEGIN
		SET @Exists = 0;
	END
END;
GO

CREATE PROC usp_check_producer_exists
@ProducerId INT,
@Exists INT OUTPUT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Foundation.Producers WHERE Id = @ProducerId)
	BEGIN
		SET @Exists = 1;
	END
	ELSE
	BEGIN
		SET @Exists = 0;
	END
END;
GO

CREATE PROC usp_check_movie_name_exists
@MovieName NVARCHAR(50),
@Exists INT OUTPUT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Foundation.Movies WHERE Name = @MovieName)
	BEGIN
		SET @Exists = 1;
	END
	ELSE
	BEGIN
		SET @Exists = 0;
	END
END;
GO

CREATE PROC usp_insert_movie
	@MovieName NVARCHAR(50),
    @YearOfRelease DATE,
    @Plot NVARCHAR(100),
    @Poster NVARCHAR(255),
    @Genre NVARCHAR(20),
    @Language VARCHAR(30),
    @Country NVARCHAR(50),
    @Rating FLOAT,
    @Profit INT,
    @ActorIds NVARCHAR(MAX), -- list comma separated actor ids (1,2,3,..)
	@CharacterNames NVARCHAR(MAX), -- Comma-separated list of Character Names
    @ScreenTimes NVARCHAR(MAX), -- Comma-separated list of Screen Times in HH:MM:SS
	@ProducerId INT
AS
BEGIN
	--CHECK VARIABLES
	DECLARE @MovieExist INT
	DECLARE @ProducerExist INT;
	DECLARE @ActorExist INT;

	-- Checking if movie already exists
	EXEC usp_check_movie_exists @MovieName, @MovieExist OUT;
	IF @MovieExist = 1
	BEGIN
		PRINT 'Movie already exists'
		RETURN 1;
	END

	-- Crating Temporary tables
	CREATE TABLE #ActorsTemp (Id INT IDENTITY(1, 1), ActorId INT);
    CREATE TABLE #CharacterNamesTemp (Id INT IDENTITY(1, 1), CharacterName NVARCHAR(50));
    CREATE TABLE #ScreenTimesTemp (Id INT IDENTITY(1, 1), ScreenTime TIME);

    -- Insert actor IDs, character names and screen times into the temporary tables
	-- Parsing a comma separated string into ActorIds CharacterNames and Screentimes
    INSERT INTO #ActorsTemp (ActorId)
    SELECT CAST(value AS INT) FROM STRING_SPLIT(@ActorIds, ',');

    INSERT INTO #CharacterNamesTemp (CharacterName)
    SELECT value FROM STRING_SPLIT(@CharacterNames, ',');

    INSERT INTO #ScreenTimesTemp (ScreenTime)
    SELECT CAST(value AS TIME) FROM STRING_SPLIT(@ScreenTimes, ',');
		
	-- Counter and Iterator Variables
	DECLARE @Counter INT = 1;
	DECLARE @MaxCount INT;
	DECLARE @ActorToCheck INT;
	DECLARE @ActorMissingId INT;

	-- Setting Max Count
	SELECT @MaxCount = MAX(ActorId) FROM #ActorsTemp;

	-- Iterating Over Actors given in input and validating if they exist
	WHILE @Counter <= @MaxCount
	BEGIN
		SELECT @ActorToCheck = ActorId FROM #ActorsTemp WHERE Id = @Counter;

		EXEC usp_check_actor_exists @ActorToCheck, @ActorExist OUTPUT;

		IF @ActorExist = 0
		BEGIN
			SELECT @ActorMissingId = ActorId FROM #ActorsTemp WHERE Id = @Counter
			BREAK;
		END

		SET @Counter = @Counter + 1
	END

	-- If Actor does not exist
	IF @ActorExist = 0
	BEGIN
		PRINT 'ActorId' + CAST(@ActorMissingId AS VARCHAR(10)) + 'is not in the database.';
		RETURN 1;
	END

	-- Checking if producer exists
	EXEC usp_check_producer_exists @ProducerId, @ProducerExist OUTPUT;

	-- If Producer does not exist
	IF @ProducerExist = 0
	BEGIN
		PRINT 'Producer does not exist in the database'
		RETURN 1;
	END

	-- If all checks satisfied i.e Movie does not exist and producer and actors exist
	-- Insert Movie in Movie Table
	INSERT INTO Foundation.Movies (Name, YearOfRelease, Plot, Poster, ProducerId, Genre, Language, Country, Rating, Profit ) VALUES (@MovieName, @YearOfRelease, @Plot, @Poster, @ProducerId, @Genre, @Language, @Country, @Rating, @Profit);

	-- Variables for Iterating Character Names and Screen Times
	DECLARE @CharacterName NVARCHAR(50);
	DECLARE @ScreenTime TIME;

	-- Setting loop counter variable and looping
	SET @Counter = 1;
	WHILE @Counter <= @MaxCount
	BEGIN
		-- Selecting the column values from temporary tables
		SELECT @ActorToCheck = ActorId FROM #ActorsTemp WHERE Id = @Counter;
		SELECT @CharacterName = CharacterName FROM #CharacterNamesTemp WHERE Id = @Counter;
		SELECT @ScreenTime = ScreenTime FROM #ScreenTimesTemp WHERE Id = @Counter;

		-- Inserting into Movies_Actors Table
		INSERT INTO Foundation.Movies_Actors (MovieId, ActorId, CharacterName, ScreenTime ) VALUES ((SELECT Id FROM Foundation.Movies WHERE Name = @MovieName), @ActorToCheck, @CharacterName, @ScreenTime);
		SET @Counter = @Counter + 1
	END
END
GO

-- Test Execution
EXEC usp_insert_movie
    @MovieName = 'Top Gun',
    @YearOfRelease = '2024-01-01',
    @Plot = 'A test movie plot.',
    @Poster = 'test.jpg',
    @ProducerId = 1, 
    @Genre = 'Test Genre',
    @Language = 'Test Language',
    @Country = 'Test Country',
    @Rating = 7.5,
    @Profit = 1000000,
    @ActorIds = '1,25', 
    @CharacterNames = 'Test Character',
    @ScreenTimes = '01:30:00';