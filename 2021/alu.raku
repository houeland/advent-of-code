my @sections;

my @current_section;

my $w = "";
my $inp_ctr = 0;
sub run_cmd($line) {
  if $line eq "inp w" {
    @sections.push(@current_section.List);
    @current_section = ();
    $inp_ctr += 1;
    $w = "w$inp_ctr";
  } else {
    my ($op, $a, $b) = split(" ", $line);
    if $b eq "w" {
      $b = $w;
    }
    @current_section.push("$op $a $b");
  }
}

for $*IN.lines() -> $line {
  run_cmd($line);
}
@sections.push(@current_section.List);
@sections.shift;

#say "num sections: {@sections.elems}";

my $cur_section;
my $cur_section_consumed;

sub nextline() {
  my $line = $cur_section[$cur_section_consumed];
  $cur_section_consumed += 1;
  return $line;
}

sub peekline() {
  return $cur_section[$cur_section_consumed];
}

sub peekargument() {
  my ($op, $a, $b) = split(" ", peekline());
  return $b;
}

sub eatline($line) {
  my $read = nextline();
  if $read eq $line {
  } else {
    say "tried to eat line: $line";
    say "but input was:     $read";
    die "oh no something went wrong";
  }
}

sub maybe_eatline($line) {
  if peekline() eq $line {
    eatline($line);
    return True;
  } else {
    return False;
  }
}

sub dumprest() {
  while $cur_section_consumed < $cur_section.elems {
    my $l = nextline();
    say ">> $l";
  }
}

sub process_section($section) {
  $cur_section = $section;
  $cur_section_consumed = 0;
  eatline("mul x 0");
  eatline("add x z");
  eatline("mod x 26");
  my $x_cond;
  if maybe_eatline("div z 1") {
    my $xadd = peekargument();
    eatline("add x $xadd");
    if $xadd >= 0 {
      $x_cond = "z.peek() + $xadd";
    } else {
      $x_cond = "z.peek() - {$xadd * -1}";
    }
  } else {
    eatline("div z 26");
    my $xadd = peekargument();
    eatline("add x $xadd");
    if $xadd >= 0 {
      $x_cond = "z.pop() + $xadd";
    } else {
      $x_cond = "z.pop() - {$xadd * -1}";
    }
  }

  my $w = peekargument();
  eatline("eql x $w");
  eatline("eql x 0");
  say "if ($x_cond != $w):";

  eatline("mul y 0");
  eatline("add y 25");
  eatline("mul y x");
  eatline("add y 1");
  eatline("mul z y");

  eatline("mul y 0");
  eatline("add y $w");
  my $yadd = peekargument();
  eatline("add y $yadd");
  eatline("mul y x");
  eatline("add z y");
  say "  z.push($w + $yadd)";

  dumprest();
}

for @sections -> $section {
   process_section($section);
}
