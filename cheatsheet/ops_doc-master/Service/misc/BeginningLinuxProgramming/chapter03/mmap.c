/*  We start by defining a RECORD structure
    and then create NRECORDS versions each recording their number.
    These are appended to the file records.dat.  */

#include <unistd.h>
#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>

//---------------------------------------------------
//                         共享内存空间
// 	常常会出现段错误，现在还没有搞清到底
//是哪方面的错误
//mmap(0, NRECORDS*sizeof(record), 
//                       PROT_READ|PROT_WRITE, MAP_SHARED, f, 0);
//---------------------------------------------------

typedef struct 
{
	int integer;
	char string[24];
} RECORD;

#define NRECORDS (100)

int main(void)
{
	RECORD record, *mapped;
	int i, f;
	FILE *fp;

/*
r:Opens for reading. If the file does not exist or cannot be found, the fopen call fails.
W:Opens an empty file for writing. If the given file exists, its contents are destroyed.
a:Opens for writing at the end of the file (appending) without removing the EOF marker before writing new data to the file; creates the file first if it doesn’t exist.
r+:Opens for both reading and writing. (The file must exist.)
w+:Opens an empty file for both reading and writing. If the given file exists, its contents are destroyed.
b:Open in binary (untranslated) mode; translations involving carriage-return and linefeed characters are suppressed. 

a _O_WRONLY | _O_APPEND (usually _O_WRONLY | _O_CREAT | _O_APPEND) 
a+ _O_RDWR | _O_APPEND (usually _O_RDWR | _O_APPEND | _O_CREAT ) 
r _O_RDONLY 
r+ _O_RDWR 
w _O_WRONLY (usually _O_WRONLY | _O_CREAT | _O_TRUNC) 
w+ _O_RDWR (usually _O_RDWR | _O_CREAT | _O_TRUNC) 
b _O_BINARY 
t _O_TEXT 
c None 
n None 

*/
	fp = fopen( "records.dat", "w" );
	for( i = 0; i < NRECORDS; i++ ) 
	{
		record.integer = i;
		sprintf( record.string,"RECORD-%d",i );
		fwrite( &record, sizeof(record), 1, fp );
	}
	printf("001fp = %d \n", fp);
	
	fclose(fp);

/*  We now change the integer value of record 43 to 143
    and write this to the 43rd record's string.  */

	fp = fopen( "records.dat", "r+" );
	fseek( fp, 43*sizeof(record), SEEK_SET );
	fread( &record, sizeof(record), 1, fp );

	record.integer = 143;
	sprintf(record.string,"RECORD-%d",record.integer);

	fseek( fp, 43*sizeof(record), SEEK_SET );
	fwrite( &record, sizeof(record), 1, fp );
	fseek( fp, 0, SEEK_SET );
	printf("002fp = %d \n", fp);
	fclose( fp );

/*  We now map the records into memory
    and access the 43rd record in order to change the integer to 243
    (and update the record string), again using memory mapping.  */

	f = open("records.dat",O_RDWR);

	printf("003fp = %d \n", fp);

	mapped = (RECORD *)mmap( 0, (NRECORDS+1)*sizeof(record), 
	                      PROT_READ|PROT_WRITE, MAP_SHARED, f, 0 );

  	 // mapped[43].integer = 243;
  	// (mapped+43)->integer = 243;
	//return 0;
	//关键是该函数的内存映射没有成功返回值为0xffffffff
	printf("111111111111111111111111\n");

	if( mapped == 0xffffffff )
	{
		close( f );
		printf("004f = %d \n", fp);
		return 0;
	}
	printf("segment %p\n",mapped);
	printf("--------------%d-------\n",mapped[43].integer);
	printf("smmap=%s dmmap=%dmmap\n",mapped[43].string,sizeof(mapped[43].string));
    	sprintf(mapped[43].string,"RECORD-%d",mapped[43].integer);
	printf("222222222222222222222222\n");
    	msync((void *)mapped, NRECORDS*sizeof(record), MS_ASYNC);
    	munmap((void *)mapped, NRECORDS*sizeof(record));
    	close(f);

    	exit(0);
}

