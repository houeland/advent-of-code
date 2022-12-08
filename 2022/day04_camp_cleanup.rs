use std::io::{self, BufRead};
use std::cmp;

fn parse_range(s: &str) -> (i32, i32) {
    let splits = s.split("-").collect::<Vec<_>>();
    return (splits[0].parse::<i32>().unwrap(), splits[1].parse::<i32>().unwrap());
}

fn parse_line(line: &str) -> ((i32, i32), (i32, i32)) {
    let splits = line.split(",").collect::<Vec<_>>();
    let one = parse_range(splits[0]);
    let two = parse_range(splits[1]);
    return (one, two);
}

fn main() {
    let mut pairs = Vec::new();
    for line in io::stdin().lock().lines() {
        let l = line.unwrap();
        pairs.push(parse_line(&l));
    }

    let mut sum_full_overlap = 0;
    let mut sum_any_overlap = 0;
    for p in &pairs {
        println!("pair: {:?}", p);
        let one = p.0;
        let two = p.1;
        let range = (cmp::min(one.0, two.0), cmp::max(one.1, two.1));
        if range == one {
            sum_full_overlap += 1;
        } else if range == two {
            sum_full_overlap += 1;
        } else {
        }

        let overlap = (cmp::max(one.0, two.0), cmp::min(one.1, two.1));
        // println!("overlaps: {:?}", overlap);
        if overlap.1 >= overlap.0 {
            sum_any_overlap += 1;
        }
    }

    println!("fully overlapping ranges: {:?}", sum_full_overlap);
    println!("anywhere overlapping ranges: {:?}", sum_any_overlap);
}
