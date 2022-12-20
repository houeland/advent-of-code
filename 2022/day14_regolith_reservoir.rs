use std::io::{self, BufRead};
use std::collections::HashSet;

fn get_at(pos: &(i32, i32), input: &HashSet<(i32, i32)>, sand: &HashSet<(i32, i32)>) -> char {
    if input.contains(pos) {
        return '#';
    } else if sand.contains(pos) {
        return 'o';
    } else {
        return '.';
    }
}

fn solve(input: &HashSet<(i32, i32)>, with_floor: bool) -> usize {
    let mut sand = HashSet::new();
    let lowest = *input.iter().map(|(_x,y)| y).max().unwrap();
    // println!("lowest: {:?}", lowest);
    loop {
        let oldlen = sand.len();
        let mut pos = (500, 0);
        loop {
            if pos.1 > lowest {
                if with_floor {
                    sand.insert(pos);
                }
                break;
            }
            // println!("pos: {:?}", pos);
            let down = (pos.0, pos.1 + 1);
            let downleft = (pos.0 - 1, pos.1 + 1);
            let downright = (pos.0 + 1, pos.1 + 1);
            if get_at(&down, &input, &sand) == '.' {
                pos = down;
            } else if get_at(&downleft, &input, &sand) == '.' {
                pos = downleft;
            } else if get_at(&downright, &input, &sand) == '.' {
                pos = downright;
            } else {
                sand.insert(pos);
                break;
            }
        }
        if sand.len() == oldlen {
            break;
        }
    }
    return sand.len();
}

fn parse(lines: Vec<String>) -> HashSet<(i32, i32)> {
    let mut h = HashSet::new();
    for l in lines {
        let mut prev: Option<(i32, i32)> = None;
        for p in l.split(" -> ") {
            let vals: Vec<i32> = p.split(",").map(|x| x.parse::<i32>().unwrap()).collect();
            assert!(vals.len() == 2);
            let target = (vals[0], vals[1]);
            // println!("parts: {:?}", target);
            match prev {
                Some(old) => {
                    let mut step = old;
                    loop {
                        // println!("x: ({} - {}).signum() == {}", target.0, step.0, (target.0 - step.0).signum());
                        // println!("y: ({} - {}).signum() == {}", target.1, step.1, (target.1 - step.1).signum());
                        let newx = step.0 + (target.0 - step.0).signum();
                        let newy = step.1 + (target.1 - step.1).signum();
                        step = (newx, newy);
                        // println!("step at: {:?}", step);
                        h.insert(step);
                        if step == target {
                            break;
                        }
                    }
                },
                None => { h.insert(target); },
            }
            prev = Some(target);
        }
    }
    return h;
}

fn main() {
    let mut lines = Vec::new();
    for line in io::stdin().lock().lines() {
        lines.push(line.unwrap());
    }
    let parsed = parse(lines);
    // println!("parsed: {:?}", parsed);
    println!("units of sand that come to rest on top of void (part1): {}", solve(&parsed, false));
    println!("units of sand that come to rest on top of floor (part2): {}", solve(&parsed, true));
}
