use std::io::{self, BufRead};
use std::collections::HashSet;

#[derive(Debug)]
enum Move {
    Up,
    Down,
    Left,
    Right,
}

fn parse(lines: Vec<String>) -> Vec<(Move, usize)> {
    let mut vec = Vec::new();
    for l in lines {
        let parts = l.split_whitespace().collect::<Vec<_>>();
        let repeats = parts[1].parse::<usize>().unwrap();
        let m = match parts[0] {
            "U" => Move::Up,
            "D" => Move::Down,
            "L" => Move::Left,
            "R" => Move::Right,
            _ => panic!("cannot parse line: {}", l),
        };
        vec.push((m, repeats));
    }
    return vec;
}

fn solve(input: &Vec<(Move, usize)>, rope_length: usize) -> usize {
    let mut visited = HashSet::new();
    let mut chain = vec![(0,0); rope_length];
    visited.insert(chain[chain.len()-1]);
    for m in input {
        for _ in 0..(m.1) {
            // let before = chain.clone();
            let h = &mut chain[0];
            match &m.0 {
                Move::Up => *h = (h.0, h.1 - 1),
                Move::Down => *h = (h.0, h.1 + 1),
                Move::Left => *h = (h.0 - 1, h.1),
                Move::Right => *h = (h.0 + 1, h.1),
            }
            for idx in 1..chain.len() {
                let a = chain[idx-1];
                let b = &mut chain[idx];
                let dx: i32 = a.0 - b.0;
                let dy: i32 = a.1 - b.1;
                if dx.abs() > 1 || dy.abs() > 1 {
                    let mut nx = b.0;
                    let mut ny = b.1;
                    if dx > 0 {
                        nx = b.0 + 1;
                    }
                    if dx < 0 {
                        nx = b.0 - 1;
                    }
                    if dy > 0 {
                        ny = b.1 + 1;
                    }
                    if dy < 0 {
                        ny = b.1 - 1;
                    }
                    *b = (nx, ny);
                }
            }
            visited.insert(chain[chain.len()-1]);
        }
    }
    for y in (-10)..10+1 {
        for x in (-15)..15+1 {
            if visited.contains(&(x,y)) {
                print!("#");
            } else {
                print!(".");
            }
        }
        println!("");
    }
    return visited.len();
}

fn main() {
    let mut lines = Vec::new();
    for line in io::stdin().lock().lines() {
        lines.push(line.unwrap());
    }
    let parsed = parse(lines);
    // println!("parsed: {:?}", parsed);
    println!("tiny tail positions visited (part 1): {}", solve(&parsed, 2));
    println!("long tail positions visited (part 2): {}", solve(&parsed, 10));
}
