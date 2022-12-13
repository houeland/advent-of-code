use std::io::{self, BufRead};
use std::cmp::Ordering;

#[derive(Debug)]
enum Element {
    Number(i32),
    List(List),
}

#[derive(Debug)]
struct List {
    children: Vec<Element>,
}

fn parse_number(line: &Vec<char>, idx: &mut usize) -> i32 {
    let mut vec = vec![];
    loop {
        match line[*idx] {
            '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9' => vec.push(line[*idx]),
            _ => return vec.iter().collect::<String>().parse::<i32>().unwrap(),
        };
        *idx += 1;
    }
}

fn parse_list(line: &Vec<char>, idx: &mut usize) -> List {
    assert!(line[*idx] == '[');
    *idx += 1;
    let mut children = vec![];
    loop {
        match line[*idx] {
            '[' => children.push(Element::List(parse_list(line, idx))),
            '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9' => children.push(Element::Number(parse_number(line, idx))),
            ']' => {
                *idx += 1;
                return List { children };
            },
            _ => panic!("unexpected line: {:?}", line),
        }
        if line[*idx] == ',' {
            *idx += 1;
        }
    }
}

fn parse_packet(line: &str) -> List {
    let vec = line.chars().collect::<Vec<_>>();
    let mut idx = 0;
    return parse_list(&vec, &mut idx);
}

fn tostring(l: &List) -> String {
    let mut v = vec![];
    for x in &l.children {
        v.push(match x {
            Element::Number(n) => format!("{}", n),
            Element::List(c) => tostring(&c),
        });
    }
    return "[".to_string() + &v.join(",") + "]";
}

fn parse(lines: Vec<String>) -> Vec<(List, List)> {
    let mut vec = Vec::new();
    for idx in (0..lines.len()).step_by(3) {
        let first = parse_packet(&lines[idx]);
        let second = parse_packet(&lines[idx+1]);
        // println!("{} {}", lines[idx], tostring(&first));
        // println!("{} {}", lines[idx+1], tostring(&second));
        assert!(tostring(&first) == lines[idx]);
        assert!(tostring(&second) == lines[idx+1]);
        vec.push((first, second));
    }
    return vec;
}

fn aslist<'a>(v: &'a Element, ph: &'a mut List) -> &'a List {
    match v {
        Element::Number(n) => {
            ph.children.push(Element::Number(*n));
            return ph;
        },
        Element::List(l) => l,
    }
}

fn compare_lists(left: &List, right: &List) -> Ordering {
    // println!("compare: {} {}", tostring(&left), tostring(&right));
    let mut idx = 0;
    loop {
        match (idx >= left.children.len(), idx >= right.children.len()) {
            (true, true) => return Ordering::Equal,
            (false, true) => return Ordering::Greater,
            (true, false) => return Ordering::Less,
            (false, false) => {
                let r = match (&left.children[idx], &right.children[idx]) {
                    (Element::Number(l), Element::Number(r)) => if l < r {
                        Ordering::Less
                    } else if l > r {
                        Ordering::Greater
                    } else {
                        Ordering::Equal
                    }, 
                    (x,y) => {
                        let mut leftph = List { children: vec![] };
                        let mut rightph = List { children: vec![] };
                        compare_lists(&aslist(&x, &mut leftph), &aslist(&y, &mut rightph))
                    },
                };
                if r != Ordering::Equal {
                    return r;
                } else {
                    idx += 1;
                }
            },
        }
    }
}

fn solve(input: &Vec<(List, List)>) {
    let mut right_orders = vec![];
    for (i, (first, second)) in input.iter().enumerate() {
        let r = compare_lists(&first, &second);
        // println!("#{}: {:?} vs {:?}: {}", i+1, tostring(&first), tostring(&second), r);
        if r == Ordering::Less {
            right_orders.push(i+1);
        }
    }
    // println!("{:?}", right_orders);
    println!("sum of indices of right order pairs (part 1): {}", right_orders.iter().sum::<usize>());

    let mut everything = vec![];
    let two = parse_packet("[[2]]");
    let six = parse_packet("[[6]]");
    for (f,s) in input {
        everything.push(f);
        everything.push(s);
    }
    everything.push(&two);
    everything.push(&six);
    everything.sort_by(|a, b| compare_lists(&a, &b));
    let mut idxv = vec![];
    for (idx, l) in everything.iter().enumerate() {
        // println!("{}", tostring(&l));
        if std::ptr::eq(*l as *const List, &two as *const List) {
            // println!("BOOM idx={} {}", idx+1, tostring(&l));
            idxv.push(idx+1);
        }
        if std::ptr::eq(*l as *const List, &six as *const List) {
            // println!("MOOB idx={} {}", idx+1, tostring(&l));
            idxv.push(idx+1);
        }
    }
    println!("decoder key (part 1): {}", idxv[0] * idxv[1]);
}

fn main() {
    let mut lines = Vec::new();
    for line in io::stdin().lock().lines() {
        lines.push(line.unwrap());
    }
    let parsed = parse(lines);
    // println!("parsed: {:?}", parsed);
    solve(&parsed);
}
