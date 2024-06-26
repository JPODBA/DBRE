USE BA_DBA
GO
IF(OBJECT_ID('PR_DBA_MONITORA_PEMISSOES_BASES') IS NULL) EXEC ('CREATE PROCEDURE PR_DBA_MONITORA_PEMISSOES_BASES AS RETURN')
GO
ALTER PROCEDURE PR_DBA_MONITORA_PEMISSOES_BASES
AS
/************************************************************************
 AUTOR: EQUIPE DBA\JO�O PAULO OLIVEIRA	
 DATA DE CRIA��O: 12/06/2024
 DATA DE ATUALIZA��O:                   
 FUNCIONALIDADE: MONITORA AS PERMISS�ES DE INST�NCIA E BANCO DE DADOS
*************************************************************************/
BEGIN
	SET NOCOUNT ON

	TRUNCATE TABLE BA_DBA.DBO.DBA_MONITOR_USERS
	TRUNCATE TABLE BA_DBA.DBO.DBA_MONITOR_LOGINS	

	DROP TABLE IF EXISTS #ROLES_RESUMIDAS
	SELECT 
		LOGINNAME [LOGINNAME],
		HASACCESS [HASACCESS], 
		GETDATE() [ULTIMA_ATUALIZACAO],
		CASE WHEN SYSADMIN = 1      THEN 1 ELSE 0 END  AS SYSADMIN,
		CASE WHEN SECURITYADMIN = 1 THEN 1 ELSE 0 END  AS SECURITYADMIN,
		CASE WHEN SERVERADMIN = 1   THEN 1 ELSE 0 END  AS SERVERADMIN,
		CASE WHEN SETUPADMIN = 1    THEN 1 ELSE 0 END  AS SETUPADMIN,
		CASE WHEN PROCESSADMIN = 1  THEN 1 ELSE 0 END  AS PROCESSADMIN,
		CASE WHEN DISKADMIN = 1     THEN 1 ELSE 0 END  AS DISKADMIN,
		CASE WHEN DBCREATOR = 1     THEN 1 ELSE 0 END  AS DBCREATOR,
		CASE WHEN BULKADMIN = 1     THEN 1 ELSE 0 END  AS BULKADMIN
	INTO #ROLES_RESUMIDAS
	FROM SYS.SYSLOGINS
	WHERE NAME NOT LIKE 'NT%'
		AND NAME NOT IN ('SA')
		AND NAME NOT LIKE 'SQL-PRD-%'
		AND NAME NOT LIKE 'DB-ANALY-PRD%'

	INSERT INTO BA_DBA.DBO.DBA_MONITOR_LOGINS 
	SELECT * FROM #ROLES_RESUMIDAS 
	WHERE SYSADMIN > 0 
	OR SECURITYADMIN > 0 
	OR SERVERADMIN > 0 
	OR SETUPADMIN > 0 
	OR PROCESSADMIN > 0 
	OR DISKADMIN > 0 
	OR DBCREATOR > 0 
	OR BULKADMIN > 0 

	DECLARE @DBS AS TABLE (NAME VARCHAR(100))
	INSERT INTO @DBS (NAME)
	SELECT 
		NAME 
	FROM SYS.DATABASES
	WHERE DATABASE_ID > 4
		AND NAME NOT IN ('BA_DBA')

	WHILE EXISTS (SELECT 1 FROM @DBS) 
	BEGIN
		DECLARE @DB VARCHAR(100), @EXEC VARCHAR(MAX)

		SELECT @DB = NAME FROM @DBS

		SELECT @EXEC = 'USE '+@DB+';
		
		
		INSERT INTO BA_DBA.DBO.DBA_MONITOR_USERS (USERNAME, ROLENAME, ULTIMA_ATUALIZACAO)
		SELECT 
			U.NAME AS USERNAME,
			R.NAME AS ROLENAME, 
			GETDATE()
		FROM SYS.DATABASE_ROLE_MEMBERS DRM
		JOIN SYS.DATABASE_PRINCIPALS     R ON DRM.ROLE_PRINCIPAL_ID = R.PRINCIPAL_ID
		JOIN SYS.DATABASE_PRINCIPALS     U ON DRM.MEMBER_PRINCIPAL_ID = U.PRINCIPAL_ID
		WHERE U.NAME NOT IN (
			 ''PLOOMES_API2''
			,''PLOOMES_BILLING''
			,''PLOOMES_CENTRAL''
			,''PLOOMES_DBSYNC''
			,''PLOOMES_SERVICES''
			,''PLOOMES_SHOOTER''
			,''PLOOMES_API'')
		ORDER BY 
				U.NAME, R.NAME;'

		EXEC(@EXEC)

		DELETE FROM @DBS WHERE NAME = @DB

	END -- END WHILE

END --PROC
GO
-- DROP TABLE IF EXISTS BA_DBA.DBO.DBA_MONITOR_LOGINS
IF (OBJECT_ID ('BA_DBA.DBO.DBA_MONITOR_LOGINS') IS NULL)
BEGIN
	CREATE TABLE BA_DBA.DBO.DBA_MONITOR_LOGINS (
		LOGINNAME			VARCHAR(100), 
		HASACCESS			INT , 
		ULTIMA_ATUALIZACAO DATETIME,
		SYSADMIN			INT,
		SECURITYADMIN INT,
		SERVERADMIN		INT,
		SETUPADMIN		INT,
		PROCESSADMIN  INT,
		DISKADMIN			INT,
		DBCREATOR			INT,
		BULKADMIN			INT
		)
END
GO 
-- DROP TABLE IF EXISTS BA_DBA.DBO.DBA_MONITOR_USERS
IF (OBJECT_ID ('BA_DBA.DBO.DBA_MONITOR_USERS') IS NULL)
BEGIN
	CREATE TABLE BA_DBA.DBO.DBA_MONITOR_USERS (
		USERNAME	VARCHAR(100),  
		ROLENAME VARCHAR(100),
		ULTIMA_ATUALIZACAO DATETIME
		)
END
GO 

--EXEC BA_DBA.DBO.PR_DBA_MONITORA_PEMISSOES_BASES
--SELECT * FROM BA_DBA.DBO.DBA_MONITOR_USERS
--SELECT * FROM BA_DBA.DBO.DBA_MONITOR_LOGINS