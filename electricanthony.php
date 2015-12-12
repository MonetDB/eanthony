<?php
date_default_timezone_set('Europe/Amsterdam');
ini_set("auto_detect_line_endings", true);

error_reporting(E_ALL);

function ld($d) {
	$ret = array();
	foreach (scandir($d) as $f) {
		$ff = $d.DIRECTORY_SEPARATOR.$f;
		if (is_dir($ff) && substr($f, 0, 1) != ".") {
			$ret[] = $ff;
		}
	}
	return $ret;
}

function gf($d, $f) {
	return trim(@file_get_contents($d.DIRECTORY_SEPARATOR.$f));
}

function fe($d, $f) {
	return file_exists($d.DIRECTORY_SEPARATOR.$f);
}

$runs = array();
$tests = array();

foreach(ld('.') as $hostd) {
	$host = basename($hostd);
	foreach(ld($hostd) as $rund) {
		$run = basename($rund);
		$runid = $host ."-".$run;
		$ttests = array_unique(array_filter(explode("\n", 
			gf($rund, 'runtests')), 'trim'));

		$tests = array_unique(array_merge($tests, $ttests));
		asort($tests);

		$tr = array();

		foreach($ttests as $t) {
			$tr[$t] = array(
				'tname'    => $t,
				'started'  => fe($rund, $t.'-started'),
				'complete' => fe($rund, $t.'-complete'),
				'setup'    => fe($rund, $t.'-setup-success'),
				'test'     => fe($rund, $t.'-test-success')
			);
			$tr[$t]['success'] = $tr[$t]['complete'] && $tr[$t]['setup'] && $tr[$t]['test'];
		}

		$runs[] = array(
			'host'     => $host,
			'run'      => $run,
			'runid'    => $runid,
			'runp'     => date("Y-m-d H:i", $run),
			'runrfc'   => date("r", $run),
			'mbranch'  => gf($rund, 'monetdb-branch'),
			'mrev'     => gf($rund, 'monetdb-revision'),
			'rver'     => gf($rund, 'r-version'),
			'deps'     => fe($rund, 'packages-success'),
			'complete' => fe($rund, 'complete'),
			'path'     => $host.DIRECTORY_SEPARATOR.$run,
			'tests'    => $tr
		);
	}	
}

function rcmp($a, $b) {
    if ($a['run'] == $b['run']) {
        return 0;
    }
    return ($a['run'] > $b['run']) ? -1 : 1;
}
usort($runs, "rcmp");

function tail($filename, $nlines) {
	$lines = array();
	$fp = fopen($filename, "r");
	while(!feof($fp)) {
	   $line = fgets($fp);
	   array_push($lines, $line);
	   if (count($lines) > $nlines)
	       array_shift($lines);
	}
	fclose($fp);
	return(implode("", array_unique($lines)));
}

header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

if (isset($_REQUEST['rss'])) {
	header("Content-type: application/rss+xml");
		print '<?xml version="1.0" encoding="UTF-8"?>
	<rss version="2.0">
	  <channel>
	    <title>E. Anthony</title>
	    <description>asdfree tests with MonetDB.R and MonetDBLite</description>';

	foreach($runs as $r) {
		$runinfo = "Run started at $r[runp] using R $r[rver] and MonetDB $r[mbranch]/$r[mrev]";
		foreach($tests as $t) {
			$ti = @$r['tests'][$t];
			if ($ti['complete'] && !$ti['success']) {
				$testinfo = "$ti[tname] failure on $r[host] ($runinfo)";
				$logtail = htmlentities(tail("$r[path]/$t.log", 10));
				print "
	    <item>
	      <title>$testinfo</title>
	      <link>http://monetdb.cwi.nl/testweb/web/eanthony/#$r[runid]</link>
	      <description>$logtail</description>
	    </item>";
			}
		}
	}
	print '  </channel>
	</rss>';
	return;
}

?>

<html>
<head>
<title>Electric A.</title>
<meta http-equiv="refresh" content="10">
<style>
body {
	font-family: Helvetica, sans-serif;
}
td {
	padding: 4px;
}
.status {
	width: 12px;
	height: 12px;
}
.status-started {
	background-color: #e9e9e9;
}
.status-failed {
	background-color: #FF6633;
}
.status-success {
	background-color: #00CC33;
}
.vertical {
	-webkit-writing-mode:vertical-rl; 
	-ms-writing-mode:tb-rl; 
	writing-mode:vertical-rl; 
}
</style>
</head>

<body>
<h1>Electric A.</h1>
<table>
<tr>
	<th></th>
	<th></th>
	<?= '<th><span class="vertical">'.implode('</th><th><span class="vertical">', $tests).'</span></th>' ?>
	<th></th> 
</tr>

<?php foreach($runs as $r) { ?>

<tr>
<td><a name="<?=$r['runid']?>"></a><?= $r['runp'] ?></td>
<td><?= $r['host'] ?></td>
<!--<td><?= $r['complete']?"completed":"running" ?></td>-->

<?php foreach($tests as $t) { $ti = @$r['tests'][$t]; ?>
<td><a href="<?= $r['path'] ?>/<?=$t?>.log"><div class="status status-<?= $ti['success']?'success':($ti['complete']?'failed':($ti['started']?'started':'none')) ?>"></div></a></td>
<?php } ?>

<!--<td>R <?= $r['rver'] ?></td><td>M <a href="https://dev.monetdb.org/hg/MonetDB/rev/<?= $r['mrev'] ?>"><?= $r['mbranch'] ?></a></td><td><a href="<?= $r['path'] ?>/package-versions">Packages</a></td>-->
<td><a href="<?= $r['path'] ?>">logs</a></td>
</tr>

<?php } ?>

</table>

<br><br>
<small>
<a href="?rss">RSS</a>
</small>

</body>
</html>
