#!/bin/bash
#set -x

BASEDIR=$EABASEDIR
if [ -z $BASEDIR ] || [ ! -d $BASEDIR ]; then
	echo "you need to set an existing basedir in \$EABASEDIR"
    exit -1
fi

uname | grep -v CYGWIN > /dev/null
ISWIN=$?

while :
do
	RUNID=`date +%s`
	echo $RUNID
	date

	# these files need to exist and denote R version and MonetDB HG branch to use
	RTAG=`cat $BASEDIR/r-tag`
	RUNTESTS=$BASEDIR/runtests

	if [ -z $RTAG ] ; then
		echo "need to define R version in $RTAG"
	    exit -1
	fi

	if [ ! -f $RUNTESTS ] ; then
		echo "need to define tests to run in $RUNTESTS"
	    exit -1
	fi

	RSRCDIR=$BASEDIR/r-source-$RTAG
	RINSTALLDIR=$BASEDIR/r-install-$RTAG
	RBIN=$RINSTALLDIR/bin/R
	if [ $ISWIN -eq 1 ]; then
		RBIN=$RBIN.exe
	fi
	# R packages should be reinstalled with new R version
	RLIBDIR=$BASEDIR/r-packages-$RTAG
	RTMPDIR=$BASEDIR/r-tmp
	RWDDIR=$BASEDIR/r-wd
	LOGDIR=$BASEDIR/logs/$RUNID

	rm $BASEDIR/logs/current
	ln -s $LOGDIR $BASEDIR/logs/current

	mkdir -p $RSRCDIR $RLIBDIR $RTMPDIR $RWDDIR $LOGDIR $RINSTALLDIR
	if [ ! -d $MINSTALLDIR ]; then
		echo "Unable to make install dirs."
		exit -1
	fi

	# build R
	# TODO: remove old R source/install/packages dirs
	# TODO: auto-install new R versions on Windows?
	echo $RTAG > $LOGDIR/r-version
	if [ ! -f $RBIN ] && [ $ISWIN -eq 0 ] ; then
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

	export R_LIBS=$RLIBDIR TMP=$RTMPDIR TEMP=$RTMPDIR PATH=$PATH:$RINSTALLDIR/bin
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
	sleep 1

	cp $RUNTESTS $LOGDIR
	RTESTS=`cat $RUNTESTS`

	for RSCRIPT in $RTESTS ; do
	  if [ -z $RSCRIPT ] || [ ! -f $BASEDIR/$RSCRIPT-setup.R ] ; then
	  	echo "Could not run $RSCRIPT"
	  	continue
	  fi
	  (echo "running $RSCRIPT"
	   	touch $LOGDIR/$RSCRIPT-started
		export RWD=$RWDDIR/$RSCRIPT-$RUNID
		mkdir -p $RWD
		set -o pipefail
		timeout -k 40h 30h $RBIN -f $BASEDIR/$RSCRIPT-setup.R 2>&1 | awk '{print strftime("%Y-%m-%d %H:%M:%S"), $0; fflush(); }' > $LOGDIR/$RSCRIPT.log 
		if [ $? != 0 ]; then
		 	echo "$RSCRIPT setup fail"
		 else
		 	touch $LOGDIR/$RSCRIPT-setup-success
			timeout -k 40h 30h $RBIN -f $BASEDIR/$RSCRIPT-test.R 2>&1 | awk '{print strftime("%Y-%m-%d %H:%M:%S"), $0; fflush(); }' >> $LOGDIR/$RSCRIPT.log 
			if [ $? != 0 ]; then
				echo "$RSCRIPT test fail"
			else
				touch $LOGDIR/$RSCRIPT-test-success
			fi
		fi
		touch $LOGDIR/$RSCRIPT-complete
		rm -rf $RWD
	  ) &
	  sleep 1
	  done
	wait
	touch $LOGDIR/complete
	sleep 10
done


