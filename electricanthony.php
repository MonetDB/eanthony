<?php
date_default_timezone_set('Europe/Amsterdam');

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

		$tests = array_unique(array_merge($tests, $ttests));
		asort($tests);

		$tr = array();

		foreach($ttests as $t) {
			$tr[$t] = array(
				tname    => $t,
				started  => fe($rund, $t.'-started'),
				complete => fe($rund, $t.'-complete'),
				setup    => fe($rund, $t.'-setup-success'),
				test     => fe($rund, $t.'-test-success')
			);
			$tr[$t]['success'] = $tr[$t]['complete'] && $tr[$t]['setup'] && $tr[$t]['test'];
		}

		$runs[] = array(
			host     => $host,
			run      => $run,
			runp     => date("Y-m-d h:i", $run),
			mbranch  => gf($rund, 'monetdb-branch'),
			mrev     => gf($rund, 'monetdb-revision'),
			rver     => gf($rund, 'r-version'),
			deps     => fe($rund, 'packages-success'),
			complete => fe($rund, 'complete'),
			path     => $host.DIRECTORY_SEPARATOR.$run,
			tests    => $tr
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

?>

<html>
<head>
<title>Electric Anthony</title>

<style>
.status {
	width: 20px;
	height: 20px;
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
</style>
</head>

<body>
<h1>Electric Anthony</h1>
<table>
<tr>
	<th></th>
	<th></th>
	<th></th>
	<?= '<th>'.implode('</th><th>', $tests).'</th>' ?>
	<th></th>
	<th></th>

</tr>

<?php foreach($runs as $r) { ?>

<tr>
<td><?= $r['runp'] ?></td>
<td><?= $r['host'] ?></td>
<td><?= $r['complete']?"completed":"running" ?></td>

<?php foreach($tests as $t) { $ti = $r['tests'][$t]; ?>
<td><a href="<?= $r['path'] ?>/<?=$t?>.log"><div class="status status-<?= $ti['success']?'success':($ti['complete']?'failed':($ti['started']?'started':'none')) ?>"></div></a></td>
<?php } ?>

<td>R <?= $r['rver'] ?></td><td>M <a href="https://dev.monetdb.org/hg/MonetDB/rev/<?= $r['mrev'] ?>"><?= $r['mbranch'] ?></a></td><td><a href="<?= $r['path'] ?>/package-versions">Packages</a></td><td><a href="<?= $r['path'] ?>">Logfiles</a></td>
</tr>

<?php } ?>

</table>

</body>
</html>
