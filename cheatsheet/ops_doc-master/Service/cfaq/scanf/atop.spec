Name:           atop
Version:        XVERSX
Release:        XRELX
Source0:        %{name}-%{version}.tar.gz
URL:            https://www.atoptool.nl
Packager:       Gerlof Langeveld <gerlof.langeveld@atoptool.nl>
Summary:        Advanced System and Process Monitor
License:        GPL
Group: 	        System Environment
Requires:       zlib, ncurses
BuildRequires:  zlib-devel, ncurses-devel
BuildRoot:      /var/tmp/rpm-buildroot-atop

%description
The program atop is an interactive monitor to view the load on
a Linux-system. It shows the occupation of the most critical
hardware-resources (from a performance point of view) on system-level,
i.e. cpu, memory, disk and network. It also shows which processess
(and threads) are responsible for the indicated load (again cpu-,
memory-, disk- and network-load on process-level).
The program atop can also be used to log system- and process-level
information in raw format for long-term analysis.

The program atopsar can be used to view system-level statistics
as reports.

%prep
%setup -q

%build
make

%install
rm    -rf 			  $RPM_BUILD_ROOT

# generic build
install -Dp -m 04711 atop 	  $RPM_BUILD_ROOT/usr/bin/atop
ln -s atop                        $RPM_BUILD_ROOT/usr/bin/atopsar
install -Dp -m 0711 atopconvert	  $RPM_BUILD_ROOT/usr/bin/atopconvert
install -Dp -m 0700 atopacctd 	  $RPM_BUILD_ROOT/usr/sbin/atopacctd

install -Dp -m 0711 atop.daily	  $RPM_BUILD_ROOT/usr/share/atop/atop.daily

install -Dp -m 0644 man/atop.1 	  $RPM_BUILD_ROOT/usr/share/man/man1/atop.1
install -Dp -m 0644 man/atopsar.1 $RPM_BUILD_ROOT/usr/share/man/man1/atopsar.1
install -Dp -m 0644 man/atopconvert.1 $RPM_BUILD_ROOT/usr/share/man/man1/atopconvert.1
install -Dp -m 0644 man/atoprc.5  $RPM_BUILD_ROOT/usr/share/man/man5/atoprc.5
install -Dp -m 0644 man/atopacctd.8  $RPM_BUILD_ROOT/usr/share/man/man8/atopacctd.8

install -Dp -m 0644 psaccs_atop	  $RPM_BUILD_ROOT/etc/logrotate.d/psaccs_atop
install -Dp -m 0644 psaccu_atop	  $RPM_BUILD_ROOT/etc/logrotate.d/psaccu_atop

install -d  -m 0755 		  $RPM_BUILD_ROOT/var/log/atop

# systemd-specific build
install -Dp -m 0644 atop.service  $RPM_BUILD_ROOT/usr/lib/systemd/system/atop.service
install -Dp -m 0644 atopacct.service $RPM_BUILD_ROOT/usr/lib/systemd/system/atopacct.service
install -Dp -m 0644 atop.cronsystemd $RPM_BUILD_ROOT/etc/cron.d/atop
install -Dp -m 0711 atop-pm.sh	  $RPM_BUILD_ROOT/usr/lib/systemd/system-sleep/atop-pm.sh

%clean
rm -rf $RPM_BUILD_ROOT

%post
/bin/systemctl enable  atopacct
/bin/systemctl start   atopacct
/bin/systemctl enable  atop
/bin/systemctl start   atop

# save today's logfile (format might be incompatible)
mv /var/log/atop/atop_`date +%Y%m%d` /var/log/atop/atop_`date +%Y%m%d`.save \
					2> /dev/null || :

# create dummy files to be rotated
touch /var/log/atop/dummy_before /var/log/atop/dummy_after

# activate daily logging for today
sleep 2
/usr/share/atop/atop.daily&

%preun
if [ $1 -eq 0 ]
then
	/bin/systemctl stop    atop
	/bin/systemctl disable atop
	/bin/systemctl stop    atopacct
	/bin/systemctl disable atopacct
fi

# atop-XVERSX and atopsar-XVERSX will remain for old logfiles
cp -f  /usr/bin/atop            /usr/bin/atop-XVERSX
ln -sf /usr/bin/atop-XVERSX     /usr/bin/atopsar-XVERSX

%files
%defattr(-,root,root)
%doc README COPYING AUTHOR ChangeLog
/usr/bin/atop
/usr/bin/atopconvert
/usr/bin/atopsar
/usr/sbin/atopacctd
/usr/share/man/man1/atop.1*
/usr/share/man/man1/atopsar.1*
/usr/share/man/man1/atopconvert.1*
/usr/share/man/man5/atoprc.5*
/usr/share/man/man8/atopacctd.8*
/usr/lib/systemd/system/atop.service
/usr/lib/systemd/system/atopacct.service
/usr/lib/systemd/system-sleep/atop-pm.sh
/usr/share/atop/atop.daily
/etc/cron.d/atop
/etc/logrotate.d/psaccs_atop
/etc/logrotate.d/psaccu_atop
%dir /var/log/atop/
