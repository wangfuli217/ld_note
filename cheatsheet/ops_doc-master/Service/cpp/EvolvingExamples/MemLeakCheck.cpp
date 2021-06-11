#include <iostream>
#include <vector>
#include <string>
#include "MemLeakCheck.h"

using std::shared_ptr;
using std::weak_ptr;
using std::vector;
using std::make_shared;
using std::cout;
using std::endl;
using std::cin;
using std::string;

void toLeakOrNotToLeak(void)
{
  // Weak pointer vector associated with shared pointers
  vector<weak_ptr<MemLeakCheck>> weakPointers = {};

  // This code block is used to control the life cycle of shared pointers.
  {
    // Shared pointer vector
    vector<shared_ptr<MemLeakCheck>> sharedPointers = {};

    for (int i = 0; i != 5; i++)
    {
      // Create two shared pointers
      shared_ptr<MemLeakCheck> pShrAlice = make_shared<MemLeakCheck>(i*2);
      shared_ptr<MemLeakCheck> pShrBob = make_shared<MemLeakCheck>(i*2+1);

      // Make a circle between two shared pointers
      // Enable the following two statements to leak.
      //pShrAlice->pMemLeak = pShrBob;
      //pShrBob->pMemLeak = pShrAlice;

      // Add them into the vector
      sharedPointers.push_back(pShrAlice);
      sharedPointers.push_back(pShrBob);
      // Create two weak pointers and add them into the vector
      weakPointers.push_back(weak_ptr<MemLeakCheck>(pShrAlice));
      weakPointers.push_back(weak_ptr<MemLeakCheck>(pShrBob));
    }

    // Weak pointers should not expire as the shared pointer vector is alive
    for (weak_ptr<MemLeakCheck> pWeak : weakPointers)
    {
      if (pWeak.expired())
      {
        cout << "[Fatal Error] expired too early!" << endl;
      }
    }
  }

  // Weak pointers should expire as the shared pointer vector is gone.
  for (weak_ptr<MemLeakCheck> pWeak : weakPointers)
  {
    if (!pWeak.expired())
    {
      shared_ptr<MemLeakCheck> sptrFromWptr = pWeak.lock();
      cout << "[Fatal Error] " << sptrFromWptr->m_id
        << " Should be expired!" << endl;
    }
  }

}

void memLeakTest(void)
{
  toLeakOrNotToLeak();
}
