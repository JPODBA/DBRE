USE [Queue]
GO
/****** Object:  StoredProcedure [dbo].[sp_Delete_Queues]    Script Date: 29/05/2024 17:50:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        <Tiago Rodrigues Silva>
-- Create date: <2023-01-23>
-- Description:    <Procedure para apagar logs mais antigos do que 6 meses>
-- =============================================
ALTER PROCEDURE [dbo].[sp_Delete_Queues]
AS
BEGIN
    DELETE FROM [Queue].[dbo].[Integration_Queue] WHERE [CreateDate] < dateadd(month, -6, getdate());
    UPDATE [Queue].[dbo].[Integration_Queue] SET [Status] = 88 WHERE [Status] < 4 AND ([CreateDate] < DATEADD(day, -14, GETDATE()) OR [EntityUpdateDate]< DATEADD(day, -14, GETDATE()));
END