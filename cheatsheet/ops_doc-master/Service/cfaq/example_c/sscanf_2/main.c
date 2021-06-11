#include <stdio.h>

#define __DATA_FMT__ "%05u_%24s_%u_%lu"
#define __DATA__(data, sid, app, plt, uid) sscanf(data, __DATA_FMT__, &sid, app, &plt, &uid)
int main(int argc, char **argv)
{
	unsigned int 	sid = 0;
	char 			app[64];
	unsigned int 	plt = 0;
	unsigned long 	uid = 0;
	
	__DATA__("00010_04d25d9e991a9ed98ddc7117_0_342342342346", sid, app, plt, uid);
	printf("sid: %u app: %s plt: %u uid: %lu\n", sid, app, plt, uid);
	printf(__DATA_FMT__"\n", sid, app, plt, uid);
	return 0;
}
