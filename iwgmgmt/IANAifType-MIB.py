# PySNMP SMI module. Autogenerated from smidump -f python IANAifType-MIB
# by libsmi2pysnmp-0.1.3 at Mon Apr  2 20:39:05 2012,
# Python version sys.version_info(major=2, minor=7, micro=2, releaselevel='final', serial=0)

# Imports

( Integer, ObjectIdentifier, OctetString, ) = mibBuilder.importSymbols("ASN1", "Integer", "ObjectIdentifier", "OctetString")
( NamedValues, ) = mibBuilder.importSymbols("ASN1-ENUMERATION", "NamedValues")
( ConstraintsIntersection, ConstraintsUnion, SingleValueConstraint, ValueRangeConstraint, ValueSizeConstraint, ) = mibBuilder.importSymbols("ASN1-REFINEMENT", "ConstraintsIntersection", "ConstraintsUnion", "SingleValueConstraint", "ValueRangeConstraint", "ValueSizeConstraint")
( Bits, Integer32, ModuleIdentity, MibIdentifier, TimeTicks, mib_2, ) = mibBuilder.importSymbols("SNMPv2-SMI", "Bits", "Integer32", "ModuleIdentity", "MibIdentifier", "TimeTicks", "mib-2")
( TextualConvention, ) = mibBuilder.importSymbols("SNMPv2-TC", "TextualConvention")

# Types

class IANAifType(Integer):
    subtypeSpec = Integer.subtypeSpec+ConstraintsUnion(SingleValueConstraint(194,64,24,69,240,154,4,244,12,114,78,43,113,210,47,178,68,5,214,202,90,11,72,177,188,215,201,89,187,222,49,38,46,159,74,117,227,100,242,172,167,221,224,132,33,243,176,104,149,223,237,92,54,52,200,234,61,97,171,232,41,160,116,150,75,108,76,8,14,137,21,13,10,6,131,44,166,71,55,73,29,147,155,80,22,99,126,20,66,36,192,28,107,31,109,53,103,226,211,217,239,105,212,9,197,111,163,112,189,123,169,3,148,27,161,91,98,48,101,199,219,181,62,170,118,235,225,), SingleValueConstraint(175,135,238,102,129,26,165,216,190,143,146,152,88,51,156,35,133,121,86,230,157,124,179,2,84,182,15,173,193,57,85,204,40,196,17,162,141,136,153,185,110,174,95,19,198,106,30,81,18,151,128,241,191,184,180,229,23,32,87,7,79,208,206,82,125,144,228,138,58,60,16,59,77,119,122,34,42,139,145,134,186,205,195,140,168,236,39,67,203,209,45,65,120,183,94,63,218,37,127,1,207,115,70,130,93,50,213,158,96,83,231,56,25,164,142,220,233,))
    namedValues = NamedValues(("other", 1), ("iso88026Man", 10), ("voiceEM", 100), ("voiceFXO", 101), ("voiceFXS", 102), ("voiceEncap", 103), ("voiceOverIp", 104), ("atmDxi", 105), ("atmFuni", 106), ("atmIma", 107), ("pppMultilinkBundle", 108), ("ipOverCdlc", 109), ("starLan", 11), ("ipOverClaw", 110), ("stackToStack", 111), ("virtualIpAddress", 112), ("mpc", 113), ("ipOverAtm", 114), ("iso88025Fiber", 115), ("tdlc", 116), ("gigabitEthernet", 117), ("hdlc", 118), ("lapf", 119), ("proteon10Mbit", 12), ("v37", 120), ("x25mlp", 121), ("x25huntGroup", 122), ("trasnpHdlc", 123), ("interleave", 124), ("fast", 125), ("ip", 126), ("docsCableMaclayer", 127), ("docsCableDownstream", 128), ("docsCableUpstream", 129), ("proteon80Mbit", 13), ("a12MppSwitch", 130), ("tunnel", 131), ("coffee", 132), ("ces", 133), ("atmSubInterface", 134), ("l2vlan", 135), ("l3ipvlan", 136), ("l3ipxvlan", 137), ("digitalPowerline", 138), ("mediaMailOverIp", 139), ("hyperchannel", 14), ("dtm", 140), ("dcn", 141), ("ipForward", 142), ("msdsl", 143), ("ieee1394", 144), ("if-gsn", 145), ("dvbRccMacLayer", 146), ("dvbRccDownstream", 147), ("dvbRccUpstream", 148), ("atmVirtual", 149), ("fddi", 15), ("mplsTunnel", 150), ("srp", 151), ("voiceOverAtm", 152), ("voiceOverFrameRelay", 153), ("idsl", 154), ("compositeLink", 155), ("ss7SigLink", 156), ("propWirelessP2P", 157), ("frForward", 158), ("rfc1483", 159), ("lapb", 16), ("usb", 160), ("ieee8023adLag", 161), ("bgppolicyaccounting", 162), ("frf16MfrBundle", 163), ("h323Gatekeeper", 164), ("h323Proxy", 165), ("mpls", 166), ("mfSigLink", 167), ("hdsl2", 168), ("shdsl", 169), ("sdlc", 17), ("ds1FDL", 170), ("pos", 171), ("dvbAsiIn", 172), ("dvbAsiOut", 173), ("plc", 174), ("nfas", 175), ("tr008", 176), ("gr303RDT", 177), ("gr303IDT", 178), ("isup", 179), ("ds1", 18), ("propDocsWirelessMaclayer", 180), ("propDocsWirelessDownstream", 181), ("propDocsWirelessUpstream", 182), ("hiperlan2", 183), ("propBWAp2Mp", 184), ("sonetOverheadChannel", 185), ("digitalWrapperOverheadChannel", 186), ("aal2", 187), ("radioMAC", 188), ("atmRadio", 189), ("e1", 19), ("imt", 190), ("mvl", 191), ("reachDSL", 192), ("frDlciEndPt", 193), ("atmVciEndPt", 194), ("opticalChannel", 195), ("opticalTransport", 196), ("propAtm", 197), ("voiceOverCable", 198), ("infiniband", 199), ("regular1822", 2), ("basicISDN", 20), ("teLink", 200), ("q2931", 201), ("virtualTg", 202), ("sipTg", 203), ("sipSig", 204), ("docsCableUpstreamChannel", 205), ("econet", 206), ("pon155", 207), ("pon622", 208), ("bridge", 209), ("primaryISDN", 21), ("linegroup", 210), ("voiceEMFGD", 211), ("voiceFGDEANA", 212), ) + NamedValues(("voiceDID", 213), ("mpegTransport", 214), ("sixToFour", 215), ("gtp", 216), ("pdnEtherLoop1", 217), ("pdnEtherLoop2", 218), ("opticalChannelGroup", 219), ("propPointToPointSerial", 22), ("homepna", 220), ("gfp", 221), ("ciscoISLvlan", 222), ("actelisMetaLOOP", 223), ("fcipLink", 224), ("rpr", 225), ("qam", 226), ("lmp", 227), ("cblVectaStar", 228), ("docsCableMCmtsDownstream", 229), ("ppp", 23), ("adsl2", 230), ("macSecControlledIF", 231), ("macSecUncontrolledIF", 232), ("aviciOpticalEther", 233), ("atmbond", 234), ("voiceFGDOS", 235), ("mocaVersion1", 236), ("ieee80216WMAN", 237), ("adsl2plus", 238), ("dvbRcsMacLayer", 239), ("softwareLoopback", 24), ("dvbTdm", 240), ("dvbRcsTdma", 241), ("x86Laps", 242), ("wwanPP", 243), ("wwanPP2", 244), ("eon", 25), ("ethernet3Mbit", 26), ("nsip", 27), ("slip", 28), ("ultra", 29), ("hdh1822", 3), ("ds3", 30), ("sip", 31), ("frameRelay", 32), ("rs232", 33), ("para", 34), ("arcnet", 35), ("arcnetPlus", 36), ("atm", 37), ("miox25", 38), ("sonet", 39), ("ddnX25", 4), ("x25ple", 40), ("iso88022llc", 41), ("localTalk", 42), ("smdsDxi", 43), ("frameRelayService", 44), ("v35", 45), ("hssi", 46), ("hippi", 47), ("modem", 48), ("aal5", 49), ("rfc877x25", 5), ("sonetPath", 50), ("sonetVT", 51), ("smdsIcip", 52), ("propVirtual", 53), ("propMultiplexor", 54), ("ieee80212", 55), ("fibreChannel", 56), ("hippiInterface", 57), ("frameRelayInterconnect", 58), ("aflane8023", 59), ("ethernetCsmacd", 6), ("aflane8025", 60), ("cctEmul", 61), ("fastEther", 62), ("isdn", 63), ("v11", 64), ("v36", 65), ("g703at64k", 66), ("g703at2mb", 67), ("qllc", 68), ("fastEtherFX", 69), ("iso88023Csmacd", 7), ("channel", 70), ("ieee80211", 71), ("ibm370parChan", 72), ("escon", 73), ("dlsw", 74), ("isdns", 75), ("isdnu", 76), ("lapd", 77), ("ipSwitch", 78), ("rsrb", 79), ("iso88024TokenBus", 8), ("atmLogical", 80), ("ds0", 81), ("ds0Bundle", 82), ("bsc", 83), ("async", 84), ("cnr", 85), ("iso88025Dtr", 86), ("eplrs", 87), ("arap", 88), ("propCnls", 89), ("iso88025TokenRing", 9), ("hostPad", 90), ("termPad", 91), ("frameRelayMPI", 92), ("x213", 93), ("adsl", 94), ("radsl", 95), ("sdsl", 96), ("vdsl", 97), ("iso88025CRFPInt", 98), ("myrinet", 99), )
    
class IANAtunnelType(Integer):
    subtypeSpec = Integer.subtypeSpec+SingleValueConstraint(8,14,13,6,11,7,9,2,12,1,5,10,3,4,)
    namedValues = NamedValues(("other", 1), ("msdp", 10), ("sixToFour", 11), ("sixOverFour", 12), ("isatap", 13), ("teredo", 14), ("direct", 2), ("gre", 3), ("minimal", 4), ("l2tp", 5), ("pptp", 6), ("l2f", 7), ("udp", 8), ("atmp", 9), )
    

# Objects

ianaifType = ModuleIdentity((1, 3, 6, 1, 2, 1, 30)).setRevisions(("2007-09-13 00:00","2007-05-29 00:00","2007-03-08 00:00","2007-01-23 00:00","2006-10-17 00:00","2006-09-25 00:00","2006-08-17 00:00","2006-08-11 00:00","2006-07-25 00:00","2006-06-14 00:00","2006-03-31 00:00","2006-03-30 00:00","2005-12-22 00:00","2005-10-10 00:00","2005-09-09 00:00","2005-05-27 00:00","2005-03-03 00:00","2004-11-22 00:00","2004-06-17 00:00","2004-05-12 00:00","2004-05-07 00:00","2003-08-25 00:00","2003-08-18 00:00","2003-08-07 00:00","2003-03-18 00:00","2003-01-13 00:00","2002-10-17 00:00","2002-07-16 00:00","2002-07-10 00:00","2002-06-19 00:00","2002-01-04 00:00","2001-12-20 00:00","2001-11-15 00:00","2001-11-06 00:00","2001-11-02 00:00","2001-10-16 00:00","2001-09-19 00:00","2001-05-11 00:00","2001-01-12 00:00","2000-12-19 00:00","2000-12-07 00:00","2000-12-04 00:00","2000-10-17 00:00","2000-10-02 00:00","2000-09-01 00:00","2000-08-24 00:00","2000-08-23 00:00","2000-08-22 00:00","2000-04-25 00:00","2000-03-06 00:00","1999-10-08 14:30","1994-01-31 00:00",))
if mibBuilder.loadTexts: ianaifType.setOrganization("IANA")
if mibBuilder.loadTexts: ianaifType.setContactInfo("        Internet Assigned Numbers Authority\n\nPostal: ICANN\n        4676 Admiralty Way, Suite 330\n        Marina del Rey, CA 90292\n\nTel:    +1 310 823 9358\nE-Mail: iana&iana.org")
if mibBuilder.loadTexts: ianaifType.setDescription("This MIB module defines the IANAifType Textual\nConvention, and thus the enumerated values of\nthe ifType object defined in MIB-II's ifTable.")

# Augmentions

# Exports

# Module identity
mibBuilder.exportSymbols("IANAifType-MIB", PYSNMP_MODULE_ID=ianaifType)

# Types
mibBuilder.exportSymbols("IANAifType-MIB", IANAifType=IANAifType, IANAtunnelType=IANAtunnelType)

# Objects
mibBuilder.exportSymbols("IANAifType-MIB", ianaifType=ianaifType)

