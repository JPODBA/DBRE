/* Criando as credencias do BLOB para realização dos Restores.*/
--- Central ------ .7

CREATE CREDENTIAL [https://stsqlprdbr01.blob.core.windows.net/bkdiferencialsqlprd01] WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:29:03Z&st=2022-08-19T17:29:03Z&spr=https&sig=tZuIoxW6rLW9Zytw2%2BJcw91rzpiWYX5l%2BKkJN2d8k4s%3D'
CREATE CREDENTIAL [https://stsqlprdbr01.blob.core.windows.net/bkfullsqlprd01]        WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:29:03Z&st=2022-08-19T17:29:03Z&spr=https&sig=tZuIoxW6rLW9Zytw2%2BJcw91rzpiWYX5l%2BKkJN2d8k4s%3D'
CREATE CREDENTIAL [https://stsqlprdbr01.blob.core.windows.net/bkloglsqlprd01]				 WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:29:03Z&st=2022-08-19T17:29:03Z&spr=https&sig=tZuIoxW6rLW9Zytw2%2BJcw91rzpiWYX5l%2BKkJN2d8k4s%3D'
GO

--- Shard 1 --- .30

CREATE CREDENTIAL [https://stsqlprdbr02.blob.core.windows.net/bkdiferencialsqlprd02]  WITH IDENTITY = 'SHARED ACCESS SIGNATURE' ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-21T04:04:02Z&st=2022-07-20T20:04:02Z&spr=https&sig=mwOfPRDSIyDfaVUUXTwm7Iawq%2FFJ0PPfaGEcnWpD%2Fak%3D'
CREATE CREDENTIAL [https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02]					WITH IDENTITY = 'SHARED ACCESS SIGNATURE' ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-21T04:04:02Z&st=2022-07-20T20:04:02Z&spr=https&sig=mwOfPRDSIyDfaVUUXTwm7Iawq%2FFJ0PPfaGEcnWpD%2Fak%3D'
CREATE CREDENTIAL [https://stsqlprdbr02.blob.core.windows.net/bkloglsqlprd02]					WITH IDENTITY = 'SHARED ACCESS SIGNATURE' ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-21T04:04:02Z&st=2022-07-20T20:04:02Z&spr=https&sig=mwOfPRDSIyDfaVUUXTwm7Iawq%2FFJ0PPfaGEcnWpD%2Fak%3D'
GO

--- Shard02 ------ .23

CREATE CREDENTIAL [https://stsqlprdbr03.blob.core.windows.net/bkdiferencialsqlprd03] WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:33:25Z&st=2022-08-19T17:33:25Z&spr=https&sig=Y%2BxK3Y72KrkZE%2F0PhaDtGlT0iVE6ZFQI6qO7hAZdyoc%3D'
CREATE CREDENTIAL [https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03]				 WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:33:25Z&st=2022-08-19T17:33:25Z&spr=https&sig=Y%2BxK3Y72KrkZE%2F0PhaDtGlT0iVE6ZFQI6qO7hAZdyoc%3D'
CREATE CREDENTIAL [https://stsqlprdbr03.blob.core.windows.net/bklogsqlprd03]				 WITH  IDENTITY = 'SHARED ACCESS SIGNATURE'  ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:33:25Z&st=2022-08-19T17:33:25Z&spr=https&sig=Y%2BxK3Y72KrkZE%2F0PhaDtGlT0iVE6ZFQI6qO7hAZdyoc%3D'
GO

--- Shard 3 ---

CREATE CREDENTIAL [https://stsqlprdwe01.blob.core.windows.net/bkdiferencialsqlprdwe01]  WITH IDENTITY = 'SHARED ACCESS SIGNATURE',SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-22T05:08:07Z&st=2022-07-21T21:08:07Z&spr=https&sig=RMwAYr2zhWATZAFGyT3qe7aTQonlOtTwjBUeDU5ttpE%3D'
CREATE CREDENTIAL [https://stsqlprdwe01.blob.core.windows.net/bkfulllsqlprdwe01]				WITH IDENTITY = 'SHARED ACCESS SIGNATURE',SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-22T05:08:07Z&st=2022-07-21T21:08:07Z&spr=https&sig=RMwAYr2zhWATZAFGyT3qe7aTQonlOtTwjBUeDU5ttpE%3D'
CREATE CREDENTIAL [https://stsqlprdwe01.blob.core.windows.net/bklogsqlprdwe01]					WITH IDENTITY = 'SHARED ACCESS SIGNATURE',SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-22T05:08:07Z&st=2022-07-21T21:08:07Z&spr=https&sig=RMwAYr2zhWATZAFGyT3qe7aTQonlOtTwjBUeDU5ttpE%3D'
GO

--- Shard 4 ---  .45

CREATE CREDENTIAL [https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05]  WITH  IDENTITY = 'SHARED ACCESS SIGNATURE' ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:35:44Z&st=2022-08-19T17:35:44Z&spr=https&sig=%2FT%2FcQwZBnrlJVCoSoUUAEzcIurM7OQjFG6NRB1Y860s%3D'
CREATE CREDENTIAL [https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05]				WITH  IDENTITY = 'SHARED ACCESS SIGNATURE' ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:35:44Z&st=2022-08-19T17:35:44Z&spr=https&sig=%2FT%2FcQwZBnrlJVCoSoUUAEzcIurM7OQjFG6NRB1Y860s%3D'
CREATE CREDENTIAL [https://stsqlprdbr05.blob.core.windows.net/bklogsqlprd05]					WITH  IDENTITY = 'SHARED ACCESS SIGNATURE' ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:35:44Z&st=2022-08-19T17:35:44Z&spr=https&sig=%2FT%2FcQwZBnrlJVCoSoUUAEzcIurM7OQjFG6NRB1Y860s%3D'
GO

--- Shard05 ------ .34

CREATE CREDENTIAL [https://stsqlprdbr06.blob.core.windows.net/bkdiferencialsqlprd06]  WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-09-06T22:12:47Z&st=2022-09-06T14:12:47Z&spr=https&sig=LcsOISmfrX4KANskYfXCBV7cZmulGN5JlXjDyuMxo84%3D'
CREATE CREDENTIAL [https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06]         WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-09-06T22:12:47Z&st=2022-09-06T14:12:47Z&spr=https&sig=LcsOISmfrX4KANskYfXCBV7cZmulGN5JlXjDyuMxo84%3D'
CREATE CREDENTIAL [https://stsqlprdbr06.blob.core.windows.net/bklogsqlprd06]          WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-09-06T22:12:47Z&st=2022-09-06T14:12:47Z&spr=https&sig=LcsOISmfrX4KANskYfXCBV7cZmulGN5JlXjDyuMxo84%3D'
GO

--- Shard06 ------ .8

CREATE CREDENTIAL [https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07]         WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwltfx&se=2090-11-11T02:29:59Z&st=2022-11-10T18:29:59Z&spr=https&sig=WO6n8%2FLO5HuQTJV7FjGvCATbv0XUTSFi37YsARxjemQ%3D'
CREATE CREDENTIAL [https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07]	WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwltfx&se=2090-11-11T02:29:59Z&st=2022-11-10T18:29:59Z&spr=https&sig=WO6n8%2FLO5HuQTJV7FjGvCATbv0XUTSFi37YsARxjemQ%3D'
GO


--- Integrações  --- 33

CREATE CREDENTIAL [https://stsqlintprdbr01.blob.core.windows.net/bkdiferencialsqlintprdbr01]  WITH      IDENTITY = 'SHARED ACCESS SIGNATURE'      ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-13T02:53:16Z&st=2022-08-12T18:53:16Z&spr=https&sig=61054hX7L8X4NxYy03G5wwzLqgnXimpJdA8wtKaj1hw%3D'
CREATE CREDENTIAL [https://stsqlintprdbr01.blob.core.windows.net/bkfullsqlintprdbr01]					WITH      IDENTITY = 'SHARED ACCESS SIGNATURE'      ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-13T02:53:16Z&st=2022-08-12T18:53:16Z&spr=https&sig=61054hX7L8X4NxYy03G5wwzLqgnXimpJdA8wtKaj1hw%3D'
CREATE CREDENTIAL [https://stsqlintprdbr01.blob.core.windows.net/bklogsqlintprdbr01]					WITH      IDENTITY = 'SHARED ACCESS SIGNATURE'      ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-13T02:53:16Z&st=2022-08-12T18:53:16Z&spr=https&sig=61054hX7L8X4NxYy03G5wwzLqgnXimpJdA8wtKaj1hw%3D'
GO

--- Analytics ----

CREATE CREDENTIAL [https://stsqlanalyprd01.blob.core.windows.net/bkfullsqlanaly01]				 WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-20T22:57:31Z&st=2022-07-20T14:57:31Z&spr=https&sig=w%2BWeQrCCoEagBo4goHkqgX04Eko1lFSqADUbKqcuF4k%3D'
CREATE CREDENTIAL [https://stsqlanalyprd01.blob.core.windows.net/bkdiferencialsqlanaly01]  WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-20T22:57:31Z&st=2022-07-20T14:57:31Z&spr=https&sig=w%2BWeQrCCoEagBo4goHkqgX04Eko1lFSqADUbKqcuF4k%3D'
CREATE CREDENTIAL [https://stsqlanalyprd01.blob.core.windows.net/bkloglsqlanaly01]				 WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-20T22:57:31Z&st=2022-07-20T14:57:31Z&spr=https&sig=w%2BWeQrCCoEagBo4goHkqgX04Eko1lFSqADUbKqcuF4k%3D'
GO
---- PRD004 -- 71 

CREATE CREDENTIAL [https://stsqlprdbr04.blob.core.windows.net/bkdiferencialsqlprd04]  WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:29:03Z&st=2022-08-19T17:29:03Z&spr=https&sig=tZuIoxW6rLW9Zytw2%2BJcw91rzpiWYX5l%2BKkJN2d8k4s%3D'
CREATE CREDENTIAL [https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04]					WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:29:03Z&st=2022-08-19T17:29:03Z&spr=https&sig=tZuIoxW6rLW9Zytw2%2BJcw91rzpiWYX5l%2BKkJN2d8k4s%3D'
CREATE CREDENTIAL [https://stsqlprdbr04.blob.core.windows.net/bklogsqlprd04]					WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:29:03Z&st=2022-08-19T17:29:03Z&spr=https&sig=tZuIoxW6rLW9Zytw2%2BJcw91rzpiWYX5l%2BKkJN2d8k4s%3D'
GO
