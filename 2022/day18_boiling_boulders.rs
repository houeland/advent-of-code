use std::io::{self, BufRead};
use std::collections::HashSet;
use std::collections::VecDeque;

#[derive(Debug, Eq, PartialEq, Hash, Clone)]
struct Cube {
    x: i32,
    y: i32,
    z: i32,
}

fn parse(lines: &[String]) -> Vec<Cube> {
    return lines.iter().map(|l| {
        let s: Vec<_> = l.split(",").map(|x| x.parse::<i32>().unwrap()).collect();
        Cube { x: s[0], y: s[1], z: s[2] }
    }).collect();
}

fn solve(input: &[Cube]) {
    let mut hs = HashSet::new();
    for c in input {
        hs.insert(c);
    }
    let mut uncovered = 0;
    for c in input {
        let check = |dx: i32, dy: i32, dz: i32| -> bool {
            let newc = Cube { x: c.x + dx, y: c.y + dy, z: c.z + dz };
            return !hs.contains(&newc);
        };
        if check(-1, 0, 0) { uncovered += 1; }
        if check(1, 0, 0) { uncovered += 1; }
        if check(0, -1, 0) { uncovered += 1; }
        if check(0, 1, 0) { uncovered += 1; }
        if check(0, 0, -1) { uncovered += 1; }
        if check(0, 0, 1) { uncovered += 1; }
    }
    println!("uncovered sides (part1): {uncovered}");

    let mut visited = HashSet::new();
    let mut q = VecDeque::new();
    q.push_back(Cube { x: -5, y: -5, z: -5 });
    let mut reachable = 0;
    while !q.is_empty() {
        let c = q.pop_front().unwrap();
        if visited.contains(&c) { continue; }
        visited.insert(c.clone());
        if c.x < -5 || c.x >= 25 { continue; }
        if c.y < -5 || c.y >= 25 { continue; }
        if c.z < -5 || c.z >= 25 { continue; }
        let mut check = |dx: i32, dy: i32, dz: i32| {
            let newc = Cube { x: c.x + dx, y: c.y + dy, z: c.z + dz };
            if hs.contains(&newc) {
                reachable += 1;
            } else {
                q.push_back(newc);
            }
        };
        check(-1, 0, 0);
        check(1, 0, 0);
        check(0, -1, 0);
        check(0, 1, 0);
        check(0, 0, -1);
        check(0, 0, 1);
    }
    println!("reachable from outside (part2): {reachable}");
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
