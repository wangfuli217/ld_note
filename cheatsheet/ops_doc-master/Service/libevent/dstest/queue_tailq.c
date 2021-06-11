/*
 * A simple program to demonstrate basic usage of the BSD TAILQ (Tail queues)
 * facilities. For info see queue(3).
 *
 * To compile the program do:
 *
 * gcc -g -o tailq.exe tailq.c && ./tailq.exe
 *
 *
 * \author Luca Ferrari - fluca1978 (at) gmail (dot) com 
 */

#include <sys/queue.h>

#include <stdio.h>
#include <stdlib.h>


/*
 * Here we define the data-payload that we want to use. The only thing to
 * add to the application-logic data is a field to handle the pointers
 * to other data entries: this is done specifying a TAILQ_ENTRY field of
 * the same type of the structure the application is using.
 * The TAILQ_ENTRY macro expands to the following:
 * \begincode
    struct { struct car_st *tqe_next; struct car_st **tqe_prev; } _cars;
 * \endcode
 * that is two pointers are added as '_cars' field to link forward and back.
 *
 * +----------- car_st ----------+
 * |      <application data>     |
 * | TAILQ_ENTRY( car_st ) _cars |   --- tqe_next --->  +----------- car_st ----------+
 * +-----------------------------+   ^		        |      <application data>     |
 *				     +--- tqe_prev ---- | TAILQ_ENTRY( car_st ) _cars |
 *                                                      +-----------------------------+
 */
struct car_st{					       
  char  model[ 20 ];
  int   cc_size;
  TAILQ_ENTRY( car_st ) _cars;
};



/*
 * An utility function used to dump the content of a car_st pointer
 * and to display the linking pointers. Please note that the le_prev
 * pointer is a pointer to the previous tqe_next pointer, and therefore
 * the double linking is performed using always the next pointer.
 *
 * \param car a pointer to the struct car_st to print on the stdout
 */
void
dump_car( struct car_st * car ){
  if( car == NULL ){ printf( "\n--\n" ); }
  else{
    printf( "\nCar model = %s, engine size = %d ",
	    car->model, car->cc_size );
    printf( "\n\t0x%x <--(prev next)\t (this) 0x%x\t (next) --> 0x%x", 
	    *((car->_cars).tqe_prev),
	    car,
	    (car->_cars).tqe_next );
  }
}





int
main( int argc, char** argv ){
  
  /*
   * Initialization of the queue, that expands to the following:
   * \begincode
      struct CAR_LIST { struct car_st *tqh_first; struct car_st **tqh_last; } head 
                          = { ((void *)0), &(head).tqh_first };
   * \endcode
   * that is the 'head' is initialized with the first pointer to null and the previous
   * to be the same pointer.
   */
  TAILQ_HEAD( CAR_LIST, car_st ) head  = TAILQ_HEAD_INITIALIZER( head ); 
  int i;


  struct car_st *current  = NULL, *previous = NULL;
 


  for( i = 0; i < 10; i++ ){
    current = (struct car_st *) malloc( 1 * sizeof( struct car_st ) );
    snprintf( current->model, sizeof( current->model ), "Model %d", i );
    current->cc_size = 1000 + ( i + 1 ) * 500;

    /*
     * TAILQ_EMPTY expands to the following:
     * \begincode
        ((&head)->tqh_first == ((void *)0))
     * \endcode
     * that simply tests if the head has something to point to.
     *
     * The TAILQ_INSERT_HEAD expands to the following:
     * \begincode
         do { ; 
           if (((((current))->_cars.tqe_next) = (((&head))->tqh_first)) != ((void *)0)) 
             (((&head))->tqh_first)->_cars.tqe_prev = &(((current))->_cars.tqe_next); 
           else 
             (&head)->tqh_last = &(((current))->_cars.tqe_next); 
          (((&head))->tqh_first) = (current); 
          (current)->_cars.tqe_prev = &(((&head))->tqh_first); ; ; 
        } while (0);
     * \endcode
     * that is:
     * - current next pointer becomes the same of the head, since current is going to be
     * inserted as new head. If the head had something, the backlink pointer of the head next
     * element is adjusted to point back to current, that is the new head.
     * - head points to current
     * - the previous of current is adjusted to point to the address of the pointer of
     * head, to identify the 'head' of the queue.
     *
     *
     * The TAILQ_INSERT_TAIL macro expands to the following:
     * \begincode
          do { ; 
            (((current))->_cars.tqe_next) = ((void *)0); 
            (current)->_cars.tqe_prev = (&head)->tqh_last; 
            *(&head)->tqh_last = (current); 
            (&head)->tqh_last = &(((current))->_cars.tqe_next); ; ; 
          } while (0);
     * \endcode
     * that is:
     * - current next pointer is set to null (current is going to be the last element
     * of the tail)
     * - current previous element is set to the head last element
     * - head last element is adjusted to point to current
     * - head last pointer is adjusted to point to the current next pointer
     */
    if( TAILQ_EMPTY( &head ) )
      TAILQ_INSERT_HEAD( &head, current, _cars );
    else
      TAILQ_INSERT_TAIL( &head, current, _cars );
    

    previous = current;
  }



  printf( "\nTraversing the list using a foreach loop" );
  /* 
   * The TAILQ_FOREACH expands to the following:
   * \begincode
      for ((current) = (((&head))->tqh_first); 
           (current); 
           (current) = (((current))->_cars.tqe_next))
   * \endcode
   * that simply initializes the current to the first element in the head, then test
   * it is not null and increments it using the current next pointer.
   */
  TAILQ_FOREACH( current, &head, _cars ){
    dump_car( current );
  }


  printf( "\nTraversing the list using a next-based loop" );
  /*
   * The TAILQ_FIRST macro expands to the following:
   * \begincode
        current = ((&head)->tqh_first);
   * \endcode
   * that simply picks up the first element pointed by head.
   *
   * The macro TAILQ_NEXT expands to the following:
   * \begincode
      current = ((current)->_cars.tqe_next);
   * \endcode
   * that simply goes forward using the next link.
   */
  current = TAILQ_FIRST( &head );
  while( current != NULL ){
    dump_car( current );
    current = TAILQ_NEXT( current, _cars );
  }



  printf( "\nTraversing the list and removing elements\n" );
  current = previous = NULL;
  /*
   * The TAILQ_FOREACH_SAFE expands to the following:
   * \begincode
     for ((current) = (((&head))->tqh_first); 
         (current) && ((previous) = (((current))->_cars.tqe_next), 1); 
	 (current) = (previous))
   * \endcode
   * that initializes 'current' to the first element pointed by the head, then test
   * that 'current' is not null and assigns to 'previous' the next element of current
   * (the 1 makes the test not to fail), and finally increments 'current' assigning the
   * the next element.
   *
   * The TAILQ_REMOVE expands to the following:
   * \begincode
      do { ; ; ; ; 
       if (((((current))->_cars.tqe_next)) != ((void *)0)) 
        (((current))->_cars.tqe_next)->_cars.tqe_prev = (current)->_cars.tqe_prev; 
       else { (&head)->tqh_last = (current)->_cars.tqe_prev; ; } 
       *(current)->_cars.tqe_prev = (((current))->_cars.tqe_next); ; ; ; } 
      while (0);
   * \endcode
   * that is:
   * - if 'current' has a next element the current next element is adjusted to point
   * to 'current' previous element so to exclude current from the backward links chain
   * - otherwise 'current' is the last element and therefore the head last element is
   * updated to point to the current previous element
   * - finally the current previous element pointer is set to point the current next
   * element so to exlcude the current from the forward links
   */
  TAILQ_FOREACH_SAFE( current, &head, _cars, previous ){
    if( (current->cc_size / 500) % 2 == 1 ){
      printf( "\n\tRemoving the car..." );
      TAILQ_REMOVE( &head, current, _cars );
      free( current );
    }
  }
  


  printf( "\nTraversing the list using a foreach loop" );
  TAILQ_FOREACH( current, &head, _cars ){
    dump_car( current );
  }



  printf( "\nBye\n" );
  exit( 0 );
}
