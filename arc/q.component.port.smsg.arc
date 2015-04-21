.//============================================================================
.//
.function TE_PO_smsg_send
  .param inst_ref te_c
  .param inst_ref te_po
  .param inst_ref foreign_te_c
  .param inst_ref foreign_te_po
  .select any te_file from instances of TE_FILE
  .if ( ( not_empty te_c ) and ( not_empty foreign_te_c ) )
    .include "${te_file.arc_path}/t.component.port.smsg.send.c"
  .end if
.end function
.//
.function TE_PO_smsg_recv
  .param inst_ref first_te_mact
  .assign te_mact = first_te_mact
  .select any te_disp from instances of TE_DISP
  .select any te_file from instances of TE_FILE
  .// Build vector table for structured messaging.
  .include "${te_file.arc_path}/t.component.smsg.recv1.c"
  .while ( not_empty te_mact )
    .if ( ( ( te_mact.Provision ) and ( 0 == te_mact.Direction ) ) or ( ( not te_mact.Provision ) and ( 1 == te_mact.Direction ) ) )
      .select one te_aba related by te_mact->TE_ABA[R2010]
      .include "${te_file.arc_path}/t.component.smsg.recv2.c"
    .end if
    .select one te_mact related by te_mact->TE_MACT[R2083.'succeeds']
  .end while
  .include "${te_file.arc_path}/t.component.smsg.recv3.c"
.end function
.//
