use std::io::{self, BufRead};
use std::convert::TryFrom;

#[derive(Debug)]
enum Instruction {
    Noop,
    Addx(i32),
}

struct State {
    x_register: i32,
    cur_cycle: usize,
    signal_strength: Vec<(usize, i32)>,
}

fn parse(lines: Vec<String>) -> Vec<Instruction> {
    let mut vec = Vec::new();
    for l in lines {
        let parts = l.split_whitespace().collect::<Vec<_>>();
        let m = match parts[0] {
            "noop" => Instruction::Noop,
            "addx" => {
                let v = parts[1].parse::<i32>().unwrap();
                Instruction::Addx(v)
            },
            _ => panic!("cannot parse line: {}", l),
        };
        vec.push(m);
    }
    return vec;
}

fn inc_cycle(s: &mut State) {
    // println!("cycle #{}: X={}", s.cur_cycle, s.x_register);
    s.signal_strength.push((s.cur_cycle, s.x_register));
    s.cur_cycle += 1;
}

fn solve(input: Vec<Instruction>) {
    let mut state = State { x_register: 1, cur_cycle: 1, signal_strength: Vec::new() };
    let noop = |mut s: &mut State| {
        inc_cycle(&mut s);
    };
    let addx = |mut s: &mut State, addval: i32| {
        inc_cycle(&mut s);
        inc_cycle(&mut s);
        s.x_register += addval;
    };
    for l in input {
        match l {
            Instruction::Noop => noop(&mut state),
            Instruction::Addx(addval) => addx(&mut state, addval),
        }
    }
    let mut signal_sum = 0;
    for (c, x) in &state.signal_strength {
        if *c >= 20 && (*c - 20) % 40 == 0 {
            let signal = i32::try_from(*c).unwrap() * x;
            println!("cycle #{}: X={}, signal={}", c, x, signal);
            signal_sum += signal;
        }
    }
    println!("signal sum (part 1): {}", signal_sum);

    println!("CRT screen (part 2):");
    let mut idx = 0;
    for _y in 0..6 {
        for x in 0..40 {
            let (_c, x_register) = state.signal_strength[idx];
            if (x_register - x).abs() <= 1 {
                print!("#");
            } else {
                print!(".");
            }
            idx += 1;
        }
        println!("");
    }
}

fn main() {
    let mut lines = Vec::new();
    for line in io::stdin().lock().lines() {
        lines.push(line.unwrap());
    }
    let parsed = parse(lines);
    println!("parsed: {:?}", parsed);
    solve(parsed);
}
