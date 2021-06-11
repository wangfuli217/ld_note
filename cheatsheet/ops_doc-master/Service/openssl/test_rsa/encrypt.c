/*
* =====================================================================================
*
*       Filename:  test_rsa.c
*
*    Description:  
*
*        Version:  1.0
*        Created:  09/01/2013 10:46:26 AM
*       Revision:  none
*       Compiler:  gcc
*
*         Author:  sunke (), sunke@sunniwell.net
*        Company:  Sunniwell
*
* =====================================================================================
*/
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <openssl/pem.h>
#include <openssl/rsa.h>

int main()
{
    // 原始明文
    char plain[256]="hello123";
    // 用来存放密文
    char encrypted[1024];
    // 用来存放解密后的明文
    char decrypted[1024];

    // 公钥和私钥文件
    const char* pub_key="public.pem";
    const char* priv_key="private.pem";

    // -------------------------------------------------------
    // 利用公钥加密明文的过程
    // -------------------------------------------------------

    // 打开公钥文件
    FILE* pub_fp=fopen(pub_key,"r");
    if(pub_fp==NULL){
        printf("failed to open pub_key file %s!\n", pub_key);
        return -1;
    }

    // 从文件中读取公钥
    RSA* rsa1=PEM_read_RSA_PUBKEY(pub_fp, NULL, NULL, NULL);
    if(rsa1==NULL){
        printf("unable to read public key!\n");
        return -1; 
    }
    
    if(strlen(plain)>=RSA_size(rsa1)-41){
        printf("failed to encrypt\n");
        return -1;
    }
    fclose(pub_fp);

    // 用公钥加密
    int len=RSA_public_encrypt(strlen(plain), plain, encrypted, rsa1, RSA_PKCS1_PADDING);
    if(len==-1 ){
        printf("failed to encrypt\n");
        return -1;
    }
    
    // 输出加密后的密文
    FILE* fp=fopen("out.txt","w");
    if(fp){
        fwrite(encrypted,len,1,fp);
        fclose(fp);
    }
    // -------------------------------------------------------
    // 利用私钥解密密文的过程
    // -------------------------------------------------------
    // 打开私钥文件
    FILE* priv_fp=fopen(priv_key,"r");
    if(priv_fp==NULL){
        printf("failed to open priv_key file %s!\n", priv_key);
        return -1;
    }
   

    // 从文件中读取私钥
    RSA *rsa2 = PEM_read_RSAPrivateKey(priv_fp, NULL, NULL, NULL);
    if(rsa2==NULL){
        printf("unable to read private key!\n");
        return -1; 
    }
    
    // 用私钥解密
    len=RSA_private_decrypt(len, encrypted, decrypted, rsa2, RSA_PKCS1_PADDING);
    if(len==-1){
        printf("failed to decrypt!\n");
        return -1;
    }
    fclose(priv_fp);


    // 输出解密后的明文
    decrypted[len]=0;
    printf("%s\n",decrypted);


}
