.if ( not te_po.Provision )
  ${te_c.Name}_port_fd[ ${te_c.Name}_${te_po.Name}_e ] = ${te_prefix.result}smsg_connect( "127.0.0.1", ${te_prefix.define_u}SMSG_PORT_BASE + (${te_prefix.result}${foreign_te_iir.component_name}_e*24) + ${foreign_te_iir.component_name}_${foreign_te_iir.port_name}_e );
.end if
