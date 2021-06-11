#!/usr/bin/env python

"""A test with fixtures.

"""

import unittest


class FixturesTest(unittest.TestCase):
    def setUp(self):
        print 'In setUp()'
        self.fixture = range(1, 10)

    def tearDown(self):
        print 'In tearDown()'
        del self.fixture

    def test(self):
        print 'in test()'
        self.failUnlessEqual(self.fixture, range(1, 10))


if __name__ == '__main__':
    unittest.main()
