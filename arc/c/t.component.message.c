
/*
 * Interface:  ${te_mact.InterfaceName}
.if ( te_mact.Provision )
 * Provided \
.else
 * Required \
.end if
Port:  ${te_mact.PortName}
.if ( 0 == te_mact.Direction )
 * To Provider \
.else
 * From Provider \
.end if
Message:  ${te_mact.MessageName}
 */
${te_aba.ReturnDataType}
${te_aba.scope}${te_aba.GeneratedName}(${te_aba.ParameterDefinition})
{
  .if ( te_aba.NonSelfEventCount > 0 )
    .if ( event_prioritization_needed.result )
  /* Set up instance handle for priority event generation.  */
  static ${te_instance.handle} ${te_instance.self};
    .end if
  .end if
  .if ( te_mact.trace )
    .invoke r = GetDomainTypeIDFromString( te_c.Name )
    .assign dom_id = r.result
  /* <message compname="${te_c.Name}" compnum="${te_c.number}" portname="${te_po.Name}" portnum="${te_po.Order}" msgname="${te_mact.MessageName}" msgnum="${te_mact.Order}"/> */
  ${te_trace.component_msg_start}( "${te_aba.ParameterFormat}", ${dom_id}, ${te_po.Order}, ${te_mact.Order}${te_aba.ParameterTrace} );
  .end if
  .if ( te_sys.StructuredMessaging )
    .if ( ( ( te_mact.Provision ) and ( 1 == te_mact.Direction ) ) or ( ( not te_mact.Provision ) and ( 0 == te_mact.Direction ) ) )
      .// outbound message
    ${te_mact.InterfaceName}_${te_mact.MessageName}_t m, * e; e = &m;
    e->mid.msg = ${te_mact.InterfaceName}_${te_mact.MessageName}_e;
    e->mid.len = sizeof( ${te_mact.InterfaceName}_${te_mact.MessageName}_t );
    e->mid.port = ${te_c.Name}_${te_po.GeneratedName}_e;
${te_aba.ParameterAssignment}
      .if ( not_empty foreign_te_po )
  ${te_c.Name}_smsg_send( ( ${te_disp.base_message_type} * ) &m );
        .assign action_body = ""
      .end if
    .end if
  .end if
  ${action_body}
}
