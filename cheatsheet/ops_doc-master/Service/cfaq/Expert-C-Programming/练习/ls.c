#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h>
#include <pwd.h>
#include <grp.h>
#include <time.h>
#include <setjmp.h>
#include <assert.h>
#include <math.h>

#include "list.h"


#define UNM_SIZE 32
#define GNM_SIZE 32
#define TIME_SIZE 32
#define TOKEN_SIZE 32
#define FILENM_SIZE 256
#define COLOR_SIZE 10

#define HAS_BIT(settings, bit) (((settings) & (bit)) == (bit))

enum SHOW_OPTIONS{
    SHOW_ALL = 1,
    SHOW_LONG = 1 << 1,
    SHOW_INODE = 1 << 2
};

struct ls_entry{
    ino_t ino;
    char typ;
    char perms[10];
    nlink_t nlink;
    char user[UNM_SIZE];
    char group[GNM_SIZE];
    int major_dev;
    off_t size;
    char mtime[TIME_SIZE];
    char filenm[FILENM_SIZE];
    char lnfilenm[FILENM_SIZE];
    char color[COLOR_SIZE];
    struct list_head node;
};

struct ls_entry_max{
    ino_t ino;
    nlink_t nlink;
    int user_len;
    int group_len;
    int major_dev;
    off_t size;
};

static int LS_ENT_COUNT = 0;

static void parse_argv(char **argv, char **path, int *options);
static char *load_ls_colors();
static int trave_dir(char *path, int options, char *ls_colors);
static int process_file(const char *name, struct list_head *list, char *ls_colors);

int main(int argc, char **argv){
    int options = 0;
    char *path = ".";

    parse_argv(argv, &path, &options);
    char *ls_colors = load_ls_colors();
    int ret = trave_dir(path, options, ls_colors);
    free(ls_colors);
    return ret;
}

static void parse_argv(char **argv, char **path, int *options){
    char *c, ch;
    while(*(++argv) != NULL){
        if(**argv == '-'){
            c = *argv;
            while((ch = *(++c)) != '\0'){
                switch(ch){
                    case 'a' : *options = *options|SHOW_ALL; break;
                    case 'l' : *options = *options|SHOW_LONG; break;
                    case 'i' : *options = *options|SHOW_INODE; break;
                    default: break;
                }
            }
        }
        else
            *path = *argv;
    }
}

static char *load_ls_colors(){
    char *colors = getenv("LS_COLORS");
    if(colors == NULL) return NULL;
    return strdup(colors);
}


static struct list_head *init_list(){
    struct list_head *list = malloc(sizeof(*list));
    assert(list != NULL);
    INIT_LIST_HEAD(list);
    return list;
}

static void destroy_list(struct list_head *list){
    struct list_head *cur;
    struct ls_entry *ls_ent;
    __list_for_each(cur, list) {
        ls_ent = list_entry(cur, struct ls_entry, node);
        free(ls_ent);
    }
    free(list);
}

static void print_ls_entry(const struct ls_entry *entry, int options, struct ls_entry_max max){
    if(!HAS_BIT(options, SHOW_ALL) && entry->filenm[0] == '.') return;
    if(HAS_BIT(options, SHOW_INODE))
        printf("%*ld ", (int)log10(max.ino) + 1, entry->ino);
    if(HAS_BIT(options, SHOW_LONG)){
        printf("%c%s %*d %-*s %-*s ",  //%*ld %s ",
            entry->typ, entry->perms,
            (int)log10(max.nlink) + 1, entry->nlink,
            max.user_len, entry->user,
            max.group_len, entry->group);
        if(entry->typ == 'b' || entry->typ == 'c')
            printf("%*d, %*ld ",
                max.major_dev > 0 ? (int)log10(max.major_dev) + 1 : 1,
                entry->major_dev,
                max.size > 0 ? (int)log10(max.size) + 1 : 1,
                entry->size);
        else
            printf("%*ld ",
                (max.major_dev > 0 ? (int)log10(max.major_dev) + 1 : 1)
                + (max.size > 0 ? (int)log10(max.size) + 1 : 1) + 2,
                entry->size);
        printf("%s ",entry->mtime);
    }
    printf("\033[%sm%s\033[0m ", entry->color, entry->filenm);

    if(HAS_BIT(options, SHOW_LONG) && entry->typ == 'l')
        printf("> %s", entry->lnfilenm);

    printf("\n");
}

int ls_entry_cmp(const void *data1, const void *data2){
    struct ls_entry **ent1 = (struct ls_entry **)data1;
    struct ls_entry **ent2 = (struct ls_entry **)data2;
    return strcasecmp((*ent1)->filenm, (*ent2)->filenm);
}

static void show_ls_entries(struct list_head *list, int options){
    struct list_head *cur;
    struct ls_entry *ls_ent;

    struct ls_entry **sort_list = malloc(sizeof(struct ls_entry *) * LS_ENT_COUNT);
    int idx = 0;
    struct ls_entry_max max = {0};
    __list_for_each(cur, list) {
        ls_ent = list_entry(cur, struct ls_entry, node);
        sort_list[idx++] = ls_ent;

        if(ls_ent->ino > max.ino) max.ino = ls_ent->ino;
        if(ls_ent->nlink > max.nlink) max.nlink = ls_ent->nlink;
        if(strlen(ls_ent->user) > max.user_len) max.user_len = strlen(ls_ent->user);
        if(strlen(ls_ent->group) > max.group_len) max.group_len = strlen(ls_ent->group);
        if((ls_ent->typ == 'b' || ls_ent->typ == 'c') && ls_ent->major_dev > max.major_dev) max.major_dev = ls_ent->major_dev;
        if(ls_ent->size > max.size) max.size = ls_ent->size;
    }

    qsort(sort_list, LS_ENT_COUNT, sizeof(struct ls_entry *), ls_entry_cmp);
    for(idx = 0; idx < LS_ENT_COUNT; idx++){
        print_ls_entry(sort_list[idx], options, max);
    }
    free(sort_list);
}


static int trave_dir(char *path, int options, char *ls_colors){
    DIR *dir = NULL;
    struct dirent *entry;

    struct stat st;
    int retcd = 0;
    struct list_head *list;

    if (stat(path, &st)== -1) {
        perror("stat()");
        return -1;
    }

    list = init_list();

    if(!S_ISDIR(st.st_mode)){
        if(process_file(path, list, ls_colors) == -1){
            retcd = -1;
            goto DESTORY_LIST;
        }
    }
    else {
        dir = opendir(path);
        if (dir == NULL) {
            perror("opendir()");
            retcd = -1;
            goto DESTORY_LIST;
        }

        if(chdir(path) == -1){
            perror("chdir()");
            retcd = -1;
            goto CLOSE_DIR;
        }

        while (1) {
            entry = readdir(dir);
            if (entry == NULL) break;
            if(process_file(entry->d_name, list, ls_colors) == -1){
                retcd = -1;
                goto CLOSE_DIR;
            }
        }
    }

    show_ls_entries(list, options);

CLOSE_DIR:
    closedir(dir);

DESTORY_LIST:
    destroy_list(list);

    return retcd;
}

static char get_file_type(mode_t mode){
    switch(mode & S_IFMT){
        case S_IFSOCK:
            return 's';
        case S_IFLNK:
            return 'l';
        case S_IFREG:
            return '-';
        case S_IFBLK:
            return 'b';
        case S_IFDIR:
            return 'd';
        case S_IFCHR:
            return 'c';
        case S_IFIFO:
            return 'p';
    }
    return '-';
}

static void get_file_perm(mode_t mode, char *perm_str){
    if(HAS_BIT(mode, S_IRUSR))
        perm_str[0]='r';
    if(HAS_BIT(mode, S_IWUSR))
        perm_str[1]='w';
    if(HAS_BIT(mode, S_IXUSR))
        perm_str[2]='x';
    if(HAS_BIT(mode, S_ISUID))
        perm_str[2]='S';
    if(HAS_BIT(mode, S_IXUSR|S_ISUID))
        perm_str[2]='s';


    if(HAS_BIT(mode, S_IRGRP))
        perm_str[3]='r';
    if(HAS_BIT(mode, S_IWGRP))
        perm_str[4]='w';
    if(HAS_BIT(mode, S_IXGRP))
        perm_str[5]='x';
    if(HAS_BIT(mode, S_ISGID))
        perm_str[5]='S';
    if(HAS_BIT(mode, S_IXGRP|S_ISGID))
        perm_str[5]='s';


    if(HAS_BIT(mode, S_ISGID))
        perm_str[5]='s';
    if(HAS_BIT(mode, S_IROTH))
        perm_str[6]='r';
    if(HAS_BIT(mode, S_IWOTH))
        perm_str[7]='w';
    if(HAS_BIT(mode, S_IXOTH))
        perm_str[8]='x';
    if(HAS_BIT(mode, S_ISVTX))
        perm_str[8]='T';
    if(HAS_BIT(mode, S_IXOTH|S_ISVTX))
        perm_str[8]='t';
}


static void get_file_username(uid_t uid, char *unm_str){
    struct passwd *pwd = getpwuid(uid);
    if(pwd == NULL){
        snprintf(unm_str, UNM_SIZE, "%d", uid);
        return;
    }
    strncpy(unm_str, pwd->pw_name, UNM_SIZE);
}

static void get_file_groupname(gid_t gid, char *gnm_str){
    struct group *grp = getgrgid(gid);
    if(grp == NULL){
        snprintf(gnm_str, GNM_SIZE, "%d", gid);
        return;
    }
    strncpy(gnm_str, grp->gr_name, GNM_SIZE);
}

static void get_file_time(time_t mtime, char *time_str){
    time_t now = time(NULL);
    struct tm *ntm = localtime(&now);
    int y = ntm->tm_year;

    struct tm *ltm = localtime(&mtime);
    if(ltm->tm_year == y)
        strftime(time_str, TIME_SIZE, "%b %d %R", ltm);
    else
        strftime(time_str, TIME_SIZE, "%b %d  %Y", ltm);
}

static int get_link_filenm(const char *name, char *lnfilenm){
    ssize_t size = readlink(name, lnfilenm, FILENM_SIZE);
    if(size == -1){
        snprintf(lnfilenm, FILENM_SIZE, "%s readlink()", name);
        perror(lnfilenm);
        return -1;
    }
    if(size == FILENM_SIZE) lnfilenm[FILENM_SIZE - 1] = '\0';
    else lnfilenm[size] = '\0';
    return 0;
}

static void get_ls_color_item(char *ls_colors, char *nm, char *color){
    char *ls_colors_dup = strdup(ls_colors);

    char *outer_ptr = NULL;
    char *inner_ptr = NULL;

    char *tok, *sub_tok;
    char *val = NULL;
    for(tok = strtok_r(ls_colors_dup, ":", &outer_ptr); tok != NULL; tok = strtok_r(NULL, ":", &outer_ptr)){
        for(sub_tok = strtok_r(tok, "=", &inner_ptr); sub_tok != NULL; sub_tok = strtok_r(NULL, "=", &inner_ptr)){
            if(strcmp(nm, sub_tok) == 0){
                val = strtok_r(NULL, "=", &inner_ptr);
                strncpy(color, val, COLOR_SIZE);
                goto FREE;
            }
        }
    }
FREE:
    free(ls_colors_dup);
}

static void get_file_colors(struct ls_entry *entry, char *ls_colors){
    if(entry->perms[2] == 'x' || entry->perms[5] == 'x' || entry->perms[8] == 'x')
        get_ls_color_item(ls_colors, "ex", entry->color);
    switch(entry->typ){
        case 'd' : get_ls_color_item(ls_colors, "di", entry->color); break;
        case 'l' : get_ls_color_item(ls_colors, "ln", entry->color); break;
        case 'b' : get_ls_color_item(ls_colors, "bd", entry->color); break;
        case 'c' : get_ls_color_item(ls_colors, "cd", entry->color); break;
    }
    if(entry->perms[2] == 'S' || entry->perms[2] == 's')
        get_ls_color_item(ls_colors, "su", entry->color);
    if(entry->perms[5] == 'S' || entry->perms[5] == 's')
        get_ls_color_item(ls_colors, "sg", entry->color);
    if(entry->perms[8] == 'T' || entry->perms[8] == 't')
        get_ls_color_item(ls_colors, "st", entry->color);

}

static int process_file(const char *name, struct list_head *list, char *ls_colors){
    struct ls_entry *entry = malloc(sizeof(*entry));
    assert(entry != NULL);
    struct stat st;

    if (lstat(name, &st) == -1) {
        perror("stat()");
        goto ERROR;
    }

    entry->ino = st.st_ino;
    entry->nlink = st.st_nlink;

    entry->typ = get_file_type(st.st_mode);

    strncpy(entry->perms, "---------", 10);
    get_file_perm(st.st_mode, entry->perms);

    get_file_username(st.st_uid, entry->user);
    get_file_groupname(st.st_gid, entry->group);

    entry->size = st.st_size;
    if(S_ISBLK(st.st_mode) || S_ISCHR(st.st_mode) ){
        entry->major_dev = major(st.st_rdev);
        entry->size = minor(st.st_rdev);
    }

    get_file_time(st.st_mtime, entry->mtime);
    strncpy(entry->filenm, name, FILENM_SIZE);

    memset(entry->lnfilenm, '\0', FILENM_SIZE);
    if(S_ISLNK(st.st_mode)){
        if(get_link_filenm(name, entry->lnfilenm) == -1){
            goto ERROR;
        }
    }

    strncpy(entry->color, "0", COLOR_SIZE);
    get_file_colors(entry, ls_colors);

    list_add(&entry->node, list);
    LS_ENT_COUNT++;
    return 0;

ERROR:
    free(entry);
    return -1;
}


// gcc myls.c -o myls -lm
// longjmp
//
