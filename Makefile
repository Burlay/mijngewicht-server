PROJECT = mijngewicht_server

DEPS = cowboy jiffy ossp_uuid epgsql
dep_cowboy = pkg://cowboy master
dep_jiffy = https://github.com/davisp/jiffy.git
dep_ossp_uuid = https://github.com/yrashk/erlang-ossp-uuid.git
dep_epgsql=https://github.com/wg/epgsql.git

include erlang.mk
