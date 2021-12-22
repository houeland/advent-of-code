set data_map [gets stdin]
gets stdin
set input_line 0
while {1 > 0} {
  set data_input_line [gets stdin]
  if {$data_input_line == ""} break
  incr input_line
  set field($input_line) $data_input_line
}

proc expand_line {line} {
  global padding
  return $padding$padding$line$padding$padding
}

proc expand_field {} {
  global field
  global new_expanded_field
  global padding
  set empty_line [string repeat $padding [string length $field(1)]]
  set new_line_idx 1
  set old_line_idx 0
  set new_expanded_field($new_line_idx) [expand_line $empty_line]
  incr new_line_idx
  set new_expanded_field($new_line_idx) [expand_line $empty_line]
  foreach key [array names field] {
    set old_line $field($key)
    incr new_line_idx
    incr old_line_idx
    set new_expanded_field($new_line_idx) [expand_line $field($old_line_idx)]
  }
  incr new_line_idx
  set new_expanded_field($new_line_idx) [expand_line $empty_line]
  incr new_line_idx
  set new_expanded_field($new_line_idx) [expand_line $empty_line]
}

proc lookup_new_value {bits} {
  global data_map
  set bits_bits [string map {. 0 # 1} $bits]
  set idx [expr "0b$bits_bits"]
  return [string index $data_map $idx]
}

proc iterate_field {} {
  global field
  global new_expanded_field
  global padding
  set y_len [array size new_expanded_field]
  set x_len [string length $new_expanded_field(1)]
  #puts "y: $y_len x: $x_len"
  set field_idx 0
  for {set y 2} {$y <= [expr {$y_len - 1}]} {incr y} {
    set new_y_line ""
    for {set x 1} {$x < [expr {$x_len - 1}]} {incr x} {
      set bits ""
      set bitidx 0
      foreach dy [list -1 0 +1] {
        foreach dx [list -1 0 +1] {
          set old_char [string index $new_expanded_field([expr {$y + $dy}]) [expr {$x + $dx}]]
          append bits $old_char
          incr bitidx
        }
      }
      # puts "bits: <$bits>"
      append new_y_line [lookup_new_value $bits]
    }
    # puts $new_y_line
    incr field_idx
    set field($field_idx) $new_y_line
  }
  set padding [lookup_new_value [string repeat $padding 9]]
}

proc count_lit_on_field_verbose {} {
  global field
  set y_len [array size field]
  set total_cnt 0
  for {set y 1} {$y <= $y_len} {incr y} {
    set cnt [regexp -all # $field($y)]
    puts "line: $field($y) cnt: $cnt"
    incr total_cnt $cnt
  }
  return $total_cnt
}

proc count_lit_on_field {} {
  global field
  set y_len [array size field]
  set total_cnt 0
  for {set y 1} {$y <= $y_len} {incr y} {
    set cnt [regexp -all # $field($y)]
    incr total_cnt $cnt
  }
  return $total_cnt
}

proc do_part_1 {} {
global data_map
global field
global new_expanded_field
global padding
puts $data_map
puts "  -- -- --  "
parray field
puts "  -- -- --  "
set padding "."

expand_field
puts "  -- -- --  "
parray new_expanded_field
puts "  -- -- --  "

iterate_field
puts "  -- -- --  "
parray field
puts "  -- -- --  "

expand_field
puts "  -- -- --  "
parray new_expanded_field
puts "  -- -- --  "

iterate_field
puts "  -- -- --  "
parray field
puts "  -- -- --  "

puts "count lit: [count_lit_on_field_verbose]"
}

proc do_part_2 {} {
global data_map
global field
global new_expanded_field
global padding
set padding "."

for {set times 0} {$times <= 50} {incr times 2} {
puts "iter $times count lit: [count_lit_on_field]"
expand_field
iterate_field
expand_field
iterate_field
}
}

#do_part_1
do_part_2
