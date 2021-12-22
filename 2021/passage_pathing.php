<?php
$example_10_input = "
start-A
start-b
A-c
A-b
b-d
A-end
b-end
";

$example_19_input = "
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
";

$example_226_input = "
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
";

$real_input = "
vp-BY
ui-oo
kk-IY
ij-vp
oo-start
SP-ij
kg-uj
ij-UH
SP-end
oo-IY
SP-kk
SP-vp
ui-ij
UH-ui
ij-IY
start-ui
IY-ui
uj-ui
kk-oo
IY-start
end-vp
uj-UH
ij-kk
UH-end
UH-kk
";

function stepstates($states) {
    global $conns;
    global $completepaths;
    $newstates = [];
    foreach ($states as $s) {
      $where = $s["where"];
      $seen = $s["seen"];
      $doubledipped = $s["doubledipped"];
      foreach ($conns as $c) {
        $from = $c[0];
        $to = $c[1];
        $beenthere = array_key_exists($to, $seen);
        $cango = !$beenthere || !$doubledipped;
        if (($from == $where) && $cango) {
         if ($to == "start") {
         } elseif ($to == "end") {
          // echo "go $from to $to and done wah!\n";
          $completepaths += 1;
         } else {
          // echo "go $from to $to\n";
          $newdoubledipped = $doubledipped;
          if ($beenthere) {
            $newdoubledipped = TRUE;
          }
          $newseen = $seen;
          if (!ctype_upper($to{0})) {
            $newseen[$to] = TRUE;
          }
          $newstates[] = array("where"=>$to, "doubledipped"=>$newdoubledipped, "seen"=>$newseen);
         }
        }
      }
    }
    return $newstates;
}

function solve($someinput) {
    global $conns;
    global $completepaths;

$input = $someinput;
$arr = explode("\n", $input);
$arr = array_slice($arr, 1, -1);

$conns = [];

foreach ($arr as $value) {
    $fromto = explode("-", $value);
    $conns[] = [$fromto[0], $fromto[1]];
    $conns[] = [$fromto[1], $fromto[0]];
    // echo "[ $value ]\n";
}

$completepaths = 0;
$states = [];
$states[] = array("where"=>"start", "doubledipped"=>TRUE, "seen"=>array("start"=>TRUE));
// print_r($states);
while (count($states) > 0) {
  $numstates = count($states);
  echo "got $numstates states\n";
  $states = stepstates($states);
}
$basicpaths = $completepaths;

$completepaths = 0;
$states = [];
$states[] = array("where"=>"start", "doubledipped"=>FALSE, "seen"=>array("start"=>TRUE));
// print_r($states);
while (count($states) > 0) {
  $numstates = count($states);
  echo "got $numstates states\n";
  $states = stepstates($states);
}
$doubledippaths = $completepaths;


echo "Num paths: basic=$basicpaths doubledip=$doubledippaths\n";

}

solve($example_10_input);
solve($example_19_input);
solve($example_226_input);
solve($real_input);

?>
