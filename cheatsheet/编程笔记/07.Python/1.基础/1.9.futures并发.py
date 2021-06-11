使用futures的并发
    串行方式的图片下载
    # flags.py
    """Download flags of top 20 countries by population
    Sequential version
    Sample run::
        $ python3 flags.py
        BD BR CD CN DE EG ET FR ID IN IR JP MX NG PH PK RU TR US VN
        20 flags downloaded in 10.16s
    
    """
    # BEGIN FLAGS_PY
    import os
    import time
    import sys
    
    import requests  # <1>
    
    POP20_CC = ('CN IN US ID BR PK NG BD RU JP '
                'MX PH VN ET EG DE IR TR CD FR').split()  # <2>
    BASE_URL = 'http://flupy.org/data/flags'  # <3>
    DEST_DIR = 'downloads/'  # <4>
    
    def save_flag(img, filename):  # <5>
        path = os.path.join(DEST_DIR, filename)
        with open(path, 'wb') as fp:
            fp.write(img)
    
    def get_flag(cc):  # <6>
        url = '{}/{cc}/{cc}.gif'.format(BASE_URL, cc=cc.lower())
        resp = requests.get(url)
        return resp.content
    
    def show(text):  # <7>
        print(text, end=' ')
        sys.stdout.flush()
    
    def download_many(cc_list):  # <8>
        for cc in sorted(cc_list):  # <9>
            image = get_flag(cc)
            show(cc)
            save_flag(image, cc.lower() + '.gif')
    
        return len(cc_list)
    
    def main(download_many):  # <10>
        t0 = time.time()
        count = download_many(POP20_CC)
        elapsed = time.time() - t0
        msg = '\n{} flags downloaded in {:.2f}s'
        print(msg.format(count, elapsed))
    
    if __name__ == '__main__':
        main(download_many)  # <11>
    # END FLAGS_PY

使用线程池方式的下载

    """Download flags of top 20 countries by population
    ThreadPoolExecutor version
    Sample run::
        $ python3 flags_threadpool.py
        BD retrieved.
        EG retrieved.
        CN retrieved.
        ...
        PH retrieved.
        US retrieved.
        IR retrieved.
        20 flags downloaded in 0.93s
    """
    # BEGIN FLAGS_THREADPOOL
    from concurrent import futures
    from flags import save_flag, get_flag, show, main  # <1>
    MAX_WORKERS = 20  # <2>
    
    
    def download_one(cc):  # <3>
        image = get_flag(cc)
        show(cc)
        save_flag(image, cc.lower() + '.gif')
        return cc


    def download_many(cc_list):
        workers = min(MAX_WORKERS, len(cc_list))  # <4>
        with futures.ThreadPoolExecutor(workers) as executor:  # <5>
            res = executor.map(download_one, sorted(cc_list))  # <6>
        return len(list(res))  # <7>
    
    
    if __name__ == '__main__':
        main(download_many)  # <8>
    # END FLAGS_THREADPOOL

concurrent.futures.Future类方法:
    done(): 非阻塞. 返回bool值用于判断任务是否执行完成
    add_done_callback(): 回调函数, 用于异步处理结果
    result(): 阻塞, 获取执行结果. 有一个keyword参数timeout
    as_completed(): 返回执行完成的任务集合