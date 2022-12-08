use std::io::{self, BufRead};

fn score(opponent: &str, me: &str) -> i32 {
    let outcome_score = match opponent {
        "A" => match me { // Rock
            "X" => 3, // Rock
            "Y" => 6, // Paper
            "Z" => 0, // Scissors
            _ => panic!("unexpected me move: {}", me),
        },
        "B" => match me { // Paper
            "X" => 0, // Rock
            "Y" => 3, // Paper
            "Z" => 6, // Scissors
            _ => panic!("unexpected me move: {}", me),
        },
        "C" => match me { // Scissors
            "X" => 6, // Rock
            "Y" => 0, // Paper
            "Z" => 3, // Scissors
            _ => panic!("unexpected me move: {}", me),
        },
        _ => panic!("unexpected opponent move: {}", opponent),
    };
    let shape_score = match me {
        "X" => 1, // Rock
        "Y" => 2, // Paper
        "Z" => 3, // Scissors
        _ => panic!("unexpected me move: {}", me),
    };
    return outcome_score + shape_score;
}

fn main() {
    let mut sum = 0;
    for line in io::stdin().lock().lines() {
        let l = line.unwrap();
        let vec: Vec<&str> = l.split_whitespace().collect();
        let s = score(vec[0], vec[1]);
        println!("score: {}", s);
        sum += s;
    }
    println!("part 1 score sum: {}", sum);
}
