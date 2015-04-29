typedef char bool;
typedef char c_t;
typedef int i_t;
typedef long s4_t;
typedef unsigned long u4_t;

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

c_t * Escher_itoa( c_t * , s4_t );
i_t Escher_socket_send( char *, int, int );
i_t Escher_socket_recv( char *, int, const unsigned int );

i_t sockfd;

i_t Escher_socket_init(
  c_t * host,
  i_t port,
  i_t I_am_server
)
{
  struct addrinfo hints, *servinfo, *p;
  i_t sockfd, rv, yes = 1;
  c_t s[32];

  memset( &hints, 0, sizeof( hints ) );
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;
  hints.ai_flags = AI_PASSIVE; // use my IP

  if ( 0 != ( rv = getaddrinfo( host, Escher_itoa( s, port ), &hints, &servinfo ) ) ) {
    fprintf( stderr, "getaddrinfo: %s\n", gai_strerror( rv ) );
    return -1;
  }

  for ( p = servinfo; p != NULL; p = p->ai_next ) {
    if ( -1 == ( sockfd = socket(p->ai_family, p->ai_socktype, p->ai_protocol ) ) ) {
      perror( "socket" );
      continue;
    }
    rv = ( I_am_server ) ?
      setsockopt( sockfd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int) ), bind( sockfd, p->ai_addr, p->ai_addrlen ) :
      connect( sockfd, p->ai_addr, p->ai_addrlen );
    if ( -1 == rv ) {
      close( sockfd );
      perror( "bind/connect" );
      continue;
    }
    break;
  }

  if ( NULL == p ) {
    fprintf( stderr, "socket failed\n" );
    return -2;
  }
  if ( I_am_server ) {
    if ( -1 == listen( sockfd, 10 ) ) {
      perror( "listen" );
      return -3;
    }
  }

  freeaddrinfo( servinfo ); // all done with this structure
  return sockfd;
}

i_t Escher_socket_accept( i_t s )
{
  int accepted_socket_fd;
  struct sockaddr_storage their_addr;
  socklen_t sin_size = sizeof their_addr;

  accepted_socket_fd = accept( s, (struct sockaddr *) &their_addr, &sin_size );
  if ( -1 == accepted_socket_fd ) {
    perror( "accept" );
  } else {
    Escher_socket_send( "Hello, world!", 13, accepted_socket_fd );
  }
  close( s );
  return accepted_socket_fd;
}

int main( int argc, char *argv[] )
{
  c_t buf[32];
  int iamserver = atoi( argv[2] );
  if ( iamserver ) {
    sockfd = Escher_socket_init( NULL, 3490, iamserver );
    sockfd = Escher_socket_accept( sockfd );
  } else {
    sockfd = Escher_socket_init( argv[1], 3490, iamserver );
    if ( 0 < Escher_socket_recv( buf, 32, 0 ) ) {
      printf( "client: received '%s'\n", buf );
    }
  }
  close( sockfd );
  return 0;
}

/*
 * Attempt to read a message.  One may be there or not.  If so,
 * we read it and process it.  Otherwise, plan to come back later.
 * This routine needs to be called periodically (perhaps from the
 * background loop.  A timeout is set up to limit the wait duration
 * on the socket select.
 */
i_t Escher_socket_recv(
  char * message,
  int maxlength,
  const unsigned int p
)
{
  struct timeval timeout;
  fd_set toberead; // will need port mapping here
  FD_ZERO( &toberead ); // clear the list
  FD_SET( sockfd, &toberead ); // mark the socket to be queried
  timeout.tv_usec = 10000;
  timeout.tv_sec = 0;
  if ( 0 < select( sockfd + 1, &toberead, 0, 0, &timeout ) ) {
    int bytes_read;
    bytes_read = recv( sockfd, message, maxlength, 0 );
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
i_t Escher_socket_send(
  char * message,
  int length,
  int s
)
{
  return send( s, message, length, 0 );
}

#define ESCHER_ATOI_RADIX 10
c_t *
Escher_itoa( c_t * string, s4_t value )
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
