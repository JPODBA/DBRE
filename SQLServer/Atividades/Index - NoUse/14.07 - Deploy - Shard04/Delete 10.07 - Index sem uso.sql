use BA_DBA
go 
Select * from DBA_MONITOR_INDEX_NOUSE
Select 'drop index if exists ' +Tabela+'.'+indice from DBA_MONITOR_INDEX_NOUSE

--drop index if exists Campo_Valor_Order.IX_Campo_Valor_Order_DateTimeValue
--drop index if exists Campo_Valor_Cliente.IX_Campo_Valor_Cliente_ID_Campo_Booleano
--drop index if exists Cliente.IX_Cliente_ID_ClientePloomes
--drop index if exists Ploomes_Cliente_Pagamento.IX_Ploomes_Cliente_Pagamento_ID_PagarMe
--drop index if exists Campo_Valor_Lead.IX_Campo_Valor_Lead_ValorTexto
--drop index if exists Campo_Valor_Lead.IX_Campo_Valor_Lead_ValorInteiro
--drop index if exists Campo_Valor_Lead.IX_Campo_Valor_Lead_ID_Campo_Booleano
--drop index if exists Campo_Valor_Lead.IX_Campo_Valor_Lead_ID_Campo_Texto
--drop index if exists Campo_Valor_Lead.IX_Campo_Valor_Lead_ID_Campo_Inteiro
--drop index if exists Campo_Valor_Lead.IX_Campo_Valor_Lead_ID_Campo_Decimal
--drop index if exists Campo_Valor_Lead.IX_Campo_Valor_Lead_ID_Campo_DataHora
--drop index if exists Ploomes_Cliente_Pagamento.IX_Ploomes_Cliente_Pagamento_ID_Boleto