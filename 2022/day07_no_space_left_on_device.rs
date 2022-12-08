use std::io::{self, BufRead};
use std::collections::HashMap;

#[derive(Debug)]
enum ParsedLine {
    Cd { dir: String },
    Ls,
    Dir { name: String },
    File { size: usize, name: String },
}

#[derive(Debug)]
struct DirContents {
    direct_file_size_sum: usize,
    sub_dirs: Vec<String>,
}

fn parse_line(line: &String) -> ParsedLine {
    let parts: Vec<&str> = (*line).split_whitespace().collect();
    match parts[0] {
        "$" => match parts[1] {
                "cd" => {
                    return ParsedLine::Cd { dir: parts[2].to_string() };
                },
                "ls" => {
                    return ParsedLine::Ls;
                },
                x => panic!("unexpected command: {}", x),
        },
        "dir" => {
            return ParsedLine::Dir { name: parts[1].to_string() };
        },
        file_size => {
            return ParsedLine::File { size: file_size.parse::<usize>().unwrap(), name: parts[1].to_string() };
        },
    }
}

fn solve(dir_contents: HashMap<String, DirContents>) {
    fn traverse(dir_contents: &HashMap<String, DirContents>, dir: String, mut total_sizes: &mut HashMap<String, usize>) -> usize {
        let dc = dir_contents.get(&dir).unwrap();
        let mut sum = dc.direct_file_size_sum;
        for child in dc.sub_dirs.iter() {
            sum += traverse(&dir_contents, child.to_string(), &mut total_sizes);
        }
        total_sizes.insert(dir, sum);
        return sum;
    };
    let mut total_sizes = HashMap::new();
    traverse(&dir_contents, "".to_string(), &mut total_sizes);

    let mut sum_of_small_sizes = 0;
    for (_dirname, size) in &total_sizes {
        if *size < 100000 {
            sum_of_small_sizes += size;
        }
    }
    println!("sum of small dirs (part1): {}", sum_of_small_sizes);

    let total_used_size = total_sizes.get("").unwrap();
    let max_used_size = 40000000;
    let need_to_delete = total_used_size - max_used_size;

    println!("total size: {}, need another {}", total_used_size, need_to_delete);
    let mut smallest_deletion = total_used_size;
    for (_dirname, size) in &total_sizes {
        if *size >= need_to_delete {
            smallest_deletion = std::cmp::min(smallest_deletion, size);
        }
    }
    println!("smallest sufficient deletion (part2): {}", smallest_deletion);
}

fn parse(lines: Vec<String>) -> HashMap<String, DirContents> {
    let cmds = lines.iter().map(parse_line).collect::<Vec<_>>();
    let mut cur_path = vec!["???"];
    let mut idx = 0;
    let mut dir_contents = HashMap::new();
    loop {
        let c = &cmds[idx];

        match c {
            ParsedLine::Cd { dir } => {
                match dir.as_str() {
                    "/" => {
                        cur_path = vec![""];
                    },
                    ".." => {
                        cur_path.pop();
                    },
                    dirname => {
                        cur_path.push(dirname);
                    },
                }
                // println!("cd ==> {:?}", cur_path.join("/"));
                idx += 1;
            },
            ParsedLine::Ls => {
                let dirname = cur_path.join("/");
                // println!("ls {:?} {}", c, dirname);
                let mut direct_file_size_sum = 0;
                let mut sub_dirs = Vec::new();
                idx += 1;
                loop {
                    if idx == cmds.len() { break; }
                    let f = &cmds[idx];
                    match f {
                        ParsedLine::Cd { dir: _ } => { break; },
                        ParsedLine::Ls => { break; },
                        ParsedLine::Dir { name } => {
                            // println!("ls dir {:?}", f);
                            sub_dirs.push(format!("{}/{}", dirname, name));
                            idx += 1;
                        },
                        ParsedLine::File { size, name: _ } => {
                            // println!("ls file {:?}", f);
                            direct_file_size_sum += size;
                            idx += 1;
                        },
                    }
                }
                let dc = DirContents { direct_file_size_sum, sub_dirs };
                // println!("ls {:?}: {:?}", dirname, &dc);
                dir_contents.insert(dirname, dc);
            },
            ParsedLine::Dir { name: _ } => panic!("unexpected cmd: {:?}", c),
            ParsedLine::File { size: _, name: _ } => panic!("unexpected cmd: {:?}", c),
        }
        if idx == cmds.len() {
            break;
        }
    }
    return dir_contents;
}

fn main() {
    let mut lines = Vec::new();
    for line in io::stdin().lock().lines() {
        lines.push(line.unwrap());
    }
    solve(parse(lines));
}
