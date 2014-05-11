PROJECT = mijngewicht_server

DEPS = cowboy jiffy ossp_uuid epgsql bcrypt lager folsom
dep_cowboy = pkg://cowboy master
dep_jiffy = https://github.com/davisp/jiffy.git
dep_ossp_uuid = https://github.com/yrashk/erlang-ossp-uuid.git
dep_epgsql=https://github.com/wg/epgsql.git
dep_bcrypt=https://github.com/opscode/erlang-bcrypt.git
dep_lager=https://github.com/basho/lager.git b6b6ceb
dep_folsom=https://github.com/boundary/folsom.git 0.8.1

include erlang.mk
