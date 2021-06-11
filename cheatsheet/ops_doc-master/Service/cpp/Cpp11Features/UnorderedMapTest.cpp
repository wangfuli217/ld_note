
#include "stdafx.h"
#include <iostream>
#include <cstdio>
#include <set>
#include <unordered_set>
#include <unordered_map>
#include <string>
using namespace std;

struct Node {
  Node() {}
  Node(int _x, int _y) :x(_x), y(_y) {}
  int x, y;
  bool operator == (const Node &t) const {
    return  x == t.x && y == t.y;
  }
};
struct NodeHash {
  std::size_t operator () (const Node &t) const {
    return  t.x * 100 + t.y;
  }
};
//unordered_set <Node, NodeHash> h_set;
//unordered_map <Node, string, NodeHash> h_map;
unordered_map<Node, string, NodeHash> h_map;

void dispUnorderedMap(unordered_map<Node, string, NodeHash>& m, char* pre)
{
  cout << "============ " << pre << " ============" << endl;
  cout << "bucket_count：" << m.bucket_count() << endl;
  cout << "max_bucket_count：" << m.max_bucket_count() << endl;
  cout << "bucket_size：" << m.bucket_size(0) << endl;
  cout << "load_factor：" << m.load_factor() << endl;
  cout << "max_load_factor：" << m.max_load_factor() << endl;
  cout << "content：" << endl;

  unordered_map<Node, string, NodeHash>::iterator it;
  for (it = m.begin(); it != m.end(); it++)
  {
    cout << "bucket[" << m.bucket(it->first) << "]: ";
    std::cout << "Node(" << it->first.x << "," << it->first.y << "):(" << it->second << ") " << endl;
  }
  cout << "============================" << endl << endl;
}

int unorderedMapTest(void)
{

  dispUnorderedMap(h_map, "Before adding anything");

  h_map[Node(1, 2)] = "Node(\"1,2\")";
  dispUnorderedMap(h_map, "Adding (1,2)");

  h_map[Node(1, 3)] = "Node(\"1,3\")";
  dispUnorderedMap(h_map, "Adding (1,3)");

  h_map[Node(2, 2)] = "Node(\"2,2\")";
  dispUnorderedMap(h_map, "Adding (2,2)");

  h_map[Node(123, 2)] = "Node(\"123,2\")";
  dispUnorderedMap(h_map, "Adding (123,2)");

  h_map.insert(unordered_map <Node, string, NodeHash>::value_type(Node(123, 456), "Great!"));
  dispUnorderedMap(h_map, "Adding (123,456)");

  cout << h_map[Node(2, 2)] << endl;
  //cout << (h_map[Node(123456, 0)] == "") << endl; //[]在主键不存在时自动创建
  cout << (h_map.find(Node(123, 456)) == h_map.end()) << endl;
  cout << (h_map.find(Node(123456, 0)) == h_map.end()) << endl;

  h_map.erase(h_map.find(Node(123, 456)));
  dispUnorderedMap(h_map, "Erase (123,456)");

  h_map.clear();
  dispUnorderedMap(h_map, "Clear");

  return 0;
}
