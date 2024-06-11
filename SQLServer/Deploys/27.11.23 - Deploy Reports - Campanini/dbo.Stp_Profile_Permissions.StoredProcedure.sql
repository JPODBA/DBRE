USE Ploomes_IdentityProvider
GO
CREATE or ALTER PROCEDURE [dbo].[Stp_Profile_Permissions]
	@ProfileId INT
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @EntitiesToSetPermission Table
	(
		EntityId INT,
		ModuleEntityId INT
	)

	INSERT INTO @EntitiesToSetPermission VALUES(1, 1)
	INSERT INTO @EntitiesToSetPermission VALUES(2, 2)
	INSERT INTO @EntitiesToSetPermission VALUES(3, 3)
	INSERT INTO @EntitiesToSetPermission VALUES(4, 4)
	INSERT INTO @EntitiesToSetPermission VALUES(24, 7)
	INSERT INTO @EntitiesToSetPermission VALUES(56, 18)

	WHILE((SELECT COUNT(1) FROM @EntitiesToSetPermission) > 0)
	BEGIN
		DECLARE @EntityId INT
		DECLARE @ModuleEntityId INT
		SELECT TOP 1 @EntityId = EntityId, @ModuleEntityId = ModuleEntityId FROM @EntitiesToSetPermission

		DELETE UR
		FROM UserOwner UR INNER JOIN [User] U ON UR.UserId = U.ID
		WHERE U.ProfileId = @ProfileId AND UR.EntityId = @EntityId

		DECLARE @ViewProfileOptionId INT
		SELECT TOP 1 @ViewProfileOptionId = PME.ViewProfileOptionId FROM ProfileModuleEntity PME (NOLOCK) 
		WHERE  PME.ProfileId = @ProfileId AND PME.ModuleEntityId = @ModuleEntityId

		IF (@ViewProfileOptionId = 1)
		BEGIN
			INSERT INTO UserOwner(UserId, OwnerId, EntityId)
			SELECT U.ID, U2.ID, @EntityId
			FROM [User] U (NOLOCK)
			INNER JOIN [User] U2 (NOLOCK) ON U.AccountId = U2.AccountId
			WHERE U.ProfileId = @ProfileId 

			IF(@EntityId <> 24)
			BEGIN
				INSERT INTO UserOwner(UserId, OwnerId, EntityId)
				SELECT U.ID, 0, @EntityId
				FROM [User] U  (NOLOCK)
				WHERE U.ProfileId = @ProfileId 
			END
		END
		ELSE IF (@ViewProfileOptionId = 2)
		BEGIN
			SELECT U.ID, EU.TeamId
			INTO #UsersTeams
			FROM [User] U (NOLOCK)
			INNER JOIN TeamUser (NOLOCK) EU ON U.ID = EU.UserId
			WHERE U.ProfileId = @ProfileId

			INSERT INTO UserOwner(UserId, OwnerId, EntityId)
			SELECT DISTINCT UT.ID, EU2.UserId, @EntityId
			FROM #UsersTeams UT (NOLOCK)
			INNER JOIN TeamUser EU2 (NOLOCK) ON UT.TeamId = EU2.TeamId
			WHERE UT.ID <> EU2.UserId

			DROP TABLE #UsersTeams 
		END

		IF(@ViewProfileOptionId in (2, 3))
		BEGIN
			INSERT INTO UserOwner(UserId, OwnerId, EntityId)
			SELECT U.ID, U.ID, @EntityId
			FROM [User] U (NOLOCK)
			WHERE U.ProfileId = @ProfileId
		END

		DELETE @EntitiesToSetPermission WHERE EntityId = @EntityId
	END


	--Deals from contacts

	DECLARE @ProfileOtherOptionValue INT 
	SELECT TOP 1 @ProfileOtherOptionValue = [VALUE]
	FROM ProfileModuleEntity (NOLOCK) PME
	INNER JOIN ProfileModuleEntityOtherOption (NOLOCK) PMEO ON PME.Id = PMEO.ProfileModuleEntityId AND PMEO.ProfileOtherOptionId = 8
	WHERE PME.ProfileId = @ProfileId AND PME.ModuleEntityId = 2

	IF(@ProfileOtherOptionValue IS NOT NULL)
	BEGIN
		IF(@ProfileOtherOptionValue = 0)
		BEGIN
			DELETE OCU
			FROM DealCollaboratorUser OCU INNER JOIN [User] U ON OCU.UserId = U.ID AND OCU.[System] = 1
			WHERE U.ProfileId = @ProfileId
		END
		ELSE IF(@ProfileOtherOptionValue = 1)
		BEGIN
			SELECT U.ID as UserId, Cli.Id as ContactId
			INTO #UserContacts
			FROM [User] (NOLOCK) U
			INNER JOIN Contact (NOLOCK) Cli ON U.ID = Cli.OwnerId
			WHERE U.ProfileId = @ProfileId

			INSERT INTO DealCollaboratorUser(UserId, DealId, [System])
			SELECT UC.UserId, O.ID, 1
			FROM Deal (NOLOCK) O
			INNER JOIN #UserContacts UC ON UC.ContactId = O.ContactId

			DROP TABLE #UserContacts

			INSERT INTO DealCollaboratorUser(UserId, DealId, [System])
			SELECT U.ID, O.ID, 1
			FROM [User] (NOLOCK) U
			INNER JOIN ContactCollaboratorUser (NOLOCK) CCU ON U.ID = CCU.UserId
			INNER JOIN Deal (NOLOCK) O ON CCU.ContactId  = O.ContactId
			WHERE U.ProfileId = @ProfileId
		END
	END
END;
