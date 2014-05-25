#!/usr/bin/env python
"""
DocString
"""
import argparse
from pysnmp.entity.rfc3413.oneliner import cmdgen
from tabulate import tabulate

def get_uptime(host, port, community):
    """
    DocString
    """
    _cmd_gen = cmdgen.CommandGenerator()

    _err_indication, _err_status, _err_index, _var_binds = _cmd_gen.getCmd(
        cmdgen.CommunityData(community),
        cmdgen.UdpTransportTarget((host, port)),
        cmdgen.MibVariable('DISMAN-EVENT-MIB', 'sysUpTimeInstance'))

    # Check for errors and print out results
    if _err_indication:
        print _err_indication
    else:
        if _err_status:
            print('%s at %s' % (
                _err_status.prettyPrint(),
                _err_index and _var_binds[int(_err_index)-1] or '?'))
        else:
            print _var_binds
            for val in _var_binds:
                _div, _mod = divmod(int(val[1]), 8640000)
                print '%d days ' %_div,
                _div, _mod = divmod(_mod, 360000)
                print '%d:' %_div,
                _div, _mod = divmod(_mod, 6000)
                print '%d:' %_div,
                _div, _mod = divmod(_mod, 100)
                print '%d.%d' %(_div, _mod)

def get_nodes(host, port, community):
    """
    DocString
    """
    _cmd_gen = cmdgen.CommandGenerator()

    _err_indication, _err_status, _err_index, _var_binds = _cmd_gen.nextCmd(
        cmdgen.CommunityData(community),
        cmdgen.UdpTransportTarget((host, port)),
        '.1.3.6.1.4.1.193.19.3.1.2.1.1.1.2',
        '.1.3.6.1.4.1.193.19.3.1.2.1.1.1.3',
        '.1.3.6.1.4.1.193.19.3.1.2.1.1.1.4',
        '.1.3.6.1.4.1.193.19.3.1.2.1.1.1.5',
        '.1.3.6.1.4.1.193.19.3.1.2.1.1.1.6',
        '.1.3.6.1.4.1.193.19.3.1.2.1.1.1.7',
        '.1.3.6.1.4.1.193.19.3.1.2.1.1.1.8',
        '.1.3.6.1.4.1.193.19.3.1.2.1.1.1.9',
        '.1.3.6.1.4.1.193.19.3.1.2.1.1.1.10',
        '.1.3.6.1.4.1.193.19.3.1.2.1.1.1.11')

    # Check for errors and print out results
    if _err_indication:
        print _err_indication
    else:
        if _err_status:
            print('%s at %s' % (
                _err_status.prettyPrint(),
                _err_index and _var_binds[int(_err_index)-1] or '?'))
        else:
            table = []
            for val in _var_binds:
                row = []
                for val2 in val:
                    row.append(val2[1].prettyPrint())
                table.append(row)
            print tabulate(
                table,
                headers=[
                    "name",
                    "machine",
                    "version",
                    "scheduled",
                    "CPU time",
                    "real time",
                    "funcs called",
                    "running procs",
                    "bytes in",
                    "bytes out"])

def get_diskstatus(host, port, community):
    """
    DocString
    """
    _cmd_gen = cmdgen.CommandGenerator()

    _err_indication, _err_status, _err_index, _var_binds = _cmd_gen.nextCmd(
        cmdgen.CommunityData(community),
        cmdgen.UdpTransportTarget((host, port)),
        '.1.3.6.1.4.1.193.19.3.2.2.2.2.1.2',
        '.1.3.6.1.4.1.193.19.3.2.2.2.2.1.3',
        '.1.3.6.1.4.1.193.19.3.2.2.2.2.1.4')

    # Check for errors and print out results
    if _err_indication:
        print _err_indication
    else:
        if _err_status:
            print('%s at %s' % (
                _err_status.prettyPrint(),
                _err_index and _var_binds[int(_err_index)-1] or '?'))
        else:
            table = []
            for val in _var_binds:
                row = []
                for val2 in val:
                    row.append(val2[1].prettyPrint())
                table.append(row)
            print tabulate(
                table,
                headers=["disks", "totalsize (kbytes)", "used (percentage)"],)

def get_interfaces(host, port, community):
    """
    DocString
    """

    _fields = [
        'ifDescr',
        #'ifType',
        #'ifMtu',
        #'ifPhysAddress',
        #'ifAdminStatus',
        #'ifOperStatus',
        #'ifLastChange',
        'ifInOctets',
        #'ifInUcastPkts',
        #'ifInNUcastPkts',
        'ifInDiscards',
        'ifInErrors',
        'ifInUnknownProtos',
        'ifOutOctets',
        #'ifOutUcastPkts',
        #'ifOutNUcastPkts',
        'ifOutDiscards',
        'ifOutErrors',
        #'ifOutQLen',
        #'ifSpecific']
        ]

    _mib_variables = []
    for field in _fields:
        _mib_variables.append(cmdgen.MibVariable('IF-MIB', field))

    _cmd_gen = cmdgen.CommandGenerator()

    _err_indication, _err_status, _err_index, _var_binds = _cmd_gen.nextCmd(
        cmdgen.CommunityData(community),
        cmdgen.UdpTransportTarget((host, port)),
        *_mib_variables
        )

    # Check for errors and print out results
    if _err_indication:
        print _err_indication
    else:
        if _err_status:
            print('%s at %s' % (
                _err_status.prettyPrint(),
                _err_index and _var_binds[int(_err_index)-1] or '?'))
        else:
            table = []
            table = []
            for val in _var_binds:
                row = []
                for val2 in val:
                    row.append(val2[1].prettyPrint())
                table.append(row)
            print tabulate(table, headers=_fields)

def main():
    """
    DocString
    """
    parser = argparse.ArgumentParser(
        description="Use this tool too easily manage your iwg server.")
    parser.add_argument(
        "item",
        help="the name of the item to retrieve",
        default="uptime",
        nargs="?")
    parser.add_argument(
        "-i",
        "--ip-address",
        help="The IP address of the server you want to manage.",
        default="127.0.0.1")
    parser.add_argument(
        "-p",
        "--port",
        help="The port number where snmp is running on the server.",
        default="161",
        type=int)
    parser.add_argument(
        "-c",
        "--community",
        help="The community string",
        default="public")

    args = parser.parse_args()

    if args.item == "uptime":
        get_uptime(args.ip_address, args.port, args.community)
    elif args.item == "disks":
        get_diskstatus(args.ip_address, args.port, args.community)
    elif args.item == "nodes":
        get_nodes(args.ip_address, args.port, args.community)
    elif args.item == "interfaces":
        get_interfaces(args.ip_address, args.port, args.community)

if __name__ == '__main__':
    main()
