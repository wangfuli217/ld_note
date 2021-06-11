sfk automated regression test
=============================

this directory provides an automated regression test of sfk.
after every source change, or recompile on a new system,
it is recommended to enter the scripts directory and run

under windows:
   01-sfk-selftest-win.bat cmp

under any unix:
   03-sfk-selftest-ux.bat

with every new feature added, extend the test suite,
which is contained in

   11-sub-test-win.bat

and then say, under windows:
   01-sfk-selftest-win.bat upd

to record only the added result data.
after that, the unix side must be updated.
to do so, run

   02-conv-win-to-ux.bat

which translates the windows files into a unix compatible version.
after that, 03-sfk-selftest-ux.bat should ideally produce the same
results.

should you change/extend the testfiles, it can become necessary
to re-record all test results, as some results rely on the
directory listing. to do so, say

   01-sfk-selftest-win.bat rec

under windows (or adapt the unix script to use rec i/o cmp).
