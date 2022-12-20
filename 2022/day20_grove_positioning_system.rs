use std::io::{self, BufRead};
use std::convert::TryFrom;

fn parse(lines: &[String]) -> Vec<i64> {
    return lines.iter().map(|l| l.parse().unwrap()).collect();
}

fn mix(v: &mut Vec<(usize, i64)>, which_idx: usize) {
    for idx in 0..v.len() {
        if v[idx].0 == which_idx {
            let val = v[idx].1 % i64::try_from(v.len() - 1).unwrap();
            // println!("val: {} => {val}", v[idx].1);
            let mut i = idx;
            for _back in val..0 {
                let next_i = (i + v.len() - 1) % v.len();
                v.swap(i, next_i);
                // println!("moving back to idx={next_i}:     {:?}", v.iter().map(|z| z.1).collect::<Vec<_>>());
                i = next_i;
            }
            for _forwards in 0..val {
                let next_i = (i + 1) % v.len();
                v.swap(i, next_i);
                // println!("moving forwards to idx={next_i}: {:?}", v.iter().map(|z| z.1).collect::<Vec<_>>());
                i = next_i;
            }
            // println!("found {val} at idx {idx}; result={:?}", v.iter().map(|z| z.1).collect::<Vec<_>>());
            break;
        }
    }
}

fn mix_nums(v: &mut Vec<(usize, i64)>) {
    for idx in 0..v.len() {
        mix(v, idx);
    }
}

fn compute_coordinate_values(v: &[(usize, i64)]) -> i64 {
    let mut zero_idx = 0;
    loop {
        if v[zero_idx].1 == 0 { break; }
        else { zero_idx += 1; }
    }
    let nums = vec![
        v[(zero_idx + 1000) % v.len()].1,
        v[(zero_idx + 2000) % v.len()].1,
        v[(zero_idx + 3000) % v.len()].1,
    ];
    // println!("nums: {nums:?}");
    return nums.iter().sum::<i64>();
}

fn solve(input: &[i64]) {
    let mut v: Vec<(usize, i64)> = input.iter().enumerate().map(|(a,b)| (a, *b)).collect();
    mix_nums(&mut v);
    println!("sum of grove coordinate numbers (part 1): {}", compute_coordinate_values(&v));

    let mut v2: Vec<(usize, i64)> = input.iter().enumerate().map(|(a,b)| (a, *b * 811589153)).collect();
    for _ in 0..10 {
        mix_nums(&mut v2);
        // println!("nums: {:?}", v2.iter().map(|z| z.1).collect::<Vec<_>>());
    }
    println!("sum of key decrypted grove coordinate numbers (part 2): {}", compute_coordinate_values(&v2));
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
