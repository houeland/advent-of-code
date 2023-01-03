use std::io::{self, BufRead};
use std::collections::HashMap;
use std::convert::TryFrom;

#[derive(Debug, Copy, Clone)]
enum Tile {
    Invalid,
    Open,
    Wall,
}

#[derive(Debug, Copy, Clone)]
enum Facing {
    Up,
    Down,
    Left,
    Right,
}

#[derive(Debug)]
enum Step {
    Forwards(i32),
    TurnLeft,
    TurnRight,
}

#[derive(Debug, Hash, Eq, PartialEq, Clone)]
struct Point {
    x: i32,
    y: i32,
}

fn parse_path(line: &str) -> Vec<Step> {
    let s = line.replace("R", "|R|").replace("L", "|L|");
    let mut v = Vec::new();
    for it in s.split("|") {
        // println!("it: {it}");
        let step = match it {
            "L" => Step::TurnLeft,
            "R" => Step::TurnRight,
            other => Step::Forwards(other.parse::<i32>().unwrap()),
        };
        v.push(step);
    }
    return v;
}

fn parse(lines: &[String]) -> (HashMap<Point, Tile>, Vec<Step>) {
    let mut m = HashMap::new();
    let mut path = Vec::new();
    for (y, l) in lines.iter().enumerate() {
        if y == lines.len() - 1 {
            path = parse_path(l);
            continue;
        }
        for (x, c) in l.chars().enumerate() {
            let tile = match c {
                ' ' => Tile::Invalid,
                '.' => Tile::Open,
                '#' => Tile::Wall,
                _ => panic!("unexpected line: {}", l),
            };
            // println!("x={x} y={y} tile={tile:?}");
            m.insert(Point { x: i32::try_from(x).unwrap() + 1, y: i32::try_from(y).unwrap() + 1 }, tile);
        }
    }
    return (m, path);
}

fn find_starting_position(map: &HashMap<Point, Tile>) -> Point {
    for x in 1.. {
        let p = Point { x, y: 1 };
        if let Some(t) = map.get(&p) {
            match t {
                Tile::Invalid => {},
                Tile::Open => return p,
                Tile::Wall => return p,
            }
        }
    }
    unreachable!();
}

fn find_cube_sides(map: &HashMap<Point, Tile>, cube_length: i32) -> i32 {
    let mut assigned = HashMap::new();
    let mut side_num = 1;
    for y in 0..(cube_length * 6) {
        for x in 0..(cube_length * 6) {
            let p = Point { x, y };
            match map.get(&p) {
                Some(Tile::Open) | Some(Tile::Wall) => {
                    if let None = assigned.get(&p) {
                        println!("found something at {p:?}, assigning side {side_num}");
                        for j in 0..cube_length {
                            for i in 0..cube_length {
                                let p = Point { x: x + i, y : y + j };
                                assigned.insert(p, side_num);
                            }
                        }
                        side_num += 1;
                    }
                }
                _ => {},
            }
        }
    }
    return -123;
}

fn turn_right(f: Facing) -> Facing {
    match f {
        Facing::Up => Facing::Right,
        Facing::Right => Facing::Down,
        Facing::Down => Facing::Left,
        Facing::Left => Facing::Up,
    }
}

fn turn_left(f: Facing) -> Facing {
    return turn_right(turn_right(turn_right(f)));
}

fn facing_value(f: Facing) -> i32 {
    match f {
        Facing::Up => 3,
        Facing::Right => 0,
        Facing::Down => 1,
        Facing::Left => 2,
    }
}

fn solve((map, path): &(HashMap<Point, Tile>, Vec<Step>), cube_length: i32) {
    let get_at = |pos: &Point| -> Tile {
        match map.get(&pos) {
            Some(t) => *t,
            None => Tile::Invalid,
        }
    };
    let peek_front = |pos: &Point, dir: Facing| -> (Point, Tile) {
        let where_to = match dir {
            Facing::Up => Point { x: pos.x, y: pos.y - 1 },
            Facing::Down => Point { x: pos.x, y: pos.y + 1 },
            Facing::Left => Point { x: pos.x - 1, y: pos.y },
            Facing::Right => Point { x: pos.x + 1, y: pos.y },
        };
        let found = get_at(&where_to);
        return (where_to, found);
    };
    let wrap_around_from_invalid = |pos: Point, dir: Facing| -> Point {
        let mut here = pos.clone();
        let check = turn_right(turn_right(dir));
        println!("teleport from: {here:?}");
        loop {
            let (next, there) = peek_front(&here, check);
            if let Tile::Invalid = there {
                break;
            }
            here = next;
        }
        println!("teleport to: {here:?}");
        return here;
    };
    let next_pos = |pos: Point, dir: Facing| -> Point {
        let (where_to, found) = peek_front(&pos, dir);
        let next = match found {
            Tile::Open => where_to,
            Tile::Wall => where_to,
            Tile::Invalid => wrap_around_from_invalid(where_to, dir),
        };
        let there = get_at(&next);
        match there {
            Tile::Open => next,
            Tile::Wall => pos,
            Tile::Invalid => unreachable!(),
        }
    };
    let mut pos = find_starting_position(map);
    let sides = find_cube_sides(map, cube_length);
    let mut dir = Facing::Right;
    // println!("map: {map:?}");
    // println!("path: {path:?}");
    println!("pos: {pos:?}, dir: {dir:?}");
    for p in path {
        match p {
            Step::Forwards(amt) => for _ in 0..*amt { pos = next_pos(pos, dir); },
            Step::TurnLeft => dir = turn_left(dir),
            Step::TurnRight => dir = turn_right(dir),
        };
        println!("pos: {pos:?}, dir: {dir:?}");
    }
    let password = 1000 * pos.y + 4 * pos.x + facing_value(dir);
    println!("final password (part 1): {password}");
}

fn main() {
    let mut lines: Vec<String> = Vec::new();
    for line in io::stdin().lock().lines() {
        lines.push(line.unwrap());
    }
    let parsed = parse(&lines);
    let cube_length = match lines.len() {
        14 => 4,
        202 => 50,
        _ => panic!("unexpected map input"),
    };
    // println!("parsed: {parsed:?}");
    solve(&parsed, cube_length);
}
