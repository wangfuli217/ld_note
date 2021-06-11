Heap 
    - a specialized tree-based data structure that satisfies the heap property
    - Heap property
        * If A is a parent node of B then key(A) is ordered with respect to key(B) with the same ordering applying across the heap. 
        * The heap relation mentioned above applies only between nodes and their immediate parents. 
        * no implied ordering between siblings or cousins 
        * no implied sequence for an in-order traversal (as there would be in, e.g., a binary search tree). 
        
Application
    - Heaps are crucial in 
        * several efficient graph algorithms such as Dijkstra's algorithm
        * in the sorting algorithm heapsort.
        
Binary heap
    - The maximum number of children each node can have depends on the type of heap, 
    - but in many types it is at most two, which is known as a "binary heap".
    
Variants


Priority queue
    - a priority queue is an abstract data type which is like a regular queue or stack data structure, but where additionally each element has a "priority" associated with it.
    -  In a priority queue, an element with high priority is served before an element with low priority. 
        * If two elements have the same priority, they are served according to their order in the queue.

Priority queue operations:
    - insert_with_priority
        * add an element to the queue with an associated priority
    - pull_highest_priority_element
        * remove the element from the queue that has the highest priority, and return it
    - peek (in this context often called find-max or find-min)
        * which returns the highest-priority element but does not modify the queue, is very frequently implemented
        * nearly always executes in O(1) time

        
Misconception about priorty queue:
    - It is a common misconception that a priority queue is a heap. 
    - A priority queue is an abstract concept like "a list" or "a map"
        * just as a list can be implemented with a linked list or an array, a priority queue can be implemented with a heap or a variety of other methods.
        
        
