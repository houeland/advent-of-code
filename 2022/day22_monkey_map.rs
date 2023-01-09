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

#[derive(Debug)]
struct Bounds {
    min_x: i32,
    min_y: i32,
    max_x: i32,
    max_y: i32,
}

#[derive(Debug, Hash, Eq, PartialEq, Clone)]
struct Point3D {
    x: i32,
    y: i32,
    z: i32,
}

fn render_tile(t: &Tile) -> &str {
    match t {
        Tile::Invalid => " ",
        Tile::Open => ".",
        Tile::Wall => "#",
    }
}

fn render_facing(f: &Facing) -> &str {
    match f {
        Facing::Up => "^",
        Facing::Down => "v",
        Facing::Left => "<",
        Facing::Right => ">",
    }
}

fn compute_cross_product(a: &Point3D, b: &Point3D) -> Point3D {
    Point3D {
        x: a.y * b.z - a.z * b.y,
        y: a.z * b.x - a.x * b.z,
        z: a.x * b.y - a.y * b.x,
    }
}

#[derive(Debug)]
struct Side {
    idx: i32,
    center: Point3D,
    dir: Point3D,
    bounds: Bounds,
}

fn find_cube_sides(map: &HashMap<Point, Tile>, cube_length: i32) -> Vec<Side> {
    let mut assigned = HashMap::new();
    let mut side_num = 1;
    for y in 0..(cube_length * 6) {
        for x in 0..(cube_length * 6) {
            let p = Point { x, y };
            match map.get(&p) {
                Some(Tile::Open) | Some(Tile::Wall) => {
                    if let None = assigned.get(&p) {
                        // println!("found something at {p:?}, assigning side {side_num}");
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

    let get_bounds = |idx| {
        let mut min_x = i32::max_value();
        let mut min_y = i32::max_value();
        let mut max_x = i32::min_value();
        let mut max_y = i32::min_value();
        for (p, v) in &assigned {
            if *v == idx {
                min_x = min_x.min(p.x);
                min_y = min_y.min(p.y);
                max_x = max_x.max(p.x);
                max_y = max_y.max(p.y);
            }
        }
        return Bounds { min_x, min_y, max_x, max_y };
    };
    println!("bounds #1: {:?}", get_bounds(1));
    println!("bounds #2: {:?}", get_bounds(2));
    println!("bounds #3: {:?}", get_bounds(3));
    println!("bounds #4: {:?}", get_bounds(4));
    println!("bounds #5: {:?}", get_bounds(5));
    println!("bounds #6: {:?}", get_bounds(6));
    //               . +Z
    //             . .
    //      -Y   .   .
    //    ......     .
    //    .  -Z.     .
    // -X .    . +X.
    //    .    . .
    //    ......
    //      +Y

    let compute_turned = |center: &Point3D, dir: &Point3D| {
        let turning_edge = Point3D { x: center.x + dir.x, y: center.y + dir.y, z: center.z + dir.z };
        let next_center = dir.clone();
        let next_dir = Point3D { x: next_center.x - turning_edge.x, y: next_center.y - turning_edge.y, z: next_center.z - turning_edge.z };
        return (next_center, next_dir);
    };

    let find_neighbors = |idx: i32| {
        let bounds = get_bounds(idx);
        let mut left_idx = -1;
        let mut right_idx = -1;
        let mut top_idx = -1;
        let mut bottom_idx = -1;
        for idx in 1..=6 {
            let other_bounds = get_bounds(idx);
            if other_bounds.max_x == bounds.min_x - 1 && other_bounds.min_y == bounds.min_y && other_bounds.max_y == bounds.max_y {
                left_idx = idx;
            }
            if other_bounds.min_x == bounds.max_x + 1 && other_bounds.min_y == bounds.min_y && other_bounds.max_y == bounds.max_y {
                right_idx = idx;
            }
            if other_bounds.max_y == bounds.min_y - 1 && other_bounds.min_x == bounds.min_x && other_bounds.max_x == bounds.max_x {
                top_idx = idx;
            }
            if other_bounds.min_y == bounds.max_y + 1 && other_bounds.min_x == bounds.min_x && other_bounds.max_x == bounds.max_x {
                bottom_idx = idx;
            }
        }
        // println!("from idx={idx}, left={left_idx}, right={right_idx}, top={top_idx}, bottom={bottom_idx}");
        return (left_idx, right_idx, top_idx, bottom_idx);
    };

    find_neighbors(1);
    find_neighbors(2);
    find_neighbors(3);
    find_neighbors(4);
    find_neighbors(5);
    find_neighbors(6);

    let back_center = Point3D { x: 0, y: 0, z: -1 };
    let back_dir = Point3D { x: 0, y: -1, z: 0 };
    let back_idx = 1;

    let mut known_positions = HashMap::new();
    known_positions.insert(back_idx, (back_center, back_dir));

    for _rounds in 1..=10 {
        // println!("rounds={_rounds}");
        for (idx, (center, dir)) in &known_positions.clone() {
            let (left_idx, right_idx, top_idx, bottom_idx) = find_neighbors(*idx);
            let left_center = compute_cross_product(center, dir);
            let left_dir = dir.clone();
            // println!("idx={idx} center={center:?} dir={dir:?}, left_idx={left_idx} left_center={left_center:?} left_dir={left_dir:?}");

            let left_left_center = compute_cross_product(&left_center, dir);
            let left_left_dir = left_dir.clone();
            // println!("idx={idx} center={center:?} dir={dir:?}, left_left_idx=n/a left_left_center={left_left_center:?} left_left_dir={left_left_dir:?}");

            let right_center = compute_cross_product(&left_left_center, dir);
            let right_dir = left_left_dir.clone();
            // println!("idx={idx} center={center:?} dir={dir:?}, right_idx={right_idx} right_center={right_center:?} right_dir={right_dir:?}");

            let (up_center, up_dir) = compute_turned(center, dir);
            // println!("idx={idx} center={center:?} dir={dir:?}, up_idx={top_idx} up_center={up_center:?} up_dir={up_dir:?}");

            let (up_up_center, up_up_dir) = compute_turned(&up_center, &up_dir);
            // println!("idx={idx} center={center:?} dir={dir:?}, up_up_idx=n/a up_up_center={up_up_center:?} up_up_dir={up_up_dir:?}");

            let (down_center, down_dir) = compute_turned(&up_up_center, &up_up_dir);
            // println!("idx={idx} center={center:?} dir={dir:?}, down_idx={bottom_idx} down_center={down_center:?} down_dir={down_dir:?}");

            if left_idx != -1 {
                known_positions.insert(left_idx, (left_center, left_dir));
            }
            if right_idx != -1 {
                known_positions.insert(right_idx, (right_center, right_dir));
            }
            if top_idx != -1 {
                known_positions.insert(top_idx, (up_center, up_dir));
            }
            if bottom_idx != -1 {
                known_positions.insert(bottom_idx, (down_center, down_dir));
            }
        }
        // println!("known_positions:");
        // for (idx, (center, dir)) in &known_positions {
        //     println!("idx={idx} center={center:?} dir={dir:?}");
        // }
        // println!("");
    }

    let mut v = Vec::new();
    for (idx, (center, dir)) in &known_positions {
        let bounds = get_bounds(*idx);
        v.push(Side { idx: *idx, center: center.clone(), dir: dir.clone(), bounds });
    }
    return v;
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

//     .      // [0] ==> [0] // len 1
//    . .     // [-0.5, +0.5] ==> [-1, +1] // len 2
//   . . .    // [-1, 0, +1] ==> [-2, 0, +2] // len 3
//  . . . .   // [-1.5, -0.5, +0.5, +1.5] ==> [-3, -1, +1, +3] // len 4
// . . . . .  // [-2, -1, 0, +1, +2] ==> [-4, -2, 0, +2, +4] // len 5

fn solve_cube((map, path): &(HashMap<Point, Tile>, Vec<Step>), cube_length: i32) {
    let sides = find_cube_sides(map, cube_length);
    // println!("known_positions:");
    // for s in &sides {
    //     println!("idx={idx} center={center:?} dir={dir:?} bounds={bounds:?}", idx=s.idx, center=s.center, dir=s.dir, bounds=s.bounds);
    // }
    // println!("");

    let mut cube_voxels = HashMap::new();
    let mut cube_pt = Point3D { x: i32::max_value(), y: i32::max_value(), z: i32::max_value() };
    let mut cube_dir = Point3D { x: i32::max_value(), y: i32::max_value(), z: i32::max_value() };
    for s in &sides {
        // -1.5 -0.5 +0.5 +1.5 "real coords"
        // -3 -1 +1 +3   Point3D coords
        let center_3d = Point3D { x: s.center.x * (cube_length+1), y: s.center.y * (cube_length+1), z: s.center.z * (cube_length+1) };
        let center_to_edge_len_2x = cube_length - 1;
        println!("cube_length={cube_length}");
        println!("s: {s:?}");
        let up_dir = s.dir.clone();
        let left_dir = compute_cross_product(&s.center, &s.dir);
        let right_dir = Point3D { x: -left_dir.x, y: -left_dir.y, z: -left_dir.z };
        let down_dir = Point3D { x: -s.dir.x, y: -s.dir.y, z: -s.dir.z };
        println!("up_dir={up_dir:?} left_dir={left_dir:?} right_dir={right_dir:?} down_dir={down_dir:?}");
        for j in 0..cube_length {
            for i in 0..cube_length {
                let p = Point3D { x: center_3d.x + (i*2 - center_to_edge_len_2x) * right_dir.x + (j*2 - center_to_edge_len_2x) * down_dir.x,
                                  y: center_3d.y + (i*2 - center_to_edge_len_2x) * right_dir.y + (j*2 - center_to_edge_len_2x) * down_dir.y,
                                  z: center_3d.z + (i*2 - center_to_edge_len_2x) * right_dir.z + (j*2 - center_to_edge_len_2x) * down_dir.z };
                // print!("(i={i} j={j}) p={p:?} ");
                let p2d = Point { x: s.bounds.min_x + i, y: s.bounds.min_y + j };
                if s.idx == 1 && i == 0 && j == 0 {
                    cube_pt = p.clone();
                    cube_dir = Point3D { x: right_dir.x * 2, y: right_dir.y * 2, z: right_dir.z * 2 };
                }
                cube_voxels.insert(p, p2d);
            }
            // println!("");
        }
        println!("");
    }

    let determine_facing = |cube_pt: &Point3D, cube_dir: &Point3D| -> Facing {
        let map2d_p = cube_voxels.get(&cube_pt).unwrap();
        for s in &sides {
            if map2d_p.x >= s.bounds.min_x && map2d_p.x <= s.bounds.max_x && map2d_p.y >= s.bounds.min_y && map2d_p.y <= s.bounds.max_y {
                let up_dir = s.dir.clone();
                let left_dir = compute_cross_product(&s.center, &s.dir);
                let right_dir = Point3D { x: -left_dir.x, y: -left_dir.y, z: -left_dir.z };
                let down_dir = Point3D { x: -s.dir.x, y: -s.dir.y, z: -s.dir.z };
                if cube_dir.x == up_dir.x*2 && cube_dir.y == up_dir.y*2 && cube_dir.z == up_dir.z*2 {
                    return Facing::Up;
                } else if cube_dir.x == right_dir.x*2 && cube_dir.y == right_dir.y*2 && cube_dir.z == right_dir.z*2 {
                    return Facing::Right;
                } else if cube_dir.x == down_dir.x*2 && cube_dir.y == down_dir.y*2 && cube_dir.z == down_dir.z*2 {
                    return Facing::Down;
                } else if cube_dir.x == left_dir.x*2 && cube_dir.y == left_dir.y*2 && cube_dir.z == left_dir.z*2 {
                    return Facing::Left;
                } else {
                    panic!("Unexpected cube_dir={:?}", cube_dir);
                }
            }
        }
        unreachable!();
    };

    let _draw_debug_map = |cube_pt: &Point3D, cube_dir: &Point3D| {
        let get_at = |pos: &Point| -> Tile {
            match map.get(&pos) {
                Some(t) => *t,
                None => Tile::Invalid,
            }
        };
        let map2d_p = cube_voxels.get(&cube_pt).unwrap();
        let f = determine_facing(&cube_pt, &cube_dir);
        let password = 1000 * map2d_p.y + 4 * map2d_p.x + facing_value(f);
        println!("cube_pt={cube_pt:?} cube_dir={cube_dir:?} map2d_p={map2d_p:?}, password={password}");

        let min_x = sides.iter().map(|s| s.bounds.min_x).min().unwrap();
        let max_x = sides.iter().map(|s| s.bounds.max_x).max().unwrap();
        let min_y = sides.iter().map(|s| s.bounds.min_y).min().unwrap();
        let max_y = sides.iter().map(|s| s.bounds.max_y).max().unwrap();
        for y in min_y..=max_y {
            for x in min_x..=max_x {
                if x == map2d_p.x && y == map2d_p.y {
                    print!("{}", render_facing(&f));
                    continue;
                }
                let t = get_at(&Point { x, y });
                print!("{}", render_tile(&t));
            }
            println!("");
        }
    };

    for p in path {
        // _draw_debug_map(&cube_pt, &cube_dir);
        // println!("");
        let resolve_forward_step = |cube_pt: &Point3D, cube_dir: &Point3D| {
            let next_cube_peek_pt = Point3D { x: cube_pt.x + cube_dir.x, y: cube_pt.y + cube_dir.y, z: cube_pt.z + cube_dir.z };
            if let Some(_next_map2d_p) = cube_voxels.get(&next_cube_peek_pt) {
                // println!("next_map2d_p={_next_map2d_p:?}");
                return (next_cube_peek_pt, cube_dir.clone());
            } else {
                for (dx, dy, dz) in [
                    (-2, 0, 0),
                    (0, -2, 0),
                    (0, 0, -2),
                    (2, 0, 0),
                    (0, 2, 0),
                    (0, 0, 2),
                ] {
                    let probe_pt = Point3D { x: next_cube_peek_pt.x + dx, y: next_cube_peek_pt.y + dy, z: next_cube_peek_pt.z + dz };
                    if probe_pt == *cube_pt {
                        continue;
                    }
                    if let Some(_probe_map2d_p) = cube_voxels.get(&probe_pt) {
                        // println!("probe_pt={probe_pt:?} probe_map2d_p={_probe_map2d_p:?}");
                        let new_dir = Point3D { x: dx, y: dy, z: dz };
                        // println!("new_dir={new_dir:?}");
                        return (probe_pt, new_dir);
                    }
                }
                unreachable!();
            }
        };
        let resolve_left_turn = |cube_pt: &Point3D, cube_dir: &Point3D| -> Point3D {
            let max_edge_len = cube_length + 1;
            let cube_norm_pt = Point3D { x: cube_pt.x / max_edge_len, y: cube_pt.y / max_edge_len, z: cube_pt.z / max_edge_len };
            let left_dir = compute_cross_product(&cube_norm_pt, &cube_dir);
            return left_dir;
        };
        // println!("left turn would be: {:?}", resolve_left_turn(&cube_pt, &cube_dir));
        // let (next_cube_pt, next_cube_dir) = resolve_forward_step(&cube_pt, &cube_dir);
        // cube_pt = next_cube_pt;
        // cube_dir = next_cube_dir;

        // println!("Next move: {p:?}");
        match p {
            Step::Forwards(amt) => for _ in 0..*amt {
                let (next_cube_pt, next_cube_dir) = resolve_forward_step(&cube_pt, &cube_dir);
                let next_map2d_p = cube_voxels.get(&next_cube_pt).unwrap();
                match map.get(&next_map2d_p) {
                    Some(Tile::Open) => {
                        cube_pt = next_cube_pt;
                        cube_dir = next_cube_dir;
                    },
                    Some(Tile::Wall) => {},
                    _ => unreachable!(),
                }
            },
            Step::TurnLeft => cube_dir = resolve_left_turn(&cube_pt, &cube_dir),
            Step::TurnRight => cube_dir = resolve_left_turn(&cube_pt, &resolve_left_turn(&cube_pt, &resolve_left_turn(&cube_pt, &cube_dir))),
        };
    }
    // _draw_debug_map(&cube_pt, &cube_dir);
    {
        let map2d_p = cube_voxels.get(&cube_pt).unwrap();
        let f = determine_facing(&cube_pt, &cube_dir);
        let password = 1000 * map2d_p.y + 4 * map2d_p.x + facing_value(f);
        println!("cube-world password (part 2): {password}");
    }
}

fn solve_2d((map, path): &(HashMap<Point, Tile>, Vec<Step>), _cube_length: i32) {
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
        // println!("teleport from: {here:?}");
        loop {
            let (next, there) = peek_front(&here, check);
            if let Tile::Invalid = there {
                break;
            }
            here = next;
        }
        // println!("teleport to: {here:?}");
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
    let mut dir = Facing::Right;
    // println!("map: {map:?}");
    // println!("path: {path:?}");
    // println!("pos: {pos:?}, dir: {dir:?}");
    for p in path {
        match p {
            Step::Forwards(amt) => for _ in 0..*amt { pos = next_pos(pos, dir); },
            Step::TurnLeft => dir = turn_left(dir),
            Step::TurnRight => dir = turn_right(dir),
        };
        // println!("pos: {pos:?}, dir: {dir:?}");
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
    solve_2d(&parsed, cube_length);
    solve_cube(&parsed, cube_length);
}
