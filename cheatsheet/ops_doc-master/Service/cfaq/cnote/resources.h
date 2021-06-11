#ifndef RESOURCES_H
#define RESOURCES_H
typedef enum { /* Define a type describing the possible valid resource IDs. */
  RESOURCE_UNDEFINED = -1, /* To be used to initialise any EnumResourceID typed variable to be
GoalKicker.com – C Notes for Professionals 251
                              marked as "not in use", "not in list", "undefined", wtf.
                              Will say un-initialised on application level, not on language level.
Initialised uninitialised, so to say ;-)
                              Its like NULL for pointers ;-)*/
  RESOURCE_UNKNOWN = 0,    /* To be used if the application uses some resource ID,
                              for which we do not have a table entry defined, a fall back in
                              case we _need_ to display something, but do not find anything
                              appropriate. */
  /* The following identify the resources we have defined: */
  RESOURCE_OK,
  RESOURCE_CANCEL,
  RESOURCE_ABORT,
  /* Insert more here. */
  RESOURCE_MAX /* The maximum number of resources defined. */
} EnumResourceID;
extern const char * const resources[RESOURCE_MAX]; /* Declare, promise to anybody who includes
                                      this, that at linkage-time this symbol will be around.
                                      The 1st const guarantees the strings will not change,
                                      the 2nd const guarantees the string-table entries
                                      will never suddenly point somewhere else as set during
                                      initialisation. */
#endif