#[derive(Debug, PartialEq, Clone)]
pub struct State {
    pub fishCountPerDay: [i64; 10],
}

fn parse_fish(input: &str) -> State {
    let numbers: Vec<usize> = input.split(',').map(|s| s.parse().unwrap()).collect();
    let mut state = State {
        fishCountPerDay: [0; 10],
    };
    for fish in numbers.iter() {
        state.fishCountPerDay[*fish] += 1;
    }
    return state;
}

fn compute_cycle(input: &State) -> State {
    let mut state = State {
        fishCountPerDay: [0; 10],
    };
    state.fishCountPerDay[6] += input.fishCountPerDay[0];
    state.fishCountPerDay[8] += input.fishCountPerDay[0];
    for n in 0..9 {
        state.fishCountPerDay[n] += input.fishCountPerDay[n + 1];
    }
    return state;
}

fn count_fish(input: &State) -> i64 {
    let mut count = 0;
    for n in 0..10 {
        count += input.fishCountPerDay[n];
    }
    return count;
}

// _ 1 2 33 4 _ _

fn main() {
    // let mut state = parse_fish("3,4,3,1,2");
    let mut state = parse_fish("1,3,3,4,5,1,1,1,1,1,1,2,1,4,1,1,1,5,2,2,4,3,1,1,2,5,4,2,2,3,1,2,3,2,1,1,4,4,2,4,4,1,2,4,3,3,3,1,1,3,4,5,2,5,1,2,5,1,1,1,3,2,3,3,1,4,1,1,4,1,4,1,1,1,1,5,4,2,1,2,2,5,5,1,1,1,1,2,1,1,1,1,3,2,3,1,4,3,1,1,3,1,1,1,1,3,3,4,5,1,1,5,4,4,4,4,2,5,1,1,2,5,1,3,4,4,1,4,1,5,5,2,4,5,1,1,3,1,3,1,4,1,3,1,2,2,1,5,1,5,1,3,1,3,1,4,1,4,5,1,4,5,1,1,5,2,2,4,5,1,3,2,4,2,1,1,1,2,1,2,1,3,4,4,2,2,4,2,1,4,1,3,1,3,5,3,1,1,2,2,1,5,2,1,1,1,1,1,5,4,3,5,3,3,1,5,5,4,4,2,1,1,1,2,5,3,3,2,1,1,1,5,5,3,1,4,4,2,4,2,1,1,1,5,1,2,4,1,3,4,4,2,1,4,2,1,3,4,3,3,2,3,1,5,3,1,1,5,1,2,2,4,4,1,2,3,1,2,1,1,2,1,1,1,2,3,5,5,1,2,3,1,3,5,4,2,1,3,3,4");
    println!("Original: {:?} = {:?} fish", state, count_fish(&state));
    for n in 1..256 + 1 {
        state = compute_cycle(&state);
        println!(
            "After day {:?}: {:?} = {:?} fish",
            n,
            state,
            count_fish(&state)
        );
    }
    println!("Final state: {:?} = {:?} fish", state, count_fish(&state));
}
