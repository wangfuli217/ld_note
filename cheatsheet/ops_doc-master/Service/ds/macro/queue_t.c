#include "Queue.h"
#include <string.h>
#include <stdio.h>


// our queue
static QUEUE queue;

typedef struct car_structure {
	char* model;
	char* manufacturer;
	QUEUE node;
} car, *car_p;

int main(void)
{
	// pointer to a node
	static QUEUE* q;

	// creat 2 new elements of queue and allocate memory in the stack

	car car1;
	car1.model = _strdup("civic");
	car1.manufacturer = _strdup("honda");

	car car2;
	car2.model = _strdup("camry");
	car2.manufacturer = _strdup("toyota");


	// init queue and elements
	QUEUE_INIT(&queue);
	QUEUE_INIT(&car1.node);
	QUEUE_INIT(&car2.node);
	
	// insert element into tail of queue
	QUEUE_INSERT_TAIL(&queue, &car1.node);
	QUEUE_INSERT_TAIL(&queue, &car2.node);

	// get head element
	q = QUEUE_HEAD(&queue);

	// retrieve element's data
	car_p current_car = QUEUE_DATA(q, car, node);

	// print info
	printf("%s => %s\n",
		current_car->manufacturer, current_car->model);


	// go trought all elements of queue
	QUEUE_FOREACH(q, &queue) {
		car_p current_car = QUEUE_DATA(q, car, node);

		printf("%s => %s\n",
			current_car->manufacturer, current_car->model);
	}

	return 0;
}