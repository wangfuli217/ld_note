#include <stdio.h>


class person_t {
public:
	person_t(unsigned int _id):id(_id) {}
	person_t(const person_t& rh);
	
	person_t& operator=(const person_t& rsh) {
		printf("%s\n", __PRETTY_FUNCTION__);
		id = rsh.id;
	}
	
public:
	unsigned int get_id() { return id; };
private:
	unsigned int id;
};

person_t::person_t(const person_t& rh)
{
	printf("id: %u\n", id);
	id = rh.id;
	printf("id: %u\n", id);
}

person_t g_pp(100);

static person_t 
__new(unsigned int id)
{
	return person_t(id);
}

static person_t
__new_2(unsigned int id)
{
	person_t temp(id);
	
	return temp;
}

static person_t
__new_global() 
{
	return g_pp;
}

int 
main(int argc, char **argv)
{
	person_t temp = __new_global();
	printf("temp.id: %u\n", temp.get_id());
	
	person_t pa(200);
	
	person_t pb(300);
	
	//printf("PA: %p\n", &pa);
	//pa = pb;
	//printf("PA: %p\n", &pa);
	
	//person_t aaa = temp;
	

	return 0;
}
