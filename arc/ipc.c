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
char * Escher_socket_receive( const unsigned int );
void Escher_socket_send( char *, int, const unsigned int );

i_t sockfd;

i_t Escher_socket_init(c_t * h, i_t port, i_t I_am_server)
{
  struct addrinfo hints, *servinfo, *p;
  i_t rv, yes = 1;
  c_t s[32];

  memset(&hints, 0, sizeof hints);
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;
  hints.ai_flags = AI_PASSIVE; // use my IP

  if ((rv = getaddrinfo(h, Escher_itoa(s,port), &hints, &servinfo)) != 0) {
    fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
    return 1;
  }

  for(p = servinfo; p != NULL; p = p->ai_next) {
    if ((sockfd = socket(p->ai_family, p->ai_socktype, p->ai_protocol)) == -1) {
      perror("socket");
      continue;
    }
    rv = ( I_am_server ) ?
      setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int)), bind(sockfd, p->ai_addr, p->ai_addrlen) :
      connect(sockfd, p->ai_addr, p->ai_addrlen);
    if ( -1 == rv ) {
      close(sockfd);
      perror("bind/connect");
      continue;
    }
    break;
  }

  if (p == NULL) {
    fprintf(stderr, "socket failed\n");
    return 2;
  }
  if ( I_am_server ) {
    if (-1 == listen(sockfd, 10)) {
      perror("listen");
      exit(1);
    }
  }

  freeaddrinfo(servinfo); // all done with this structure
  return 0;
}

i_t Escher_socket_accept(void)
{
  int new_fd;
  struct sockaddr_storage their_addr;

  printf("server: waiting for connections...\n");

  socklen_t sin_size = sizeof their_addr;
  new_fd = accept(sockfd, (struct sockaddr *)&their_addr, &sin_size);
  if (new_fd == -1) perror("accept");
  close(sockfd);
  sockfd = new_fd;
  Escher_socket_send("Hello, world!", 13, 0);
  close(new_fd);

  return 0;
}

i_t oldreceive(void);

int main(int argc, char *argv[])
{
  int iamserver = atoi( argv[2] );
  if ( iamserver ) {
    Escher_socket_init(NULL,3490,iamserver);
    Escher_socket_accept();
  } else {
    Escher_socket_init(argv[1],3490,iamserver);
    oldreceive();
  }
  return 0;
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

#define MAXDATASIZE 100 // max number of bytes we can get at once 
i_t oldreceive(void)
{
  int numbytes;
  char buf[MAXDATASIZE];
  if ((numbytes = recv(sockfd, buf, MAXDATASIZE-1, 0)) == -1) {
    perror("recv");
    exit(1);
  }
  buf[numbytes] = '\0';

  printf("client: received '%s'\n",buf);

  close(sockfd);

  return 0;
}

/*
 * Attempt to read a message.  One may be there or not.  If so,
 * we read it and process it.  Otherwise, plan to come back later.
 * This routine needs to be called periodically (perhaps from the
 * background loop.
 */
char * Escher_socket_receive(
  const unsigned int p
)
{
  int retval;
  struct timeval timeout;

  //FD_ZERO( &socklist[ portmap[p] ] );
  //FD_SET( file_descriptor[ portmap[p] ], &socklist[ portmap[p] ] );
  timeout.tv_usec = 10000;
  timeout.tv_sec = 0;
  //retval = select( file_descriptor[ portmap[p] ] + 1, &socklist[ portmap[p] ], 0, 0, &timeout );
  if ( 0 < retval ) {
    //retval = recv( file_descriptor[ portmap[p] ], buffer[ portmap[p] ], sizeof(buffer[ portmap[p] ]), 0 );
    if ( 0 < retval ) {
      //buffer[ portmap[p] ][ retval ] = 0;
      //return buffer[ portmap[p] ];
    }
  }
  return 0;
}


/*
 * Attempt to send a message to the host through the socket.
 * Only length bytes will be transmitted even if more exist.
 * Note that this routine walks on the input buffer.
 */
void Escher_socket_send(
  char * message,
  int length,
  const unsigned int p
)
{
  if ( send( sockfd, message, length, 0 ) < 0 ) {
    perror( "Bad news.  Cannot send message.\n" );
  }
}
