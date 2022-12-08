use std::io::{self, BufRead};

fn main() {
    let mut elves = Vec::new();
    let mut current_sum = 0;
    for line in io::stdin().lock().lines() {
        let l = line.unwrap();
        if l == "" {
            elves.push(current_sum);
            current_sum = 0;
        } else {
            let val: i32 = l.parse().unwrap();
            current_sum += val;
        }
    }
    elves.push(current_sum);
    // println!("{:?}", elves);
    elves.sort();
    elves.reverse();

    println!("most food: {}", elves[0]);
    println!("sum top three: {}", elves[0] + elves[1] + elves[2]);
}
