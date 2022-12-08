use std::io::{self, BufRead};
use std::collections::VecDeque;

fn has_repeats(v: &VecDeque<char>) -> bool {
    for i in 0..v.len() {
        for j in i+1..v.len() {
            if v[i] == v[j] { return true; }
        }
    }
    return false;
}

fn solve(line: &str) {
    let mut seen = VecDeque::new();
    
    for (i, c) in line.chars().enumerate() {
        if seen.len() == 14 {
            seen.pop_front();
        }
        seen.push_back(c);
        if seen.len() == 14 && !has_repeats(&seen) {
            println!("start message: {}", i+1);
            return;
        }
    }
    panic!("no packet found");
}

fn main() {
    for line in io::stdin().lock().lines() {
        let l = line.unwrap();
        solve(&l);
    }
}
