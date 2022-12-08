use std::io::{self, BufRead};
use std::collections::HashSet;
use std::convert::TryFrom;

fn find_common(line1: &str, line2: &str, line3: &str) -> String {
    let in_part1: HashSet<char> = line1.chars().collect();
    let in_part2: HashSet<char> = line2.chars().collect();
    for c in line3.chars() {
        if in_part1.contains(&c) && in_part2.contains(&c) {
            return c.to_string();
        }
    }
    panic!("invalid input, no common item!");
}

const ITEM_PRIORITIES: &str = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

fn priority_of(item: &str) -> i32 {
    let val = ITEM_PRIORITIES.find(&item).unwrap();
    println!("priority of {} --> {}", item, val);
    return i32::try_from(val).unwrap();
}

fn main() {
    let mut common = Vec::new();
    let mut three_lines = Vec::new();
    for line in io::stdin().lock().lines() {
        let l = line.unwrap();
        three_lines.push(l.to_string());
        if three_lines.len() == 3 {
            common.push(find_common(&three_lines[0], &three_lines[1], &three_lines[2]));
            three_lines.clear();
        }
    }

    let mut sum = 0;
    for m in &common {
        sum += priority_of(&m);
    }
    println!("shared items: {:?}", common);
    println!("priority sum: {}", sum);
}
