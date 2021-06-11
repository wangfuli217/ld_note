#include "tcpsocket.h"
#include "common.h"

CTcpSocket::CTcpSocket()
{
    m_nSocket = INVALID_SOCKET;
    m_hThd = NULL;
    m_bRun = FALSE;

    memset(m_achBuf, 0, sizeof(m_achBuf));
    m_nBufLen = 0;
    m_wNeedRcvLen = 0;
}

CTcpSocket::~CTcpSocket()
{
    Destroy();
}

BOOL32 CTcpSocket::Create(const s8 *szSvrIp, u16 dwSvrPort, pFuncRcvDataCB pRcvDataCb, void *pContent)
{
    m_pRcvDataCB = pRcvDataCb;
    m_pUsrContent = pContent;

    m_nSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if(INVALID_SOCKET == m_nSocket)
    {
        perror("socket()");
        return FALSE;
    }
   
    struct sockaddr_in tServer;
    memset(&tServer, 0, sizeof(tServer));
    tServer.sin_family = AF_INET;
    tServer.sin_port = dwSvrPort;
    //tServer.sin_addr.s_addr = dwSvrIp;
    inet_pton(AF_INET, szSvrIp, &tServer.sin_addr.s_addr);

    s32 nRet = connect(m_nSocket, (struct sockaddr *)&tServer, sizeof(tServer));
    if(INVALID_SOCKET == nRet)
    {
        perror("connect()");
        printf("errno=%d\n", errno);
        Destroy();
        return FALSE;
    }

    SetSocketOption(m_nSocket, TRUE);

    m_bRun = TRUE;
    ThreadCreate(m_hThd, RcvThd, this);
    if(NULL == m_hThd)
    {
        m_bRun = FALSE;
        Destroy();
        return FALSE;
    }

    return TRUE;
}

void CTcpSocket::Destroy()
{
    m_bRun = FALSE;

    if(NULL != m_hThd)
    {
       WaitForThreadEnd(m_hThd);
       ThreadClose(m_hThd);
    }

    if(INVALID_SOCKET != m_nSocket)
    {
        SocketClose(m_nSocket);
        m_nSocket = INVALID_SOCKET;
    }

    m_wNeedRcvLen = 0;
}

BOOL32 CTcpSocket::SendMsg(const s8 *pCmd, u16 wLen)
{
    if(INVALID_SOCKET != m_nSocket)
    {
        return FALSE;
    }

    s32 nRet = send(m_nSocket, pCmd, wLen, 0);
    if(nRet != wLen)
    {
        printf("send msgs drops or failed!!! errno=%d\n", errno);
        return FALSE;
    }
    
    return TRUE;
}

BOOL32 CTcpSocket::SetSocketOption(SOCKET socket, BOOL32 bNonBlock)
{
    s32 nKeepAlive = 1;
    //如果连接超时，read会返回-1，且error为ETIMEDEOUT
    setsockopt(socket, SOL_SOCKET, SO_KEEPALIVE, (s8*)&nKeepAlive, sizeof nKeepAlive);

    s32 nRcvBuf = 64*1024;
    //防止处理慢缓存溢出，设置足够大缓存
    setsockopt(socket, SOL_SOCKET, SO_RCVBUF, (s8*)&nRcvBuf, sizeof nRcvBuf);

    //设置l_onoff为非0，l_linger为0，则套接口关闭时TCP夭折连接，TCP将丢弃保留在套接口发送缓冲区中
    //的任何数据并发送一个RST给对方，而不是通常的四分组终止序列，这避免了TIME_WAIT状态
    //对端操作 read/write 第一次errno为ECONNRESET,第二次errno为EPIPE、同时会产生SIGPIPE信号 
    struct linger ling = {1, 0};
    //SO_LINGER选项用来设置当调用closesocket时是否马上关闭socket
    setsockopt(socket, SOL_SOCKET, SO_LINGER, (s8*)&ling, sizeof ling);

    s32 nEnable = 1;
    //TCP_NODELAY选项禁止Nagle算法。Nagle算法通过将未确认的数据存入缓冲区直到
    //蓄足一个包一起发送的方法，来减少主机发送的零碎小数据包的数目
    setsockopt(socket, IPPROTO_TCP, TCP_NODELAY, (s8*)&nEnable, sizeof nEnable);
    
    //下面三个设置内部的TCP心跳包，不靠谱，后期改为应用层的心跳包
    s32 nSec = 10;
    setsockopt(socket, IPPROTO_TCP, TCP_KEEPIDLE, &nSec, sizeof nSec);
    nSec = 3;
    setsockopt(socket, IPPROTO_TCP, TCP_KEEPINTVL, &nSec, sizeof nSec);
    setsockopt(socket, IPPROTO_TCP, TCP_KEEPCNT, &nSec, sizeof nSec);

    if(bNonBlock)
    {
        u32 dwOn = 1;
        ioctl(socket, FIONBIO, &dwOn);
    }

    return TRUE;
}

FUNCALLBACK CTcpSocket::RcvThd(void *p)
{
    CTcpSocket *pTs = (CTcpSocket*)p;
    if(pTs)
    {
        pTs->RcvLoop();
    }

    
}

void CTcpSocket::RcvLoop()
{
    if(INVALID_SOCKET == m_nSocket)
    {
        return;
    }

    fd_set rSet;

    while(m_bRun)
    {
        FD_ZERO(&rSet);
        FD_SET(m_nSocket, &rSet);

        struct timeval tTime;
        tTime.tv_sec = 10;
        tTime.tv_usec = 500;

        s32 nRet = select(m_nSocket+1, &rSet, NULL, NULL, &tTime);
        if(-1 == nRet)
        {
            printf("select failed!!! errno=%d\n", errno);
            break;
        }
        else if(0 == nRet)
        {
            continue;
        }

        if(FD_ISSET(m_nSocket, &rSet))
        {
            s8 achRcvBuf[1025] = {0};
            s32 nRet = recv(m_nSocket, achRcvBuf, sizeof(achRcvBuf)-1, 0);
            printf("nRet=%d\n", nRet);
            if(nRet > 0)
            {
                RcvData((u8*)achRcvBuf, nRet);
            }
            else if(nRet == 0)
            {
                printf("read socket closed\n");
                s8 achTemp[20] = "lostcntnty";
                m_pRcvDataCB(achTemp, strlen(achTemp), m_pUsrContent);
                break;
            }
            else if(-1 == nRet)
            {
                perror("recv()");
                printf("recv errno=%d\n", errno);
                break;
            }
        }
    }

    FD_CLR(m_nSocket, &rSet);
    SocketClose(m_nSocket);
    m_nSocket = INVALID_SOCKET;
}

//Description::这里接受的是二进制文本，不是字符文本
void CTcpSocket::RcvData(const u8 *pBuf, s32 nLen)
{
    //若有拆包组包则这里作相应处理，否则直接调用回调
    m_pRcvDataCB((s8*)pBuf, nLen, m_pUsrContent);
}

/*
int main(int argc, char **argv)
{


    return 0;
}
*/
