#!/bin/bash

# Configuracoes gerais
# crontab -e
# 0 5 * * * /var/www/myrouter/backup.sh

DATA=`/bin/date +%Y%m%d-%H%M`			# Armazena a data mascarada
DATA1=`/bin/date +%d/%m/%Y`			# Armazena a data mascarada
CAMINHO="/var/www/myrouter/backups/"			# Caminho
NOME="myrouter-$DATA.sql"				# Nome do arquivo de dump
HOST="localhost"				# Servidor do banco de dados
USER="root"					# Usuario do banco de dados
PASSWORD="33#erp@myrouter#33"				# Senha do banco de dados
DATABASE="myrouter"				# Banco de dados para backup

# Configuracoes servidor ftp - backup remoto

FTP="ftp.myrouter.com.br"			# Endereco servidor ftp
USER_FTP="myrouterbackup"			# Usuario ftp
PASSWORD_FTP="33#sysadmin#33"			# Senha ftp


mysqldump -h $HOST -u $USER -p$PASSWORD $DATABASE > $CAMINHO$NOME

mysql -u $USER -p$PASSWORD $DATABASE << EOF
insert into backups (servidor,arquivo,data,idmk,regkey) values ('MyRouterERP','$NOME.gz' ,'$DATA1','00','$DATA');
EOF

gzip $CAMINHO$NOME

sleep 5

ftp -in << EOF
	open $FTP
	user $USER_FTP $PASSWORD_FTP
	bin
	lcd $CAMINHO
	cd private/backupDB
	put $NOME.gz
	bye
EOF

