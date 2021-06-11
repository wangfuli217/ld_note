#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include <assert.h>

void read_slogan(FILE *fp, char **slogan){
    char buf[1024];
    int i;
    for (i = 0; i < 7; i++){
        fgets(buf, sizeof(buf), fp);
        buf[strlen(buf)-1] = '\0'; /* remove '\n' */
        slogan[i] = malloc(sizeof(char) * (strlen(buf) + 1));
        assert(slogan[i] != NULL);
        strcpy(slogan[i], buf);
    }
}

int main(int argc, const char *argv[]){
    char *slogan[7];
    int i;

    read_slogan(stdin, slogan);

    for (i = 0; i < 7; i++){
        printf("%s\n", slogan[i]);
    }
    return 0;
}

// 对标语的长度作了1024的限制，这让人感到不便，可使用下面程序来动态分配临时缓冲区
#if 0 
#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include <assert.h>

#define INIT_ALLOC_LEN (4)

typedef struct{
    char *buffer;
    int used_len;
    int alloc_len;
} LineStatus;

static void line_status_new(LineStatus *l){
    l->used_len = 0;
    l->alloc_len = INIT_ALLOC_LEN;
    l->buffer = malloc(INIT_ALLOC_LEN * sizeof(char));
    assert(l->buffer != NULL);
}

static void add_character(LineStatus *l, char ch){
    assert(l->alloc_len >= l->used_len);
    if(l->used_len == l->alloc_len){
        l->alloc_len *= 2;
        l->buffer = realloc(l->buffer, l->alloc_len * sizeof(char));
        assert(l->buffer != NULL);
    }
    l->buffer[l->used_len] = ch;
    l->used_len++;
}

static void line_status_free(LineStatus *l){
    free(l->buffer);
}

char *read_line(FILE *fp){
    char ch, *ret_line;
    LineStatus line_status;
    line_status_new(&line_status);

    while((ch = getc(fp)) != EOF){
        if(ch == '\n'){
            add_character(&line_status, '\0');
            break;
        }
        add_character(&line_status, ch);
    }
    if(ch == EOF){
        if(line_status.used_len > 0){
            add_character(&line_status, '\0');
        }else{
            return NULL;
        }
    }
    ret_line = malloc(line_status.used_len * sizeof(char));
    assert(ret_line != NULL);
    strcpy(ret_line, line_status.buffer);
    line_status_free(&line_status);
    return ret_line;
}

int main(int argc, const char *argv[]){
    char *line = read_line(stdin);
    printf("%s %d\n", line, strlen(line));
    free(line);
    return 0;
}

// 调用方需要将输出的实参line进行free()
#endif

#if 0
#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include <assert.h>

#define INIT_ALLOC_LEN (4)

typedef struct{
    char *buffer;
    int used_len;
    int alloc_len;
} LineStatus;

static void line_status_new(LineStatus *l){
    l->used_len = 0;
    l->alloc_len = INIT_ALLOC_LEN;
    l->buffer = malloc(INIT_ALLOC_LEN * sizeof(char));
    assert(l->buffer != NULL);
}

static void add_character(LineStatus *l, char ch){
    assert(l->alloc_len >= l->used_len);
    if(l->used_len == l->alloc_len){
        l->alloc_len *= 2;
        l->buffer = realloc(l->buffer, l->alloc_len * sizeof(char));
        assert(l->buffer != NULL);
    }
    l->buffer[l->used_len] = ch;
    l->used_len++;
}

static void line_status_free(LineStatus *l){
    free(l->buffer);
}

char *read_line(FILE *fp){
    char ch, *ret_line;
    LineStatus line_status;
    line_status_new(&line_status);

    while((ch = getc(fp)) != EOF){
        if(ch == '\n'){
            add_character(&line_status, '\0');
            break;
        }
        add_character(&line_status, ch);
    }
    if(ch == EOF){
        if(line_status.used_len > 0){
            add_character(&line_status, '\0');
        }else{
            return NULL;
        }
    }
    ret_line = malloc(line_status.used_len * sizeof(char));
    assert(ret_line != NULL);
    strcpy(ret_line, line_status.buffer);
    line_status_free(&line_status);
    return ret_line;
}

char **add_line(char **text_data, char *line,
                int *line_alloc_num, int *line_num){
    assert(*line_alloc_num >= *line_num);
    if(*line_alloc_num == *line_num){
        text_data = realloc(text_data, (*line_alloc_num + INIT_ALLOC_LEN) * sizeof(char*));
        *line_alloc_num += INIT_ALLOC_LEN;
    }
    text_data[*line_num] = line;
    (*line_num)++;
    return text_data;
}

char **read_file(FILE *fp, int *ret_line_num_p){
    char **text_data = NULL;
    int line_num = 0;
    int line_alloc_num = 0;
    char *line;

    while((line = read_line(fp)) != NULL){
        text_data = add_line(text_data, line, &line_alloc_num, &line_num);
    }
    *ret_line_num_p = line_num;
    return text_data;
}

int main(int argc, const char *argv[]){
    char **text_data;
    int line_num;
    int i = 0;
    FILE *fp = fopen("input.txt", "r");

    text_data = read_file(fp, &line_num);

    for(; i < line_num; i++){
        printf("%s\n", text_data[i]);
        free(text_data[i]);
    }
    free(text_data);
    fclose(fp);
    return 0;
}
#endif


#if 0 

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include <assert.h>
#include <stdarg.h>

#ifdef DEBUG
#define DEBUG_WRITE(arg) debug_write arg
#else
#define DEBUG_WRITE(arg)
#endif

#define INIT_ALLOC_LEN (4)

void debug_write(char *format, ...){
    va_list ap;
    va_start(ap, format);
    vfprintf(stderr, format, ap);
    va_end(ap);
}

typedef struct{
    void *buffer;
    int elem_size;
    int used_len;
    int alloc_len;
    void(*free_fn)(void*);
} Cache;

static void cache_new(Cache *c, int elem_size, void(*free_fn)(void*)) {
    assert(elem_size > 0);
    c->elem_size = elem_size;
    c->used_len = 0;
    c->alloc_len = INIT_ALLOC_LEN;
    c->buffer = malloc(INIT_ALLOC_LEN * elem_size);
    c->free_fn = free_fn;
    assert(c->buffer != NULL);
}

static void cache_grow(Cache *c){
    DEBUG_WRITE(("-cache_grow_b: %d\n", c->alloc_len));
    c->alloc_len *= 2;
    c->buffer = realloc(c->buffer, c->alloc_len * sizeof(c->elem_size));
    assert(c->buffer != NULL);
}

static void cache_add(Cache *c, void *data_addr){
    assert(c->alloc_len >= c->used_len);
    if(c->used_len == c->alloc_len){
        cache_grow(c);
    }
    void *target = (char*)c->buffer + c->used_len * c->elem_size;
    memcpy(target, data_addr, c->elem_size);

    #ifdef DEBUG //debug write
        if(c->elem_size == sizeof(char)){
            DEBUG_WRITE(("-cache_add_char_s: %c\n", *(char*)data_addr));
            DEBUG_WRITE(("-cache_add_char_t: %c\n", ((char*)c->buffer)[c->used_len]));
        }
        else if (c->elem_size == sizeof(char*)){
            DEBUG_WRITE(("-cache_add_char*_s: %s\n", *(char**)data_addr));
            DEBUG_WRITE(("-cache_add_char*_t: %s\n", ((char**)c->buffer)[c->used_len]));
        }
    #endif

    c->used_len++;
}

static void cache_free(Cache *c){
    int i;
    if(c->free_fn != NULL){
        for(i = 0; i < c->used_len; i++){
            c->free_fn((char)c->buffer + i * c->elem_size);
        }
    }
    #ifdef DEBUG
        if(c->elem_size == sizeof(char)){
            DEBUG_WRITE(("-cache_free_char*: %s\n", (char*)c->buffer));
        }
        else if (c->elem_size == sizeof(char*)){
            DEBUG_WRITE(("-cache_free_char**\n"));
        }
    #endif
    free(c->buffer);
}

char *read_line(FILE *fp){
    char ch, temp_ch, *ret_line;
    Cache cache;
    cache_new(&cache, sizeof(char), NULL);

    while((ch = getc(fp)) != EOF){
        if(ch == '\n'){
            temp_ch = '\0';
            cache_add(&cache, &temp_ch);
            break;
        }
        cache_add(&cache, &ch);
    }
    if(ch == EOF){
        if(cache.used_len > 0){
            temp_ch = '\0';
            cache_add(&cache, &temp_ch);
        }else{
            return NULL;
        }
    }
    ret_line = malloc(cache.used_len * sizeof(char));
    assert(ret_line != NULL);
    strcpy(ret_line, (char*)cache.buffer);
    cache_free(&cache);
    return ret_line;
}

void string_free(void* elemAddr) {
    char** p = (char**)elemAddr;
    DEBUG_WRITE(("-string_free: %s\n", *p));
    free(*p);
}

char **read_file(FILE *fp, int *ret_line_num){
    char *temp_line, **ret_file_data;
    Cache cache;

    // cache_new(&cache, sizeof(char*), string_free);
    cache_new(&cache, sizeof(char*), NULL);
    while((temp_line = read_line(fp)) != NULL){
        // must use &, so add `char**`
        cache_add(&cache, &temp_line);
    }
    // not *ret_file_data = ...
    ret_file_data = malloc(cache.used_len * sizeof(char*));
    assert(ret_file_data != NULL);

    memcpy(ret_file_data, cache.buffer, cache.used_len * sizeof(char*));
    *ret_line_num = cache.used_len;
    cache_free(&cache);

    return ret_file_data;
}

int main(int argc, const char *argv[]){
    char **file_data;
    int i, line_num;
    FILE *fp = fopen("input.txt", "r");

    file_data = read_file(fp, &line_num);

    for(i = 0; i < line_num; i++){
        printf("%s\n", file_data[i]);
        free(file_data[i]);
    }
    free(file_data);
    fclose(fp);
    return 0;
}

#endif