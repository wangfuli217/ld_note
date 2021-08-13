#include <stdio.h>
char g_Map[3][3];
void init() {
    int row;
    int col;
    for (row = 0; row < 3; row++) {
         for (col = 0; col < 3; col++) {
               g_Map[row][col] = ' ';
          }
     }
}

void show_map() {
     printf("%c | %c | %c\n", g_Map[0][0], g_Map[0][1], g_Map[0][2]);
     printf("--+---+--\n");
     printf("%c | %c | %c\n", g_Map[1][0], g_Map[1][1], g_Map[1][2]);
     printf("--+---+--\n");
     printf("%c | %c | %c\n", g_Map[2][0], g_Map[2][1], g_Map[2][2]);
}

int place_chess(char player) {
     while(1) {
        int row;
        int col;
        printf("请输入行号：\n");
        scanf("%d", &row);
        if ((row < 1) || (row > 3)) {
             printf("输入错误，请再次输入\n");
             continue;
         }
        printf("请输入列号：\n");
        scanf("%d", &col);
        if ((col < 1) || (col > 3)) {
             printf("输入错误，请再次输入\n");
             continue;
         }
        row--;
        col--;
        if (' ' != g_Map[row][col]) {
             printf("输入错误，请再次输入\n");
             continue;
         }
        g_Map[row][col] = player;
        break;
      }
}

char wins() {
    if ((g_Map[0][0] == g_Map[0][1]) && 
        (g_Map[0][1] == g_Map[0][2]) &&
        (' ' != g_Map[0][1])) {
       return g_Map[0][0];
     }
    if ((g_Map[1][0] == g_Map[1][1]) && 
        (g_Map[1][1] == g_Map[1][2]) &&
        (' ' != g_Map[1][1])) {
       return g_Map[1][0];
     }
    if ((g_Map[2][0] == g_Map[2][1]) && 
        (g_Map[2][1] == g_Map[2][2]) &&
        (' ' != g_Map[2][1])) {
       return g_Map[2][0];
     }
    if ((g_Map[0][0] == g_Map[1][0]) && 
        (g_Map[1][0] == g_Map[2][0]) &&
        (' ' != g_Map[1][0])) {
       return g_Map[0][0];
     }
    if ((g_Map[0][1] == g_Map[1][1]) && 
        (g_Map[1][1] == g_Map[2][1]) &&
        (' ' != g_Map[1][1])) {
       return g_Map[0][1];
     }
    if ((g_Map[0][2] == g_Map[1][2]) && 
        (g_Map[1][2] == g_Map[2][2]) &&
        (' ' != g_Map[1][2])) {
       return g_Map[0][2];
     }
    if ((g_Map[0][0] == g_Map[1][1]) && 
        (g_Map[1][1] == g_Map[2][2]) &&
        (' ' != g_Map[0][0])) {
       return g_Map[0][0];
     }
    if ((g_Map[2][0] == g_Map[1][1]) && 
        (g_Map[1][1] == g_Map[0][2]) &&
        (' ' != g_Map[1][1])) {
       return g_Map[1][1];
     }
    return ' ';
}

int main() {
     int again;
    do {
        char player = 'O';
        init();
        show_map();
        int loop;
        for (loop = 0; loop < 9; loop++) {
            place_chess(player);
            show_map();
            char result = wins();
            if (('*' == result) || ('O' == result)) {
                printf("%c wins!!\n", result);
                break;
              }
            else {
                if ('O' == player) {
                    player = '*';
		   }
                else {
                    player = 'O';
                   }
              }
          }
        if (9 == loop) {
           printf("和棋!!\n");
         }
        printf("是否开始新的游戏?(1 is Yes, 0 is No)\n");
        scanf("%d", &again);
    } while(0 != again);
    return 0;
}
