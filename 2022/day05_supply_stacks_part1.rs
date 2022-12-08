use std::io::{self, BufRead};
use std::collections::HashMap;

fn parse_drawing(lines: &Vec<String>) -> (Vec<Vec<char>>, HashMap<String, usize>) {
    let num_cols = (lines[0].len() + 1) / 4;
    let mut stacks = Vec::new();
    for _ in 0..num_cols {
        stacks.push(Vec::new());
    }
    for i in 0..lines.len()-1 {
        let l = &lines[i];
        // println!("D: {}", l);
        let mut skip = 1;
        for (ci, c) in l.chars().enumerate() {
            if skip == 0 {
                let col = (ci-1)/4;
                // println!("  c={} ==> col #{} = {}", ci, col+1, c);
                skip = 4;
                if c != ' ' {
                    stacks[col].push(c)
                }
            }
            skip -= 1;
        }
    }
    for s in &mut stacks {
        s.reverse();
    }
    let mut mapping = HashMap::new();
    for col in lines[lines.len()-1].split_whitespace() {
        mapping.insert(col.to_string(), mapping.len());
    }
    return (stacks, mapping);
}

fn main() {
    let mut stacks: Vec<Vec<char>> = Vec::new();
    let mut mapping = HashMap::new();
    let mut lines = Vec::new();
    let mut parsed = false;
    for line in io::stdin().lock().lines() {
        let l = line.unwrap();
        if parsed {
            let splits: Vec<_> = l.split_whitespace().collect();
            let cnt = splits[1].parse::<i32>().unwrap();
            let from: usize = *mapping.get(splits[3]).unwrap();
            let to: usize = *mapping.get(splits[5]).unwrap();
            for _ in 0..cnt {
                // println!("M: mv from {} to {}", from, to);
                let v = stacks[from].pop().unwrap();
                stacks[to].push(v);
            }
        } else if l == "" {
            let (nstacks, nmapping) = parse_drawing(&lines);
            stacks = nstacks;
            mapping = nmapping;
            parsed = true;
        } else {
            lines.push(l.to_string());
        }
    }

    for s in &stacks {
        println!("stack: {:?}", s);
    }

    println!("solution: {:?}", stacks.iter().map(|x| x[x.len()-1]).collect::<String>());
}
