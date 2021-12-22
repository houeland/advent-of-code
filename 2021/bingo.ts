const example_input = `
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
`;

function parseInput(input: string) {
  const lines = input.split(/\n/).slice(1);
  const numberLine = lines[0];
  const toNum = (x) => Number(x);
  const numbers = numberLine.split(/,/).map(toNum);
  let idx = 2;
  const boards: number[][][] = [];
  while (idx < lines.length) {
    const board = [];
    board.push(lines[idx + 0].trim().split(/ +/).map(toNum));
    board.push(lines[idx + 1].trim().split(/ +/).map(toNum));
    board.push(lines[idx + 2].trim().split(/ +/).map(toNum));
    board.push(lines[idx + 3].trim().split(/ +/).map(toNum));
    board.push(lines[idx + 4].trim().split(/ +/).map(toNum));
    boards.push(board);
    idx += 6;
  }
  return { numbers, boards };
}

function updateBoard(board: number[][], n: number) {
  for (const y of [0, 1, 2, 3, 4]) {
    for (const x of [0, 1, 2, 3, 4]) {
      if (board[y][x] === n) {
        board[y][x] = n - 1000;
      }
    }
  }
}

function didBoardWin(board: number[][]) {
  const got = (x: number, y: number) => board[y][x] < 0;
  for (const x of [0, 1, 2, 3, 4]) {
    let all = true;
    for (const y of [0, 1, 2, 3, 4]) {
      if (!got(x, y)) all = false;
    }
    if (all) return true;
  }
  for (const y of [0, 1, 2, 3, 4]) {
    let all = true;
    for (const x of [0, 1, 2, 3, 4]) {
      if (!got(x, y)) all = false;
    }
    if (all) return true;
  }
  //   if (true) {
  //     let all = true;
  //     for (const i of [0, 1, 2, 3, 4]) {
  //       if (!got(i, i)) all = false;
  //     }
  //     if (all) return true;
  //   }
  //   if (true) {
  //     let all = true;
  //     for (const i of [0, 1, 2, 3, 4]) {
  //       if (!got(i, 4 - i)) all = false;
  //     }
  //     if (all) return true;
  //   }
}

function printBoard(board: number[][]) {
  console.log("board:");
  for (const y of [0, 1, 2, 3, 4]) {
    console.log(board[y]);
  }
}

function playUntilWin(numbers: number[], boards: number[][][]) {
  const haveWon = new Set<number>();
  for (const n of numbers) {
    let boardnum = 0;
    for (const b of boards) {
      boardnum += 1;
      updateBoard(b, n);
      if (didBoardWin(b)) {
        haveWon.add(boardnum);
        if (haveWon.size == boards.length) {
          return { winningBoard: b, winningNumber: n };
        }
      }
    }
  }
}

function scoreBoard(board: number[][], number: number) {
  let sum = 0;
  for (const y of [0, 1, 2, 3, 4]) {
    for (const x of [0, 1, 2, 3, 4]) {
      const v = board[y][x];
      if (v >= 0) sum += v;
    }
  }
  console.log("sum", sum);
  console.log("number", number);
  return sum * number;
}

function doStuff(input: string) {
  const { numbers, boards } = parseInput(input);
  const { winningBoard, winningNumber } = playUntilWin(numbers, boards);
  printBoard(winningBoard);
  const score = scoreBoard(winningBoard, winningNumber);
  console.log(score);
}

const large_input = `
17,58,52,49,72,33,55,73,27,69,88,80,9,7,59,98,63,42,84,37,87,28,97,66,79,77,61,48,83,5,94,26,70,12,51,82,99,45,22,64,10,78,13,18,15,39,8,30,68,65,40,21,6,86,90,29,60,4,38,3,43,93,44,50,41,96,20,62,19,91,23,36,47,92,76,31,67,11,0,56,95,85,35,16,2,14,75,53,1,57,81,46,71,54,24,74,89,32,25,34

59 98 84 27 56
17 35 18 64 34
62 16 74 26 55
21 99  1 19 93
65 68 53 24 73

 1 86 98 16  6
93 69 33 49 71
54 43 77 29 47
82 73 99 31 27
28 48 36 89 20

80 92 52 23 67
47 38  4 25 65
54 31 77 13 39
18 70 17 22 24
14 99 30 96  8

88 97 17 48 71
60 50 15 37 24
78  6 79 56 91
70 30 72 46 73
41 42 32  7 59

37 20 34 32  3
48 40  4 27 42
94 87 14 24 57
17 18 90 44 76
43 28 46  5 19

 3 69 88 77 74
 6 44 12 81 49
73 23 32 97 53
83  4 85 38 61
10 87 50 60 47

84 17 58 31 79
25 97 35 72 16
11 91 75 67 41
 6 85 27 44 86
43 40 54 95 68

70 55 88 22 50
96 98 48 85 75
95 72  8 26 14
16 63 46 91 78
93  3 83 99 21

29  7  6 75 36
37 93 23 63 65
56 79 87 48 49
27 24 80 53 33
86 46 95 99 42

33 30 72 99 65
49 93 76 36 53
26 35 86 97 12
47 19 54 25  3
75 34 50  8 95

41 69 49  0 48
73  9 72 61 85
56 20 58 57  1
12 82 38 21 46
34 83 11 68 53

54 79 35 24 33
89 77 75 76 96
94  2 38 39 40
63 51 34 12 30
20 21 70 26 23

82 62 87 42 19
94 65 18  4 33
 0 30 27 55 66
76 46 78 14 48
57 53 43 15 75

94 38 96 44 46
10 14 75 97 76
 7 61 56 36  1
81 67 49 78 86
31 65 88 24 63

22  2 51 36 24
78 62 67 13 84
32 91 59 66 33
73 80 54  3 85
65 70 98 79 55

80  1 23 70 47
91 88 24 56 11
98 79 72 31 86
 7 87 28 25 92
74 20 62 46 71

62 45 91 49 96
73  3 57 30 95
74 31 12 17 40
53 39 63 55  1
58 82 23 64 84

11 71 60 51 63
90 64 79 88 39
65 13 76 66 26
20 34 40  0 95
21 72 62 83 77

24 70 72 60 63
53 69 94 74 57
25 41 20 84 45
76 68 16 15 18
75 58  0 10 47

17 23 90  8  4
88 24 74 12 18
62 99 67 49 92
29 64 16 21 25
 9 19 30 60 53

28 85 61 76 29
15 33 89 48  1
68 77 11 93 51
87 59  8  5 54
65 34 18 81 43

53  9 31 23 35
17 59 91 43 25
 7 90  5 33 58
21 68 29 52 15
86  3 48 11 26

78 77 63 91 24
40 31 54 17 72
84 21 69 45 38
89 12 70 42 65
27 52 97 64 94

36 23 33 20 70
35 10 52 18 34
22 19 98 93  5
67 94 90 51 62
38  6 53 64 76

90 69 16 70 34
57 94  3 61 36
60 22 47 97 31
30  8  4 84 91
12 65 37 18 72

12 93 39  1 96
 0 13 67 55 72
84  9 30 40 62
10 74 79 41 85
51 52 47 98 75

63 82 76 42 50
40 75 85 10 99
 6 34 22 43 15
87 57 79 66 55
97 24 72 54 68

68 39 48 66 81
26  9 96  5 38
22  1 57 30 98
 2 43 14 50 97
56 37 62 13 29

 4  9 98 28 11
21 20 10 39 69
85 47 87 94 36
88 75 35 22 91
86 44  2 56 12

98 65 26 91 86
 7 25 45 80 22
39  2 95 69 46
84 49 68 85 47
23 90 40  4 44

63  2 32 56 52
30 11 33 10 70
36 34 88 82 37
62 57 40 28 96
58 73 41 69 85

 8 27 64 80 19
87 79 99 53 95
84  6 31 22  3
44 91 47 41 82
16 74 43 29 70

32 67 62 81 36
47 61 74 60 57
27 35 38  4 26
34 72  2 21 90
49 84 42 31 76

 3 53 26 35 12
20 30  0 76 80
96 46 89 83 48
 7 13 98 66 75
97 82 55  5 68

22 61 69 36 77
95 53  4 21 94
 5 17 18  2 96
 0 81 56 31 66
70 75 55 58 42

97 10 40 80 43
57 90 53 34 13
38  7 47 86 89
51 65 76 85  0
48 62 28 42 35

 6 21 88 78 22
30 90 65 53 66
31 36  3 99 32
52 13 69 68 72
57 97 79 73 94

77 76 81 94 20
45 17 52 49 18
98 56 21 32 80
63 99 87 24 43
61  1 16  3 40

 3 45 98 84 31
99 23 90 71 27
24 60 46 69 37
83 62  6 36 49
42 55 11 68 17

60 22 98 46  0
59  9 28 16 26
56 33 43 93 31
73 27 29  6 94
13 12 51 61 45

85 22 48 27 58
86 23 65 19 91
50 36 97 10 78
15  9  3 72 96
31  1 87  8 14

79 48 30 50 77
92 71 90 25 14
39 45 98  1 84
47  8 66 60 74
80 75 55 62 35

45 60 77 16 18
78 21 23 44 56
36 27 99 80 61
81 71 75 58  5
53 49 46  9 38

56  6 53 79 33
 3 62 30 83 96
 1 34 12 44 47
58 35 87 91 69
20 85  0 60  4

 9 87 28 94 66
 3 10 27 13 54
40  0 43 35 85
67 34 81 92 58
21 53 79  6 19

23 72  9  1 57
61 73 33 52 64
 7 21 92 84 46
50 56 38 25 76
75 67 47 81 37

50  4 98 48 85
46 39 45 93 69
60  5 79 68 21
31 67  8 74 16
88  3 15 84 23

53 61 99 17 25
16 86 27 83 46
 9 75 67 19 10
84 81 76 88  8
49 97 79  3 21

69 40 56 75  4
34 16 79 46 77
19 54 35 74 84
73 50 20 47 10
62 99 51  6 92

53 79 80 96 45
28  0  2 35 33
51 70 34 90 72
30 54 41 38 15
91 73 97 23 49

20 78 55 10 18
61 89 14  2 17
93 96 41 70 76
19 37 47 80 71
82 92 90  0 57

29 40 64 62 32
56 58  7 68 67
16 76  4 50 13
37 90 66 60 83
33 97 25 80 54

56 91 67 49 98
85 15 25  1 32
24 93 86 54 52
22 73 23 63 94
65 72 14 26 55

74 38 19 20 11
57 86 87 29 89
13 21 75 85 44
33 84 56 76 92
52 37 64 72 73

45 14 60 32 59
66 49 16  2 94
19 10 68 90 78
95  8 93 61 24
85 48 29 28 84

 6 74  4 42 86
88 79  8 96 66
63 85 89  9 12
57  1 67 38 32
87 26 71 78 46

78 49 54 77 56
18  4 50 14 23
16 12 25 64 39
75  2 22 41 37
88 19 93 85 53

79  6 52 48 37
51 67 66 42  3
63 43 39 56 91
 8 18  7 29 89
55 71 45 36 38

 9  8 42 35 79
11 62  7 93 68
28 26 61 96 19
29 88 81 43 98
84 80 23 77 17

90 21 51 43 60
95 12 34 77 29
75 82 47 92 15
56 73 52 64  7
17 85 94 41 46

43 75 58 76 35
37 41 65 60 14
90 51 83 32 88
26 99 16 68 64
44 97 24 29 20

50 32 90 95 27
34 38 82 39 15
60 66 68 40 22
85 98 87 58  7
30 54 97 11 33

77 30 84 12  0
34  6  5 70 44
87 67  4 61 75
31 96 52 57  8
21 41 13 45 62

 6 26 69 27 75
61 33 88 38 20
 9 56 70 98 82
80 76 55 66 29
97 84 42 77 73

83 35 25 47 69
70 31 93 56 57
97 14 26 55 27
51 39 98 77 17
45 86  6 95 89

18  9 29 14 38
69 64 30 90 57
75 97 80 94 44
85 41 11 96 86
33 81 58 26 49

31 11 12 75 96
68 85 95  2 47
35 57 87 41  6
65 50 74 25 59
26  9 30 17 88

54 59 23 46 37
56 43 91 75  1
18 96 11 84 14
30 94 82  2  8
67 90 99 33 34

51 90 80 71 32
73 18  8 35 58
53 91 60 74 37
76  9 25 17 31
54 84 43 88 34

20  8 27 64 40
11 99 85 72 32
62  7 55 83 35
96 48 12 33 30
73  4 21 16 75

14 15 52 30 88
97 94 59 56 77
31 12 41 36 20
62  3  2 38 82
68 45 33 91 61

 4 11  9 89 60
97 70 18 57 40
98 75  6 50 88
56 30 21 80 83
 7 73 65 23 69

70 23 49 90 82
 1 68 95 33 76
72 89 39 51 59
 8 65 88 73 24
47 26 80  5 34

13 50 15 43 51
 7 58 40 68 91
62 18 47 79 42
60  1 74 71 86
25 53 36 10 70

92 96 37 63 61
49 94 65 13 23
15 75 52 10 82
30 59 14 43 48
53 62 21 35  0

79 84 95 93 41
58 94  6 20 92
88  0 78 16 21
40 96 24  2 66
85 87 13 14 80

33 53 54 20 37
18 88 70 61 85
90 76 12 44 79
81 69  9 98 74
14 13 15 36 93

61 46 67 24 98
80 36 41 86  9
82 75 40 42 58
49 51 99  5 90
91 97 26 20 56

90 22 94 41  7
13 16 51 44 32
 5 43 60 19 49
38 96 23 12 79
57 85 58  3 48

52  3 40 90 43
14 64 59 93 56
99 94 61 72 46
84 87 48 22 91
 2 67 35 76 92

48 82 26 38 90
50 98 30 76 60
 1 49 92 99 77
59 97 22 47 93
81 35 43 23 53

41  5 57 29  2
90 23 55 75 96
48 60 86 67  8
34 12 59  6 45
89  1 44 49 76

76 81  4 44 22
89 84 85 70 11
51 97 50 25 95
31 27 21 40 87
65 91 69 58 23

96 42 98 38 52
39 57 40 94 91
87 79 23 36 82
 4 72 95 22 43
51 73 59 15 44

99 29 30 90 33
60 61 65  8 56
89 87 25 95 55
 6 39 69 98 20
76 81 85 16 93

86 35 92 90 19
26 55 21 12 33
 3 82 41 47 15
14 94 63 62 23
95 65  2  0 72

22  8 49 39 36
63  7 61 92 51
25 96 43  1 46
28 64 59 47 27
87 65 48 88 37

58 59 93 23 70
18 97 83 73 21
90 14 13 95 45
44  6 10 80 15
92 56 26 76 52

34 68  7 52 51
17 25 97 35 78
 2 40 89 67 24
73 37 45  0 64
57 66 47  4 12

11 35 14 69 13
86 90  2 19 27
70  0  6 31 98
64 23 54 88 26
94 43 59 71 36

28  9 67 39 20
16 44 47 69 96
19 45 30 91 68
75 56 37 35 52
27 42 93 43 84

24 67 39 70 93
71 72 12 85  1
77 59 66  5 76
54 13 35 40 82
51 25 64  6 19

65 36 92 51 74
55 90 68  9 97
28 56 35 34 73
50 10 61 37 30
79 49 96 18  1

57  8 17 51 19
86 97 21 84 20
32 44 33 27 62
 3 76 70 58 79
36 74 75 65 71

24 65 37 29 66
26 60 49 45 61
23 22 83 71 10
46 59 86 40 12
64 74 27  8 78

63 79 80 54 68
16 89 60 96 31
 6 91 32 37 86
93 20 61 70 21
58 88 11 15 39

36 44 75  3 29
58 32 84 37 48
76 99 65 91 24
22 20 42 57 49
50 85 52  2 54

77 65 38 15 12
50 53 10 34 40
87 60  4 68 71
 5 35 28 63 66
11 86  9  8 49

 3 71 46 10  1
83 12 52 99 24
96 87 85 51 33
11 69 62 34 41
88 22 89 21 49

55  0 82 40 48
71 32  3 90 92
39 69 63 86 60
51 36 66 12 46
73 57 58 33 94
`;

doStuff(example_input);
doStuff(large_input);
