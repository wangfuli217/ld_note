/** 
 * @brief: Ò»¸ö°üÀ¨¶¨Ê±Æ÷½áµãµÄË«ÏòÁ´±í
 *         Ò»¸öÂÖ×Ó£¬²å²Û´óÐ¡Îªm_size,±íÊ¾Ã¿Ò»¸ö²å²Û¶¼ÓÐÒ»¸öË«ÏòÁ´±í¡£
 *
 * @Author:Expter
 * @date:  03/01/2010
 */

#ifndef __LINK_LIST_H_
#define __LINK_LIST_H_

#include "TypeDef.h"
#include "tools.h"


///			  
/// Ò»¸öÂÖ×Ó,Ò»¸öÑ­»·¶ÓÁÐ
/// 
/// 
class CLinkList
{

public:

	CLinkList(void);

	CLinkList( int size );
	
	~CLinkList(void);
	
	/// 
	/// ³õÊ¼»¯
	/// 
	void  init();

	/// 
	/// ÈÃÖ¸ÕëÖ¸Ïò×Ô¼º
	/// 
	void  init_list_self( int  index);

	/// 
	/// °Ñnews²åÈëµ½prev,nextÖ®¼ä
	/// 
	void  insert_listnode(ListNode *news , ListNode* prev , ListNode* next);

	/// 
	/// ²åÈëµ½Á´±íÍ·
	/// 
	void  insert_head( ListNode* news , ListNode* head );

	///
	/// ²åÈëµ½Á´±íÎ²
	/// 
	void  insert_tail( ListNode* news , ListNode* head );

	/// 
	/// É¾³ý½Úµã
	/// 
	void  list_del( ListNode* list);

	/// 
	/// µÃµ½¸ÄÂÖ×Ó×ªµ½µÚ¼¸¸ö²å²Û
	///
	int        GetIndex( ) const { return m_index ;}

	///
	/// ¸üÐÂÂÖ×ÓµÄ²å²Û
	///
	void       SetIndex(int idx) { m_index = idx  ;}

	/// 
	/// µÃµ½ÂÖ×Ó²å²ÛµÄÖ¸Õë 
	///
	ListNode*  GetNode(int index) const;

private:
	///
	/// ÂÖ×ÓµÄ²å²ÛÊý×é
	/// 
	ListNode *m_List;  
	
	///
	/// ÂÖ×Óµ±Ç°×ªµ½µÄË÷Òý
	/// 
	int		  m_index; 

	///
	/// ÂÖ×Ó´óÐ¡
	///
	int       m_Size;

};

#endif
