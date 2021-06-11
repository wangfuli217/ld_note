for (var = SPLAY_MIN(NAME, &head); var != NULL; var = nxt) {
       nxt = SPLAY_NEXT(NAME, &head, var);
       SPLAY_REMOVE(NAME, &head, var);
       free(var);
}