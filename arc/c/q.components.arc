.//============================================================================
.// $RCSfile: q.components.arc,v $
.//
.// Description:
.// Component ports top level query.
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
.//
.assign port_declarations = ""
.assign register_offset = ""
.assign TLM_message_order = ""
.select many te_cs from instances of TE_C where ( selected.included_in_build )
.for each te_c in te_cs
  .assign message_definitions = ""
  .assign message_declarations = ""
  .assign port_enum = ""
  .invoke s = TE_C_CreateIncludeList ( te_c )
  .assign include_files = s.include_files
  .// nested components
  .// ports
  .// messages
  .select many te_pos related by te_c->TE_PO[R2005]
  .if ( te_sys.StructuredMessaging )
    .select many c_is related by te_pos->C_I[R2007]
    .for each c_i in c_is
      .assign message_declarations = message_declarations + "#include ""${c_i.Name}_interface.h""\n"
    .end for
    .assign message_declarations = message_declarations + "void ${te_c.Name}_smsg_recv( ${te_disp.base_message_type} * );\n"
  .end if
  .for each te_po in te_pos
    .// Get the first te_mact(s) in the port.
    .select many te_macts related by te_po->TE_MACT[R2006] where ( selected.Order == 0 )
    .invoke s = TE_MACT_CreateDeclarations( te_macts )
    .assign message_declarations = message_declarations + s.body
  .end for
  .if ( not_empty te_pos )
    .assign port_enum = port_enum + "enum {"
    .for each te_po in te_pos
      .assign port_enum = port_enum + " ${te_c.Name}_${te_po.GeneratedName}_e = ${te_po.Order},"
      .select any foreign_te_po related by te_po->TE_IIR[R2080]->TE_IIR[R2081.'provides or is delegated']->TE_PO[R2080]
      .if ( empty foreign_te_po )
        .select any foreign_te_po related by te_po->TE_IIR[R2080]->TE_IIR[R2081.'requires or delegates']->TE_PO[R2080]
      .end if
      .select one foreign_te_c related by foreign_te_po->TE_C[R2005] where ( selected.included_in_build )
      .invoke r = TE_PO_smsg_send( te_c, te_po, foreign_te_c, foreign_te_po )
      .assign te_c.smsg_send = te_c.smsg_send + r.body
      .select one first_te_mact related by te_po->TE_MACT[R2099]
      .invoke r = TE_PO_smsg_recv( first_te_mact )
      .assign te_c.smsg_recv = te_c.smsg_recv + r.body
    .end for
    .assign port_enum = port_enum + " ${te_c.Name}_portmax };"
  .end if
  .include "${arc_path}/t.component.module.h"
  .emit to file "${te_file.system_include_path}/${te_c.module_file}.${te_file.hdr_file_ext}"
  .//
  .for each te_po in te_pos
    .select one first_te_mact related by te_po->TE_MACT[R2099]
    .// Get the first te_mact(s) in the port.
    .select many te_macts related by te_po->TE_MACT[R2006] where ( selected.Order == 0 )
    .invoke s = TE_MACT_CreateDefinition( te_c, te_po, te_macts )
    .assign message_definitions = message_definitions + s.body
    .assign portisr = ""
    .if ( "TLM" == te_sys.SystemCPortsType )
      .invoke s = TE_MACT_CreateISR( te_macts )
      .assign portisr = s.body
      .invoke wrapper = Vista_TLM_CreateTCLFiles ( te_c )
      .assign register_offset = register_offset + wrapper.register_offset
      .// CDS This is not general purpose yet.  We need to handle multiple ports and ordering within ports and polymorphism.
      .invoke mo = TE_MACT_GenerateTLMMessageOrder( first_te_mact )
      .assign TLM_message_order = TLM_message_order + mo.message_order
    .end if
  .end for
  .//
  .// initialization
  .// Build the domain init information containing data structures collecting
  .// class info for the entire domain.
  .// This set of queries drives the generation of initialization and
  .// top-level domain connection to the rest of the system.
  .select any te_class related by te_c->TE_CLASS[R2064]
  .select any te_sm related by te_c->TE_CLASS[R2064]->TE_SM[R2072]
  .select any te_cia from instances of TE_CIA
  .select one te_dci related by te_c->TE_DCI[R2090]
  .invoke class_dispatch_array = GetDomainDispatcherTableName( te_c.Name )
  .select one te_sync related by te_c->TE_SYNC[R2097]
  .invoke s = CreateDomainInitSegment( te_c, te_sync, te_sm )
  .assign init_segment = s.body
  .//
  .// internal classes
  .//
  .assign function_definitions = ""
  .assign instance_dumpers = ""
  .assign class_info_init = ""
  .if ( te_c.internal_behavior )
    .invoke class_type_identifiers = CreateClassIdentifierFile( te_c, te_sync )
    .assign instance_dumpers = class_type_identifiers.instance_dumpers
    .assign class_info_init = class_type_identifiers.class_info_init
${class_type_identifiers.body}
    .emit to file "${te_file.domain_include_path}/${te_c.classes_file}.${te_file.hdr_file_ext}"
    .// functions
    .if ( not_empty te_sync )
      .invoke r = CreateSynchronousServiceClassDefinition( te_c, te_sync )
      .assign function_definitions = r.body
    .end if
  .end if
  .//
  .select any ilb_te_sync related by te_c->TE_SYNC[R2084] where ( selected.IsSafeForInterrupts )
  .include "${te_file.arc_path}/t.component.messages.c"
  .if ( te_c.isRealized )
    .emit to file "${te_file.system_source_path}/${te_c.module_file}_realized.${te_file.src_file_ext}"
  .else
    .emit to file "${te_file.system_source_path}/${te_c.module_file}.${te_file.src_file_ext}"
  .end if
  .// AUTOSAR VFB ports
  .select many te_macts related by te_c->TE_PO[R2005]->TE_MACT[R2006]
  .include "${te_file.arc_path}/q.autosar.vfb_ports.arc"
.end for
.//
.// ISR/TLM/AUTOSAR/SVX
.// AUTOSAR VFB functions
.include "${te_file.arc_path}/q.autosar.vfb_functions.arc"
.if ( te_sys.SystemCPortsType == "TLM" )
  .include "${te_file.arc_path}/t.component.regdefs.h"
  .emit to file "${te_file.system_source_path}/${te_file.registers}.${te_file.hdr_file_ext}"
.end if
.// registers/memory
