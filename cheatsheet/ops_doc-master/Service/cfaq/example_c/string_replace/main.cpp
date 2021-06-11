#include <stdio.h>
#include <string>
#include <stdlib.h>
#include <string.h>

using namespace std;



int 
main(int argc, char **argv)
{
	int pos, pos2, pos3;
	
	string sql = "INSERT INTO paycenter_order (mid,sitemid,buyer,sid,appid,pmode,pamount,pcoins,pchips,pcard,pnum,pamount_rate,pamount_unit,pamount_usd,payconfid,pcoinsnow,pdealno,pbankno,`desc`,pstarttime,pendtime,pstatus,ext_10) VALUES('86279278','58410485','58410485','7','115','218','6','0','27600','0','1','0.1588','','0.95','50346','0','0','0','0','1415859271','0','0','0101')";
	
	pos = sql.find(")");
	if (pos != string::npos) {
		printf("pos: %d\n", pos);
		sql.replace(pos, strlen(")"), ",pid)");
	}
	
	pos = sql.find(")");
	if (pos != string::npos) {
		printf("pos2: %d\n", pos);
	}
	
	pos2 = sql.find(")", pos + 1);
	if (pos2 != string::npos) {
		printf("pos2: %d\n", pos2);
		sql.replace(pos2, strlen(")"), ",123456789)");
	}
	
	
	printf("sql: %s\n", sql.c_str());
	
	system("pause");
	return 0;
}
