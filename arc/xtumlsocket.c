typedef char bool;
typedef char c_t;
typedef int i_t;
typedef long s4_t;
typedef unsigned long u4_t;
#define Escher_memset memset
#define SYS_MAX_STRING_LEN 128
c_t * Escher_itoa( c_t *, s4_t );

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
#include "xtumlsocket.h"

/* 
 * Open a socket in server or client mode.  Return the socket handle.
 */
i_t 
Escher_socket_init(
  c_t * host,
  i_t port,
  i_t iamserver
)
{
  struct addrinfo hints, *servinfo, *p;
  int sfd, rv, yes = 1;
  c_t strspace[ SYS_MAX_STRING_LEN ];

  Escher_memset( &hints, 0, sizeof( hints ) );
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;
  hints.ai_flags = AI_PASSIVE; /* use my IP */

  if ( 0 != ( rv = getaddrinfo( host, Escher_itoa( strspace, port ), &hints, &servinfo ) ) ) {
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
Escher_socket_accept(
  i_t sfd
)
{
  int accepted_socket_fd;
  struct sockaddr_storage their_addr;
  socklen_t sin_size = sizeof their_addr;

  accepted_socket_fd = accept( sfd, (struct sockaddr *) &their_addr, &sin_size );
  if ( -1 == accepted_socket_fd ) {
    perror( "accept" );
  }
  close( sfd );
  return accepted_socket_fd;
}

/*
 * Attempt to read a message.  One may be there or not.  If so,
 * we read it and process it.  Otherwise, plan to come back later.
 * This routine needs to be called periodically, perhaps from the
 * background loop.  A timeout is set to limit the wait duration
 * on the socket select.
 */
i_t 
Escher_socket_recv(
  c_t * message,
  i_t maxlength,
  i_t sfd
)
{
  struct timeval timeout;
  fd_set toberead; /* will need port mapping here */
  FD_ZERO( &toberead ); /* clear the list */
  FD_SET( sfd, &toberead ); /* mark the socket to be queried */
  timeout.tv_usec = 10000;
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
Escher_socket_send(
  c_t * message,
  i_t length,
  i_t sfd
)
{
  return send( sfd, message, length, 0 );
}

#define ESCHER_ATOI_RADIX 10
c_t *
Escher_itoa(
  c_t * string,
  s4_t value
)
{
  c_t tmp[16];
  c_t * sp, * tp = tmp;
  s4_t i;
  bool sign;
  u4_t v;

  sign = ( value < 0 );
  if ( sign ) {
    v = -value;
  } else {
    v = (unsigned) value;
  }
  while ( ( v != 0 ) || ( tp == tmp ) ) {
    i = v % ESCHER_ATOI_RADIX;
    v = v / ESCHER_ATOI_RADIX;
    if ( i < 10 ) {
      *tp++ = i + '0';
    } else {
      *tp++ = i + 'a' - 10;
    }
  }
  sp = string;
  if ( sign ) {
    *sp++ = '-';
  }
  while ( tp > tmp ) {
    *sp++ = *--tp;
  }
  *sp = 0;
  return string;
}

#define socket_port_base 10300
#define calc_domain_id 0
#define keypad_domain_id 1
enum { tocalc_e = 0, keypad_maxports };
enum { keyboard_e = 0, calc_maxports };
int 
main( int argc, char * argv[] )
{
  int calc_port_fd[ calc_maxports ];
  int keypad_port_fd[ keypad_maxports ];
  int iamserver = atoi( argv[2] );
  if ( 1 ) {
      i_t bytes_sent = 0;
      keypad_port_fd[ tocalc_e ] = Escher_socket_init( NULL, socket_port_base + (keypad_domain_id*24) + tocalc_e, 1 );
      calc_port_fd[ keyboard_e ] = Escher_socket_init( argv[1], socket_port_base + (keypad_domain_id*24) + tocalc_e, 0 );
      if ( 0 < keypad_port_fd[ keyboard_e ] ) keypad_port_fd[ keyboard_e ] = Escher_socket_accept( keypad_port_fd[ keyboard_e ] );
      if ( 0 < keypad_port_fd[ keyboard_e ] ) bytes_sent = Escher_socket_send( "Hello, world!", 13, keypad_port_fd[ keyboard_e ] );
      if ( 0 >= bytes_sent ) perror( "send" );
      if ( 0 < calc_port_fd[ keyboard_e ] ) {
        c_t buf[ SYS_MAX_STRING_LEN ];
        if ( 0 < Escher_socket_recv( buf, SYS_MAX_STRING_LEN, calc_port_fd[ keyboard_e ] ) ) {
          printf( "client: received '%s'\n", buf );
        } else { /* recv recovery TBD */ }
      } else { /* recovery TBD */ }
  } else {
    if ( iamserver ) {
      i_t bytes_sent = 0;
      keypad_port_fd[ tocalc_e ] = Escher_socket_init( NULL, port_base + (keypad_domain_id*24) + tocalc_e, iamserver );
      if ( 0 < keypad_port_fd[ keyboard_e ] ) keypad_port_fd[ keyboard_e ] = Escher_socket_accept( keypad_port_fd[ keyboard_e ] );
      if ( 0 < keypad_port_fd[ keyboard_e ] ) bytes_sent = Escher_socket_send( "Hello, world!", 13, keypad_port_fd[ keyboard_e ] );
      if ( 0 >= bytes_sent ) perror( "send" );
    } else {
      calc_port_fd[ keyboard_e ] = Escher_socket_init( argv[1], port_base + (keypad_domain_id*24) + tocalc_e, iamserver );
      if ( 0 < calc_port_fd[ keyboard_e ] ) {
        c_t buf[ SYS_MAX_STRING_LEN ];
        if ( 0 < Escher_socket_recv( buf, SYS_MAX_STRING_LEN, calc_port_fd[ keyboard_e ] ) ) {
          printf( "client: received '%s'\n", buf );
        } else { /* recv recovery TBD */ }
      } else { /* recovery TBD */ }
    }
  }
  close( calc_port_fd[ keyboard_e ] );
  close( keypad_port_fd[ tocalc_e ] );
  return 0;
}
