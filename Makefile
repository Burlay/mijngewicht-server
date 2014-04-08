PROJECT = mijngewicht_server

DEPS = cowboy jiffy ossp_uuid epgsql bcrypt lager
dep_cowboy = pkg://cowboy master
dep_jiffy = https://github.com/davisp/jiffy.git
dep_ossp_uuid = https://github.com/yrashk/erlang-ossp-uuid.git
dep_epgsql=https://github.com/wg/epgsql.git
dep_bcrypt=https://github.com/opscode/erlang-bcrypt.git
dep_lager=https://github.com/basho/lager.git b6b6ceb

include erlang.mk
