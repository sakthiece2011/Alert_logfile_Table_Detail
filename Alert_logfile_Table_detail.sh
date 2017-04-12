#exit 0

#!/usr/bin/ksh
###################################################################################
#                                Paysa Db entries
#                      Use pursuant to company instructions
#
#
#  Script  Name:Alert_Table_modification_Paysa.sh
#
#  Description : This script checks for impacted tables in Paysa remittance application client login
#                and sends report to Users via email.
#
#
#  Parameters  : 
#
#
#  Change Log
#
#  Changed By            Date           Description
#  -----------------     ---------      -----------------------------
#  Sakthivel V      2016-04-11       Initial
######################################################################################

#!/bin/sh

set -x

###############Need to change the configuration settings:#########

FromEmailId="AutoAlert-TableModified@domain.com"
ToEmailId="to_mail_id";
FileDir=/dirname/apache-tomcat-7.0.40/logs

##################################################################
cd $FileDir

#################change the logile name##########################
grep Hibernate $FileDir/file_name > $FileDir/Hibernate.txt
##################################################################

grep -oP "from\s+\K\w+" $FileDir/Hibernate.txt >> $FileDir/tables.txt

grep -oP "join\s+\K\w+" $FileDir/Hibernate.txt >> $FileDir/tables.txt

grep -oP "update\s+\K\w+" $FileDir/Hibernate.txt >> $FileDir/tables.txt

grep -oP "into\s+\K\w+" $FileDir/Hibernate.txt >> $FileDir/tables.txt

sort $FileDir/tables.txt | uniq > $FileDir/Final_tables.txt

cat $FileDir/Final_tables.txt > $FileDir/Affected_tables.txt

###################################################################################
#Step 5:- Sending mail Notification with list of jobs modified
##################################################################################

Count=`cat $FileDir/Affected_tables.txt |wc -l`

if [[ $Count -ge 1 ]]; then

echo "Hi Team," > $FileDir/MailTextFile.txt
echo "" >> $FileDir/MailTextFile.txt

FromDate=`date +%H:%M -d 'now - 4 hours'`
echo "Please Find Below The List Of tables Got Modified In Paysa Application Between $FromDate Hrs AND `date +%H:%M%p` Hrs  Today [ `date +%d-%m-%y` ]"  >> MailTextFile.txt
echo "" >> $FileDir/MailTextFile.txt
echo "Table List" >> $FileDir/MailTextFile.txt
echo "---------------" >> $FileDir/MailTextFile.txt
cat $FileDir/Affected_tables.txt >> $FileDir/MailTextFile.txt
echo "" >> $FileDir/MailTextFile.txt
echo "This is a System generated email. Please don't reply to the email." >> $FileDir/MailTextFile.txt
echo "" >> $FileDir/MailTextFile.txt
echo "Thanks & Regards" >> $FileDir/MailTextFile.txt
echo "  Data Migration Team" >> $FileDir/MailTextFile.txt
cat $FileDir/MailTextFile.txt | 
     mailx -v -s "Table Modification Alert-Paysa Application B/W $FromDate AND `date +%H:%M` Hrs  [ `date +%d-%m-%y` ]" \
    -S smtp-use-starttls \
    -S ssl-verify=ignore \
    -S smtp-auth=login \
    -S smtp=smtp://smtp.office365.com:587 \
    -S from=from mail id \
    -S smtp-auth-user=username \
    -S smtp-auth-password=password \
    -S nss-config-dir="/etc/pki/nssdb/" \
	$ToEmailId


###################################################################################
#Step 6:- Removing Temp Files
##################################################################################

rm $FileDir/MailTextFile.txt
rm $FileDir/Affected_tables.txt
rm $FileDir/tables.txt
rm $FileDir/Hibernate.txt
rm $FileDir/Final_tables.txt
fi
