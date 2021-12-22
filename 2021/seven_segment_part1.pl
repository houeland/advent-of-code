stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", Lines).

%1=>2
%4=>4
%7=>3
%8=>7
map_unique(2, 1).
map_unique(4, 4).
map_unique(3, 7).
map_unique(7, 8).
map_unique(_, -1).

resolve_unique(Word, Out) :-
  string_length(Word, Len),
  map_unique(Len, Out).

count_uniq([-1|T], Acc, Cnt) :- count_uniq(T, Acc, Cnt).
count_uniq([_|T], Acc, Cnt) :- count_uniq(T, Acc+1, Cnt).
count_uniq(_, Acc, Cnt) :- Acc = Cnt.
  

do_unique(Stuff,Outs) :-
  split_string(Stuff, " ", "", Segs),
  maplist(resolve_unique, Segs, Outs).

do_line(Line, Uniqs) :-
  split_string(Line, "|", " ", [_Before,After]),
  %write(Before), nl, write(After), nl, nl,
  do_unique(After, Uniqs).

process_all_lines([], Acc) :- write("All done now:"), X is Acc, write(X), nl.
process_all_lines([X|Xs], Acc) :-
  do_line(X, Vals),
  count_uniq(Vals, 0, Cnt),
  process_all_lines(Xs, Acc+Cnt).

main :- stream_lines(user_input, Lines),
  process_all_lines(Lines, 0).

?-main.


%%% == Input ==
% acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf
% be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
% edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
% fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
% fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
% aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
% fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
% dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
% bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
% egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
% gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce


%%% == Output ==
% [-1,-1,-1,-1]
% [8,-1,-1,4]
% [-1,7,8,1]
% [1,1,-1,7]
% [-1,-1,-1,1]
% [4,8,7,-1]
% [8,4,1,8]
% [4,-1,4,8]
% [1,-1,-1,-1]
% [8,7,1,7]
% [4,-1,1,-1]
% All done now:26
