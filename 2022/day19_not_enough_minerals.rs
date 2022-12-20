use std::io::{self, BufRead};

#[derive(Debug)]
struct Blueprint {
    blueprint_num: i32,
    ore_robot_ore_cost: i32,
    clay_robot_ore_cost: i32,
    obsidian_robot_ore_cost: i32,
    obsidian_robot_clay_cost: i32,
    geode_robot_ore_cost: i32,
    geode_robot_obsidian_cost: i32,
}

fn parse_ore(s: &str, expected: &str) -> i32 {
    return s.strip_suffix(expected).unwrap().strip_suffix(" ").unwrap().parse().unwrap();
}

fn parse(lines: &[String]) -> Vec<Blueprint> {
    let mut v = Vec::new();
    for l in lines {
        let parts: Vec<_> = l.strip_prefix("Blueprint ").unwrap().split(": ").collect();
        let blueprint_num = parts[0].parse::<i32>().unwrap();
        let robots: Vec<_> = parts[1].strip_suffix(".").unwrap().split(". ").collect();
        // println!("robots: {robots:?}");
        let ore_robot_cost = robots[0].strip_prefix("Each ore robot costs ").unwrap();
        let clay_robot_cost = robots[1].strip_prefix("Each clay robot costs ").unwrap();
        let obsidian_robot_costs = robots[2].strip_prefix("Each obsidian robot costs ").unwrap().split(" and ").collect::<Vec<_>>();
        let geode_robot_costs = robots[3].strip_prefix("Each geode robot costs ").unwrap().split(" and ").collect::<Vec<_>>();
        // println!("robots: {ore_robot_cost:?}  |  {clay_robot_cost:?}  |  {obsidian_robot_costs:?}  |  {geode_robot_costs:?}");
        let ore_robot_ore_cost = parse_ore(ore_robot_cost, "ore");
        let clay_robot_ore_cost = parse_ore(clay_robot_cost, "ore");
        let obsidian_robot_ore_cost = parse_ore(obsidian_robot_costs[0], "ore");
        let obsidian_robot_clay_cost = parse_ore(obsidian_robot_costs[1], "clay");
        let geode_robot_ore_cost = parse_ore(geode_robot_costs[0], "ore");
        let geode_robot_obsidian_cost = parse_ore(geode_robot_costs[1], "obsidian");
        v.push(Blueprint {
            blueprint_num,
            ore_robot_ore_cost,
            clay_robot_ore_cost,
            obsidian_robot_ore_cost,
            obsidian_robot_clay_cost,
            geode_robot_ore_cost,
            geode_robot_obsidian_cost,
        });
    }
    return v;
}

fn tick(s: &mut State) {
    s.ore += s.ore_robots;
    s.clay += s.clay_robots;
    s.obsidian += s.obsidian_robots;
    s.geodes += s.geode_robots;
    s.minutes_remaining -= 1;
}

fn buy_ore_robot(b: &Blueprint, s: &mut State) {
    let mut max_ore_cost = -1;
    // max_ore_cost = std::cmp::max(max_ore_cost, b.ore_robot_ore_cost);
    max_ore_cost = std::cmp::max(max_ore_cost, b.clay_robot_ore_cost);
    max_ore_cost = std::cmp::max(max_ore_cost, b.obsidian_robot_ore_cost);
    max_ore_cost = std::cmp::max(max_ore_cost, b.geode_robot_ore_cost);
    loop {
        if s.ore >= b.ore_robot_ore_cost && s.ore_robots < max_ore_cost {
            tick(s);
            s.ore -= b.ore_robot_ore_cost;
            s.ore_robots += 1;
            break;
        } else {
            tick(s);
            if s.minutes_remaining == 0 { return; }
        }
    }
}

fn buy_clay_robot(b: &Blueprint, s: &mut State) {
    loop {
        if s.ore >= b.clay_robot_ore_cost && s.clay_robots < b.obsidian_robot_clay_cost {
            tick(s);
            s.ore -= b.clay_robot_ore_cost;
            s.clay_robots += 1;
            break;
        } else {
            tick(s);
            if s.minutes_remaining == 0 { return; }
        }
    }
}

fn buy_obsidian_robot(b: &Blueprint, s: &mut State) {
    loop {
        if s.ore >= b.obsidian_robot_ore_cost && s.clay >= b.obsidian_robot_clay_cost && s.obsidian_robots < b.geode_robot_obsidian_cost {
            tick(s);
            s.ore -= b.obsidian_robot_ore_cost;
            s.clay -= b.obsidian_robot_clay_cost;
            s.obsidian_robots += 1;
            break;
        } else {
            tick(s);
            if s.minutes_remaining == 0 { return; }
        }
    }
}

fn buy_geode_robot(b: &Blueprint, s: &mut State) {
    loop {
        if s.ore >= b.geode_robot_ore_cost && s.obsidian >= b.geode_robot_obsidian_cost {
            tick(s);
            s.ore -= b.geode_robot_ore_cost;
            s.obsidian -= b.geode_robot_obsidian_cost;
            s.geode_robots += 1;
            break;
        } else {
            tick(s);
            if s.minutes_remaining == 0 { return; }
        }
    }
}

#[derive(Debug, Clone)]
struct State {
    ore_robots: i32,
    ore: i32,
    clay_robots: i32,
    clay: i32,
    obsidian_robots: i32,
    obsidian: i32,
    geode_robots: i32,
    geodes: i32,
    minutes_remaining: i32,
}

fn recurse(b: &Blueprint, state: State) -> i32 {
    if state.minutes_remaining == 0 {
        // println!("state: {state:?}");
        return state.geodes;
    }
    let mut best = 0;
    for choice in [buy_ore_robot, buy_clay_robot, buy_obsidian_robot, buy_geode_robot] {
        let mut s = state.clone();
        choice(b, &mut s);
        best = std::cmp::max(best, recurse(b, s));
    }
    return best;
}

fn compute_geodes(b: &Blueprint, minutes_remaining: i32) -> i32 {
    return recurse(b, State {
        ore_robots: 1,
        ore: 0,
        clay_robots: 0,
        clay: 0,
        obsidian_robots: 0,
        obsidian: 0,
        geode_robots: 0,
        geodes: 0,
        minutes_remaining,
    });
}

fn solve(input: &[Blueprint]) {
    let mut sum_quality = 0;
    for b in input {
        let geodes = compute_geodes(&b, 24);
        let quality_level = b.blueprint_num * geodes;
        println!("Blueprint #{num}: {geodes} ==> quality_level={quality_level}", num=b.blueprint_num);
        sum_quality += quality_level;
    }
    println!("added up quality levels (part 1): {sum_quality}");
    let mut multiply_result = 1;
    for (idx, b) in input.iter().enumerate() {
        if idx > 2 { break; }
        let geodes = compute_geodes(&b, 32);
        println!("Blueprint #{num}: {geodes}", num=b.blueprint_num);
        multiply_result *= geodes;
    }
    println!("result of multiplying (part 2): {multiply_result}");
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
