(*

 y
 ^  z
 | /
 |/
  ---> x

z from +z -> x<+x y<+y z<+z
z from +x -> x<-z y<+y z<+x
z from +y -> x<+x y<-z z<+y

z from -z -> x<-x y<+y z<-z
z from -x -> x<+z y<+y z<-x
z from -y -> x<+x y<+z z<-y

turn (clockwise around z axis):
  newz = oldz
  newx = oldy
  newy = -oldx

*)

fun turn_around_z (x,y,z) = (y,~x,z)

fun z_from_plusz (x,y,z) = (x,y,z)
fun z_from_plusx (x,y,z) = (~z,y,x)
fun z_from_plusy (x,y,z) = (x,~z,y)
fun z_from_negz (x,y,z) = (~x,y,~z)
fun z_from_negx (x,y,z) = (z,y,~x)
fun z_from_negy (x,y,z) = (x,z,~y)

fun beacontostr (a,b,c) = String.concat ["(", Int.toString a, " ", Int.toString b, " ", Int.toString c, ")"];
fun int_to_str x = if x >= 0 then Int.toString x else String.concat ["-", Int.toString (~x)]
fun beacontostr_input_format (a,b,c) = String.concat [int_to_str a, ",", int_to_str b, ",", int_to_str c];

fun printscanner s = (
    map (fn x => print (beacontostr x)) s;
    print "\n"
  );

fun printlnscanner s = (
    map (fn x => (print (beacontostr x); print "\n")) s;
    print "\n"
  );

fun printlnscanner_input_format s = (
    map (fn x => (print (beacontostr_input_format x); print "\n")) s;
    print "\n"
  );

fun readscanner inpsrc =
  let
    val line = ref NONE
    val beacons = ref []
    val scanner_name = getOpt (TextIO.inputLine inpsrc, "<empty>")
  in
    while (line := TextIO.inputLine inpsrc; isSome (!line) andalso valOf (!line) <> "\n") do (
      (*print "got line:";
      print (valOf (!line));
      print "\n";*)
      let
        val toks = String.tokens (Char.contains ",") (valOf (!line)) 
        val [SOME first, SOME second, SOME third] = map Int.fromString toks
      in
        beacons := (first, second, third) :: !beacons
      end);
    (scanner_name, List.rev (!beacons))
  end;

fun z_from_plusz (x,y,z) = (x,y,z)
fun z_from_plusx (x,y,z) = (~z,y,x)
fun z_from_plusy (x,y,z) = (x,~z,y)
fun z_from_negz (x,y,z) = (~x,y,~z)
fun z_from_negx (x,y,z) = (z,y,~x)
fun z_from_negy (x,y,z) = (x,z,~y)

fun mkfacings scanner =
  let
    val f0 = map z_from_plusz scanner
    val f1 = map z_from_plusx scanner
    val f2 = map z_from_plusy scanner
    val f3 = map z_from_negz scanner
    val f4 = map z_from_negx scanner
    val f5 = map z_from_negy scanner
  in
    List.concat [[f0, f1, f2], [f3, f4, f5]]
  end;

fun aroundzs scanner =
  let
    val s0 = scanner
    val s1 = map turn_around_z s0
    val s2 = map turn_around_z s1
    val s3 = map turn_around_z s2
  in
    List.concat [[s0, s1], [s2, s3]]
  end;

fun alloptions scanner =
  let
    val facings = mkfacings scanner
  in
    List.concat (map aroundzs facings)
  end;

fun diffbeacons (b0x, b0y, b0z) (b1x, b1y, b1z) = (b0x - b1x, b0y - b1y, b0z - b1z)

fun adjustscan s b0 b1 =
  let
    val (dx, dy, dz) = diffbeacons b0 b1
  in
    (*print "dxdydx ";
    print (String.concat [Int.toString dx, "|", Int.toString dy, "|", Int.toString dz]);
    print "\n";*)
    map (fn (x,y,z) => (x+dx, y+dy, z+dz)) s
  end;

fun count_if s b = if List.exists (fn x => x = b) s then 1 else 0

fun count_overlap s0 s1 =
  let
    val foo = map (count_if s0) s1
    val as_strings = map Int.toString foo
    val cc_printable = String.concat as_strings
  in
    (*print cc_printable;
    print "\n";*)
    foldl op+ 0 foo
  end;

fun printlnint x = (print (Int.toString x); print "\n")

fun listmax (x::xs) sofar = if x > sofar then listmax xs x else listmax xs sofar
  | listmax [] sofar = sofar

fun list1max ((x,y)::xs) (sofar,oldlist) = if x > sofar then list1max xs (x,y) else list1max xs (sofar,oldlist)
  | list1max [] best = best

fun try_all_overlaps s0 s1 =
  let
    val doremap = fn x => fn y => (adjustscan s1 x y, diffbeacons x y)
    val over_s0 = fn b0 => map (doremap b0) s1
    val allthings = List.concat (map over_s0 s0)
    val allcounts = map (fn (trys1, trys1origin) => (count_overlap s0 trys1, (trys1, trys1origin))) allthings
    val (biggest_score, (biggest_scanner, originat)) = list1max allcounts (0,([],(0,0,0)))
  in
    (*print "biggest_score:";
    print (Int.toString biggest_score);
    print "";*)
    (biggest_score, (biggest_scanner, originat))
  end;

fun find_most_bestest solid newscan =
  let
    val opts = alloptions newscan
    val counts_and_vals = map (fn s1 => try_all_overlaps solid s1) opts
  in
    list1max counts_and_vals (0,([],(0,0,0)))
  end;

(*
fun runprogram inpsrc =
  let
    val scanner0input = readscanner inpsrc
    val scanner1input = readscanner inpsrc
    val scanner2input = readscanner inpsrc
    val scanner3input = readscanner inpsrc
    val scanner4input = readscanner inpsrc
    val (s1_score, (s1_list, s1_origin)) = find_most_bestest scanner0input scanner1input
    val (s4_score, (s4_list, s4_origin)) = find_most_bestest s1_list scanner4input
  in
(*
    map (fn x => (printscanner x; print "")) [scanner0input];
    print "\n\n\n";
    map (fn x => (printscanner x; print "")) [scanner1input];
    print "\n\n\n";
    map (fn s1 => (
      print "try s1:";
      printscanner s1;
      let val cnt = try_all_overlaps scanner0input s1 in
        print "count:";
        print (Int.toString cnt);
        print "\n\n"
      end
    )) scanner1opts;
*)

    print "s1 got:";
    printlnint s1_score;
    print "from: ";
    printscanner s1_list;
    print "origin at: ";
    print (beacontostr s1_origin);
    print "\n";

    print "s4 got:";
    printlnint s4_score;
    print "from: ";
    printscanner s4_list;
    print "origin at: ";
    print (beacontostr s4_origin);
    print "\n";

    print ""
    (*map (fn x => (printscanner x; print "")) scanner1opts;
    print "\n\n\n"*)
  end;
*)

fun read_scanners_input inpsrc =
  let
    val scanners = ref []
    val keepgoing = ref true
  in
    while (!keepgoing) do (
      let val (newscannername, newscanner) = readscanner inpsrc in
        (*print "length: ";
        print (Int.toString (List.length newscanner));
        print "  ";
        printscanner newscanner;*)
        if List.length newscanner > 0 then scanners := (newscannername, newscanner) :: (!scanners) else ();
        keepgoing := (List.length newscanner > 0)
      end
    );
    List.rev (!scanners)
  end;

fun dumpscannerlist xs = map (fn (name, beacons) => (print name; printscanner beacons)) xs

fun gitgud known (newname,news) =
  let
    val result = ref (false, (newname,news), (0,0,0))
  in
    map (fn (kname,k) => (
      let val (score, (list, origin)) = find_most_bestest k news in
        if score >= 12 then result := (true, (newname,list), origin) else ()
      end
    )) known;
    !result
  end;

fun alignscanners inpsrc =
  let
    val (scanner0input::otherscanners) = read_scanners_input inpsrc
    val allknown = ref [(scanner0input, (0,0,0))]
    val newknown = ref [scanner0input]
    val unknown = ref otherscanners
    val newunknown = ref []
  in
    (*
    print "allknown:\n";
    dumpscannerlist (!allknown);
    print "unknown:\n";
    dumpscannerlist (!unknown);*)

    print "\n\nstart solving...\n\n\n";
    while (length (!unknown) > 0) do (
      newunknown := [];
      let val results = map (fn news => gitgud (!newknown) news) (!unknown) in
        newknown := [];
        map (fn (won, (scname, beacons), origin) => (
          if won then (print "won: "; print scname) else ();
          (*printscanner beacons;
          print "origin: ";
          print (beacontostr origin);
          print "\n";*)
          if won
            then (
              newknown := (scname, beacons) :: (!newknown);
              allknown := ((scname, beacons), origin) :: (!allknown)
            ) else (
              newunknown := (scname, beacons) :: (!newunknown)
            )
        )) results
      end;
      unknown := (!newunknown)
    );

    (*
    print "\n\nfound results...\n\n\n";

    print "allknown:\n";
    dumpscannerlist (!allknown);
    print "unknown:\n";
    dumpscannerlist (!newunknown);
    *)

    !allknown
  end;

fun manh a b = if a > b then a - b else b - a

fun calc_manh_len ((x0, y0, z0), (x1, y1, z1)) = (manh x0 x1) + (manh y0 y1) + (manh z0 z1)

fun biggest_dist scanners =
  let
    val origin_list = map (fn ((nam,sli),org) => org) scanners
    val all_to_all = List.concat (map (fn y => map (fn x => (x,y)) origin_list) origin_list)
    val lens = map calc_manh_len all_to_all
  in
    listmax lens 0
  end;

fun reduce_unique_beacons found (todo::rest) =
        if List.exists (fn x => x = todo) found
          then reduce_unique_beacons found rest
          else reduce_unique_beacons (todo::found) rest
  | reduce_unique_beacons found [] = found;

fun solveproblem inpsrc = (
  print "aligning scanners...\n";
  let
    val scanners = alignscanners inpsrc
    val allbeacons = List.concat (map (fn ((nam,sli),org) => sli) scanners)
    val uniquebeacons = reduce_unique_beacons [] allbeacons
    val manhattan_span = biggest_dist scanners
  in
    print "allbeacons count: ";
    printlnint (List.length allbeacons);
    (*print "\n\nbeacons:\n";
    printlnscanner_input_format uniquebeacons;
    print "\ndone.\n";*)

    print "num unique beacons: ";
    printlnint (List.length uniquebeacons);
    print "\n";

    print "scanners:\n";
    map (fn ((nam,sli),org) => (print (beacontostr org); print " = "; print nam)) scanners;
    print "\n";

    print "biggest scanner distance: ";
    printlnint manhattan_span;
    print "\n"
  end
);

solveproblem TextIO.stdIn;
