# Introduction [中文](https://github.com/desion/terminal/blob/master/README_CN.md)
  Terminal is a persistent huge storage service , compatible with the majority of memcached interfaces (get,stats). With the huge amount of data stored,  Except huge storage capacity, Terminal also support load huge data one time, it can load many db and append data to the existed db, when there is the same key in the new version and old version Terminal will return the value with new version. Terminal is very useful for the recommend system.
  
  Terminal's db is composed of memory and disk, the index will load into memory and the dat will store in disk, so it can save much memory. The data file name dat,and the index file name idx. The idx file is composed of many key-pos pairs. Current version support Integer keys and string keys. The Integer keys is faster than string keys.

  this is base on [lushan](https://github.com/wbrecom/lushan)

# Quickstart and Try

## Dashboard
   you can use the dashboard to manage the Terminal
   1. update the configure file in terminal/web/conf.py
      specify the host, port and the server tag
   2. start the dashboard server (Dependencies tornado, you can install it use pip install tornado)
      ```
      python http_server.py <port>
      ```
   3. then you can visit dashboard and use it to manage the Terminal
      ![image](https://github.com/desion/terminal/raw/master/screenshots/terminal_dash.png)
## Compile
### Dependencies
    - libevent1.4
### Start Compile
    1. git clone https://github.com/desion/terminal.git
    2. Compile
       cd terminal
       make

## Useage
   1. start Terminal
      ```
      -p <num>   TCP port to listen on (default: 9898)
      -l <ip_addr>  interface to listen on, default is INDRR_ANY
      -c <num>      max simultaneous connections (default: 1024)
      -d            daemon
      -h            help
      -v            verbose (print errors/warnings)
      -t <num>      number of worker threads to use, default 4
      -T <num>      timeout in millisecond, 0 for none, default 0

      ./terminal -p 9898 -c 1024 -d -t 8
      ```
   2. load data
      you should put the idx and dat file in a folder, and run the command to load the data to db
      ```
      echo -ne "open <data_dir>\r\n" | nc 127.0.0.1 9898
      ```
      you can also to append the new version data to the same db, by this you can get the new version data when you search the key
      ```
      echo -ne "append <data_dir>\r\n" | nc 127.0.0.1 9898
      ```
   3. unload the db
      ```
      echo -ne "close <label>\r\n" | nc 127.0.0.1 9898
      ```
   4. unload the db with specific version
      ```
      echo -ne "close <label> <version>\r\n" | nc 127.0.0.1 9898
      ```

## Command
   you can use the stats command to get the status of server
   ```
   echo -ne "stats\r\n" | nc 127.0.0.1 9898
   ```
   get the value by the key in the specific db(get label-key) 
   ```
   echo -ne "get 1-123456\r\n" | nc 127.0.0.1 9898
   ```
   use info command to get the db status
   ```
   echo -ne "info\r\n" | nc 127.0.0.1 9898
   ```
## Generate Data
    1. give the dat file that is composed of key-value lines, the line should be split by :, and the key must be integer in version 1.0
    2. the dat file should be sorted by the key
    3. you can use the binary file index_create to make the idx file
    for integer key:
    ```
    ./index_create -i <dat> -o <idx> -l <label>
    <dat> is the data file,<idx> is the index file will be generated,<label> is the flag of db
    ```
    for string key
    ```
    ./index_create -i <dat> -o <idx> -l <label> -s -n <key number>
    <dat> is the data file
    <idx> is the index file will be generated
    <label> is the flag of db
    <key number> is the number of keys in the dat file
    ```
# Support Commands
  - info

    get the information of db that load into the server

  - stats

    get the status of server

  - get

    get the value by key

  - open reopen

    open the db and load the index and data
  
  - append

    append the new version data to server

  - stats reset(be careful)

    reset the server status information

  - close

    close db, unload data
