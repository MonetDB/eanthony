<?php
date_default_timezone_set('Europe/Amsterdam');
ini_set("auto_detect_line_endings", true);

error_reporting(E_WARNING);

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
		$ttests = array_unique(array_filter(explode("\n", 
			gf($rund, 'runtests')), 'trim'));

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

for ($i = 0; $i < min(5, sizeof($runs)); $i++) {
	$tests = array_unique(array_merge($tests, array_keys($runs[$i]['tests'])));
	asort($tests);
}


for ($i = 0; $i < sizeof($runs); $i++) {
	foreach($runs[$i]['tests'] as $test => $result) {
		if (!$result['complete']) {
			continue;
		}
		for($j = $i + 1; $j < sizeof($runs); $j++) {
			if ($runs[$i]['host'] == $runs[$j]['host']) {
				$runs[$j]['tests'][$test]['complete'] = true;
				$runs[$i]['tests'][$test]['changed'] = (!isset($runs[$j]['tests'][$test]) || 
				$result['success'] != $runs[$j]['tests'][$test]['success']);
				break;
			} 
		}
	}
}


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
	return(substr(implode("", array_unique($lines)),-3000));
}

header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

if (isset($_REQUEST['badge'])) {
	//header("Content-type: image/svg+xml");

	$state = 'unknown';

	foreach(array_slice($runs, 0, 20) as $r) {

		$ti = @$r['tests'][$_REQUEST['badge']];
		if ($r['host'] == $_REQUEST['host']) {
			//print_r($ti);
			if ($ti['complete']) {
				if ($ti['success']) {
					$state = 'success';
				} else {
					$state = 'failed';
				}
				break;
			}
		}
	}
	if ($state == "success") {
		header("Location: https://img.shields.io/badge/$_REQUEST[host]-passing-brightgreen.svg");
	}
	if ($state == "failed") {
		header("Location: https://img.shields.io/badge/$_REQUEST[host]-failing-red.svg");
	}
	if ($state == "unknown") {
		header("Location: https://img.shields.io/badge/$_REQUEST[host]-unknown-lightgray.svg");
	}

	die();
}


if (isset($_REQUEST['rss'])) {
	header("Content-type: application/rss+xml");
		print '<?xml version="1.0" encoding="UTF-8"?>
	<rss version="2.0">
	  <channel>
	    <title>Sisyphus</title>
	    <link>https://sisyphus.project.cwi.nl/</link>
	    <description>asdfree tests with MonetDBLite</description>';

	foreach(array_slice($runs, 0, 20) as $r) {
		$runinfo = "Run started at $r[runp] using R $r[rver]";
		foreach($tests as $t) {
			$ti = @$r['tests'][$t];
			if ($ti['complete'] && !$ti['success'] && $ti['changed']) {
				$testinfo = "$ti[tname] failure on $r[host] ($runinfo)";
				$logtail = htmlentities(tail("$r[path]/$t.log", 10));
				print "
	    <item>
	      <title>$testinfo</title>
	      <link>https://sisyphus.project.cwi.nl/$r[host]/$r[run]/$t.log</link>
	      <description>$logtail</description>
	      <guid>https://sisyphus.project.cwi.nl/$r[host]/$r[run]/$t.log</guid>
	    </item>";
			}
		}
	}
	print '  </channel>
	</rss>';
	die();
}

if (isset($_REQUEST['debug'])) {
	print "<pre>";
	print_r($runs);
	die();
}

?>

<html>
<head>
<title>Σίσυφος</title>
<meta id="meta-refresh" http-equiv="refresh" content="10">
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
	border: 1px solid #e9e9e9;
}
.status-failed-changed {
	background-color: #FF6633;
}
.status-success-changed {
	background-color: #00CC33;
}

.status-failed {
	background-color: #FCC9B8;
}
.status-success {
	background-color: #B3E6C0;
}


.vertical {
	-webkit-writing-mode:vertical-rl; 
	-ms-writing-mode:tb-rl; 
	writing-mode:vertical-rl;
}

th, td {
	width: 20px;
}
</style>
</head>

<body>
<!--<h1>Electric A.</h1>-->
<table>
<tr style="height: 200px">
	<th></th>
	<?= '<th><span class="vertical">'.implode('</th><th><span class="vertical">', $tests).'</span></th>' ?>
</tr>

<?php foreach(array_slice($runs, 0, 20) as $r) { ?>

<tr>
<td><a href="<?= $r['path'] ?>"><img src="<?= (strpos($r[host], 'win') !== FALSE) ? 'windows.png' : 'tux.png' ?>" style="height: 20px;"/><!--<?= $r['host'] ?>--></a></td>

<?php foreach($tests as $t) { $ti = @$r['tests'][$t]; ?>
<td><a href="<?= $r['path'] ?>/<?=$t?>.log"><div class="status status-<?= $ti['success']?'success':($ti['complete']?'failed':($ti['started']?'started':'none')) ?><?= $ti['changed']?'-changed':''?>"></div></a></td>
<?php } ?>

</tr>

<?php } ?>

</table>

<br><br>
<small>
<a href="?rss">RSS</a>&nbsp;&nbsp;
</small>

<img src="sysiphos.png" title="Nekyia: Persephone supervising Sisyphus pushing his rock in the Underworld. Side A of an Attic black-figure amphora, ca. 530 BC. From Vulci." style="position: fixed; left: 10px; top: 10px; height: 80px"/>


</body>
</html>
