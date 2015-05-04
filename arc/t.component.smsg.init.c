.if ( te_sys.StructuredMessaging and te_sys.NetworkSockets )

int ${te_c.Name}_port_fd[ ${te_c.Name}_portmax ];
void ${te_c.Name}_smsg_init()
{
${te_c.smsg_init}
}
void ${te_c.Name}_smsg_accept()
{
${te_c.smsg_accept}
}
void ${te_c.Name}_smsg_poll()
{
  i_t i;
  for ( i = 0; i < ${te_c.Name}_portmax; i++ ) {
    if ( 0 < ${te_c.Name}_port_fd[ i ] ) {
      c_t buffer[ ${te_prefix.define_u}MAX_SMSG_BUFFER ];
      if ( 0 < ${te_prefix.result}smsg_recv( buffer, ${te_prefix.define_u}MAX_SMSG_BUFFER, ${te_c.Name}_port_fd[ i ] ) ) {
        ${te_c.Name}_smsg_recv( (${te_disp.base_message_type} *) buffer );
      } else {}
    } else {}
  }
}
.end if
