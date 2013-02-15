#!/bin/sh
URL="http://webkit.org/"
ML_DEVS_ARCHIVE="https://lists.webkit.org/pipermail/webkit-dev/"
ML_BUGS_ARCHIVE="https://lists.webkit.org/pipermail/webkit-unassigned/"
SVN_REPO="http://svn.webkit.org/repository/webkit/trunk/"
GUILTY_DB="webkit_guilty"
CVSA_DB="webkit_cvsa"
MLSTATS_BUG_DB="webkit_bug_mls"
MLSTATS_DEV_DB="webkit_dev_mls"

#Obtención del código del repositorio:
#svn co $(SVN_REPO)

#Creación de base de datos MySQL para Guilty:
#mysqladmin -u root -p create $(GUILTY_DB)

#echo Generación de base de datos Guilty:
#guilty --output=db --db-driver=mysql --db-user=root --db-password=root --db-database=${GUILTY_DB} ${SVN_REPO}

#Creación de base de datos MySQL para CVSAnaly:
#mysqladmin -u root -p create $(CVSA_DB)

#echo Generación de base de datos CVSAnaly
#cvsanaly2 --db-user=root --db-password=root --db-database=${CVSA_DB} ${SVN_REPO}

#Creación de base de datos MySQL para MLStats, dev:
#mysqladmin -u root -p create $(MLSTATS_DEV_DB)

echo Generación de base de datos MLStats, dev
mlstats --db-admin-user="root" --db-admin-password="root" --db-user="root" --db-password="root" --db-name=${MLSTATS_DEV_DB} ${ML_DEVS_ARCHIVE}

#Creación de base de datos MySQL para MLStats, bugs:
#mysqladmin -u root -p create $(MLSTATS_BUG_DB)

echo Generación de base de datos MLStats, bugs
mlstats --db-admin-user="root" --db-admin-password="root" --db-user="root" --db-password="root" --db-name=${MLSTATS_BUG_DB} ${ML_BUG_ARCHIVE}
