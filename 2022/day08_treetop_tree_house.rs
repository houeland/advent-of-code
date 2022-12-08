use std::io::{self, BufRead};
use std::collections::HashSet;

fn solve_part1(rows: &Vec<Vec<i32>>) {
    let mut seen = HashSet::new();
    let width = rows[0].len();
    let height = rows.len();
    for y in 0..height {
        let mut tallest = -1;
        for x in 0..width {
            let tree = rows[y][x];
            if tree > tallest {
                tallest = tree;
                seen.insert((x, y));
            }
        }
        tallest = -1;
        for x in (0..width).rev() {
            let tree = rows[y][x];
            if tree > tallest {
                tallest = tree;
                seen.insert((x, y));
            }
        }
    }
    for x in 0..width {
        let mut tallest = -1;
        for y in 0..height {
            let tree = rows[y][x];
            if tree > tallest {
                tallest = tree;
                seen.insert((x, y));
            }
        }
        tallest = -1;
        for y in (0..height).rev() {
            let tree = rows[y][x];
            if tree > tallest {
                tallest = tree;
                seen.insert((x, y));
            }
        }
    }
    println!("count visible from edges (part1): {}", seen.len())
}

fn compute_scenic_score(rows: &Vec<Vec<i32>>, sx: usize, sy: usize) -> i32 {
    let width = rows[0].len();
    let height = rows.len();
    let myheight = rows[sy][sx];
    let mut left = 0;
    for x in (0..sx).rev() {
        let y = sy;
        let tree = rows[y][x];
        left += 1;
        if tree >= myheight {
            break;
        }
    }
    let mut right = 0;
    for x in (sx+1)..width {
        let y = sy;
        let tree = rows[y][x];
        right += 1;
        if tree >= myheight {
            break;
        }
    }
    let mut up = 0;
    for y in (0..sy).rev() {
        let x = sx;
        let tree = rows[y][x];
        up += 1;
        if tree >= myheight {
            break;
        }
    }
    let mut down = 0;
    for y in (sy+1)..height {
        let x = sx;
        let tree = rows[y][x];
        down += 1;
        if tree >= myheight {
            break;
        }
    }
    // println!("x={} y={} myheight={}, left={} right={} up={} down={}, scenic_score={}", sx, sy, myheight, left, right, up, down, left * right * up * down);
    return left * right * up * down;
}

fn solve_part2(rows: &Vec<Vec<i32>>) {
    let mut most_scenic_score = -1;
    let width = rows[0].len();
    let height = rows.len();
    for y in 0..height {
        for x in 0..width {
            most_scenic_score = std::cmp::max(most_scenic_score, compute_scenic_score(&rows, x, y));
        }
    }
    println!("most scenic score (part2): {}", most_scenic_score);
}

fn parse(lines: Vec<String>) -> Vec<Vec<i32>> {
    let mut vec = Vec::new();
    for l in lines {
        let row = l.chars().map(|c| c.to_string().parse::<i32>().unwrap()).collect::<Vec<_>>();
        vec.push(row);
    }
    return vec;
}

fn main() {
    let mut lines = Vec::new();
    for line in io::stdin().lock().lines() {
        lines.push(line.unwrap());
    }
    let parsed = parse(lines);
    solve_part1(&parsed);
    solve_part2(&parsed);
}
