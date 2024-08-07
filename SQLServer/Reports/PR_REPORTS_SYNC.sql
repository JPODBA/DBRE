USE Ploomes_IdentityProvider
GO
CREATE OR ALTER PROCEDURE PR_REPORTS_SYNC
	@Debug bit = 0, 
	@id int = Null,
	@Shard varchar(15) = Null
AS
/************************************************************************
 Autor: Equipe DBA
 Data de criação: 15/01/2024
 Funcionalidade: Faz a excução das procedures de resincronização do IDP.
 *************************************************************************/
BEGIN 
	Set nocount on

	Create table #Shards (Shard varchar(15))
	
	IF (@Shard is null)
	Begin 

		insert #Shards
		Select distinct Shard 
		From Ploomes_IdentityProvider..resync_reports_idp 
		Where shard not in ('SHARD03')
		order by 1
				
	End
	ELSE
	BEGIN
		insert #Shards 
		Select @Shard
	END


	IF (@Debug = 1)
	Begin 
		Select * From #Shards
		--return
	End


	While exists (Select 1 from #Shards)
	Begin
		
		Select @Shard = Shard from #Shards order by 1 desc
		--Select * From Ploomes_IdentityProvider..resync_reports_idp order by 1 

		
		--- lOG Sincronização ---------------------------------------------------------------
		DECLARE @dataExec datetime = getdate()
		INSERT resync_reports_idp_log 
			(DataInicio, Shard, procExecucao, erroId, erroLinha, erroMsg)
		SELECT 
			@dataExec, @Shard, 'PR_REPORTS_SYNC', 0, 0, null
		--- lOG Sincronização ---------------------------------------------------------------


		IF (@Debug = 1)
		Begin 
			Select @Shard
			Select * from #Shards
			--return
		End
		WAITFOR DELAY '00:00:01';

		exec Ploomes_IdentityProvider.dbo.PR_REPORTS_SYNC_CONTACT @Shard = @Shard, @Debug = 1
	
	    exec Ploomes_IdentityProvider.dbo.PR_REPORTS_SYNC_DEAL @Shard = @Shard, @Debug = 1		
		
		exec Ploomes_IdentityProvider.dbo.PR_REPORTS_SYNC_PROFILE @Shard = @Shard, @Debug = 1

		exec Ploomes_IdentityProvider.dbo.PR_REPORTS_SYNC_TEAM @Shard = @Shard, @Debug = 1

		exec Ploomes_IdentityProvider.dbo.PR_REPORTS_SYNC_USER @Shard = @Shard, @Debug = 1
				 
		
		Delete From #Shards where Shard = @Shard

		
		Declare @limpa_logFile varchar(max)
		Select @limpa_logFile = 'DBCC SHRINKFILE (Ploomes_IdentityProvider_log, 100);'
		Exec(@limpa_logFile)
		
		--- lOG Sincronização ---------------------------------------------------------------

		UPDATE resync_reports_idp_log 
		SET DataFim = GETDATE(), 
			erroId = isnull(ERROR_NUMBER(),0), 
			erroLinha = isnull(ERROR_LINE(),0), 
			erroMsg = isnull(ERROR_MESSAGE(),0) 
		WHERE DataInicio = @dataExec 
			AND Shard = @Shard
	    AND procExecucao = 'PR_REPORTS_SYNC'

		UPDATE resync_reports_idp_log 
		SET TempoDeExec_minutos = DATEDIFF(minute, datainicio, dataFim)
		WHERE DataInicio = @dataExec 
			AND Shard = @Shard
	    AND procExecucao = 'PR_REPORTS_SYNC'

		--- lOG Sincronização ---------------------------------------------------------------


		
	END -- while

END
go
IF (OBJECT_ID('resync_reports_idp_log')is null)Begin 
Create table resync_reports_idp_log(
	DataInicio					datetime, 
	DataFim							datetime, 
	TempoDeExec_minutos int,
	Shard								varchar(15), 
	procExecucao				Varchar(100), 
	erroId							int, 
	erroLinha						int, 
	erroMsg							Varchar(200)
)
End
go 
IF (OBJECT_ID('resync_reports_idp')is null)Begin 
Create table resync_reports_idp(
	Shard								varchar(15), 
	hostset_id					int, 
)
End
--Exec Ploomes_IdentityProvider.dbo.PR_REPORTS_SYNC @Debug = 1, @Shard = 'SHARD08'
--select * from resync_reports_idp

--Select * from resync_reports_idp_log (nolock) order by DataInicio desc

--Delete from resync_reports_idp_log where DataInicio >= '2024-01-16 17:40:00.400'
--Delete From resync_reports_idp_log

--Select * 
--From resync_reports_idp_log (nolock) 
--Where DataInicio >= '2024-02-05 19:36:26.430'
--order by DataInicio desc

--alter table resync_reports_idp_log add hostsetID int

--INSERT INTO resync_reports_idp (hostset_id, Shard) VALUES (1, 'SHARD01'),
--(2, 'SHARD01'),
--(3, 'SHARD01'),
--(4, 'SHARD01'),
--(5, 'SHARD01'),
--(6, 'SHARD01'),
--(7, 'SHARD01'),
--(8, 'SHARD01'),
--(9, 'SHARD01'),
--(10, 'SHARD01'),
--(10005, 'SHARD01'),
--(100002, 'SHARD01'),
--(100022, 'SHARD02'),
--(100023, 'SHARD02'),
--(21, 'SHARD02'),
--(22, 'SHARD02'),
--(23, 'SHARD02'),
--(27, 'SHARD02'),
--(31, 'SHARD03'),
--(41, 'SHARD04'),
--(42, 'SHARD04'),
--(43, 'SHARD04'),
--(44, 'SHARD04'),
--(45, 'SHARD04'),
--(100041, 'SHARD04'),
--(200, 'SHARD04'),
--(100051, 'SHARD05'),
--(100053, 'SHARD05'),
--(51, 'SHARD05'),
--(52, 'SHARD05'),
--(53, 'SHARD05'),
--(54, 'SHARD05'),
--(55, 'SHARD05'),
--(57, 'SHARD05'),
--(58, 'SHARD05'),
--(59, 'SHARD05'),
--(61, 'SHARD06'),
--(62, 'SHARD06'),
--(63, 'SHARD06'),
--(100063, 'SHARD06'),
--(200061, 'SHARD06'),
--(100071, 'SHARD07'),
--(100073, 'SHARD07'),
--(71, 'SHARD07'),
--(72, 'SHARD07'),
--(73, 'SHARD07'),
--(81, 'SHARD08'),
--(100091, 'SHARD09'),
--(91, 'SHARD09'),
--(92, 'SHARD09'),
--(93, 'SHARD09'),
--(111, 'SHARD11');


--GRANT EXECUTE ON dbo.PR_REPORTS_SYNC TO [fernando.lotti];

--GRANT EXECUTE ON dbo.PR_REPORTS_SYNC_CONTACT TO [fernando.lotti];
--GRANT EXECUTE ON dbo.PR_REPORTS_SYNC_DEAL TO [fernando.lotti];
--GRANT EXECUTE ON dbo.PR_REPORTS_SYNC_PROFILE TO [fernando.lotti];
--GRANT EXECUTE ON dbo.PR_REPORTS_SYNC_TEAM TO [fernando.lotti];
--GRANT EXECUTE ON dbo.PR_REPORTS_SYNC_USER TO [fernando.lotti];

