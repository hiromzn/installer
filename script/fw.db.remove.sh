firewall-cmd --remove-service=ftp --zone=public
firewall-cmd --remove-service=ftp --zone=public --permanent
firewall-cmd --remove-service=ssh --zone=public
firewall-cmd --remove-service=ssh --zone=public --permanent
firewall-cmd --remove-service=dns --zone=public
firewall-cmd --remove-service=dns --zone=public --permanent
firewall-cmd --remove-service=ntp --zone=public
firewall-cmd --remove-service=ntp --zone=public --permanent
firewall-cmd --remove-service=ldap --zone=public
firewall-cmd --remove-service=ldap --zone=public --permanent
firewall-cmd --remove-service=ldaps --zone=public
firewall-cmd --remove-service=ldaps --zone=public --permanent
firewall-cmd --remove-service=postgresql --zone=public
firewall-cmd --remove-service=postgresql --zone=public --permanent
