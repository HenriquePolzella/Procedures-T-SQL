create table usuariosPerm
(
	idUsuario int primary key ,--(1,1)
	nome  varchar(100),
	email varchar(200),
	login varchar(200),
	senha varchar(50)
)
--toDO: fazer as permissoes dessa pro ser validada automaticamente 
create or alter procedure permissoesEmail
as
begin
	declare @nomeAccount varchar(50),
			@profilename varchar(100)	
	
	select	@nomeAccount= 'Envio de email pelo Gmail',
			@profilename = 'Gmail_Perfil'

	EXEC msdb.dbo.sysmail_add_account_sp
    @mailserver_name = 'smtp.office365.com',            -- endereço do servidor de envio de e-mails
    @port            = 587,                             -- porta de comunicação
    @enable_ssl      = 1,                               -- habilitar SSL (criptografia durante o envio de dados)
    @account_name    = @nomeAccount,                    -- nome da conta dentro do SQL
    @display_name    = 'Banco Teste',					-- Nome que aparecerá como remetente do e-mail
    @email_address   = 'seuemail@gmail.com',			-- endereço de e-mail
    @username        = 'seuemail@gmail.com',			-- nome de usuário (geralmente o mesmo que o e-mail)
    @password        = 'suasenha'                        -- senha da conta

	
	execute msdb.dbo.sysmail_add_profile_sp
	    @profile_name	= @profilename,
	    @description	= 'Perfil para envio de notificações do SQL.'
	
	execute msdb.dbo.sysmail_add_profileaccount_sp
	
	    @profile_name		= @profilename,
	    @account_name		= @nomeAccount,
	    @sequence_number	= 1
	
	execute msdb.dbo.sp_send_dbmail 
	    @profile_name	=@profilename,
	    @recipients		= 'quemrecebeemail@gmail.com',
	    @subject		= 'Teste do sql ',
	    @body			= 'Corpo da mensagem de teste.'
end

if OBJECT_ID('TB_BODYS') is null
 CREATE TABLE TB_BODYS
 (
	BODY NVARCHAR(MAX)
 )

 if OBJECT_ID('TB_EMAILS') is null
  CREATE TABLE TB_EMAILS
 (
	EMAIL NVARCHAR(MAX)
 )

 insert into TB_EMAILS 
	values ('email@gmail.com')
		select * From tb_emails


insert into TB_BODYS
	values ('COMPRE PRODUTO2')
		select * From TB_BODYS
 
 DECLARE @STRING_SQL NVARCHAR(MAX);
 Select

 @STRING_SQL = stuff( (
	select 
		';execute msdb.dbo.sp_send_dbmail 
		@profile_name = ''Gmail_Perfil'',
		@recipients = ''' + email.email + ''',
		@subject = ''E-mail Teste BD '',
		@body = '''+ body.body +''' ' EXECUTAR
	From tb_emails email ,tb_bodys body 
	for xml path(''),type
).value('.','nvarchar(max)'),1,1,'')

EXECUTE SP_EXECUTESQL @STRING_SQL

SELECT * FROM  TB_BODYS

--TABELAS  RELACIONADAS AO ENVIO DE E-MAIL
select * from  msdb.dbo.sysmail_account

-- Perfis existentes
select * from  msdb.dbo.sysmail_profile

-- Associações Perfil & Conta
select * from  msdb.dbo.sysmail_profileaccount

-- Emails enviados
select *  from msdb.dbo.sysmail_mailitems

-- Consultar logs do gerenciador de e-mails
select *  from msdb.dbo.sysmail_log



SELECT * 
FROM msdb.dbo.sysmail_profileaccount
WHERE profile_id IN (SELECT profile_id FROM msdb.dbo.sysmail_profile WHERE name = 'Gmail_Perfil');
