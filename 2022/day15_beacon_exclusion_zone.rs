use std::io::{self, BufRead};
use std::collections::HashSet;

#[derive(Debug, Eq, PartialEq, Hash)]
struct Position {
    x: i32,
    y: i32,
}


#[derive(Debug)]
struct Report {
    sensor: Position,
    nearest_beacon: Position,
}

fn dist(a: &Position, b: &Position) -> i32 {
    return (a.x - b.x).abs() + (a.y - b.y).abs();
}

fn parse_position(l: &str) -> Position {
    let parts: Vec<_> = l.strip_prefix("x=").unwrap().split(", y=").collect();
    assert!(parts.len() == 2);
    let x = parts[0].parse::<i32>().unwrap();
    let y = parts[1].parse::<i32>().unwrap();
    return Position { x, y };
}

fn parse(lines: Vec<String>) -> Vec<Report> {
    let mut v = Vec::new();
    for l in lines {
        let parts: Vec<_> = l.strip_prefix("Sensor at ").unwrap().split(": closest beacon is at ").collect();
        assert!(parts.len() == 2);
        v.push(Report {
            sensor: parse_position(parts[0]),
            nearest_beacon: parse_position(parts[1]),
        });
    }
    return v;
}

fn dedupe_mece_ranges(mut ranges: Vec<(i32, i32)>) -> Vec<(i32, i32)> {
    ranges.sort();
    let mut mece = Vec::new();
    let mut ptr = ranges[0].0;
    let mut fully_covered_until = ranges[0].1;
    for r in ranges {
        if r.0 <= fully_covered_until + 1 {
            fully_covered_until = std::cmp::max(fully_covered_until, r.1);
        } else {
            mece.push((ptr, fully_covered_until));
            ptr = r.0;
            fully_covered_until = r.1;
        }
        // println!("r: {:?}, p:{}, fcu: {}", r, ptr, fully_covered_until);
    }
    mece.push((ptr, fully_covered_until));
    return mece;
}

fn solve(input: &Vec<Report>, input_row: i32) {
    let mut beacons = HashSet::new();
    for r in input {
        beacons.insert(&r.nearest_beacon);
    }

    let determine_ranges = |target_row: i32| {
        let mut ranges = Vec::new();
        for r in input {
            let d = dist(&r.sensor, &r.nearest_beacon);
            let plusminus = d - (r.sensor.y - target_row).abs();
            let (from, to) = (r.sensor.x - plusminus, r.sensor.x + plusminus);
            // println!("sensor at {:?}, nearest beacon {:?}, distance {}, covering {:?}", r.sensor, r.nearest_beacon, d, (from, to));
            if from <= to {
                ranges.push((from, to));
            }
        }
        return ranges;
    };

    let mut covered = 0;
    {
        let ranges = determine_ranges(input_row);
        if ranges.len() == 0 {
            return;
        }
        let mece = dedupe_mece_ranges(ranges);
        for m in mece {
            let num_beacons: i32 = beacons.iter().map(|b| b.y == input_row && b.x >= m.0 && b.x <= m.1).map(|b| b as i32).sum();
            println!("covered range: {:?}, with {} beacons", m, num_beacons);
            covered += m.1 + 1 - m.0 - num_beacons;
        }
    }
    println!("row {} positions that cannot contain a beacon (part 1): {}", input_row, covered);

    let mut solution_rows = Vec::new();
    for row in 0..input_row*2+1 {
        let ranges = determine_ranges(row);
        let mece = dedupe_mece_ranges(ranges);
        if mece.len() == 1 { continue; }
        // println!("row {}, mece = {:?}", row, mece);
        assert!(mece.len() == 2);
        solution_rows.push((row, (mece[0], mece[1])));
    }
    if solution_rows.len() == 1 {
        let (y, x_mece) = solution_rows[0];
        assert!((x_mece.1).0 == (x_mece.0).1 + 2);
        let x = (x_mece.0).1 + 1;
        println!("solution: {:?}", (x, y));
        let tuning_frequency = (x as i64) * 4000000 + (y as i64);
        println!("tuning frequency (part 2): {}", tuning_frequency);
    }
}

fn main() {
    let mut lines = Vec::new();
    for line in io::stdin().lock().lines() {
        lines.push(line.unwrap());
    }
    let parsed = parse(lines);
    // println!("parsed: {:?}", parsed);
    solve(&parsed, 10);
    solve(&parsed, 2000000);
}
