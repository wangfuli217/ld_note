#pragma once

#include <memory>

class MemLeakCheck
{
public:
  MemLeakCheck() = delete;
  MemLeakCheck(int val) : m_id(val) { }
  ~MemLeakCheck() = default;

  // Point to another instance
  std::shared_ptr<MemLeakCheck> pMemLeak = nullptr;
  int m_id;
};

void memLeakTest(void);
