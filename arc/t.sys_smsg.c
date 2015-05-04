.if ( te_sys.NetworkSockets )

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

/* 
 * Open a socket as server/provider or client/requirer.  Return file descriptor.
 */
i_t 
${te_prefix.result}smsg_init(
  c_t * host,
  i_t port,
  i_t iamserver
)
{
  struct addrinfo hints, *servinfo, *p;
  int sfd, rv, yes = 1;
  c_t strspace[ ${te_string.max_string_length} ];

  ${te_string.memset}( &hints, 0, sizeof( hints ) );
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;
  hints.ai_flags = AI_PASSIVE; /* use my IP */

  if ( 0 != ( rv = getaddrinfo( host, ${te_string.itoa}( strspace, port ), &hints, &servinfo ) ) ) {
    fprintf( stderr, "getaddrinfo: %s\n", gai_strerror( rv ) );
    return -1;
  }

  for ( p = servinfo; p != NULL; p = p->ai_next ) {
    if ( -1 == ( sfd = socket( p->ai_family, p->ai_socktype, p->ai_protocol ) ) ) {
      perror( "socket" );
      continue;
    }
    rv = ( iamserver ) ?
      setsockopt( sfd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int) ), bind( sfd, p->ai_addr, p->ai_addrlen ) :
      connect( sfd, p->ai_addr, p->ai_addrlen );
    if ( -1 == rv ) {
      close( sfd );
      perror( "bind/connect" );
      continue;
    }
    break;
  }

  if ( NULL == p ) {
    fprintf( stderr, "socket failed\n" );
    return -2;
  }
  if ( iamserver ) {
    if ( -1 == listen( sfd, 10 ) ) {
      perror( "listen" );
      return -3;
    }
  }

  freeaddrinfo( servinfo ); /* done with this structure */
  return sfd;
}

/* 
 * For a server, accept a pending connection and return the
 * new socket file descriptor.  Close the old one.
 */
i_t 
${te_prefix.result}smsg_accept(
  i_t sfd
)
{
  int accepted_smsg_fd;
  struct sockaddr_storage their_addr;
  socklen_t sin_size = sizeof their_addr;

  accepted_smsg_fd = accept( sfd, (struct sockaddr *) &their_addr, &sin_size );
  if ( -1 == accepted_smsg_fd ) {
    perror( "accept" );
  }
  close( sfd );
  return accepted_smsg_fd;
}

/*
 * Attempt to read a message.  One may be there or not.  If so,
 * we read it and process it.  Otherwise, plan to come back later.
 * This routine needs to be called periodically, perhaps from the
 * background loop.  A timeout is set to limit the wait duration
 * on the socket select.
 */
i_t 
${te_prefix.result}smsg_recv(
  c_t * message,
  i_t maxlength,
  i_t sfd
)
{
  struct timeval timeout;
  fd_set toberead;
  FD_ZERO( &toberead ); /* clear the list */
  FD_SET( sfd, &toberead ); /* mark the socket to be queried */
  timeout.tv_usec = 1000; /* allow 1 millisecond before giving up */
  timeout.tv_sec = 0;
  if ( 0 < select( sfd + 1, &toberead, 0, 0, &timeout ) ) {
    i_t bytes_read;
    bytes_read = recv( sfd, message, maxlength, 0 );
    if ( 0 < bytes_read ) {
      message[ bytes_read ] = 0;
      return bytes_read;
    }
  }
  return 0;
}

/*
 * Attempt to send a message to the host through the socket.
 * Only length bytes will be transmitted even if more exist.
 * Note that this routine walks on the message buffer.
 */
i_t 
${te_prefix.result}smsg_send(
  c_t * message,
  i_t length,
  i_t sfd
)
{
  return send( sfd, message, length, 0 );
}
.end if
