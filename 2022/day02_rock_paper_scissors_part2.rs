use std::io::{self, BufRead};

fn score(opponent: &str, me: &str) -> i32 {
    let shape_score = match opponent {
        "A" => match me { // Rock
            "X" => 3, // Scissors
            "Y" => 1, // Rock
            "Z" => 2, // Paper
            _ => panic!("unexpected me move: {}", me),
        },
        "B" => match me { // Paper
            "X" => 1, // Rock
            "Y" => 2, // Paper
            "Z" => 3, // Scissors
            _ => panic!("unexpected me move: {}", me),
        },
        "C" => match me { // Scissors
            "X" => 2, // Paper
            "Y" => 3, // Scissors
            "Z" => 1, // Rock
            _ => panic!("unexpected me move: {}", me),
        },
        _ => panic!("unexpected opponent move: {}", opponent),
    };
    let outcome_score = match me {
        "X" => 0, // Lose
        "Y" => 3, // Draw
        "Z" => 6, // Win
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
    println!("part 2 score sum: {}", sum);
}
