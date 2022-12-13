use std::io::{self, BufRead};
use std::collections::HashMap;
use std::collections::VecDeque;

#[derive(Debug)]
struct Map {
    heights: Vec<Vec<i32>>,
    start_position: (usize, usize),
    target_position: (usize, usize),
}

fn parse(lines: Vec<String>) -> Map {
    let mut vec = Vec::new();
    let mut start_position = (0, 0);
    let mut target_position = (0, 0);
    for (y, l) in lines.iter().enumerate() {
        let mut row = Vec::new();
        for (x, c) in l.chars().enumerate() {
            let height = match c {
                'S' => {
                    start_position = (x, y);
                    1
                },
                'E' => {
                    target_position = (x, y);
                    26
                },
                'a' => 1,
                'b' => 2,
                'c' => 3,
                'd' => 4,
                'e' => 5,
                'f' => 6,
                'g' => 7,
                'h' => 8,
                'i' => 9,
                'j' => 10,
                'k' => 11,
                'l' => 12,
                'm' => 13,
                'n' => 14,
                'o' => 15,
                'p' => 16,
                'q' => 17,
                'r' => 18,
                's' => 19,
                't' => 20,
                'u' => 21,
                'v' => 22,
                'w' => 23,
                'x' => 24,
                'y' => 25,
                'z' => 26,
                _ => panic!("unexpected line: {}, char: {}", l, c),
            };
            row.push(height);
        }
        vec.push(row);
    }
    return Map {
        heights: vec,
        start_position,
        target_position,
    };
}

fn solve(input: &Map, include_all_starts: bool) -> i32 {
    let mut min_steps = HashMap::new();
    let mut q = VecDeque::new();
    q.push_back((input.start_position, 0, 0));
    if include_all_starts {
        for (y, l) in input.heights.iter().enumerate() {
            for (x, h) in l.iter().enumerate() {
                if *h == 1 {
                    q.push_back(((x,y), 0, 0));
                }
            }
        }
    }
    while q.len() > 0 {
        let ((x,y), cost, from_height) = q.pop_front().unwrap();
        // println!("{:?}: {}", (x,y), cost);
        if min_steps.contains_key(&(x,y)) { continue; }
        let height = input.heights[y][x];
        if height > from_height + 1 { continue; }
        min_steps.insert((x,y), cost);
        if x > 0 { q.push_back(((x-1,y), cost+1, height)); }
        if x+1 < input.heights[y].len() { q.push_back(((x+1,y), cost+1, height)); }
        if y > 0 { q.push_back(((x,y-1), cost+1, height)); }
        if y+1 < input.heights.len() { q.push_back(((x,y+1), cost+1, height)); }
    }
    // println!("input: {:?}", input);
    return *min_steps.get(&input.target_position).unwrap();
}

fn main() {
    let mut lines = Vec::new();
    for line in io::stdin().lock().lines() {
        lines.push(line.unwrap());
    }
    let parsed = parse(lines);
    // println!("parsed: {:?}", parsed);
    println!("fewest steps to best signal (part1): {}", solve(&parsed, false));
    println!("fewest steps from any 'a' (part2): {}", solve(&parsed, true));
}
