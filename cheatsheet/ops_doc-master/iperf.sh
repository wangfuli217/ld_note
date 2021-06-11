
使用方式:
這於這個工具是Server Client架構，所以需要在兩台電腦上測試，中間經過什麼東西，
就是想測試效能的設備，比如Firewall,VPN,SSL- VPN,Wireless AP...，所以先找兩台電腦，
一台當Server，一台當Client:
Step.1 下載: 到http://www.noc.ucf.edu/Tools/Iperf/iperf.exe 將程式下載，之後將程式copy到想存放的地方，比如說D:/之下。
Step.2 開啟dos視窗: 執行->cmd
Step.3 執行Server: 從comandline輸入 D:/iperf.exe -s (其它參數)
Step.4 執行Client: 從comandline輸入 D:/iperf.exe -c serverip (其它參數)

參數參考:
Client端/Server端 都可用的參數:
-f, --format [kmKM] 以什麼方式顯示: Kbits, Mbits, KBytes, MBytes
-i, --interval # 每隔多少秒顯更新頻寬資訊
-l, --len #[KM] 設定讀寫的緩衝區長度 (預設 8 KB)
-m, --print_mss 顯示TCP/IP標頭的MTU(最大segment)大小
-o, --output 將report或錯誤訊息輸出到這個檔案裡
-p, --port # 設定server與client的溝通port
-u, --udp 使用UDP代替TCP測試
-w, --window #[KM] TCP的window大小(socket buffer size)
-B, --bind bind某,結合某介面或multicast的位址用
-C, --compatibility 與舊版本比較用，不送任何封包
-M, --mss # 設定TCP最大segment大小 (MTU - 40 bytes)
-N, --nodelay 設定無TCP延遲，取消Nagle 演算法
-V, --IPv6Version 設定為IPv6格式

Server 端參數:
-s, --server 執行Server模式
-D, --daemon 執行Server背景模式
-R, --remove 移除服務

Client 端參數:
-b, --bandwidth #[KM] UDP參數，以bits/sec傳送(預設 1 Mbit/sec, implies -u)
-c, --client 執行Client模式，並連線到Server的IP:
-d, --dualtest 同時執行雙向的模擬測試
-n, --num #[KM] 傳輸多少bytes封包 (取代-t)
-r, --tradeoff 單獨執行雙向的模擬測試
-t, --time # 每隔幾秒傳輸一次 (預設10 秒)
-F, --fileinput 選取某檔案傳輸測試
-I, --stdin 將鍵盤輸入的資料進行傳輸測試
-L, --listenport # 進行雙測試時，接收回應的port
-P, --parallel # 同時執行多少個Client連線
-T, --ttl # 進行Multicat的time-to-live(預設為 1)


1. Server端:
    iperf -s -u -i 1 -l 1024 -p 5001
設置Server只接收UDP封包，每隔1秒更新顯示一次，進行讀寫的緩衝區大小為1020k，進行監聽的port為5001

2.Client端:
    iperf -c 192.168.4.88 -u -i 1 -l 1024 -p 5001 -t 200 -b 1m
設置 Client端，連向ServerIP為192.168.4.88，以UDP傳送，每隔1秒更新顯示一次，進行寫的緩衝區大小為1020k，從 5001port丟封包出去，每隔200秒丟一次1M的封包