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
 * Open a socket as server/provider.  Listen on the given port.
 * Return the socket file descriptor.
 */
i_t 
${te_prefix.result}smsg_listen(
  c_t * host,
  i_t port
)
{
  struct addrinfo hints, *servinfo, *p;
  int sfd;
  c_t strspace[ ${te_string.max_string_length} ];

  ${te_string.memset}( &hints, 0, sizeof( hints ) );
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;
  hints.ai_flags = AI_PASSIVE; /* use my IP */

  if ( 0 != getaddrinfo( host, ${te_string.itoa}( strspace, port ), &hints, &servinfo ) ) {
    perror( "getaddrinfo" );
    sfd = -1;
  } else {
    /* Cycle through a (potential) list of server entries.  */
    for ( p = servinfo; p != 0; p = p->ai_next ) {
      int yes = 1;
      if ( -1 == ( sfd = socket( p->ai_family, p->ai_socktype, p->ai_protocol ) ) ) {
        perror( "socket" );
        sfd = -2;
      } else if ( 0 != setsockopt( sfd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int) ) ) {
        perror( "setsockopt" );
        close( sfd );
        sfd = -3;
      } else if ( 0 != bind( sfd, p->ai_addr, p->ai_addrlen ) ) {
        perror( "bind" );
        close( sfd );
        sfd = -4;
      } else {
        break;
      }
    }
    if ( 0 == p ) {
      fprintf( stderr, "server socket failed %s %d.\n", host, port );
      sfd = -5;
    } else if ( 0 != listen( sfd, 10 ) ) {
      perror( "listen" );
      close( sfd );
      sfd = -6;
    }
  }
  freeaddrinfo( servinfo );
  return sfd;
}

i_t 
${te_prefix.result}smsg_connect(
  c_t * host,
  i_t port
)
{
  struct addrinfo hints, *servinfo, *p;
  int sfd;
  c_t strspace[ ${te_string.max_string_length} ];

  ${te_string.memset}( &hints, 0, sizeof( hints ) );
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;

  if ( 0 != getaddrinfo( host, ${te_string.itoa}( strspace, port ), &hints, &servinfo ) ) {
    perror( "getaddrinfo" );
    sfd = -1;
  } else {
    /* Cycle through a (potential) list of server entries.  */
    for ( p = servinfo; p != 0; p = p->ai_next ) {
      if ( -1 == ( sfd = socket( p->ai_family, p->ai_socktype, p->ai_protocol ) ) ) {
        perror( "socket" );
        sfd = -2;
      } else {
        /* NOTE:  We hang here until we get the net connection!  */
        while ( 0 != connect( sfd, p->ai_addr, p->ai_addrlen ) );
        break;
      }
    }
    if ( 0 == p ) {
      fprintf( stderr, "client socket failed %s %d.\n", host, port );
      sfd = -4;
    }
  }
  freeaddrinfo( servinfo );
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
