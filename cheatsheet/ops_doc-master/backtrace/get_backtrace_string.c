int get_backtrace_string(void* bt,char* buff, int buff_size)  
{  
    char cmd[128] = {0};  
    char property[256]={0};  
    char not_care1[128]={0},not_care2[128]={0},not_care3[128]={0};  
    char library_path[256]={0};  
    char exe_path[256],function_name[256];  
    char maps_line[1024]={0};  
    void* offset_start,*offset_end;  
    int maps_column_num=0;  
    FILE* fd_maps=NULL;  
    fd_maps=fopen("/proc/self/maps","r");  
    unsigned long exe_symbol_offset=0;  
    char* unknow_position="??:0\n";  
    if(fd_maps==NULL)  
    {  
        return -1;  
    }  
    while(NULL!=fgets(maps_line,sizeof(maps_line),fd_maps))  
    {  
        maps_column_num=sscanf(maps_line,"%p-%p\t%s\t%s\t%s\t%s\t%s"  
                                                        ,&offset_start  
                                                        ,&offset_end  
                                                        ,property  
                                                        ,not_care1  
                                                        ,not_care2  
                                                        ,not_care3  
                                                        ,library_path);  
        if(maps_column_num==7&&bt>=offset_start&&bt<=offset_end)  
        {  
            break;  
        }  
          
    }  
    fclose(fd_maps);  
    readlink("/proc/self/exe", exe_path, sizeof(exe_path));  
    if(exe_path[strlen(exe_path)-1]=='\n')  
    {  
        exe_path[strlen(exe_path)-1]='\0';  
    }  
    if(0==strcmp(exe_path,library_path))  
    {  
        exe_symbol_offset=(unsigned long)bt;  
    }  
    else  
    {  
        exe_symbol_offset=(char*)bt-(char*)offset_start;  
    }  
    snprintf(cmd,sizeof(cmd),"addr2line -C -e %s 0x%lx",library_path,exe_symbol_offset);  
    exec_shell(cmd, buff, buff_size);  
    if(0==strcmp(buff,unknow_position))  
    {  
        snprintf(cmd,sizeof(cmd),"addr2line -Cif -e %s 0x%lx",library_path,exe_symbol_offset);  
        exec_shell(cmd, function_name, sizeof(function_name));  
        function_name[strlen(function_name)-1]='\0';  
        snprintf(buff,buff_size,"%s(%s+0x%lx)\n",library_path,function_name,exe_symbol_offset);  
    }  
    return 0;  
}