/*----------------------------------------------------------------------------
 * File:  ${te_c.module_file}.${te_file.hdr_file_ext}
 *
 * UML Component (Module) Declaration (Operations and Signals)
 *
 * ${te_copyright.body}
 *--------------------------------------------------------------------------*/

#ifndef $u{te_c.module_file}_$u{te_file.hdr_file_ext}
#define $u{te_c.module_file}_$u{te_file.hdr_file_ext}
${te_target.c2cplusplus_linkage_begin}
.if ( "" != te_c.Descrip )
/*
${te_c.Descrip}
*/
.end if

#include "${te_file.types}.${te_file.hdr_file_ext}"
.if ( te_sys.NetworkSockets )
void ${te_c.Name}_smsg_listen( void );
void ${te_c.Name}_smsg_connect( void );
void ${te_c.Name}_smsg_accept( void );
void ${te_c.Name}_smsg_poll( void );
.end if
${message_declarations}

${te_target.c2cplusplus_linkage_end}
#endif  /* $u{te_c.module_file}_$u{te_file.hdr_file_ext} */
.//
