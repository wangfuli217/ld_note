<?php
$m = new Memcached();
$m->addServer('localhost', 11211);

do {
    /* 获取ip列表以及它的标记 */
    $ips = $m->get('ip_block', null, $cas);
    /* 如果列表不存在， 创建并进行一个原子添加（如果其他客户端已经添加， 这里就返回false）*/
    if ($m->getResultCode() == Memcached::RES_NOTFOUND) {
        $ips = array($_SERVER['REMOTE_ADDR']);
        $m->add('ip_block', $ips);
    /* 其他情况下，添加ip到列表中， 并以cas方式去存储， 这样当其他客户端修改过， 则返回false */
    } else { 
        $ips[] = $_SERVER['REMOTE_ADDR'];
        $m->cas($cas, 'ip_block', $ips);
    }   
} while ($m->getResultCode() != Memcached::RES_SUCCESS);

?>
