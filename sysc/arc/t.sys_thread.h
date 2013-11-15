.//============================================================================
.// Notice:
.// (C) Copyright 1998-2011 Mentor Graphics Corporation
.//     All rights reserved.
.//
.// This document contains confidential and proprietary information and
.// property of Mentor Graphics Corp.  No part of this document may be
.// reproduced without the express written permission of Mentor Graphics Corp.
.//============================================================================
.//
.//
/*
 * Delcarations for multi-tasking/threading services.
 */

.if ( te_thread.flavor == "Nucleus" )
#include "nucleus.h"   /* Nucleus PLUS declarations */
.end if

.if ( te_thread.enabled )
#define ${te_prefix.define_u}TASKING_${te_thread.flavor} 1
.end if
#define NUM_OF_XTUML_CLASS_THREADS ${te_thread.number_of_threads}
#define NUM_OF_TOTAL_THREADS NUM_OF_XTUML_CLASS_THREADS\
.if ( persistence_needed.result )
 + 1
#define PERSISTENCE_THREAD_NUMBER NUM_OF_TOTAL_THREADS - 1
.else

.end if .// persistence_needed
.assign i = 0
#define SEMAPHORE_FLAVOR_IQUEUE    ${i}
.assign i = i + 1
#define SEMAPHORE_FLAVOR_SQUEUE    ${i}
.assign i = i + 1
#define SEMAPHORE_FLAVOR_FREELIST  ${i}
.assign i = i + 1
#define SEMAPHORE_FLAVOR_NONBUSY   ${i}
.if ( te_thread.serialize )
.assign i = i + 1
#define SEMAPHORE_FLAVOR_DISPATCH  ${i}
.end if
.assign i = i + 1
#define SEMAPHORE_FLAVOR_INSTANCE  ${i}
.assign i = i + 1
#define SEMAPHORE_FLAVOR_TIMER     ${i}
.assign i = i + 1
#define SEMAPHORE_FLAVOR_ILB       ${i}
.if ( persistence_needed.result )
.assign i = i + 1
#define SEMAPHORE_FLAVOR_PERSIST   ${i}
.end if .// persistence_needed
.assign i = i + 1
#define SEMAPHORE_FLAVOR_MAX       ${i}

extern void ${te_prefix.result}InitializeThreading( void );
.if ( te_thread.flavor == "Nucleus" )
extern void ${te_thread.create}( void (f)(UNSIGNED, void *), const u1_t );
extern void xtUML_Application_Initialize( NU_MEMORY_POOL *, const UNSIGNED );
.else
extern void ${te_thread.create}( void *(f)(void *), const u1_t );
.end if
extern void ${te_thread.mutex_lock}( const u1_t );
extern void ${te_thread.mutex_unlock}( const u1_t );
extern void ${te_thread.nonbusy_wait}( const u1_t );
extern void ${te_thread.nonbusy_wake}( const u1_t );
extern void ${te_thread.shutdown}( void );

#ifdef NOMUTEX_DEBUG
#define pthread_mutex_lock( X ) 0
#define pthread_mutex_unlock( X ) 0
#endif
