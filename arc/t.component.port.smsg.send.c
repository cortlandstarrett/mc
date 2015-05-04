    case ${te_c.Name}_${te_po.GeneratedName}_e:
      m->mid.port = ${foreign_te_iir.component_name}_${foreign_te_iir.port_name}_e;
.if ( te_sys.NetworkSockets )
      ${te_prefix.result}smsg_send( (c_t *) m, m->mid.len, ${te_c.Name}_port_fd[ ${te_c.Name}_${te_po.Name}_e ] );
.else
      ${foreign_te_iir.component_name}_smsg_recv( m );
.end if
      break;
