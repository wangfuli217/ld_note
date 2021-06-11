#include <iostream>
#include "tcpsocket.h"
#include "common.h"
#include "utility.h"

using namespace std;

void RecvData(s8 *pData, u16 wLen, void *pContent)
{
    cout << "Data=" << pData << "wLen=" << wLen << endl;
}

int main(int argc, char **argv)
{
    s8 achServerIp[20] = {0};
    s32 nPort = 0;
    CTcpSocket *pCTcpSocket = new CTcpSocket();

    if(argc != 3 )
    {
        cout << "Usage:" << argv[0] <<  " IP PORT\n";
        return -1;
    }
    
   strcpy(achServerIp, argv[1]);
    cout << achServerIp << endl;
   // u32 dwIp = Ipctol(achServerIp);
   // u32 dwIp = Ipctol(argv[1]);
    //cout << dwIp << endl;
    nPort = atoi(argv[2]);
    cout << nPort << endl;

    BOOL32 bRet = pCTcpSocket->Create(achServerIp, nPort, RecvData, (void*)pCTcpSocket);
    if(!bRet)
    {
        cout << "connect server failed!!!\n";
        return -1;
    }

    s8 achTmp[30] = "my name is client";
    pCTcpSocket->SendMsg(achTmp, strlen(achTmp));
    delete pCTcpSocket;
    pCTcpSocket = NULL;

    return 0;
}
