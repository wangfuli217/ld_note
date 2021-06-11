/*************************************************************************
 > File Name: getopt.c
 > Author: suchao.wang
 > Mail: suchao.wang@advantech.com.cn
 > Created Time: Wed 03 Dec 2014 07:42:29 PM CST
 ************************************************************************/

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <errno.h>
#include <limits.h>
#include <unistd.h>
#include <sys/file.h>
#include <string.h>

static char config_file[PATH_MAX];
static char project_dir[PATH_MAX];


static int Lockfile(const int iFd)
{
	struct flock    stLock;

	stLock.l_type = F_WRLCK;        /* F_RDLCK, F_WRLCK, F_UNLCK */
	stLock.l_start = 0;    /* byte offset, relative to l_whence */
	stLock.l_whence = SEEK_SET;    /* SEEK_SET, SEEK_CUR, SEEK_END */
	stLock.l_len = 0;        /* #bytes (0 means to EOF) */

	return (fcntl(iFd, F_SETLK, &stLock));
}

#ifndef USER_GID
#define USER_GID (37)  //37 operator
#endif
static bool process_is_first_instance ( char const * proc_name )
{
	char pid_file_name[ PATH_MAX ];
	int pid_file;
	int ret;
	mode_t pre_mode;

	sprintf(
		pid_file_name,
		"/tmp/apal_proc_%s.pid",
		proc_name );

	pre_mode = umask(0);
	pid_file = open(
		pid_file_name,
		O_CREAT | O_RDWR,
		0666 );
	umask(pre_mode);
	if ( -1 == pid_file )
	{
		return 0;
	}

	ret = Lockfile( pid_file);
	if ( 0 == ret )
	{
		// this is the first instance
		return 1;
	}

	return 0;
}
#define APP_NAME "AdvSystemSetting"

#ifndef VERSION_NUMBER
#define VERSION_NUMBER					""
#endif

static void print_app_version ( void )
{
#ifdef REVISION_NUMBER
	printf( "%s rev %s\n", APP_NAME, VERSION_NUMBER, REVISION_NUMBER );
#else
	printf( "%s build %s %s\n", APP_NAME, __DATE__,__TIME__ );
#endif
	printf( "\t-d run as daemon\n" );
	printf( "\t-f config file. must specify config file\n" );
	printf( "\t-D project direcotry. must specify config file\n" );

}

#define CONFIG_FILE	"project/SystemSetting.acr"
#define PROJECT_DIR "project"

#define DEFAULT_PATH	"/home/root/"


int main(int argc, char **argv)

{

	int ret;
	int ch;
	int run_daemon = 0;
	ret = process_is_first_instance(APP_NAME);
	if (!ret)
	{
		printf("%s already running\n", APP_NAME);
		exit(0);
	}
	memset(config_file,0,sizeof(config_file));
	memset(project_dir,0,sizeof(project_dir));

	char *value = getenv("TAGLINK_PATH");
	if(value != NULL)
	{
		printf("TAGLINK_PATH:%s\n",value);
		sprintf(config_file,"%s/%s",value,CONFIG_FILE);
		sprintf(project_dir,"%s/%s",value,PROJECT_DIR);
	}else{
		sprintf(config_file,"%s%s",DEFAULT_PATH,CONFIG_FILE);
		sprintf(project_dir,"%s%s",DEFAULT_PATH,PROJECT_DIR);
	}

	while ((ch = getopt(argc, argv, "df:D:")) != -1)
	{
//		printf("optind:%d\n", optind);
		switch (ch)
		{
		case 'd':
			run_daemon = 1;
			break;
		case 'f':
			memset(config_file,0,sizeof(config_file));
			strcpy(config_file,optarg);
			break;
		case 'D':
			memset(project_dir,0,sizeof(config_file));
			strcpy(project_dir,optarg);
			break;
		default:
			printf("other option :%c\n", ch);

		}
	}

	if(access(config_file,F_OK))
	{
		printf("Config file: %s not exist!\n",config_file);
		print_app_version();
		return -1;
	}else{
		printf("Config file: %s\n",config_file);
	}
	if(access(project_dir,F_OK))
	{
		printf("Project directory: %s not exist!\n",project_dir);
		print_app_version();
		return -1;
	}else{
		printf("Project directory: %s\n",project_dir);
	}
	if(project_dir[strlen(project_dir) -1] != '/')
		project_dir[strlen(project_dir) - 1] = '/';

	if(run_daemon)
		daemon(0, 0);

	printf("Does not run as daemon\n");

	return 0;
}



