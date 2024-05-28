use BA_DBA
GO
IF OBJECT_ID('dbo.PR_DBA_CRONOMETRO') is null exec ('create proc dbo.PR_DBA_CRONOMETRO as return')
GO
ALTER PROC PR_DBA_CRONOMETRO (
  @textoOutput      varchar(150)  = NULL,
  @cronometroLigado bit           = 1,
  @dataIni          datetime      = NULL,
  @dataFim          datetime      = NULL,
  @hash             varchar(50)   = null,
  @debug            Char(1) = 'N',
  @mostraHora       Char(1) = 'N'
) as
/************************************************************************
 Autor: Equipe DBA\João Paulo Oliveira	
 Data de criação: 09/09/2020
 Data de Atualização: 
 Funcionalidade: Guarda numa tabela ## o começo do cronometro, na
 próxima execução, pega a data da tabela ## e faz a diferença.
*************************************************************************/
BEGIN
  SET NOCOUNT ON

  -- @cronometroLigado serve para parametrizar as procs que chamam o cronometro, permitindo controlar a sua execução.
  if (@cronometroLigado = 0)
    RETURN

  declare
    @data1      varchar(23),
    @spid       varchar(5),
    @last_batch varchar(23), --Se o last_batch ainda for o mesmo, significa que é a mesma execução. Fora isso, reinicia o cronometro.
    @raiserror  varchar(300),
    @hora       varchar(20),
    @nomeTabela varchar(150)
  select @spid  = convert(varchar(5), @@spid)
  select @hash = isNull(@hash,'tmp') --Quando não for passado, coloca qualquer coisa para funcionar.
  select @nomeTabela = '##CronometroSpid' + @spid + @hash

  if ((@dataIni is not null) and (@dataFim is not null))
  begin
    select @raiserror = isnull('Cronometro(' + @textoOutput + '): ', '') +
      right('00'  + convert(varchar(2),  datediff(ss, @dataIni, @dataFim) /3600), 2) + ':' +
      right('00'  + convert(varchar(2), (datediff(ss, @dataIni, @dataFim) /60) %60), 2) + ':' +
      right('00'  + convert(varchar(2),  datediff(ss, @dataIni, @dataFim) %60), 2) + '.' +
      right('000' + convert(varchar(3),  datediff(ms, @dataIni, @dataFim) %1000), 3) + ''
    raiserror (@raiserror, 0, 1) with nowait

    RETURN
  end

  select @last_batch = convert(char(23), last_batch, 121) from master.dbo.sysprocesses (NOLOCK) where spid = @spid
  --if (@debug = 'S') begin
  --  select @spid [@spid], @last_batch [@last_batch], @nomeTabela [@nomeTabela]
  --end

  -- Se for a primeira vez, pega data1
  if not exists (select 1 from tempdb.dbo.sysobjects (NOLOCK) where name like @nomeTabela + '%')
  begin
    exec ('create table ' + @nomeTabela + ' (rowId tinyint identity, tempo datetime NOT NULL, spid varchar(5), last_batch varchar(23), hash varchar(50))')
    select @data1 = convert(varchar(23), getdate(), 121)
    exec ('insert into ' + @nomeTabela + '(tempo, spid, last_batch, hash) select ''' + @data1 + ''', ''' + @spid + ''', ''' + @last_batch + ''', ''' + @hash + '''')
if (@debug='S') exec ('select *, '''+@nometabela+''' [nomeTabela] from ' + @nomeTabela)
    if (@textoOutput is not null)
    begin
      select @raiserror = 'Cronometro(' + @textoOutput + '): ...'
      raiserror (@raiserror, 0, 1) with nowait
    end
  end
  else
  begin
    -- Se a execução tiver parado, sai pra iniciar novo processamento.
    declare @last_batchArmazenado varchar(23)
    create table #last_BatchArmazenado (last_batch varchar(23))
    insert into #last_BatchArmazenado exec ('select last_batch from ' + @nomeTabela + ' where hash='''+@hash+'''')
    select @last_batchArmazenado = last_batch from #last_BatchArmazenado
    if (@last_batch <> @last_batchArmazenado)
    begin
      exec ('drop table ' + @nomeTabela)

      -- Aqui eu identifiquei que a execução anterior foi perdida e reinicio o cronometro.
      exec ('create table ' + @nomeTabela + ' (rowId tinyint identity, tempo datetime NOT NULL, spid varchar(5), last_batch varchar(23), hash varchar(50))')
      select @data1 = convert(varchar(23), getdate(), 121)
      exec ('insert into ' + @nomeTabela + ' (tempo, spid, last_batch, hash) select ''' + @data1 + ''', ''' + @spid + ''', ''' + @last_batch + ''', ''' + @hash + '''')
			if (@debug='S') exec ('select *, '''+@nometabela+''' [nomeTabela] from ' + @nomeTabela)
      if (@textoOutput is not null)
      begin
        select @raiserror = 'Cronometro(' + @textoOutput + '): 00:00:00.000'
        raiserror (@raiserror, 0, 1) with nowait
      end

      RETURN
    end

    create table #CronometroGeral (tempoInicio datetime NOT NULL, spid varchar(5) NOT NULL, last_batch varchar(23) NOT NULL)
    exec('insert into #CronometroGeral (tempoInicio, spid, last_batch) select tempo, spid, last_batch from ' + @nomeTabela + ' where hash='''+@hash+'''')

    select @dataIni = tempoInicio
    from #CronometroGeral
    where spid = @spid

    select @dataFim = getdate()
if (@debug='S') exec ('select *, '''+@nometabela+''' [nomeTabela] from ' + @nomeTabela)

    if (@mostraHora = 'S') 
      select @hora = ' hora:'+
        right('00'  + convert(varchar(2), datepart(hh,getdate())), 2) + ':' +
        right('00'  + convert(varchar(2), datepart(mi,getdate())), 2) + ':' +
        right('00'  + convert(varchar(2), datepart(ss,getdate())), 2) + '.' +
        right('000' + convert(varchar(3), datepart(ms,getdate())), 3) + ''
    else
      select @hora = ''

    select @raiserror = 'Cronometro' + isnull('(' + @textoOutput + ')', '') + ': ' +
      right('00'  + convert(varchar(2),  datediff(ss, @dataIni, @dataFim) /3600), 2) + ':' +
      right('00'  + convert(varchar(2), (datediff(ss, @dataIni, @dataFim) /60) %60), 2) + ':' +
      right('00'  + convert(varchar(2),  datediff(ss, @dataIni, @dataFim) %60), 2) + '.' +
      right('000' + convert(varchar(3),  datediff(ms, @dataIni, @dataFim) %1000), 3) + '' +
      @hora
    raiserror (@raiserror, 0, 1) with nowait

    exec ('drop table ' + @nomeTabela)
  end

END --proc
GO

grant exec on pr_dba_cronometro to public
exec sp_recompile pr_dba_cronometro

GO

/*
declare @debug td_in_sim_nao; select @debug ='S'
exec BA_DBA.dbo.pr_dba_cronometro @hash='inicio', @debug=@debug
exec BA_DBA.dbo.pr_dba_cronometro @debug=@debug--, @hash='meio'
exec BA_DBA.dbo.sp_dba_waitfor 1
exec BA_DBA.dbo.pr_dba_cronometro 'teste meio', @debug=@debug--, @hash='meio'
exec BA_DBA.dbo.sp_dba_waitfor 2
exec BA_DBA.dbo.pr_dba_cronometro 'teste inicio', @hash='inicio', @debug=@debug
*/

-- exec BA_DBA.dbo.pr_dba_cronometro @dataIni = '2008-03-03 00:05:47', @dataFim = '2008-03-03 00:08:39', @textoOutput = 'teste'

/*
exec BA_DBA.dbo.pr_dba_cronometro
exec BA_DBA.dbo.sp_dba_waitfor 2
exec BA_DBA.dbo.pr_dba_cronometro 'teste1', @debug='N'
exec BA_DBA.dbo.pr_dba_cronometro
exec BA_DBA.dbo.sp_dba_waitfor 3
exec BA_DBA.dbo.pr_dba_cronometro 'teste2', @debug='N'
*/

