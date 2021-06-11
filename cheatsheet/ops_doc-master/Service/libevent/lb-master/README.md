
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                         _ _
                        | | |__
                        | | '_ \
                        | | |_) |
                        |_|_.__/

'lb' is a Libevent-based benchmarking tool for HTTP servers

               (C) Copyright 2009-2016
        Rocco Carbone <rocco /at/ tecsiel /dot/ it>

Released under the terms of 3-clause BSD License.
See included LICENSE file for details.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

This README file includes:

    * Hello world!
    * Motivation
    * Features
    * Licensing
    * Download
    * Requirements
    * Platforms
    * Installation
    * Documentation
    * Bugs
    * References

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

* Hello world!
  ============

  rocco@tar.tecsiel.it 6238> ./lb -n 15000 -c 40 http://tar.tecsiel.it:1234/ http://thor.tecsiel.it:1234/
  This is lb ver. 0.2.6 (compiled Jul 11 2016) running on tar.tecsiel.it
  linked to libevent-2.0.22-stable
  Copyright (c) 2009-2016 Rocco Carbone, Pisa, Italy - Released under 3-clause BSD license - http://lb.tecsiel.it

  lb: #2 HTTP servers - benchmark session started at Mon Jul 11 17:33:25 2016
  lb: #2 HTTP servers - benchmark session stopped at Mon Jul 11 17:33:52 2016

  Server Software:        wsl (minimal web server based on libevent-2.0.22-stable)
  Server Hostname:        tar
  Server Port:            1234

  Document Path:          /
  Document Length:        4096 bytes (  4.0 Kb)

  Concurrency Level:      40
  Time taken for tests:   2.346 secs
  Complete requests:      15000
  Failed requests:        0
  Write errors:           0
  Total transferred:      63990000 bytes ( 61.0 MB)
  HTML transferred:       61440000 bytes ( 58.0 MB)
  Requests per second:    6393.34 [#/sec] (mean)
  Time per request:       6.257 [ms] (mean)
  Time per request:       0.156 [ms] (mean, across all concurrent requests)
  Transfer rate:          26634.67 [Kbytes/sec] received
  Time per request:       0.13/0.15/16.69 min/avg/max [msec]

  Server Software:        wsl (minimal web server based on libevent-2.0.22-stable)
  Server Hostname:        thor
  Server Port:            1234

  Document Path:          /
  Document Length:        1024 bytes (  1.0 Kb)

  Concurrency Level:      40
  Time taken for tests:   26.536 secs
  Complete requests:      15000
  Failed requests:        0
  Write errors:           0
  Total transferred:      17910000 bytes ( 17.0 MB)
  HTML transferred:       15360000 bytes ( 14.0 MB)
  Requests per second:    565.26 [#/sec] (mean)
  Time per request:       70.764 [ms] (mean)
  Time per request:       1.769 [ms] (mean, across all concurrent requests)
  Transfer rate:          659.09 [Kbytes/sec] received
  Time per request:       1.66/1.76/11.20 min/avg/max [msec]



* Motivation
  ==========

  While reading Niels Provos's blog at
  http://www.provos.org/index.php?/archives/61-Small-Libevent-2.0-Performance-Test.html
  I was really intrigued about the test scenarios he described there and the performance
  values he reported.

  I would have like to start the same tests here on my network to evaluate the performances
  of my own Libevent-based web server applications.  And I would like to match my own implementation
  against those described in the blog in order to learn from Libevent authors about their best coding
  practices to improve application performances.  Nothing is better than learning from the gurus.

  But unfortunately the sample programs used in the test scenarios were not available neither
  for downloading nor for reading.

  While thinking all such kind of these things, I am also convinced about another big question that arises
  reading such blog.

  Why an external benchmark tool (the Apache benchmark tool 'ab' in that case) had been used
  for these benchmarks?  Why Libevent does not have such kind of tools in its source distribution?

  So for a moment I forgot the 'server side' implementations and started to think to the 'client side' ones.

  Could 'ab' should be easily re-implemented using the 'Libevent'?  And how much fast it will
  be with respect to the so popular 'ab' counterparty?

  So I decided to write my own Libevent-based benchmark tool and called it 'lb' that is an acronym
  for "libevent-based benchmark" tool.


  My goals are to extend the so popular 'ab' in order to:

   o allow to execute benchmarks with several different HTTP servers at the same time

   o allow to read the list of HTTP servers from a file

   o print output in a way as close as possible 'ab' already does in order to guarantee backward
     compatibility for users/scripts using the tool

  So the 'lb' tool aims to provide a safe and quick replacement for the Apache 'ab' tool.
  Since its first release it comes with the ability to benchmark several HTTP servers at the
  same time, being its number teorically limited only by operating system limits.


* Features
  ========

  o Provides a tool for HTTP servers to:

    * benchmark several servers at the same time and report per-server information

    * read the list of HTTP servers to benchmark from a file

    * be as backward compatible as possible with the output produced by 'ab'



* Licensing
  =========

  'lb', the Libevent-based benchmark tool, is released under the terms of
  3-clause BSD License; see included LICENSE file for more information.



* Download
  ========

  You can download the source code and documentation at:

  https://github.com/rcarbone/lb


* Requirements
  ============

  'lb' is an application written using the Libevent library:

  Copyright (c) 2000-2007 Niels Provos <provos@citi.umich.edu>
  Copyright (c) 2007-2012 Niels Provos and Nick Mathewson

  For the purpose to start learning more about the features available
  with new series of Libevent-2.x I decided to developed 'lb' from
  the Libevent git code, which at the time of writing can be found at:

  git clone https://github.com/libevent/libevent

  You need this version because I have used latest available API, in particular
  the evtimer_assign() and evhttp_connection_base_new() functions available
  only with the Libevent-2.x series are used.


* Platforms
  =========

  o i686 running Linux 2.6.26
  o sparc sun4u running Solaris 10

  Just to be clear, my development environment is on an Intel-based box
  running a testing Debian GNU/Linux distribution, but I think the effort
  to port 'lb' on different un*x where the Libevent is already available
  should be only a compilation issue


* Installation
  ============

  1> mkdir somedir
  2> cd somedir
  3> git clone https://github.com/libevent/libevent
  5> cd libevent
  6> ./configure && make
  7> git clone https://github.com/rcarbone/lb
  7> cd lb
  8> ./configure --with-libevent=..
  9> make


* Documentation
  =============

Most documentation is in the README.  But I am sure the documentation is so
far to be terminated because a lot of functionalities need to be documented.


* Bugs
  ====

There are no mailing lists for 'lb' at this time.

Bugs can be reported to the lb's author Rocco Carbone via email at:
<rocco /at/ tecsiel /dot/ it>



* References
  ==========

  http://www.monkey.org/~provos/libevent
  http://httpd.apache.org
# lb
