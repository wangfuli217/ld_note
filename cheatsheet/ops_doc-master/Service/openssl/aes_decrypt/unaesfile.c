/*************************************************************************
 > File Name: unaesfile.c
 > Author: suchao.wang
 > Mail: suchao.wang@advantech.com.cn
 > Created Time: Tue 10 Jan 2017 10:55:54 AM CST
 ************************************************************************/

#include<stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <limits.h>
#include <dlfcn.h>
#include <openssl/aes.h>
#include <openssl/md5.h>

#define PROJECT_FILE "/media/mmcblk1p1/acproj.bin"

static void showHex(const char *name, char data[], int len)
{
	int i = 0;
	printf("%s:", name);
	for (i = 0; i < len; i++)
	{
		printf("%02x ", data[i]);
	}
	printf("\n");
}

static unsigned char btKey[] =
{ 123, 69, 17, 90, 212, 234, 99, 40, 58, 235, 134, 27, 130, 210, 168, 129, 142,
		245, 153, 14, 170, 127, 65, 61, 210, 90, 105, 155, 42, 97, 138, 59 };
static unsigned char btIV[] =
{ 75, 155, 184, 57, 199, 184, 46, 101, 197, 221, 155, 203, 25, 119, 157, 80 };

static unsigned char iv[AES_BLOCK_SIZE];        // init vector
static int aes_decrypt(char *in_data, int len, char *out_data)
{
	AES_KEY aes;

	if (AES_set_decrypt_key(btKey, 256, &aes) < 0)
	{
		fprintf(stderr, "Unable to set encryption key in AES\n");
		exit(-1);
	}

	memset(out_data, 0, len);
	AES_cbc_encrypt(in_data, out_data, len, &aes, iv,
	AES_DECRYPT);
	return 0;
}

struct project_info
{
	char *project_file;
	char *zip_file;
	char *project_dir;
	int nodeid;
	char md5_local[16];
	char md5_file[16];
};

typedef struct project_info PROINFO;

static PROINFO * proinfo_create()
{
	PROINFO * pp = (PROINFO *) malloc(sizeof(PROINFO));
	memset(pp, 0, sizeof(*pp));
	return pp;
}
static void proinfo_destory(PROINFO * pp)
{
	if (pp == NULL)
		return;
	if (pp->project_dir != NULL)
		free(pp->project_dir);
	if (pp->project_file != NULL)
		free(pp->project_file);
	if (pp->zip_file != NULL)
		free(pp->zip_file);
	free(pp);
}

//nodeid
/** board resource(Watchdog/LED) handle */
typedef int BR_HANDLE;

/** The error code of BoardResource SDK */
typedef enum board_resource_result
{
	/** success */
	BR_SUCCESS = 0,
	/** device not exist */
	BR_DEVICE_NOT_EXIST = -1,
	/** device already opened */
	BR_DEVICE_ALREADY_OPENED = -2,
	/** the handle not opened */
	BR_ERR_DEVICE_NOT_OPENED = -3,
	/** i2c error */
	BR_ERR_I2C = -3,
	/** the i2c bus not exist */
	BR_ERR_I2C_BUS_NOT_EXIST = -4,
	/** the i2c device does not exist */
	BR_ERR_I2C_DEVICE_NOT_EXIST = -5,
	/** read the i2c command status error */
	BR_ERR_I2C_CONFIRM = -6,
	/** out of the parameter range */
	BR_ERR_OUT_RANGE = -7,
} BR_RESULT;

static BR_HANDLE node_id_fd = -1;

typedef BR_RESULT (*BOARD_INIT)(BR_HANDLE * handle);
typedef BR_RESULT (*BOARD_GETNODEID)(BR_HANDLE handle, unsigned int * nodeID);
typedef BR_RESULT (*BOARD_GETBATTERY)(BR_HANDLE handle, unsigned int * status);
typedef BR_RESULT (*BOARD_DEINIT)(BR_HANDLE handle);

static BOARD_INIT Board_Init = NULL;
static BOARD_GETNODEID Board_GetNodeID = NULL;
static BOARD_GETBATTERY Board_GetBattery = NULL;
static BOARD_DEINIT Board_DeInit = NULL;

//return 0 for success ,else failed
static int lib_boardresource_load()
{
	void *dp;
	char *error;
	dp = dlopen("libBoardResource.so", RTLD_NOW);
	if (dp == NULL)
	{
		fputs(dlerror(), stderr);
		return -1;
	}

	Board_Init = (BOARD_INIT) dlsym(dp, "Board_Init");
	error = dlerror();
	if (error)
	{
		fputs(error, stderr);
		return -1;
	}

	Board_GetNodeID = (BOARD_GETNODEID) dlsym(dp, "Board_GetNodeID");
	error = dlerror();
	if (error)
	{
		fputs(error, stderr);
		return -1;
	}

	Board_GetBattery = (BOARD_GETBATTERY) dlsym(dp, "Board_GetBattery");
	error = dlerror();
	if (error)
	{
		fputs(error, stderr);
		return -1;
	}

	Board_DeInit = (BOARD_DEINIT) dlsym(dp, "Board_DeInit");
	error = dlerror();
	if (error)
	{
		fputs(error, stderr);
		return -1;
	}

	return 0;
}

static int get_node_id(PROINFO *ppi)
{
	int ret = 0;
	ret = lib_boardresource_load();
	if (ret != 0)
		return -1;

	Board_Init(&node_id_fd);
	unsigned int device_id = 0;
	if (node_id_fd > 0)
	{
		Board_GetNodeID(node_id_fd, &device_id);
	}
	Board_DeInit(node_id_fd);
	ppi->nodeid = device_id & 0xff;
	return 0;
}

static int aes_decrypt_file(PROINFO *ppi)
{
	char data_buf[4096];
	char data_decrypto[4096];
	MD5_CTX ctx;
	int data_fd;
	int data_out_fd;
	int nread;
	int i;

	memcpy(iv, btIV, sizeof(btIV));
	data_fd = open(ppi->project_file, O_RDONLY);
	data_out_fd = open(ppi->zip_file, O_RDWR | O_CREAT);
	if (data_fd == -1 || data_out_fd == -1)
	{
		perror("open");
		return -1;
	}

	while (nread = read(data_fd, data_buf, sizeof(data_buf)), nread > 0)
	{
		memset(data_decrypto, 0, sizeof(data_decrypto));
		aes_decrypt(data_buf, nread, data_decrypto);
		write(data_out_fd, data_decrypto, nread);
	}
	close(data_fd);
	close(data_out_fd);
}

//return 0 for success else for failed
static int check_zip_file(const char *filename)
{
	char cmd[PATH_MAX] = { 0 };
	pid_t status;

	if (access(filename, F_OK))
		return -1;

	sprintf(cmd, "unzip -l %s", filename);

	status = system(cmd);

	if (-1 == status)
	{
		printf("system error!");
		return -1;
	}

	if (WIFEXITED(status))
	{
		if (0 == WEXITSTATUS(status))
		{
			return 0;
		}
		else
		{
			printf("run shell script fail, script exit code: %d\n",
					WEXITSTATUS(status));
			return -1;
		}
	}
	else
	{
		printf("exit status = [%d]\n", WEXITSTATUS(status));
		return -1;
	}
	return 0;
}

static int skipline(FILE *f)
{
	int ch;
	do
	{
		ch = getc(f);
	} while (ch != '\n' && ch != EOF);
	return 0;
}

static int check_file_content(PROINFO *ppi)
{
	int find = 0;
	FILE * fd;
	char line[1024];
	char name[100];
	char fname[1024];
	char node_name[32];

	if (access(ppi->zip_file, F_OK))
		return -1;

	sprintf(node_name, "%02x/", ppi->nodeid);
	sprintf(fname, "unzip -v  %s", ppi->zip_file);
	fd = popen(fname, "r");
	if (fd == NULL)
	{
		perror(fname);
		return -1;
	}
	skipline(fd);
	skipline(fd);
	skipline(fd);
	while (fgets(line, sizeof(line), fd))
	{
//		int count =	sscanf(line, "%s %s %s %s %s %s %s %s", name[0], name[1], name[2], name[3], name[4], name[5], name[6], name[7]);
//		printf("%s==%s\n",name[0],name[5]);
		int len = strlen(line) - 1;
		while (len)
		{
			if (line[len] == ' ')
			{
				strcpy(name, &line[len + 1]);
				break;
			}
			else if (line[len] == '\r' || line[len] == '\n')
			{
				line[len] = 0;
			}

			len--;
		}
		if (!strncmp(name, node_name, strlen(node_name)))
		{
			find++;
		}
//		printf("%d,%s \n",count,name[7]);
	}
	fclose(fd);
	printf("find:%d\n", find);
	return find;
}

static int unzip_file(PROINFO *ppi)
{
	char cmd[PATH_MAX];

//	sprintf();
	if (check_zip_file(ppi->zip_file))
	{
		printf("zip file incorret\n");
		return -1;
	}
	if (!check_file_content(ppi))
	{
		printf("No correct node project\n");
		return -1;
	}

	sprintf(cmd, "unzip -o %s %02x/* -d /tmp/", ppi->zip_file, ppi->nodeid);
	printf("%s:%s\n", __func__, cmd);
	system(cmd);
	sprintf(cmd, "cp -af /tmp/%02x/* %s", ppi->nodeid, ppi->project_dir);
	printf("%s:%s\n", __func__, cmd);
	system(cmd);
	sprintf(cmd, "rm -rf /tmp/%02x/", ppi->nodeid);
	printf("%s:%s\n", __func__, cmd);
	system(cmd);
	return 0;
}

static int get_file_md5sum(PROINFO *ppi)
{
	char data_buf[1024];
	unsigned char md5[16];
	MD5_CTX ctx;
	int data_fd;
	int nread;
	int i;

	if (access(ppi->project_file, F_OK))
		return -1;

	data_fd = open(ppi->project_file, O_RDONLY);
	if (data_fd == -1)
	{
		perror(ppi->project_file);
		return -1;
	}

	MD5_Init(&ctx);
	while (nread = read(data_fd, data_buf, sizeof(data_buf)), nread > 0)
	{
		MD5_Update(&ctx, data_buf, nread);
	}
	MD5_Final(md5, &ctx);
	close(data_fd);

	memcpy(ppi->md5_file, md5, sizeof(md5));
	showHex("md5file", ppi->md5_file, 16);
	return 0;
}

static int get_project_dir(PROINFO *ppi)
{
	char project_dir[PATH_MAX];
	memset(project_dir, 0, sizeof(project_dir));

	char *value = getenv("TAGLINK_PATH");
	if (value != NULL)
	{
		sprintf(project_dir, "%s/project/", value);
	}
	else
	{
		sprintf(project_dir, "/home/root/project/");
	}

	if (access(project_dir, F_OK))
	{
//		LOGEX("Project directory: %s not exist!\n",project_dir);
		return -1;
	}
	else
	{
//		LOGEX("Project directory: %s\n",project_dir);
	}

	if (project_dir[strlen(project_dir) - 1] != '/')
		project_dir[strlen(project_dir) - 1] = '/';

	ppi->project_dir = strdup(project_dir);
	return 0;
}

static int get_local_md5(PROINFO *ppi)
{
	char path[PATH_MAX];
	sprintf(path, "%s.pmd5", ppi->project_dir);
	if (access(path, F_OK))
		return 0;

	int fd = open(path, O_RDONLY);
	if (fd == -1)
		return 0;
	read(fd, ppi->md5_local, sizeof(ppi->md5_local));
	close(fd);
	showHex("md5local", ppi->md5_local, 16);
}
static int save_filemd5_to_local(PROINFO *ppi)
{
	char path[PATH_MAX];
	sprintf(path, "%s.pmd5", ppi->project_dir);

	int fd = open(path, O_RDWR | O_CREAT);
	if (fd == -1)
		return 0;
	write(fd, ppi->md5_file, sizeof(ppi->md5_file));
	close(fd);
}

int check_file()
{
	if (access(PROJECT_FILE, F_OK) != 0)
		return 0;

	PROINFO *ppi = proinfo_create();

	ppi->project_file = strdup(PROJECT_FILE);

	ppi->zip_file = strdup("/tmp/acproj.zip");

	get_node_id(ppi);

	get_project_dir(ppi);

	get_local_md5(ppi);

	get_file_md5sum(ppi);

	if (!memcmp(ppi->md5_file, ppi->md5_local, sizeof(ppi->md5_file)))
		return 0;

	aes_decrypt_file(ppi);

	unzip_file(ppi);

	save_filemd5_to_local(ppi);

	proinfo_destory(ppi);
	return 0;
}

