use std::io::{self, BufRead};
use std::collections::HashSet;
use std::collections::HashMap;
use std::convert::TryFrom;

#[derive(Debug, Hash, Eq, PartialEq, Clone)]
struct Point {
    x: i32,
    y: i32,
}

fn parse(lines: &[String]) -> HashSet<Point> {
    let mut s = HashSet::new();
    for (y, l) in lines.iter().enumerate() {
        for (x, c) in l.chars().enumerate() {
            match c {
                '.' => {},
                '#' => {
                    s.insert(Point { x: i32::try_from(x).unwrap(), y: i32::try_from(y).unwrap() });
                },
                _ => panic!("unexpected line: {}", l),
            };
        }
    }
    return s;
}

fn is_empty(elves: &HashSet<Point>, e: &Point, dx: i32, dy: i32) -> bool {
    !elves.contains(&Point {x : e.x + dx, y: e.y + dy })
}

fn remain(elves: &HashSet<Point>, e: &Point) -> Option<Point> {
    for dy in -1..2 {
        for dx in -1..2 {
            if dx == 0 && dy == 0 { continue; }
            if !is_empty(elves, e, dx, dy) {
                return None;
            }
        }
    }
    return Some(e.clone());
}

fn north(elves: &HashSet<Point>, e: &Point) -> Option<Point> {
    if is_empty(elves, e, -1, -1) && is_empty(elves, e, 0, -1) && is_empty(elves, e, 1, -1) {
        Some(Point {x : e.x, y: e.y - 1 })
    } else {
        None
    }
}

fn south(elves: &HashSet<Point>, e: &Point) -> Option<Point> {
    if is_empty(elves, e, -1, 1) && is_empty(elves, e, 0, 1) && is_empty(elves, e, 1, 1) {
        Some(Point {x : e.x, y: e.y + 1 })
    } else {
        None
    }
}

fn west (elves: &HashSet<Point>, e: &Point) -> Option<Point> {
    if is_empty(elves, e, -1, -1) && is_empty(elves, e, -1, 0) && is_empty(elves, e, -1, 1) {
        Some(Point {x : e.x - 1, y: e.y })
    } else {
        None
    }
}

fn east (elves: &HashSet<Point>, e: &Point) -> Option<Point> {
    if is_empty(elves, e, 1, -1) && is_empty(elves, e, 1, 0) && is_empty(elves, e, 1, 1) {
        Some(Point {x : e.x + 1, y: e.y })
    } else {
        None
    }
}

fn play_round(elves: &HashSet<Point>, round_num: usize) -> HashSet<Point> {
    // map[target] = vec![from...]
    let mut proposals = HashMap::new();
    let moves = [north, south, west, east];
    let mut add = |from: &Point, to: Point| {
        let v = proposals.entry(to).or_insert(vec![]);
        v.push(from.clone());
    };
    let suggest = |e: &Point| {
        let mut proposed = remain(elves, e);
        for i in 0..4 {
            let idx = (round_num + i + 3) % 4;
            let prop = moves[idx](elves, e);
            // println!("round_num={round_num}, idx={idx}, prop: {prop:?}");
            proposed = proposed.or(prop);
        }
        proposed = proposed.or(Some(e.clone()));
        // println!("result: {proposed:?}");
        proposed.unwrap()
    };
    for e in elves {
        let p = suggest(e);
        add(e, p);
    }
    // println!("proposals:");
    let mut new_elves = HashSet::new();
    for (a, b) in proposals {
        // println!("  {a:?}: {b:?}");
        if b.len() == 1 {
            new_elves.insert(a);
        } else {     
            new_elves.extend(b);
        }
    }
    new_elves
}

fn draw(elves: &HashSet<Point>) {
    let minx = elves.iter().map(|p| p.x).min().unwrap();
    let maxx = elves.iter().map(|p| p.x).max().unwrap();
    let miny = elves.iter().map(|p| p.y).min().unwrap();
    let maxy = elves.iter().map(|p| p.y).max().unwrap();
    println!("x={minx} to {maxx}, y = {miny} to {maxy}");
    let mut num_empty = 0;
    for y in miny..maxy+1 {
        for x in minx..maxx+1 {
            if elves.contains(&Point { x, y }) {
                print!("#");
            } else {
                print!(".");
                num_empty += 1;
            }
        }
        println!("");
    }
    println!("empty ground tiles in bounding rectangle (part 1): {num_empty}");
}

fn solve(input: &HashSet<Point>) {
    let mut elves = input.clone();
    for round_num in 1.. {
        let new_elves = play_round(&elves, round_num);
        if round_num == 10 {
            println!("end of round #{round_num}:");
            draw(&new_elves);
        }
        if elves == new_elves {
            println!("no more movement in round (part 2): #{round_num}");
            break;
        } else {
            elves = new_elves;
        }
    }
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
