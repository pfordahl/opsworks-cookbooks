#
# Cookbook Name:: hazelcast
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe "hazelcast::install"
include_recipe "hazelcast::configure"