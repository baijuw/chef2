#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
package "httpd" do 
	action :install
end

service "iptables" do 
	action [:stop, :disable]
end


 # template "/etc/haproxyhaproxy.cfg" do 
 # source "haproxy.cfg.erb"
 # owner "root"
 # group "root"
 # mode "0644"
 # notifies :restart, "service[haproxy]"
 # end



# node.default["apache"]["indexfile"] = "index2.html"
# cookbook_file "/var/www/html/index.html" do
# 	source node["apache"]["indexfile"]
# 	mode "0644"
# end

execute "mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/wekcine.conf.disabled" do 
	only_if do
		File.exist?("/etc/httpd/conf.d/welcome.conf")
	end
	notifies :restart, "service[httpd]"
end


node["apache"]["sites"].each do |site_name, site_data| 
	document_root = "/srv/apache/#{site_name}"

	template "/etc/httpd/conf.d/#{site_name}.conf" do
		source "custom.erb"
		mode "0644"
		variables(
			:document_root => document_root,
			:port => site_data["port"]
		)
		notifies :restart, "service[httpd]"
    end

    directory document_root do
        mode "0755"
        recursive true
    end

    template "#{document_root}/index.html" do
		source "index.html.erb"
		mode "0644"
		variables(
			:site_name => site_name,
			:port => site_data["port"]
			)
	end
end

service "httpd" do 
	supports :restart => true
	action [:enable, :start]
end