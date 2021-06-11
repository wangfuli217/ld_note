#ifndef TCP_SOCKET_H
#define TCP_SOCKET_H

#include "fxltype.h"
#include "fxlthread.h"

//#ifdef _LINUX_
typedef int SOCKET;
//#endif

#define INVALID_SOCKET (-1)
#define MAX_BUF_LEN 1024

typedef void (*pFuncRcvDataCB)(s8 *pData, u16 wLen, void *pContent);

struct TIOBuffer
{
    
};

class CTcpSocket
{
public:
    CTcpSocket();
    virtual ~CTcpSocket();

    BOOL32 Create(const s8 *szSvrIp, u16 wSvrPort, pFuncRcvDataCB pRcvDataCb, void *pContent);

    void Destroy();

    BOOL32 SendMsg(const s8 *pCmd, u16 wLen);

protected:
    BOOL32 SetSocketOption(SOCKET socket, BOOL32 bNonBlock);

    //recv thread
    static FUNCALLBACK RcvThd(void *p);
    void RcvLoop();
    void RcvData(const u8 *pBuf, s32 nLen);

private:
    SOCKET m_nSocket;

    pFuncRcvDataCB m_pRcvDataCB;
    void *m_pUsrContent;
    
    THDHANDLE m_hThd;
    BOOL32 m_bRun;

    s8 m_achBuf[MAX_BUF_LEN+1];
    s32 m_nBufLen;

    u16 m_wNeedRcvLen;
    TIOBuffer m_tIoBuf;
};

#endif //TCP_SOCKET_H
