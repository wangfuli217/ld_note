#include <psignal.h>
#include <tools-util.h>

static struct timeval g_send_time;

int main(int argc, char * argv[])
{
	char send_data[512] = "1234567890";
	int send_data_len = strlen(send_data);
	char recv_data[1024] = {0};
	int recv_data_len = 1024;
	assert_return(-1, 0 == sig_init("test2"));
	
	//sig_send(NULL, "test2_signal", send_data, send_data_len);	
	if ( 0 == sig_send_wait_reply("test1", "test2_signal", send_data, send_data_len, recv_data, &recv_data_len))
	{
		print("reply str: %s", recv_data);
	}
	else
	{
		print("no reply");
	}
	while(1)
	{
		sleep(1);
	}
}
