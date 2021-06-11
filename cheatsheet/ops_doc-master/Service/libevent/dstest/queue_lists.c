/*
 * A simple program to demonstrate basic usage of the BSD LIST (Doubly Linked List) macros and
 * facilities. For info see queue(3).
 *
 * To compile the program do:
 *
 * gcc -g -o lists.exe lists.c && ./lists.exe
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
 * to other data entries: this is done specifying a LIST_ENTRY field of
 * the same type of the structure the application is using.
 *
 * An entry LIST_ENTRY( car_st ) expands to the following:
 * \begincode
   struct { struct car_st *le_next; struct car_st **le_prev; } _cars;
 * \endcode
 * and therefore a field LIST_ENTRY( car_st ) means that the application-logic
 * structure is added of an inner anonymous structure contained in the field
 * "_cars" which has two fields:
 * - le_next is a forward pointer to the next car_st structure in the chain
 * - le_prev is a pointer to the previous element le_next pointer.
 * In other words:
 * +----------- car_st ----------+
 * |      <application data>     |
 * |  LIST_ENTRY( car_st ) _cars |   --- le_next --->  +----------- car_st ----------+
 * +-----------------------------+   ^		       |      <application data>     |
 *				     +--- le_prev ---- |  LIST_ENTRY( car_st ) _cars |
 *                                                     +-----------------------------+
 */
struct car_st{					       
  char  model[ 20 ];
  int   cc_size;
  LIST_ENTRY( car_st ) _cars;
};



/*
 * An utility function used to dump the content of a car_st pointer
 * and to display the linking pointers. Please note that the le_prev
 * pointer is a pointer to the previous le_next pointer, and therefore
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
	    *((car->_cars).le_prev),
	    car,
	    (car->_cars).le_next );
  }
}





int
main( int argc, char** argv ){
  
  /*
   * Declaration and initilization of the list head.
   * The 'head' variable is defined as a structure of name 'CAR_LIST'
   * that contains a single pointer to the type 'struct car_st'
   * and is initialized to NULL.
   *
   * In other words, the 'head' is expanded to the following piece of
   * code:
   * \begincode
     struct CAR_SLIST { struct car_st *lh_first; } head = { ((void *)0) };
   * \endcode
   */
  LIST_HEAD( CAR_LIST, car_st ) head  = LIST_HEAD_INITIALIZER( head ); 
  int i;


  struct car_st *current  = NULL, *previous = NULL;
 


  for( i = 0; i < 10; i++ ){
    current = (struct car_st *) malloc( 1 * sizeof( struct car_st ) );
    snprintf( current->model, sizeof( current->model ), "Model %d", i );
    current->cc_size = 1000 + ( i + 1 ) * 500;

    /*
     * LIST_EMPTY expands to the following piece of code:
     * \begincode
       ((&head)->slh_first == ((void *)0))
     * \endcode
     * and therefore tests if the first pointer (i.e., the pointer contained in the 'head')
     * is empty (i.e., NULL).
     *
     * The LIST_INSERT_HEAD macro expands to the following:
     * \begincode
       do { ; 
           if (((((current))->_cars.le_next) = (((&head))->lh_first)) != ((void *)0)) 
	       (((&head))->lh_first)->_cars.le_prev = &(((current))->_cars.le_next); 
           (((&head))->lh_first) = (current); 
           (current)->_cars.le_prev = &(((&head))->lh_first); 
       } while (0);
     * \endcode
     *
     * that means: the 'current' element becomes the one pointed by the 'head' (in particular
     * by 'lh_first') and the previous element of current becomes the old head. The first
     * if test assigns to the next element of current the first element pointed by the head,
     * and if this is not null the previous element of the head is associated to the address
     * of the next element of current.
     *
     *
     * The macro LIST_INSERT_AFTER expands to
     * \begincode
         do { ; 
           if (((((current))->_cars.le_next) = (((previous))->_cars.le_next)) != ((void *)0)) 
             (((previous))->_cars.le_next)->_cars.le_prev = &(((current))->_cars.le_next); 
          (((previous))->_cars.le_next) = (current); 
          (current)->_cars.le_prev = &(((previous))->_cars.le_next); 
        } while (0);
     * \endcode
     * that means: the 'current' next element is assigned to the value of the
     * 'previous' next element, and in the case such last element is not null, the
     * back links are adjusted. Then the next element of 'previous' is set to 'current',
     * so that 'current' is the one after 'previous', and finally the backlink is adjusted.
     */
    if( LIST_EMPTY( &head ) )
      LIST_INSERT_HEAD( &head, current, _cars );
    else
      LIST_INSERT_AFTER( previous, current, _cars );
    

    previous = current;
  }



  printf( "\nTraversing the list using a foreach loop" );
  /*
   * The LIST_FOREACH macro is expanded to the following:
   * \begincode
      for ((current) = (((&head))->lh_first); 
      (current); 
      (current) = (((current))->_cars.le_next))
   * \endcode
   * that is the 'current' is initialized to the first element pointed by the head, then
   * the 'current' is tested to be not null and finally the 'current' is incremented
   * to point to the next element.
   */
  LIST_FOREACH( current, &head, _cars ){
    dump_car( current );
  }


  printf( "\nTraversing the list using a next-based loop" );
  /*
   * The LIST_FIRST macro is expanded to
   * \begincode
      current = ((&head)->lh_first);
   * \endcode
   * that simply extracts the first element pointed by the head.
   *
   * The macro LIST_NEXT expands to:
   * \begincode
      current = ((current)->_cars.le_next);
   * \endcode
   * that is the next element of current is taken.
   */
  current = LIST_FIRST( &head );
  while( current != NULL ){
    dump_car( current );
    current = LIST_NEXT( current, _cars );
  }



  printf( "\nTraversing the list and removing elements\n" );
  current = previous = NULL;
  /*
   * The LIST_FOREACH_SAFE macro expands to the following:
   * \begincode
       for ((current) = (((&head))->lh_first); 
           (current) && ((previous) = (((current))->_cars.le_next), 1); 
	   (current) = (previous))
   * \endcode
   * that initializes 'current' with the first element out of the head, then tests that
   * current is not null and assigns to previous the current-next-element (the 1 is used to
   * make the test pass even if there is no next). Since 'previous' is already the next
   * element of current, the 'current' is incremented using the 'previous' pointer.
   *
   * The LIST_REMOVE macro expands to:
   * \begincode
     do { ; ; ; ; 
       if ((((current))->_cars.le_next) != ((void *)0)) 
          (((current))->_cars.le_next)->_cars.le_prev = (current)->_cars.le_prev; 
      *(current)->_cars.le_prev = (((current))->_cars.le_next); ; ; 
    } while (0);
   * \endcode
   * that means: if 'current' has a next element than the previous pointer of the next element
   * must point to the previous element of current (so to exclude 'current' from
   * the back links). Then the current previous element is adjusted to point to the next
   * element of 'current' (so to exclude 'current' from the forward link).
   */
  LIST_FOREACH_SAFE( current, &head, _cars, previous ){
    if( (current->cc_size / 500) % 2 == 1 ){
      printf( "\n\tRemoving the car..." );
      LIST_REMOVE( current, _cars );
      free( current );
    }
  }
  


  printf( "\nTraversing the list using a foreach loop" );
  LIST_FOREACH( current, &head, _cars ){
    dump_car( current );
  }



  printf( "\nBye\n" );
  exit( 0 );
}
