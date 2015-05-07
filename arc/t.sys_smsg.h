.if ( te_sys.NetworkSockets )

/*
 * Socket-based support for intercomponent (structured) messaging.
 * Port base is attempting to use a free range of unregistered ports.
 */
#define ${te_prefix.define_u}SMSG_PORT_BASE 10300
#define ${te_prefix.define_u}MAX_SMSG_BUFFER ${te_string.max_string_length}
i_t ${te_prefix.result}smsg_listen( c_t *, i_t );
i_t ${te_prefix.result}smsg_connect( c_t *, i_t );
i_t ${te_prefix.result}smsg_accept( i_t );
i_t ${te_prefix.result}smsg_recv( c_t *, i_t, i_t );
i_t ${te_prefix.result}smsg_send( c_t *, i_t, i_t );
.end if
