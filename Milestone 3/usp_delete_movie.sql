--Write an SP to Delete the Movie
--	Takes the movie Id

-- Check if movie exists with id
CREATE PROC usp_check_movie_id_exists
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

-- delete a movie given id
CREATE PROC usp_delete_movie
@MovieId INT
AS
BEGIN
	-- declare check variable
	DECLARE @MovieExist INT;
	EXEC usp_check_movie_id_exists @MovieId, @MovieExist OUT;

	IF @MovieExist = 0
	BEGIN
		PRINT 'Movie does not exist';
		RETURN 1;
	END

	SELECT Name FROM Foundation.Movies WHERE Id = @MovieId;
	DELETE FROM Foundation.Movies WHERE Id = @MovieId;
	PRINT 'Movie Deleted';
END

-- Test Execution
EXEC usp_delete_movie 1