/*
 * =====================================================================================
 *
 *       Filename:  point.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  19.03.10
 *       Revision:  
 *       Compiler:  GCC 4.4.3
 *
 *         Author:  Yang Zhang, imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */
#define		POINT_IMPLEMENTATION

#include	<omfc/Object.h>

static void *class_point_ctor(void *, va_list *);
static void *point_ctor(void *, va_list *);
static void point_draw(const void *);

/* 
 * ===  SELECTOR  ======================================================================
 *         Name:  draw
 *  Description:  
 * =====================================================================================
 */
void gdraw(OBJ _obj)
{
	struct Point * cls = class_of(_obj);
	cls->draw(_obj);
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  super_draw
 *  Description:  just export the interface for next generation
 * =====================================================================================
 */
void super_draw(OBJ _obj)
{
	struct Point * cls = gcast(class_of(class_of(_obj)), Point);
	cls->draw(_obj);
}

/*
 *--------------------------------------------------------------------------------------
 *       Class:  point
 *      Method:  point_ctor
 * Description:  
 *--------------------------------------------------------------------------------------
 */
static void * ctor(void * _pnt, va_list * arg)
{
	struct point * obj = super_ctor(point, _pnt, arg);
	va_list ap = *arg;
	obj->x = va_arg(ap, int);
	obj->y = va_arg(ap, int);
	return obj;
}

/*
 *--------------------------------------------------------------------------------------
 *       Class:  point
 *      Method:  point_draw
 * Description:  
 *--------------------------------------------------------------------------------------
 */
static void draw(const void * _obj)
{
	const struct point * pnt = _obj;
	printf("x: %d, y: %d\n", pnt->x, pnt->y);
}

