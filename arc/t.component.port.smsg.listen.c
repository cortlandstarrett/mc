.if ( te_po.Provision )
  ${te_c.Name}_port_fd[ ${te_c.Name}_${te_po.Name}_e ] = ${te_prefix.result}smsg_listen( "127.0.0.1", ${te_prefix.define_u}SMSG_PORT_BASE + (${te_prefix.result}${te_c.Name}_e*24) + ${te_c.Name}_${te_po.Name}_e );
.end if
