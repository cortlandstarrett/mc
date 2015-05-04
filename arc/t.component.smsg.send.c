.if ( te_sys.StructuredMessaging )
static void ${te_c.Name}_smsg_send( ${te_disp.base_message_type} * );
static void ${te_c.Name}_smsg_send( ${te_disp.base_message_type} * m )
{
  switch ( m->mid.port ) {
.include  "${arc_path}/t.component.smsg.send2.c"
    default:
      ; // CDS - recovery?
  }
}
.end if
