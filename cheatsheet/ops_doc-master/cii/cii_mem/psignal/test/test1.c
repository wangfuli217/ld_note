#include <psignal.h>
#include <tools-util.h>

void test_signal_callback(const struct call_param_t * pack, const void * data, int data_len)
{
	char rpy_data[512] = "reply data from test1";
	print("data: %s", data);
	print("session_id: %d", pack->session_id);
	print("src_sid: %s", pack->src_sid);
	
	sig_reply(pack->src_sid, pack->session_id, rpy_data, strlen(rpy_data));
}

int main(int argc, char * argv[])
{
	assert_return(-1, 0 == sig_init("test1"));
	
	sig_regist_callback("test2_signal", test_signal_callback);
	while(1)
	{
		sleep(1);
	}
}
