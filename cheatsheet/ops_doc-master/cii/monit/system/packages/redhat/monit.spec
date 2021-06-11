Name: monit
Summary: Process monitor and restart utility
Version: 5.25.2
Release: 1
URL: http://mmonit.com/monit/
Source: http://mmonit.com/monit/dist/%{name}-%{version}.tar.gz
Group: Utilities/Console
BuildRoot: %{_tmppath}/%{name}-buildroot
License: AGPL

%{!?_with_ssl: %{!?_without_ssl: %define _with_ssl --with-ssl}}
%{?_with_ssl:BuildRequires: openssl-devel}

%{!?_with_pam: %{!?_without_pam: %define _with_pam --with-pam}}
%{?_with_pam:BuildRequires: pam-devel}

%description
Monit is a utility for managing and monitoring processes,
files, directories and filesystems on a Unix system. Monit conducts
automatic maintenance and repair and can execute meaningful causal
actions in error situations.

%prep
%setup

%build
%configure \
        %{?_with_ssl} \
        %{?_without_ssl} \
        %{?_with_pam} \
        %{?_without_pam}
make %{?_smp_mflags}

%install
if [ -d %{buildroot} ] ; then
  rm -rf %{buildroot}
fi

mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_mandir}/man1
mkdir -p %{buildroot}/etc/init.d
install -m 755 monit %{buildroot}%{_bindir}/monit
install -m 644 monit.1 %{buildroot}%{_mandir}/man1/monit.1
install -m 600 monitrc %{buildroot}/etc/monitrc
install -m 755 system/startup/rc.monit %{buildroot}/etc/init.d/%{name}

%post
/sbin/chkconfig --add %{name}

%preun
if [ $1 = 0 ]; then
   /etc/init.d/%{name} stop >/dev/null 2>&1
   /sbin/chkconfig --del %{name}
fi

%clean
if [ -d %{buildroot} ] ; then
  rm -rf %{buildroot}
fi

%files
%defattr(-,root,root)
%doc COPYING README CHANGES
%config(noreplace) /etc/monitrc
%config /etc/init.d/%{name}
%{_bindir}/%{name}
%{_mandir}/man1/%{name}.1.gz

%changelog
* Fri Dec 15 2017 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.25.2

* Tue Nov 14 2017 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.25.1

* Thu Sep 25 2017 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.25.0

* Thu Jun 08 2017 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.24.0

* Wed Apr 19 2017 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.23.0

* Tue Mar 07 2017 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.22.0

* Sat Oct 22 2016 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.21.0

* Tue Sep 06 2016 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.20.0

* Wed Jul 27 2016 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.19.0

* Fri Apr 01 2016 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.18

* Fri Mar 04 2016 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.17.1

* Thu Feb 04 2016 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.17

* Thu Nov 05 2015 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.16

* Mon Oct 12 2015 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.15
- Added rpmbuild options for building without PAM (--without pam)
- Added rpmbuild options for building without SSL (--without ssl)
- Dropped build dependency on flex and bison

* Mon Jun 08 2015 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.14

* Mon Mar 23 2015 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.13

* Tue Mar 10 2015 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.12.2

* Fri Mar 6 2015 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.12.1

* Tue Feb 24 2015 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.12

* Wed Dec 17 2014 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.11

* Mon Oct 06 2014 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.10

* Sat Aug 23 2014 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.9

* Fri Aug 22 2014 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.8.2

* Sun Mar 30 2014 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.8.1

* Sat Mar 08 2014 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.8

* Thu Feb 20 2014 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.7

* Thu Jun 06 2013 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.6

* Tue Jun 04 2013 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.5.1

* Wed May 09 2012 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.5

* Sun May 06 2012 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.4

* Sat Oct 22 2011 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.3.1

* Thu Aug 25 2011 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.3

* Mon Mar 28 2011 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.2.5

* Wed Feb 23 2011 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.2.4

* Thu Sep 16 2010 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.2

* Thu Feb 18 2010 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.1.1

* Sat Jan 09 2010 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.1

* Thu May 28 2009 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.0.3

* Thu May 7 2009 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.0.2

* Wed Apr 22 2009 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.0.1

* Sun Apr 13 2008 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-5.0

* Tue Nov 06 2007 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-4.10.1

* Mon Nov 05 2007 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-4.10

* Mon Feb 19 2007 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-4.9

* Sun Mar 05 2006 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-4.7

* Mon Sep 19 2005 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-4.6

* Tue Oct 19 2004 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-4.4

* Tue Nov 04 2003 Martin Pala <martinp@tildeslash.com>
- Fixed the bad path to monit binary in startup script. Thanks to Ben Ciceron
  for report of the problem.

* Mon Oct 27 2003 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-4.1

* Tue Sep 23 2003 Martin Pala <martinp@tildeslash.com>
- change the description

* Fri Mar 07 2003 Martin Pala <martinp@tildeslash.com>
- Upgraded to monit-4.0
- Updated documentation list
- Changed use of monit.conf file to default monitrc ( => monit could find it )
- Use monitrc and rc.monit from default monit distribution

* Wed Jul 10 2002 Rory Toma <rory@digeo.com>
- Upgraded to monit-2.4.3

* Mon Feb 05 2001 Clinton Work <work@scripty.com>
- Upgraded to monit 1.2
- Use chkconfig to add monit to the rc.d startup scripts
- Use the example monitrc instead of my custom monit.conf
- Fixed the monit homepage URL

* Thu Feb 01 2001 Clinton Work <work@scripty.com>
- Create the inital spec file
- Created a sample config file and a rc startup script

