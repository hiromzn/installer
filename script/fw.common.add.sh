firewall-cmd --add-service=ftp --zone=public
firewall-cmd --add-service=ftp --zone=public --permanent
firewall-cmd --add-service=ssh --zone=public
firewall-cmd --add-service=ssh --zone=public --permanent
firewall-cmd --add-service=dns --zone=public
firewall-cmd --add-service=dns --zone=public --permanent
firewall-cmd --add-service=ntp --zone=public
firewall-cmd --add-service=ntp --zone=public --permanent
firewall-cmd --add-service=ldap --zone=public
firewall-cmd --add-service=ldap --zone=public --permanent
firewall-cmd --add-service=ldaps --zone=public
firewall-cmd --add-service=ldaps --zone=public --permanent
