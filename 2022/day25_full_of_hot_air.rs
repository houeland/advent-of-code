use std::io::{self, BufRead};
use std::collections::HashSet;
use std::collections::HashMap;
use std::convert::TryFrom;

#[derive(Debug, Copy, Clone)]
enum Num {
    Two,
    One,
    Zero,
    Minus,
    DoubleMinus,
}

fn parse(lines: &[String]) -> Vec<Vec<Num>> {
    let mut vv = vec![];
    for l in lines.iter() {
        let mut v = vec![];
        for c in l.chars() {
            v.push(match c {
                '2' => Num::Two,
                '1' => Num::One,
                '0' => Num::Zero,
                '-' => Num::Minus,
                '=' => Num::DoubleMinus,
                _ => panic!("unexpected line: {}", l),
            });
        }
        vv.push(v);
    }
    return vv;
}

fn snafu_num_to_decimal(n: Num) -> i64 {
    match n {
        Num::Two => 2,
        Num::One => 1,
        Num::Zero => 0,
        Num::Minus => -1,
        Num::DoubleMinus => -2,
    }
}

fn snafu_to_decimal(input: &Vec<Num>) -> i64 {
    let mut output = 0;
    for v in input {
        output *= 5;
        output += snafu_num_to_decimal(*v);
    }
    return output;
}

fn snafu_to_string(input: &Vec<Num>) -> String {
    let mut v = vec![];
    for c in input {
        v.push(match c {
            Num::Two => '2',
            Num::One => '1',
            Num::Zero => '0',
            Num::Minus => '-',
            Num::DoubleMinus => '=',
        });
    }
    return v.iter().collect();
}

fn decimal_to_snafu(input: i64) -> Vec<Num> {
    let mut v = vec![];
    let mut remaining = input;
    while remaining != 0 {
        let s = match (remaining % 5 + 5) % 5 {
            0 => Num::Zero,
            1 => Num::One,
            2 => Num::Two,
            3 => Num::DoubleMinus,
            4 => Num::Minus,
            _ => unreachable!(),
        };
        let val = snafu_num_to_decimal(s);
        // println!("remaining: {remaining} ==> s={s:?}, val={val}");
        remaining = (remaining - val) / 5;
        v.push(s);
    }
    v.reverse();
    return v;
}

fn solve(input: &[Vec<Num>]) {
    let mut sum = 0;
    for l in input {
        let d = snafu_to_decimal(l);
        println!("{} ==> {d}", snafu_to_string(l));
        let s = decimal_to_snafu(d);
        println!("  {d} ==> {}", snafu_to_string(&s));
        assert!(snafu_to_string(l) == snafu_to_string(&s));
        sum += d;
    }
    println!("sum = {sum}");
    println!("sum as snafu number (part 1): {}", snafu_to_string(&decimal_to_snafu(sum)));
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
