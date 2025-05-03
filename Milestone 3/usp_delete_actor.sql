-- Write an SP to Delete a Actor
-- Takes ActorId

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

CREATE PROC usp_delete_actor
@ActorId INT
AS
BEGIN
	-- declare check variable
	DECLARE @ActorExist INT;
	EXEC usp_check_actor_exists @ActorId, @ActorExist OUT;

	IF @ActorExist = 0
	BEGIN
		PRINT 'Actor does not exist';
		RETURN 1;
	END

	DELETE FROM Foundation.Actors WHERE Id = @ActorId;
	PRINT 'Actor Deleted';
END