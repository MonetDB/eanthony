#!/bin/bash
#set -x
BASEDIR=C:/cygwin64/home/hannes/eanthony

uname | grep -v CYGWIN > /dev/null
ISWIN=$?

while :
do
	RUNID=`date +%s`
	echo $RUNID
	date

	# these files need to exist and denote R version and MonetDB HG branch to use
	RTAG=`cat $BASEDIR/r-tag`
	MBRANCH=`cat $BASEDIR/monetdb-branch`
	RUNTESTS=$BASEDIR/runtests

	if [ -z $RTAG ] || [ -z $MBRANCH ] ; then
		echo "need to define R Tag and MonetDB branch names"
	    exit -1
	fi

	if [ ! -f $RUNTESTS ] ; then
		echo "need to define tests to run in  $RUNTESTS"
	    exit -1
	fi

	# TODO: what to do if this fails?! sleep and retry?
	# find latest testweb build for specified branch
	HTML=`curl -s "http://monetdb.cwi.nl/testweb/web/status.php?branch=$MBRANCH"`
	FURL=`echo -n "$HTML"| grep -m 1 -o "../web/\S*/" | sed 's|..|http://monetdb.cwi.nl/testweb|'`
	MREV=`echo $FURL | grep -o "/[0-f:]*/$" | sed "s|/||g"`
	MREVF=`echo $MREV | sed "s/:/_/"`

	MINSTALLDIR=$BASEDIR/monetdb-install-$MREVF
	MBIN=$MINSTALLDIR/bin/mserver5
	MSRCDIR=$BASEDIR/monetdb-source-$MREVF	

	RSRCDIR=$BASEDIR/r-source-$RTAG
	RINSTALLDIR=$BASEDIR/r-install-$RTAG
	RBIN=$RINSTALLDIR/bin/R
	if [ $ISWIN ]; then
		RBIN=$RBIN.exe
		MBIN=$MBIN.exe	
	fi
	# R packages should be reinstalled with new R version
	RLIBDIR=$BASEDIR/r-packages-$RTAG
	RTMPDIR=$BASEDIR/r-tmp
	RWDDIR=$BASEDIR/r-wd
	LOGDIR=$BASEDIR/logs/$RUNID

	rm $BASEDIR/logs/current
	ln -s $LOGDIR $BASEDIR/logs/current

	mkdir -p $RSRCDIR $RLIBDIR $RTMPDIR $RWDDIR $LOGDIR $RINSTALLDIR $MSRCDIR $MINSTALLDIR
	if [ ! -d $MINSTALLDIR ]; then
		echo "Unable to make install dirs."
		exit -1
	fi

	# build R
	# TODO: remove old R source/install/packages dirs
	# TODO: auto-install new R versions on Windows?
	echo $RTAG > $LOGDIR/r-version
	if [ ! -f $RBIN ] && [ ! $ISWIN ] ; then
		RTBURL="https://cran.r-project.org/src/base/R-3/R-$RTAG.tar.gz"
		curl -s $RTBURL | tar xz -C $RSRCDIR --strip-components=1
		cd $RSRCDIR
		./configure --prefix=$RINSTALLDIR --with-x=no --without-recommended-packages > $LOGDIR/r-configure.log 2>&1
		make > $LOGDIR/r-make.log 2>&1
		# make R install without latex
		touch $RSRCDIR/doc/NEWS.pdf
		touch $RSRCDIR/doc/RESOURCES
		touch $RSRCDIR/doc/FAQ

		make install >> $LOGDIR/r-make.log 2>&1
		cd ..
	fi
	if [ ! -f $RBIN ] ; then
		echo "Still no R. FML."
		exit -1
	fi

	# build/install MonetDB
	# TODO: remove old monetdb source/install dirs
	echo $MREV > $LOGDIR/monetdb-revision
	echo $MBRANCH > $LOGDIR/monetdb-branch
	if [ ! -f $MBIN ] ; then
		HTML2=`curl -s $FURL`
		if [ $ISWIN ]; then
			MSI=$BASEDIR/monetdbinstaller.msi
			rm -f $MSI
			MTBURL=$FURL`echo $HTML2 | grep -o  "MonetDB5-SQL-Installer-x86_64-[^-]*\.msi" | head -n 1`
			curl -s $MTBURL -o $MSI
			cmd /C "msiexec.exe /a $MSI TARGETDIR=$MINSTALLDIR /qn"
		else
			MTBURL=$FURL`echo $HTML2 | grep -o  "MonetDB-[^>]*\.tar\.bz2" | head -n 1`
			curl -s $MTBURL | tar xj -C $MSRCDIR --strip-components=1
			cd $MSRCDIR
			./configure --prefix=$MINSTALLDIR \
				--disable-fits --disable-geom --disable-rintegration --disable-gsl --disable-netcdf \
				--disable-jdbc --disable-merocontrol --disable-odbc --disable-microhttpd \
				--without-perl --without-python2 --without-python3 --without-rubygem --without-unixodbc \
				--without-samtools --without-sphinxclient --without-geos --without-samtools  \
				> $LOGDIR/monetdb-configure.log 2>&1

			make -j clean install > $LOGDIR/monetdb-make.log 2>&1
			cd ..
		fi
	fi
	if [ ! -f $MBIN ] ; then
		echo "Still no MonetDB. bleh."
		exit -1
	fi

	export R_LIBS=$RLIBDIR TMP=$RTMPDIR TEMP=$RTMPDIR PATH=$MINSTALLDIR/bin:$PATH MONETDBINSTALLDIR=$MINSTALLDIR
	# install/update various packages
	$RBIN -f $BASEDIR/packages.R > $LOGDIR/packages.log 2>&1
	# record versions of installed packages
	$RBIN --slave -e "write.table(installed.packages(lib.loc='$RLIBDIR')[, c('Package','Version')], '$LOGDIR/package-versions', sep='\t', quote=F, row.names=F, col.names=F)"

	if [ $? != 0 ]; then
		echo "Package installation failure"
		continue
	else
		touch $LOGDIR/packages-success
	fi
	# dangerous, but are there alternatives?
	if [ $ISWIN ] ; then
		taskkill /F /IM mserver5.exe /T
	else
		killall -9 mserver5
	fi
	sleep 60

	cp $RUNTESTS $LOGDIR

	# TODO: git update?
	while read SCRIPT; do
	  if [ -z $SCRIPT ] || [ ! -f $BASEDIR/$SCRIPT-setup.R ] ; then
	  	echo "Could not run $SCRIPT"
	  	continue
	  fi
	  (echo "running $SCRIPT"
	  	touch $LOGDIR/$SCRIPT-started
		export RWD=$RWDDIR/$SCRIPT-$RUNID
		mkdir -p $RWD
		$RBIN -f $BASEDIR/$SCRIPT-setup.R > $LOGDIR/$SCRIPT.log 2>&1
		if [ $? != 0 ]; then
			echo "$SCRIPT setup fail"
		else
			touch $LOGDIR/$SCRIPT-setup-success
			$RBIN -f $BASEDIR/$SCRIPT-test.R >> $LOGDIR/$SCRIPT.log 2>&1
			if [ $? != 0 ]; then
				echo "$SCRIPT test fail"
			else
				touch $LOGDIR/$SCRIPT-test-success
			fi
		fi
		touch $LOGDIR/$SCRIPT-complete
		rm -rf $RWD
	) &
	sleep 1
	done < $RUNTESTS
	wait
	touch $LOGDIR/complete
	sleep 10
done


