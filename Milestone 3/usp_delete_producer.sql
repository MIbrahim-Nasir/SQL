-- Write an SP to Delete a Producer
--	Takes ProducerId
--	Delete the movies directed by the producer as well

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

CREATE PROC usp_delete_producer_and_movies
@ProducerId INT
AS
BEGIN
	DECLARE @ProducerExist INT;
	EXEC usp_check_producer_exists @ProducerId, @ProducerExist OUT;

	IF @ProducerExist = 0
	BEGIN
		PRINT 'Producer does not exist';
		RETURN 1;
	END

	SELECT Name FROM Foundation.Movies WHERE ProducerId = @ProducerId;
	DELETE FROM Foundation.Movies WHERE ProducerId = @ProducerId;
	DELETE FROM Foundation.Producers WHERE Id = @ProducerId;
	PRINT 'Producer and movies Deleted';
END
