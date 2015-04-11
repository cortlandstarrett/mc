.//============================================================================
.// Description:
.// Interfaces top level query.
.//
.// Notice:
.// (C) Copyright 1998-2013 Mentor Graphics Corporation
.//     All rights reserved.
.//
.// This document contains confidential and proprietary information and
.// property of Mentor Graphics Corp.  No part of this document may be
.// reproduced without the express written permission of Mentor Graphics Corp.
.//============================================================================
.//
.//
.select many c_is from instances of C_I
.for each c_i in c_is
  .select any te_po related by c_i->TE_PO[R2007]
  .select one te_mact related by te_po->TE_MACT[R2099]
  .include "${te_file.arc_path}/t.interface.h"
  .while ( not_empty te_mact )
    .select one te_aba related by te_mact->TE_ABA[R2010]
    .include "${te_file.arc_path}/t.interface.message.enum.h"
    .select one te_mact related by te_mact->TE_MACT[R2083.'succeeds']
  .end while
  ${c_i.Name}_msgmax };
  .select any te_mact related by te_po->TE_MACT[R2099]
  .while ( not_empty te_mact )
    .select one te_aba related by te_mact->TE_ABA[R2010]
    .include "${te_file.arc_path}/t.interface.message.h"
    .select one te_mact related by te_mact->TE_MACT[R2083.'succeeds']
  .end while
  .include "${te_file.arc_path}/t.interface2.h"
  .// CDS - find a place for the interface name and interface file name
  .// CDS - TE_I.Name, TE_I.file
  .emit to file "${te_file.system_include_path}/$r{c_i.Name}_interface.${te_file.hdr_file_ext}"
.end for
.//
