.if ( te_sys.StructuredMessaging )
void ${te_c.Name}_smsg_recv( ${te_disp.base_message_type} * m )
{
  switch ( m->mid.port ) {
${te_c.smsg_recv}\
    default:
      ; // CDS - recovery?
  }
}
.end if
