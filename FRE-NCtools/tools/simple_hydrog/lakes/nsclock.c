/***********************************************************************
 *                   GNU Lesser General Public License
 *
 * This file is part of the GFDL FRE NetCDF tools package (FRE-NCTools).
 *
 * FRE-NCtools is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or (at
 * your option) any later version.
 *
 * FRE-NCtools is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with FRE-NCTools.  If not, see
 * <http://www.gnu.org/licenses/>.
 **********************************************************************/
#include <stdio.h>
#include <time.h>
#ifndef __aix
#ifdef __sgi
long delta_t=0;			// clock resolution in nanoseconds

long sgi_ticks_per_sec_() {	// returns inverse clock resolution (1/sec)
  struct timespec t;
  clock_getres( CLOCK_SGI_CYCLE, &t );
  delta_t = (long)t.tv_sec*1000000000 + (long)t.tv_nsec;
  return 1000000000/delta_t;
}

long sgi_tick_() {		// returns current time in units of delta_t
  struct timespec t;
  if( delta_t==0 ) (void) sgi_ticks_per_sec_(); // initialize delta_t if needed
  clock_gettime( CLOCK_SGI_CYCLE, &t );
  return ( (long)t.tv_sec*1000000000+(long)t.tv_nsec )/delta_t;
}

long sgi_max_tick_() {		// clock rollover point is 2^max_tick
#include <sys/syssgi.h>
  return syssgi(SGI_CYCLECNTR_SIZE);
}
#endif

#ifdef test_nsclock
void main() {
#ifdef __sgi
  printf( "ticks per second=%li\n", sgi_ticks_per_sec_() );
  printf( "delta_t=%li\n", delta_t );
  printf( "max tick=%li\n", sgi_max_tick_() );
#else
  printf( "ticks per second=%i\n", CLOCKS_PER_SEC );
#endif
}
#endif
#endif
