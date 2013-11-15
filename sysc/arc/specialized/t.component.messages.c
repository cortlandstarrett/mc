.//============================================================================
.// Notice:
.// (C) Copyright 1998-2011 Mentor Graphics Corporation
.//     All rights reserved.
.//
.// This document contains confidential and proprietary information and
.// property of Mentor Graphics Corp.  No part of this document may be
.// reproduced without the express written permission of Mentor Graphics Corp.
.//============================================================================
.//
/*----------------------------------------------------------------------------
 * File:  ${te_c.module_file}.${te_file.src_file_ext}
 *
 * UML Component as a SystemC Module
 * Component/Module Name:  ${te_c.Name}
 *
 * ${te_copyright.body}
 *--------------------------------------------------------------------------*/
.if ( "" != te_c.Description )
/*
 ${te_c.Description}
 */
.end if

#include "${te_file.types}.${te_file.hdr_file_ext}"
${include_files}\
#include "${te_c.module_file}.${te_file.hdr_file_ext}"
${message_definitions}
