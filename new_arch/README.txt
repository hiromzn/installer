
#--------------------------------
# directory structure & scripts
#--------------------------------
#
#   TOOL_HOME/
#		env.base/
#			httpd, jboss, systemctl[httpd/jboss]
#		conf.base/
#			httpd, jboss, systemctl[httpd/jboss], testapp
#
# : mkenv
#   ./$OUTPUT_DIR/
#	<INST_NAME>/
#		env/
#			os, httpd, jboss, systemctl[httpd/jboss]
# : mkconf
#		conf/
#			httpd, jboss, systemctl[httpd/jboss]
#
# : install <INST_NAME>_directory
# : start <INST_NAME>_directory
#		logs/start.httpd.log
#		logs/start.jboss.log
#
# : mkrunconf <INST_NAME>_directory
#		logs/runconf.httpd.log
#		logs/runconf.jboss.log
#
# : check <INST_NAME>_directory
#		logs/check.httpd.log
#		logs/check.jboss.log
#
# input:
#	env_dir/
#		httpd.env
#		jboss.env
#		systemctl.httpd.env
#		systemctl.jboss.env
#
# output:
#	conf_dir
# structure
#	mkconf iname num
#		httpd iname num
#		jboss iname num
#		systemctl.httpd iname num
#		systemctl.jboss iname num
#			file_conf iname num
#			run_conf iname num

