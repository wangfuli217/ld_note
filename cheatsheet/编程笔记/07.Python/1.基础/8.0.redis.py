https://github.com/sripathikrishnan/redis-rdb-tools/
pip install rdbtools
> rdb --command json /var/redis/6379/dump.rdb

[{
"user003":{"fname":"Ron","sname":"Bumquist"},
"lizards":["Bush anole","Jackson's chameleon","Komodo dragon","Ground agama","Bearded dragon"],
"user001":{"fname":"Raoul","sname":"Duke"},
"user002":{"fname":"Gonzo","sname":"Dr"},
"user_list":["user003","user002","user001"]},{
"baloon":{"helium":"birthdays","medical":"angioplasty","weather":"meteorology"},
"armadillo":["chacoan naked-tailed","giant","Andean hairy","nine-banded","pink fairy"],
"aroma":{"pungent":"vinegar","putrid":"rotten eggs","floral":"roses"}}]

https://github.com/andymccurdy/redis-py

https://github.com/yahoo/redislite