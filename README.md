squid-ad-groups-no-ext-acl
==========================

Squid proxy config for using AD groups without external ldap acls, which are showing terrible performance in my case.

Samba is used, server should be member of AD domain, wbinfo -t should work.

Script periodicaly queries user list for selected groups and updates files. If group did not change, corresponding file remains unchanged. If one of groups has changed, file is updated and squid service is reloaded.
