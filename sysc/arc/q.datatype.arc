.//============================================================================
.// $RCSfile: q.datatype.arc,v $
.//
.// Notice:
.// (C) Copyright 1998-2011 Mentor Graphics Corporation
.//     All rights reserved.
.//
.// This document contains confidential and proprietary information and
.// property of Mentor Graphics Corp.  No part of this document may be
.// reproduced without the express written permission of Mentor Graphics Corp.
.//============================================================================
.//
.//
.//============================================================================
.//   Get the S_DT and S_CDT object references for a given attribute
.//   (O_ATTR) instance.
.//============================================================================
.function GetAttributeCodeGenType
  .param inst_ref o_attr
  .//
  .select one dt related by o_attr->S_DT[R114]
  .select one cdt related by dt->S_CDT[R17]
  .select one edt related by dt->S_EDT[R17]
  .select one s_sdt related by dt->S_SDT[R17]
  .select one s_irdt related by dt->S_IRDT[R17]
  .if ( empty cdt )
    .select one cdt related by dt->S_UDT[R17]->S_CDT[R18]
  .end if
  .//
  .if ( empty cdt )
    .if ( empty edt )
      .if ( empty s_sdt )
        .print "Error in attribute ${o_attr.Name}"
        .print "with data type ${dt.Name}"
        .exit 100
      .end if
    .else
      .// Enum, use integer type.
      .select any cdt from instances of S_CDT where ( selected.Core_Typ == 2 )
    .end if
  .end if
  .//
  .if ( not_empty cdt)
  .if ( 7 == cdt.Core_Typ )
    .// cdt.Core_Typ is "same_as<Base_Attribute>"
    .select one base_attr related by o_attr->O_RATTR[R106]->O_BATTR[R113]->O_ATTR[R106]
    .if ( empty base_attr )
      .select one obj related by o_attr->O_OBJ[R102]
      .print "\nCouldn't find O_BATTR for object ${obj.Name} (${obj.Key_Lett}) attribute ${o_attr.Name} !"
      .print "\nDid you combine a referential and then rename the combined attribute?"
      .exit 101
    .end if
    .// Note: the following is a recursive call to this function
    .invoke baseDataType = GetAttributeCodeGenType( base_attr )
    .assign dt = baseDataType.dt
    .assign cdt = baseDataType.cdt
  .end if
  .end if
  .select one te_dt related by dt->TE_DT[R2021]
  .assign te_dt.Included = TRUE
  .assign attr_dt = dt
  .assign attr_cdt = cdt
  .assign attr_result = te_dt.ExtName
.end function
.//
.//============================================================================
.// Return the structure type for persistent links.
.//============================================================================
.function PersistLinkType
  .select any te_prefix from instances of TE_PREFIX
  .invoke instid = GetPersistentInstanceIdentifierVariable()
  .assign attr_type = "struct { ${instid.instid_type} owner, left, right, assoc; }"
  .assign attr_name = te_prefix.type + "link_t"
.end function
.//
.//============================================================================
.// Map a user defined data types precision into its corresponding instance
.// of Data Type (S_DT).
.// Note:  Might prefer POSIX type support here, but doubt we can count
.// on most embedded targets thinking this way.  Thus brute force the types.
.//============================================================================
.function MapUserSpecifiedDataTypePrecision
  .param inst_ref te_dt
  .param string mapping
  .assign attr_error = false
  .assign type = mapping
  .if ( (type == "uchar_t") or ((type == "u_char") or (type == "unsignedchar")) )
    .assign te_dt.ExtName      = "unsigned char"
  .elif ( (type == "char_t") or (type == "char") )
    .assign te_dt.ExtName      = "char"
  .elif ( type == "signedchar" )
    .assign te_dt.ExtName      = "signed char"
  .elif ( (type == "ushort_t") or ((type == "u_short") or (type == "unsignedshort")) )
    .assign te_dt.ExtName      = "unsigned short"
  .elif ( (type == "short_t") or (type == "short") )
    .assign te_dt.ExtName      = "short"
  .elif ( type == "signedshort" )
    .assign te_dt.ExtName      = "signed short"
  .elif ( (type == "uint_t") or ((type == "u_int") or (type == "unsignedint")) )
    .assign te_dt.ExtName      = "unsigned int"
  .elif ( type == "s1_t" )
    .assign te_dt.ExtName      = "s1_t"
  .elif ( type == "u1_t" )
    .assign te_dt.ExtName      = "u1_t"
  .elif ( type == "s2_t" )
    .assign te_dt.ExtName      = "s2_t"
  .elif ( type == "u2_t" )
    .assign te_dt.ExtName      = "u2_t"
  .elif ( type == "s4_t" )
    .assign te_dt.ExtName      = "s4_t"
  .elif ( type == "u4_t" )
    .assign te_dt.ExtName      = "u4_t"
  .elif ( type == "i_t" )
    .assign te_dt.ExtName      = "i_t"
  .elif ( (type == "int_t") or (type == "int") )
    .assign te_dt.ExtName      = "int"
  .elif ( type == "signedint" )
    .assign te_dt.ExtName      = "signed int"
  .elif ( (type == "ulong_t") or ((type == "u_long") or (type == "unsignedlong")) )
    .assign te_dt.ExtName      = "unsigned long"
  .elif ( (type == "long_t") or (type == "long") )
    .assign te_dt.ExtName      = "long"
  .elif ( type == "signedlong" )
    .assign te_dt.ExtName      = "signed long"
  .elif ( (type == "u_longlong_t") or ((type == "u_longlong_t") or (type == "unsignedlonglong")) )
    .assign te_dt.ExtName      = "unsigned long long"
  .elif ( (type == "longlong_t") or ((type == "longlong") or (type == "signedlonglong")) )
    .assign te_dt.ExtName      = "long long"
    .//
  .elif ( type == "float" )
    .assign te_dt.ExtName      = "float"
  .elif ( type == "r4_t" )
    .assign te_dt.ExtName      = "r4_t"
  .elif ( type == "double" )
    .assign te_dt.ExtName      = "double"
  .elif ( type == "r8_t" )
    .assign te_dt.ExtName      = "r8_t"
    .//
  .elif ( type == "size_t" )
    .assign te_dt.ExtName      = "size_t"
  .elif ( type == "ssize_t" )
    .assign te_dt.ExtName      = "ssize_t"
  .elif ( type == "time_t" )
    .assign te_dt.ExtName      = "time_t"
  .elif ( type == "clock_t" )
    .assign te_dt.ExtName      = "clock_t"
  .elif ( type == "volatile_clock_t" )
    .assign te_dt.ExtName      = "volatile unsigned long"
    .//
  .else
    .assign attr_error = true
  .end if
.end function
.//
.//
.//============================================================================
.//============================================================================
