/*
  Copyright (c) 2009 Dave Gamble
 
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
 
  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.
 
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
*/

#include <stdio.h>
#include <stdlib.h>
#include "cJSON.h"

/* Parse text to JSON, then render back to text, and print! */
void doit(char *text)
{
	char *out;cJSON *json;
	
	json=cJSON_Parse(text);
	if (!json) {printf("Error before: [%s]\n",cJSON_GetErrorPtr());}
	else
	{
		out=cJSON_Print(json);
		cJSON_Delete(json);
		printf("%s\n",out);
		free(out);
	}
}

static int doparse(char *text)
{
	cJSON *root=cJSON_Parse(text);
	if (!root)
	{
		printf("Error before: [%s]\n",cJSON_GetErrorPtr());
		return -1;
	}

	 cJSON *item=cJSON_GetObjectItem(root,"name");
	if(item!=NULL)
	{
		printf("cJSON_GetObjectItem: type=%d, key is %s, value is %s\n",item->type,item->string,item->valuestring);
//		memcpy(str_val,item->valuestring,strlen(item->valuestring));
	}
	cJSON *format=cJSON_GetObjectItem(root,"format");
	if(format!=NULL)
	{
		printf("cJSON_GetObjectItem: type=%d, key is %s, value is %s\n",format->type,format->string,format->valuestring);
	}
	cJSON *type=cJSON_GetObjectItem(format,"type");
	if(type!=NULL)
	{
		printf("cJSON_GetObjectItem: type=%d, key is %s, value is %s\n",type->type,type->string,type->valuestring);
	}
	cJSON *width=cJSON_GetObjectItem(format,"width");
	if(width!=NULL)
	{
		printf("cJSON_GetObjectItem: type=%d, key is %s, value is %s\n",width->type,width->string,width->valuestring);
	}
	cJSON *height=cJSON_GetObjectItem(format,"height");
	if(height!=NULL)
	{
		printf("cJSON_GetObjectItem: type=%d, key is %s, value is %s\n",height->type,height->string,height->valuestring);
	}
	cJSON *interlace=cJSON_GetObjectItem(format,"interlace");
	if(interlace!=NULL)
	{
		printf("cJSON_GetObjectItem: type=%d, key is %s, value is %s\n",interlace->type,interlace->string,interlace->valuestring);
	}
	cJSON *frame_rate=cJSON_GetObjectItem(format,"frame rate");
	if(frame_rate!=NULL)
	{
		printf("cJSON_GetObjectItem: type=%d, key is %s, value is %s\n",frame_rate->type,frame_rate->string,frame_rate->valuestring);
	}
	cJSON_Delete(root);

}
/*
//parse a key-value pair
int cJSON_to_str(char *json_string, char *str_val)
{
    cJSON *root=cJSON_Parse(json_string);
    if (!root)
    {
        printf("Error before: [%s]\n",cJSON_GetErrorPtr());
        return -1;
    }
    else
    {
        cJSON *item=cJSON_GetObjectItem(root,"firstName");
        if(item!=NULL)
        {
            printf("cJSON_GetObjectItem: type=%d, key is %s, value is %s\n",item->type,item->string,item->valuestring);
            memcpy(str_val,item->valuestring,strlen(item->valuestring));
        }
        cJSON_Delete(root);
    }
    return 0;
}

//parse a object to struct
int cJSON_to_struct(char *json_string, people *person)
{
    cJSON *item;
    cJSON *root=cJSON_Parse(json_string);
    if (!root)
    {
        printf("Error before: [%s]\n",cJSON_GetErrorPtr());
        return -1;
    }
    else
    {
        cJSON *object=cJSON_GetObjectItem(root,"person");
        if(object==NULL)
        {
            printf("Error before: [%s]\n",cJSON_GetErrorPtr());
            cJSON_Delete(root);
            return -1;
        }
        printf("cJSON_GetObjectItem: type=%d, key is %s, value is %s\n",object->type,object->string,object->valuestring);

        if(object!=NULL)
        {
            item=cJSON_GetObjectItem(object,"firstName");
            if(item!=NULL)
            {
                printf("cJSON_GetObjectItem: type=%d, string is %s, valuestring=%s\n",item->type,item->string,item->valuestring);
                memcpy(person->firstName,item->valuestring,strlen(item->valuestring));
            }

            item=cJSON_GetObjectItem(object,"lastName");
            if(item!=NULL)
            {
                printf("cJSON_GetObjectItem: type=%d, string is %s, valuestring=%s\n",item->type,item->string,item->valuestring);
                memcpy(person->lastName,item->valuestring,strlen(item->valuestring));
            }

            item=cJSON_GetObjectItem(object,"email");
            if(item!=NULL)
            {
                printf("cJSON_GetObjectItem: type=%d, string is %s, valuestring=%s\n",item->type,item->string,item->valuestring);
                memcpy(person->email,item->valuestring,strlen(item->valuestring));
            }

            item=cJSON_GetObjectItem(object,"age");
            if(item!=NULL)
            {
                printf("cJSON_GetObjectItem: type=%d, string is %s, valueint=%d\n",item->type,item->string,item->valueint);
                person->age=item->valueint;
            }
            else
            {
                printf("cJSON_GetObjectItem: get age failed\n");
            }

            item=cJSON_GetObjectItem(object,"height");
            if(item!=NULL)
            {
                printf("cJSON_GetObjectItem: type=%d, string is %s, valuedouble=%f\n",item->type,item->string,item->valuedouble);
                person->height=item->valuedouble;
            }
        }

        cJSON_Delete(root);
    }
    return 0;
}

//parse a struct array
int cJSON_to_struct_array(char *text, people worker[])
{
    cJSON *json,*arrayItem,*item,*object;
    int i;

    json=cJSON_Parse(text);
    if (!json)
    {
        printf("Error before: [%s]\n",cJSON_GetErrorPtr());
    }
    else
    {
        arrayItem=cJSON_GetObjectItem(json,"people");
        if(arrayItem!=NULL)
        {
            int size=cJSON_GetArraySize(arrayItem);
            printf("cJSON_GetArraySize: size=%d\n",size);

            for(i=0;i<size;i++)
            {
                printf("i=%d\n",i);
                object=cJSON_GetArrayItem(arrayItem,i);

                item=cJSON_GetObjectItem(object,"firstName");
                if(item!=NULL)
                {
                    printf("cJSON_GetObjectItem: type=%d, string is %s\n",item->type,item->string);
                    memcpy(worker[i].firstName,item->valuestring,strlen(item->valuestring));
                }

                item=cJSON_GetObjectItem(object,"lastName");
                if(item!=NULL)
                {
                    printf("cJSON_GetObjectItem: type=%d, string is %s, valuestring=%s\n",item->type,item->string,item->valuestring);
                    memcpy(worker[i].lastName,item->valuestring,strlen(item->valuestring));
                }

                item=cJSON_GetObjectItem(object,"email");
                if(item!=NULL)
                {
                    printf("cJSON_GetObjectItem: type=%d, string is %s, valuestring=%s\n",item->type,item->string,item->valuestring);
                    memcpy(worker[i].email,item->valuestring,strlen(item->valuestring));
                }

                item=cJSON_GetObjectItem(object,"age");
                if(item!=NULL)
                {
                    printf("cJSON_GetObjectItem: type=%d, string is %s, valueint=%d\n",item->type,item->string,item->valueint);
                    worker[i].age=item->valueint;
                }
                else
                {
                    printf("cJSON_GetObjectItem: get age failed\n");
                }

                item=cJSON_GetObjectItem(object,"height");
                if(item!=NULL)
                {
                    printf("cJSON_GetObjectItem: type=%d, string is %s, value=%f\n",item->type,item->string,item->valuedouble);
                    worker[i].height=item->valuedouble;
                }
            }
        }

        for(i=0;i<3;i++)
        {
            printf("i=%d, firstName=%s,lastName=%s,email=%s,age=%d,height=%f\n",
                    i,
                    worker[i].firstName,
                    worker[i].lastName,
                    worker[i].email,
                    worker[i].age,
                    worker[i].height);
        }

        cJSON_Delete(json);
    }
    return 0;
}
*/
/* Read a file, parse, render back, etc. */
void dofile(char *filename)
{
	FILE *f;long len;char *data;
	
	f=fopen(filename,"rb");fseek(f,0,SEEK_END);len=ftell(f);fseek(f,0,SEEK_SET);
	data=(char*)malloc(len+1);fread(data,1,len,f);fclose(f);
	doit(data);
	free(data);
}

/* Used by some code below as an example datatype. */
struct record {const char *precision;double lat,lon;const char *address,*city,*state,*zip,*country; };

/* Create a bunch of objects as demonstration. */
void create_objects()
{
	cJSON *root,*fmt,*img,*thm,*fld;char *out;int i;	/* declare a few. */
	/* Our "days of the week" array: */
	const char *strings[7]={"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};
	/* Our matrix: */
	int numbers[3][3]={{0,-1,0},{1,0,0},{0,0,1}};
	/* Our "gallery" item: */
	int ids[4]={116,943,234,38793};
	/* Our array of "records": */
	struct record fields[2]={
		{"zip",37.7668,-1.223959e+2,"","SAN FRANCISCO","CA","94107","US"},
		{"zip",37.371991,-1.22026e+2,"","SUNNYVALE","CA","94085","US"}};

	/* Here we construct some JSON standards, from the JSON site. */
	
	/* Our "Video" datatype: */
	root=cJSON_CreateObject();	
	cJSON_AddItemToObject(root, "name", cJSON_CreateString("Jack (\"Bee\") Nimble"));
	cJSON_AddItemToObject(root, "format", fmt=cJSON_CreateObject());
	cJSON_AddStringToObject(fmt,"type",		"rect");
	cJSON_AddNumberToObject(fmt,"width",		1920);
	cJSON_AddNumberToObject(fmt,"height",		1080);
	cJSON_AddFalseToObject (fmt,"interlace");
	cJSON_AddNumberToObject(fmt,"frame rate",	24);
	
	out=cJSON_Print(root);	cJSON_Delete(root);	printf("%s\n",out);	free(out);	/* Print to text, Delete the cJSON, print it, release the string. */

	/* Our "days of the week" array: */
	root=cJSON_CreateStringArray(strings,7);

	out=cJSON_Print(root);	cJSON_Delete(root);	printf("%s\n",out);	free(out);

	/* Our matrix: */
	root=cJSON_CreateArray();
	for (i=0;i<3;i++) cJSON_AddItemToArray(root,cJSON_CreateIntArray(numbers[i],3));

/*	cJSON_ReplaceItemInArray(root,1,cJSON_CreateString("Replacement")); */
	
	out=cJSON_Print(root);	cJSON_Delete(root);	printf("%s\n",out);	free(out);


	/* Our "gallery" item: */
	root=cJSON_CreateObject();
	cJSON_AddItemToObject(root, "Image", img=cJSON_CreateObject());
	cJSON_AddNumberToObject(img,"Width",800);
	cJSON_AddNumberToObject(img,"Height",600);
	cJSON_AddStringToObject(img,"Title","View from 15th Floor");
	cJSON_AddItemToObject(img, "Thumbnail", thm=cJSON_CreateObject());
	cJSON_AddStringToObject(thm, "Url", "http:/*www.example.com/image/481989943");
	cJSON_AddNumberToObject(thm,"Height",125);
	cJSON_AddStringToObject(thm,"Width","100");
	cJSON_AddItemToObject(img,"IDs", cJSON_CreateIntArray(ids,4));

	out=cJSON_Print(root);	cJSON_Delete(root);	printf("%s\n",out);	free(out);

	/* Our array of "records": */

	root=cJSON_CreateArray();
	for (i=0;i<2;i++)
	{
		cJSON_AddItemToArray(root,fld=cJSON_CreateObject());
		cJSON_AddStringToObject(fld, "precision", fields[i].precision);
		cJSON_AddNumberToObject(fld, "Latitude", fields[i].lat);
		cJSON_AddNumberToObject(fld, "Longitude", fields[i].lon);
		cJSON_AddStringToObject(fld, "Address", fields[i].address);
		cJSON_AddStringToObject(fld, "City", fields[i].city);
		cJSON_AddStringToObject(fld, "State", fields[i].state);
		cJSON_AddStringToObject(fld, "Zip", fields[i].zip);
		cJSON_AddStringToObject(fld, "Country", fields[i].country);
	}
	
/*	cJSON_ReplaceItemInObject(cJSON_GetArrayItem(root,1),"City",cJSON_CreateIntArray(ids,4)); */
	
	out=cJSON_Print(root);	cJSON_Delete(root);	printf("%s\n",out);	free(out);

}

int main (int argc, const char * argv[]) {
	/* a bunch of json: */
	char text1[]="{\n\"name\": \"Jack (\\\"Bee\\\") Nimble\", \n\"format\": {\"type\":       \"rect\", \n\"width\":      1920, \n\"height\":     1080, \n\"interlace\":  false,\"frame rate\": 24\n}\n}";	
	char text2[]="[\"Sunday\", \"Monday\", \"Tuesday\", \"Wednesday\", \"Thursday\", \"Friday\", \"Saturday\"]";
	char text3[]="[\n    [0, -1, 0],\n    [1, 0, 0],\n    [0, 0, 1]\n	]\n";
	char text4[]="{\n		\"Image\": {\n			\"Width\":  800,\n			\"Height\": 600,\n			\"Title\":  \"View from 15th Floor\",\n			\"Thumbnail\": {\n				\"Url\":    \"http:/*www.example.com/image/481989943\",\n				\"Height\": 125,\n				\"Width\":  \"100\"\n			},\n			\"IDs\": [116, 943, 234, 38793]\n		}\n	}";
	char text5[]="[\n	 {\n	 \"precision\": \"zip\",\n	 \"Latitude\":  37.7668,\n	 \"Longitude\": -122.3959,\n	 \"Address\":   \"\",\n	 \"City\":      \"SAN FRANCISCO\",\n	 \"State\":     \"CA\",\n	 \"Zip\":       \"94107\",\n	 \"Country\":   \"US\"\n	 },\n	 {\n	 \"precision\": \"zip\",\n	 \"Latitude\":  37.371991,\n	 \"Longitude\": -122.026020,\n	 \"Address\":   \"\",\n	 \"City\":      \"SUNNYVALE\",\n	 \"State\":     \"CA\",\n	 \"Zip\":       \"94085\",\n	 \"Country\":   \"US\"\n	 }\n	 ]";

	/* Process each json textblock by parsing, then rebuilding: */
	doit(text1);
	doit(text2);	
	doit(text3);
	doit(text4);
	doit(text5);

	/* Parse standard testfiles: */
/*	dofile("../../tests/test1"); */
/*	dofile("../../tests/test2"); */
/*	dofile("../../tests/test3"); */
/*	dofile("../../tests/test4"); */
/*	dofile("../../tests/test5"); */

	/* Now some samplecode for building objects concisely: */
//	create_objects();
	
	doparse(text1);
	return 0;
}
