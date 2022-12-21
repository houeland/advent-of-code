use std::io::{self, BufRead};
use std::collections::HashMap;

#[derive(Debug, Copy, Clone)]
enum Operation {
    Add,
    Subtract,
    Multiply,
    Divide,
}

#[derive(Debug)]
struct Calculation<'a> {
    a: &'a str,
    b: &'a str,
    op: Operation,
}

#[derive(Debug)]
enum Job<'a> {
    Yell(i64),
    Calculate(Calculation<'a>),
}

#[derive(Debug)]
struct Monkey<'a> {
    name: &'a str,
    job: Job<'a>,
}

fn parse_operation(op: &str) -> Operation {
    match op {
        "+" => Operation::Add,
        "-" => Operation::Subtract,
        "*" => Operation::Multiply,
        "/" => Operation::Divide,
        _ => panic!("cannot parse operation: {}", op),
    }
}

fn parse(lines: &[String]) -> Vec<Monkey> {
    let mut v = Vec::new();
    for l in lines {
        let parts: Vec<_> = l.split(": ").collect();
        assert!(parts.len() == 2);
        let name = parts[0];
        let op_parts: Vec<_> = parts[1].split(" ").collect();
        let job = match op_parts[..] {
            [num] => Job::Yell(num.parse().unwrap()),
            [left, op, right] => Job::Calculate(Calculation { a: left, b: right, op: parse_operation(op) }),
            _ => panic!("cannot parse monkey: {}", l),
        };
        v.push(Monkey { name, job });
    }
    return v;
}

fn compute(a: i64, b: i64, op: Operation) -> i64 {
    match op {
        Operation::Add => a + b,
        Operation::Subtract => a - b,
        Operation::Multiply => a * b,
        Operation::Divide => {
            if a % b == 0 {
                a / b
            } else {
                todo!()
            }
        },
    }
}

fn check<'a>(monkeys: &HashMap<&'a str, &Monkey>, known: &mut HashMap<&'a str, i64>, waiting: &mut HashMap<&'a str, Vec<&'a str>>, name: &'a str) {
    let m = monkeys[name];
    // println!("checking {m:?}...");
    let _show = |n: &str| match known.get(n) {
        Some(v) => println!("  {n} = {v}"),
        None => println!("  {n} unknown"),
    };
    let Calculation { a, b, op } = as_calculation(m);
    // _show(a);
    // _show(b);
    match (known.get(a), known.get(b)) {
        (Some(anum), Some(bnum)) => {
            // println!("    both known! {}, {}, {:?}", anum, bnum, op);
            let result = compute(*anum, *bnum, *op);
            resolve(monkeys, known, waiting, name, result);
        },
        _ => {},
    }
}

fn resolve<'a>(monkeys: &HashMap<&'a str, &Monkey>, known: &mut HashMap<&'a str, i64>, waiting: &mut HashMap<&'a str, Vec<&'a str>>, name: &'a str, val: i64) {
    // println!("resolving {name} to {val}");
    known.insert(name, val);
    let v = waiting.get(name).unwrap_or(&vec![]).clone();
    for w in  v {
        check(monkeys, known, waiting, w);
    }
}

fn prepare_waiting<'a>(input: &[Monkey<'a>]) -> HashMap<&'a str, Vec<&'a str>> {
    let mut waiting = HashMap::new();
    for m in input {
        match &m.job {
            Job::Yell(_) => {},
            Job::Calculate(Calculation { a, b, op: _ }) => {
                waiting.insert(*a, vec![]);
                waiting.insert(*b, vec![]);
            },
        };
    }
    for m in input {
        match &m.job {
            Job::Yell(_) => {},
            Job::Calculate(Calculation { a, b, op: _ }) => {
                waiting.get_mut(a).unwrap().push(m.name);
                waiting.get_mut(b).unwrap().push(m.name);
            },
        };
    }
    waiting
}

fn prettyprint_op(op: Operation) -> &'static str {
    match op {
        Operation::Add => "+",
        Operation::Subtract => "-",
        Operation::Multiply => "*",
        Operation::Divide => "/",
    }
}

fn as_calculation<'a, 'b>(m: &'b Monkey<'a>) -> &'b Calculation<'a> {
    match &m.job {
        Job::Calculate(c) => c,
        _ => panic!("unexpected monkey"),
    }
}

fn prettyprint<'a>(monkeys: &HashMap<&'a str, &Monkey>, known: &HashMap<&'a str, i64>, target: &str) -> String {
    if target == "humn" { return "humn".to_string(); }
    match known.get(target) {
        Some(v) => format!("{v}"),
        None => {
            let m = monkeys[target];
            let Calculation { a, b, op } = as_calculation(m);
            format!("({} {} {})", prettyprint(monkeys, known, a), prettyprint_op(*op), prettyprint(monkeys, known, b))
        }
    }
}

fn unify(monkeys: &HashMap<&str, &Monkey>, known: &HashMap<&str, i64>, m: &Monkey, target: i64) {
    if m.name == "humn" {
        println!("humn should yell (part 2): {target}");
        return;
    }
    let Calculation { a, b, op } = as_calculation(m);
    match (known.get(a), known.get(b)) {
        (Some(aval), None) => {
            // println!("need {aval} {} {b} to equal {target}", prettyprint_op(*op));
            match *op {
                Operation::Add => unify(monkeys, known, monkeys[b], target - aval),
                Operation::Subtract => unify(monkeys, known, monkeys[b], aval - target),
                Operation::Multiply => unify(monkeys, known, monkeys[b], target / aval),
                _ => todo!("aval op: {op:?}"),
            }
        },
        (None, Some(bval)) => {
            // println!("need {a} {} {bval} to equal {target}", prettyprint_op(*op));
            match *op {
                Operation::Add => unify(monkeys, known, monkeys[a], target - bval),
                Operation::Subtract => unify(monkeys, known, monkeys[a], target + bval),
                Operation::Divide => unify(monkeys, known, monkeys[a], target * bval),
                Operation::Multiply => unify(monkeys, known, monkeys[a], target / bval),
            }
        },
        other => panic!("unexpected calculation: {:?}", other),
    }
}

fn solve(input: &[Monkey]) {
    let mut monkeys = HashMap::new();
    for m in input {
        monkeys.insert(m.name, m);
    }

    {
        let mut known = HashMap::new();
        let mut waiting = prepare_waiting(input);
        for m in input {
            match &m.job {
                Job::Yell(num) => resolve(&monkeys, &mut known, &mut waiting, m.name, *num),
                Job::Calculate(_) => {},
            };
        }
        println!("calculated root (part 1): {}", known["root"]);
    }

    {
        let mut known = HashMap::new();
        let mut waiting = prepare_waiting(input);
        for m in input {
            if m.name == "humn" { continue; }
            match &m.job {
                Job::Yell(num) => resolve(&monkeys, &mut known, &mut waiting, m.name, *num),
                Job::Calculate(_) => {},
            };
        }

        // println!("know {} values out of {}", known.len(), monkeys.len());
        // println!("root = {}", prettyprint(&monkeys, &known, "root"));

        // Assume root is of the form {some calculation involving humn only once} = known value
        let root = monkeys["root"];
        let Calculation { a, b, op: _ } = as_calculation(root);
        let equation = prettyprint(&monkeys, &known, a);
        let checksum = known[b];
        println!("root check:\n  equation: {}\n  target: {checksum}", equation);
        unify(&monkeys, &known, monkeys[a], checksum);
    }
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
