use std::io::{self, BufRead};
use std::collections::HashMap;
use std::collections::HashSet;
use std::convert::TryFrom;

fn solve(input: &[i32]) {
    let horz_block: &[(i32, i32)] = &[(2,4),(3,4),(4,4),(5,4)];
    let cross_block: &[(i32, i32)] = &[(3,4),(3,5),(3,6),(2,5),(4,5)];
    let l_block: &[(i32, i32)] = &[(2,4),(3,4),(4,4),(4,5),(4,6)];
    let vert_block: &[(i32, i32)] = &[(2,4),(2,5),(2,6),(2,7)];
    let o_block: &[(i32, i32)] = &[(2,4),(3,4),(2,5),(3,5)];
    let mut field = HashSet::new();
    for i in 0..7 {
        field.insert((i,0));
    }
    let getat = |(x, y): (i32, i32), shape: &[(i32, i32)], origin: (i32, i32), f: &HashSet<(i32,i32)>| -> char {
        if (x == 0 || x == 8) && y == 0 {
            return '+';
        } else if x == 0 || x == 8 {
            return '|';
        } else if y == 0 {
            return '-';
        } else if f.contains(&(x,y)) {
            return '#';
        } else {
            for s in shape {
                if s.0 + origin.0 == x && s.1 + origin.1 == y {
                    return '@';
                }
            }
            return '.';
        }
    };
    let draw = |shape: &[(i32, i32)], origin: (i32, i32), f: &HashSet<(i32,i32)>, h: i32| {
        for y in (0..(h + 9)).rev() {
            for x in 0..9 {
                print!("{}", getat((x, y), shape, origin, f));
            }
            println!("");
        }
        println!("");
    };
    let mut drop_rock = |shape: &[(i32, i32)], jet_idx: &mut usize, highest: &mut i32| {
        let is_ok = |off: (i32, i32), f: &HashSet<(i32,i32)>| -> bool {
            for s in shape {
                let dx = s.0 + off.0;
                let dy = s.1 + off.1;
                if dx == 0 || dx == 8 || dy == 0 { return false; }
                if f.contains(&(dx,dy)) { return false; }
            }
            return true;
        };
        let mut origin = (1, *highest);
        // println!("rock appears at {:?}", origin);
        // draw(shape, origin, &field, highest);

        let mut jet_push_and_fall = || {
            let push_origin = (origin.0 + input[*jet_idx], origin.1);
            *jet_idx = (*jet_idx + 1) % input.len();
            if is_ok(push_origin, &field) {
                origin = push_origin;
            }
            // draw(shape, origin, &field, highest);
            let down_origin = (origin.0, origin.1 - 1);
            if is_ok(down_origin, &field) {
                origin = down_origin;
                // draw(shape, origin, &field, highest);
                true
            } else {
                for s in shape {
                    field.insert((s.0 + origin.0, s.1 + origin.1));
                    *highest = std::cmp::max(*highest, s.1 + origin.1);
                }
                // draw(&[], (0,0), &field, highest);
                false
            }
        };

        loop {
            let could_fall = jet_push_and_fall();
            if !could_fall { break; }
        }
    };
    let mut highest = 0;
    let allblocks = &[horz_block, cross_block, l_block, vert_block, o_block];
    let mut jet_idx = 0;
    let mut idx = 0;
    let mut lastseen = HashMap::new();
    let mut lastfrom = HashMap::new();
    for _ in 0..2022 {
        let block_idx = idx % allblocks.len();
        let block = allblocks[block_idx];
        // println!("drop_rock({idx}, {jet_idx})");
        drop_rock(block, &mut jet_idx, &mut highest);
        idx += 1;
        lastseen.insert((block_idx, jet_idx), highest);
        lastfrom.insert((block_idx, jet_idx), idx);
    }
    println!("height after 2022 blocks (part 1): {}", highest);
    let target_idx: i64 = 1000000000000;
    let mut estimate = -1;
    for _ in 2022..10000 {
        let block_idx = idx % allblocks.len();
        let block = allblocks[block_idx];
        // println!("drop_rock({idx}, {jet_idx})");
        drop_rock(block, &mut jet_idx, &mut highest);
        idx += 1;
        match lastseen.get(&(block_idx, jet_idx)) {
            Some(prev) => {
                let lastfromidx = lastfrom.get(&(block_idx, jet_idx)).unwrap();
                let high64: i64 = i64::from(highest);
                let idx64: i64 = i64::try_from(idx).unwrap();
                let cycle_height: i64 = i64::from(highest - prev);
                let cycle_len: i64 = i64::try_from(idx - lastfromidx).unwrap();
                let num_cycles = (target_idx - idx64) / cycle_len;
                let new_idx = idx64 + num_cycles * cycle_len;
                if new_idx == target_idx {
                    estimate = high64 + cycle_height * num_cycles;
                    // println!("highest={highest}, estimate={}", estimate);
                    // println!("idx{idx} {:?}: {}, highest={highest}  | lastfromidx={lastfromidx}  | cycle_len={cycle_len}", (block_idx, jet_idx), cycle_height);
                    // println!("new_idx{new_idx}: {} | high64:{high64} + cycle_height:{cycle_height} * num_cycles:{num_cycles}", high64 + cycle_height * num_cycles);
                }
            },
            None => panic!("unseen pattern!"),
        };
        lastseen.insert((block_idx, jet_idx), highest);
        lastfrom.insert((block_idx, jet_idx), idx);
    }
    // draw(&[], (0,0), &field, highest);
    println!("height after {target_idx} blocks (part 2): {}", estimate);
}

fn parse(lines: &[String]) -> Vec<i32> {
    assert!(lines.len() == 1);
    return lines[0].chars().map(|c| if c == '<' { -1 } else { 1 }).collect();
}

fn main() {
    let mut lines: Vec<String> = Vec::new();
    for line in io::stdin().lock().lines() {
        lines.push(line.unwrap());
    }
    let parsed = parse(&lines);
    // println!("parsed: {parsed:?}");
    solve(&parsed);
}
