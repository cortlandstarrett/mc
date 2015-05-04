.if ( te_po.Provision )
  ${te_c.Name}_port_fd[ ${te_c.Name}_${te_po.Name}_e ] = ${te_prefix.result}smsg_init( "127.0.0.1", ${te_prefix.define_u}SMSG_PORT_BASE + (${te_c.Name}_DOMAIN_ID*24) + ${te_c.Name}_${te_po.Name}_e, 1 );
.else
  ${te_c.Name}_port_fd[ ${te_c.Name}_${te_po.Name}_e ] = ${te_prefix.result}smsg_init( "127.0.0.1", ${te_prefix.define_u}SMSG_PORT_BASE + (${foreign_te_iir.component_name}_DOMAIN_ID*24) + ${foreign_te_iir.component_name}_${foreign_te_iir.port_name}_e, 0 );
.end if
