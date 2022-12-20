use std::io::{self, BufRead};
use std::collections::HashMap;
use std::collections::HashSet;

#[derive(Debug, Clone)]
struct Valve<'a> {
    label: &'a str,
    flow_rate: i32,
    tunnels: Vec<&'a str>,
}

fn parse_valve<'a>(l: &'a str) -> Valve<'a> {
    let parts: Vec<_> = l.strip_prefix("Valve ").unwrap().split(" has flow rate=").collect();
    // println!("parts: {:?}", parts);
    assert!(parts.len() == 2);
    let label = parts[0];
    for split in ["; tunnel leads to valve ", "; tunnels lead to valves "] {
        let next: Vec<_> = parts[1].split(split).collect();
        if next.len() == 2 {
            let flow_rate = next[0].parse::<i32>().unwrap();
            let tunnels = next[1].split(", ").collect();
            return Valve { label, flow_rate, tunnels };
        }
    }
    panic!("could not parse valve: {l}", l=l);
}

fn parse<'a>(lines: &'a [String]) -> Vec<Valve<'a>> {
    let mut v = Vec::new();
    for l in lines {
        v.push(parse_valve(l));
    }
    return v;
}

fn compute_distances<'a>(input: &'a [Valve]) -> HashMap<(&'a str, &'a str), i32> {
    let mut m: HashMap<(&str, &str), i32> = HashMap::new();
    for a in input {
        for b in input {
            m.insert((&a.label, &b.label), 1000);
        }
    }

    for v in input {
        for t in &v.tunnels {
            m.insert((&v.label, t), 1);
        }
    }

    let keys: Vec<&str> = input.iter().map(|v| v.label).collect();

    for k in &keys {
        for i in &keys {
            for j in &keys {
                let ik = *m.get(&(&i,&k)).unwrap();
                let kj = *m.get(&(&k,&j)).unwrap();
                let ij = *m.get(&(&i,&j)).unwrap();
                if ik + kj < ij {
                    m.insert((&i, &j), ik + kj);
                }
            }
        }
    }
    return m;
}

fn desc(seen: &HashSet<&str>) -> String {
    let mut a: Vec<&str> = seen.iter().map(|s| *s).collect();
    a.sort();
    return a.join(",");
}

fn recurse<'a>(steps_remaining: i32, ele_steps: i32, pressure_freed: i32, flow_rate: i32, cur_valve: &'a Valve<'a>, ele_valve: &'a Valve<'a>, seen: &mut HashSet<&'a str>, valves: &'a [Valve], minutes_remaining: i32, time_to_move: &HashMap<(&'a str, &'a str), i32>, memo: &mut HashMap<((i32, &'a str), (i32, &'a str), i32, i32, String), i32>) -> i32 {
    let mut best = pressure_freed + flow_rate * minutes_remaining;
    if steps_remaining == 0 {
        for v in valves {
            if v.flow_rate == 0 { continue; }
            if seen.contains(v.label) { continue; }
            let d = *time_to_move.get(&(cur_valve.label, v.label)).unwrap();
            if minutes_remaining >= d + 1 {
                seen.insert(v.label);
                let rv = recurse(d + 1, ele_steps, pressure_freed, flow_rate, v, ele_valve, seen, valves, minutes_remaining, time_to_move, memo);
                best = std::cmp::max(best, rv);
                seen.remove(v.label);
            }
        }
    }
    if ele_steps == 0 {
        for v in valves {
            if v.flow_rate == 0 { continue; }
            if seen.contains(v.label) { continue; }
            let d = *time_to_move.get(&(ele_valve.label, v.label)).unwrap();
            if minutes_remaining >= d + 1 {
                seen.insert(v.label);
                let rv = recurse(steps_remaining, d + 1, pressure_freed, flow_rate, cur_valve, v, seen, valves, minutes_remaining, time_to_move, memo);
                best = std::cmp::max(best, rv);
                seen.remove(v.label);
            }
        }
    }
    let mut new_flow_rate = flow_rate;
    if steps_remaining == 1 {
        new_flow_rate += cur_valve.flow_rate;
    }
    if ele_steps == 1 {
        new_flow_rate += ele_valve.flow_rate;
    }
    if minutes_remaining > 0 {
        let (old, lookup) = {
            if minutes_remaining % 8 == 0 {
                let mekey = (steps_remaining - 1, cur_valve.label);
                let elekey = (ele_steps - 1, ele_valve.label);
                let lookup = if mekey < elekey {
                    (mekey, elekey, new_flow_rate, minutes_remaining - 1, desc(seen))
                } else {
                    (elekey, mekey, new_flow_rate, minutes_remaining - 1, desc(seen))
                };
                let old = memo.get(&lookup);
                (old, Some(lookup))
            } else {
                (None, None)
            }
        };
        // println!("old: {old:?}");
        if *old.unwrap_or(&-1000) < pressure_freed + flow_rate {
            let rv = recurse(steps_remaining - 1, ele_steps - 1, pressure_freed + flow_rate, new_flow_rate, cur_valve, ele_valve, seen, valves, minutes_remaining - 1, time_to_move, memo);
            best = std::cmp::max(best, rv);
            match lookup {
                Some(lkey) => {
                    memo.insert(lkey, pressure_freed + flow_rate);
                },
                None => (),
            }
        }
    }
    best
}

fn solve(input: &[Valve]) {
    let time_to_move = compute_distances(&input);

    let mut s = HashSet::new();
    for v in input {
        if v.label == "AA" {
            println!("most pressure reduced (part 1): {}", recurse(0, 1000, 0, 0, v, v, &mut s, input, 30, &time_to_move, &mut HashMap::new()));
            println!("most pressure reduced with elephant (part 2): {}", recurse(0, 0, 0, 0, v, v, &mut s, input, 26, &time_to_move, &mut HashMap::new()));
        }
    }
}

fn main() {
    let mut lines: Vec<String> = Vec::new();
    for line in io::stdin().lock().lines() {
        lines.push(line.unwrap());
    }
    let parsed: Vec<Valve> = parse(&lines);
    // println!("parsed: {:?}", parsed);
    solve(&parsed);
}
