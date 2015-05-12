#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
search("groups", "*:*").each do |group_data|
	group group_data["id"] do
		gid group_data["gid"]
		members group_data["members"]
	end
end
