use std::io::{self, BufRead};
use std::collections::HashSet;
use std::convert::TryFrom;

fn find_mistake(line: &str) -> String {
    let split = line.len() / 2;
    let (part1,part2) = line.split_at(split);
    let in_part1: HashSet<char> = part1.chars().collect();
    for c in part2.chars() {
        if in_part1.contains(&c) {
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
    let mut duplicate = Vec::new();
    for line in io::stdin().lock().lines() {
        let l = line.unwrap();
        let mistake = find_mistake(&l);
        duplicate.push(mistake);
    }

    let mut sum = 0;
    for m in &duplicate {
        sum += priority_of(&m);
    }
    println!("shared items: {:?}", duplicate);
    println!("priority sum: {}", sum);
}
