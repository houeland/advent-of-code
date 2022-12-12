use std::io::{self, BufRead};

#[derive(Debug, Clone)]
enum Value {
    Old,
    Constant(i64),
}

#[derive(Debug, Clone)]
enum Operator {
    Add,
    Multiply,
}

#[derive(Debug, Clone)]
struct Operation {
    left: Value,
    operator: Operator,
    right: Value,
}

#[derive(Debug, Clone)]
struct Monkey {
    items: Vec<i64>,
    operation: Operation,
    divisibility_test: i64,
    test_true_target: usize,
    test_false_target: usize,
    num_times_inspected: i64,
}

fn parse_starting_items(line: &str) -> Vec<i64> {
    let tail = line.split(": ").last().unwrap();
    let numbers = tail.split(", ").map(|x| x.parse::<i64>().unwrap()).collect();
    // println!("{} ==> {} ==> {:?}", line, tail, numbers);
    return numbers;
}

fn parse_operation(line: &str) -> Operation {
    let tail = line.split("new = ").last().unwrap();
    let parts = tail.split(" ").collect::<Vec<_>>();
    let parse_value = |s| match s {
        "old" => Value::Old,
        i => Value::Constant(i.parse::<i64>().unwrap()),
    };
    let operator = match parts[1] {
        "+" => Operator::Add,
        "*" => Operator::Multiply,
        _ => panic!("unexpected operation: {}", tail),
    };
    return Operation {
        left: parse_value(parts[0]),
        operator,
        right: parse_value(parts[2]),
    };
}

fn parse_divisibility_test(line: &str) -> i64 {
    let tail = line.split("divisible by ").last().unwrap();
    let number = tail.parse::<i64>().unwrap();
    return number;
}

fn parse_target_monkey(line: &str) -> usize {
    let tail = line.split("throw to monkey ").last().unwrap();
    let number = tail.parse::<usize>().unwrap();
    return number;
}

fn parse(lines: Vec<String>) -> Vec<Monkey> {
    let mut vec = Vec::new();
    let mut idx = 0;
    loop {
        if idx >= lines.len() { break; }
        let items = parse_starting_items(&lines[idx+1]);
        let operation = parse_operation(&lines[idx+2]);
        let divisibility_test = parse_divisibility_test(&lines[idx+3]);
        let test_true_target = parse_target_monkey(&lines[idx+4]);
        let test_false_target = parse_target_monkey(&lines[idx+5]);
        vec.push(Monkey {
            items,
            operation,
            divisibility_test,
            test_true_target,
            test_false_target,
            num_times_inspected: 0,
        });
        idx += 7;
    }
    return vec;
}

fn inspect(op: &Operation, item: i64, divisor: i64, mod_factor: i64) -> i64 {
    let eval_value = |v: &Value| match &v {
        Value::Old => item,
        Value::Constant(x) => *x,
    };
    let after_inspect = match &op.operator {
        Operator::Add => eval_value(&op.left) + eval_value(&op.right),
        Operator::Multiply => eval_value(&op.left) * eval_value(&op.right),
    };
    let after_bored = after_inspect / divisor;
    return after_bored % mod_factor;
}

fn find_new_target_for(_idx: usize, monkey: &mut Monkey, item: i64, divisor: i64, mod_factor: i64) -> (usize, i64) {
    let new_worry = inspect(&monkey.operation, item, divisor, mod_factor);
    monkey.num_times_inspected += 1;
    if (new_worry % monkey.divisibility_test) == 0 {
        // println!("monkey {} item: {} ==> {} ==> yes throw_to {}", idx, item, new_worry, monkey.test_true_target);
        return (monkey.test_true_target, new_worry);
    } else {
        // println!("monkey {} item: {} ==> {} ==> no throw_to {}", idx, item, new_worry, monkey.test_false_target);
        return (monkey.test_false_target, new_worry);
    }
}

fn play_round(mut game: &mut Vec<Monkey>, divisor: i64, mod_factor: i64) {
    for idx in 0..game.len() {
        let ref mut g = game;
        let items = g[idx].items.clone();
        for i in items {
            let (new_idx, new_worry) = find_new_target_for(idx, &mut g[idx], i, divisor, mod_factor);
            g[new_idx].items.push(new_worry);
        }
        g[idx].items = vec![];
    }
}

fn solve(input: &Vec<Monkey>, divisor: i64, num_rounds: usize) -> i64 {
    let mut mod_factor = 1;
    for m in input {
        mod_factor *= m.divisibility_test;
    }

    let mut game = input.clone();
    for _r in 0..num_rounds {
        play_round(&mut game, divisor, mod_factor);
        // println!("after round {}", _r+1);
        // for (idx, m) in game.iter().enumerate() {
        //     println!("monkey {}: {:?}", idx, m.items);
        // }
        // break;
    }
    // for (idx, m) in game.iter().enumerate() {
    //     println!("monkey {}: {:?}", idx, m.num_times_inspected);
    // }
    let mut monkey_business = game.iter().map(|m| m.num_times_inspected).collect::<Vec<_>>();
    monkey_business.sort();
    monkey_business.reverse();
    // println!("monkey business (part 1): {}", monkey_business[0] * monkey_business[1]);
    return monkey_business[0] * monkey_business[1];
}

fn main() {
    let mut lines = Vec::new();
    for line in io::stdin().lock().lines() {
        lines.push(line.unwrap());
    }
    let parsed = parse(lines);
    // println!("parsed: {:?}", parsed);
    println!("monkey business (part 1): {}", solve(&parsed, 3, 20));
    println!("monkey business (part 2): {}", solve(&parsed, 1, 10000));
}
