use std::io::{self, BufRead};
use std::collections::HashMap;
use std::collections::HashSet;
use std::convert::TryFrom;

#[derive(Debug, Copy, Clone)]
enum Facing {
    Up,
    Down,
    Left,
    Right,
}

#[derive(Debug, Hash, Eq, PartialEq, Clone)]
struct Point {
    x: i32,
    y: i32,
}

#[derive(Debug)]
struct Bounds {
    min_x: i32,
    max_x: i32,
    min_y: i32,
    max_y: i32,
}

fn parse(lines: &[String]) -> (HashMap<Point, Vec<Facing>>, HashSet<Point>) {
    let mut m = HashMap::new();
    let mut s = HashSet::new();
    for (y, l) in lines.iter().enumerate() {
        for (x, c) in l.chars().enumerate() {
            let p = Point { x: i32::try_from(x).unwrap() + 1, y: i32::try_from(y).unwrap() + 1 };
            let tile = match c {
                '.' => { m.insert(p, vec![]); },
                '#' => { s.insert(p); },
                '>' => { m.insert(p, vec![Facing::Right]); },
                '<' => { m.insert(p, vec![Facing::Left]); },
                '^' => { m.insert(p, vec![Facing::Up]); },
                'v' => { m.insert(p, vec![Facing::Down]); },
                _ => panic!("unexpected line: {}", l),
            };
        }
    }
    return (m, s);
}

fn move_blizzards(m: &HashMap<Point, Vec<Facing>>, walls: &HashSet<Point>) -> HashMap<Point, Vec<Facing>> {
    let mut new_m = HashMap::new();
    for (p, v) in m.iter() {
        new_m.insert(p.clone(), vec![]);
    }
    for (p, v) in m.iter() {
        for f in v.iter() {
            let mut new_p = match f {
                Facing::Up => Point { x: p.x, y: p.y - 1 },
                Facing::Down => Point { x: p.x, y: p.y + 1 },
                Facing::Left => Point { x: p.x - 1, y: p.y },
                Facing::Right => Point { x: p.x + 1, y: p.y },
            };
            if walls.contains(&new_p) {
                match f {
                    Facing::Up => {
                        loop {
                            new_p.y += 1;
                            if walls.contains(&new_p) {
                                new_p.y -= 1;
                                break;
                            }
                        }
                    },
                    Facing::Down => {
                        loop {
                            new_p.y -= 1;
                            if walls.contains(&new_p) {
                                new_p.y += 1;
                                break;
                            }
                        }
                    },
                    Facing::Left => {
                        loop {
                            new_p.x += 1;
                            if walls.contains(&new_p) {
                                new_p.x -= 1;
                                break;
                            }
                        }
                    },
                    Facing::Right => {
                        loop {
                            new_p.x -= 1;
                            if walls.contains(&new_p) {
                                new_p.x += 1;
                                break;
                            }
                        }
                    },
                }
            }
            // println!("moving {:?} from {:?} to {:?}", f, p, new_p);
            new_m.get_mut(&new_p).unwrap().push(*f);
        }
    }
    return new_m;
}

fn draw(blizzards: &HashMap<Point, Vec<Facing>>, walls: &HashSet<Point>, possible: &HashSet<Point>, bounds: &Bounds) {
    for y in bounds.min_y..(bounds.max_y + 1) {
        for x in bounds.min_x..(bounds.max_x + 1) {
            let p = Point { x, y };
            if walls.contains(&p) {
                print!("#");
            } else {
                let v = blizzards.get(&p).unwrap();
                if v.len() == 0 {
                    if possible.contains(&p) {
                        print!("E");
                    } else {
                        print!(".");
                    }
                } else if v.len() == 1 {
                    match v[0] {
                        Facing::Up => print!("^"),
                        Facing::Down => print!("v"),
                        Facing::Left => print!("<"),
                        Facing::Right => print!(">"),
                    }
                } else {
                    print!("{}", v.len());
                }
            }
        }
        println!("");
    }
    println!("");
}

fn find_new_possibilities(m: &HashMap<Point, Vec<Facing>>, walls: &HashSet<Point>, possible: &HashSet<Point>, bounds: &Bounds) -> HashSet<Point> {
    let mut new_possible = HashSet::new();
    for p in possible {
        for new_p in vec![
            Point { x: p.x, y: p.y },
            Point { x: p.x, y: p.y - 1 },
            Point { x: p.x, y: p.y + 1 },
            Point { x: p.x - 1, y: p.y },
            Point { x: p.x + 1, y: p.y },
        ] {
            if new_p.x < bounds.min_x || new_p.x > bounds.max_x || new_p.y < bounds.min_y || new_p.y > bounds.max_y {
                continue;
            }
            if walls.contains(&new_p) {
                continue;
            }
            if m.get(&new_p).unwrap().len() > 0 {
                continue;
            }
            new_possible.insert(new_p);
        }
    }
    return new_possible;
}

fn move_from(minute: &mut i32, map: &mut HashMap<Point, Vec<Facing>>, walls: &HashSet<Point>, bounds: &Bounds, start: &Point, target: &Point) {
    let mut possible = HashSet::new();
    possible.insert(start.clone());
    loop {
        // println!("Minute: {}", minute);
        // draw(&map, walls, &possible, &bounds);
        if possible.contains(&target) {
            // println!("Reached {:?} at minute {}", target, minute);
            return;
        }
        *map = move_blizzards(&map, walls);
        possible = find_new_possibilities(&map, walls, &possible, &bounds);
        *minute += 1;
    }
}

fn solve(m: &HashMap<Point, Vec<Facing>>, walls: &HashSet<Point>) {
    let mut min_x = i32::max_value();
    let mut max_x = i32::min_value();
    let mut min_y = i32::max_value();
    let mut max_y = i32::min_value();
    for p in walls {
        if p.x < min_x { min_x = p.x; }
        if p.x > max_x { max_x = p.x; }
        if p.y < min_y { min_y = p.y; }
        if p.y > max_y { max_y = p.y; }
    }

    let bounds = Bounds { min_x, max_x, min_y, max_y };

    let mut start = Point { x: 0, y: 0 };
    let mut target = Point { x: 0, y: 0 };
    for x in min_x..(max_x+1) {
        if !walls.contains(&Point { x, y: min_y }) {
            start = Point { x, y: min_y };
        }
        if !walls.contains(&Point { x, y: max_y }) {
            target = Point { x, y: max_y };
        }
    }

    let mut minute = 0;
    let mut map = m.clone();
    move_from(&mut minute, &mut map, walls, &bounds, &start, &target);
    println!("Reached target initially at minute (part 1): {}", minute);
    move_from(&mut minute, &mut map, walls, &bounds, &target, &start);
    println!("Reached start again at minute: {}", minute);
    move_from(&mut minute, &mut map, walls, &bounds, &start, &target);
    println!("Reached target again at minute (part 2): {}", minute);
}

fn main() {
    let mut lines: Vec<String> = Vec::new();
    for line in io::stdin().lock().lines() {
        lines.push(line.unwrap());
    }
    let parsed = parse(&lines);
    // println!("parsed: {parsed:?}");
    solve(&parsed.0, &parsed.1);
}
