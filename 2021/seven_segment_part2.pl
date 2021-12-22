stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", Lines).

resolve([A,B,C,D,E,F], 0) :- permutation([A,B,C,D,E,F], [a,b,c,e,f,g]).
resolve([A,B], 1) :- permutation([A,B], [c,f]).
resolve([A,B,C,D,E], 2) :- permutation([A,B,C,D,E], [a,c,d,e,g]).
resolve([A,B,C,D,E], 3) :- permutation([A,B,C,D,E], [a,c,d,f,g]).
resolve([A,B,C,D], 4) :- permutation([A,B,C,D], [b,c,d,f]).
resolve([A,B,C,D,E], 5) :- permutation([A,B,C,D,E], [a,b,d,f,g]).
resolve([A,B,C,D,E,F], 6) :- permutation([A,B,C,D,E,F], [a,b,d,e,f,g]).
resolve([A,B,C], 7) :- permutation([A,B,C], [a,c,f]).
resolve([A,B,C,D,E,F,G], 8) :- permutation([A,B,C,D,E,F,G], [a,b,c,d,e,f,g]).
resolve([A,B,C,D,E,F], 9) :- permutation([A,B,C,D,E,F], [a,b,c,d,f,g]).

str_array([A,B,C,D,E,F,G], ['a'|T], [A|Rest]) :- str_array([A,B,C,D,E,F,G], T, Rest).
str_array([A,B,C,D,E,F,G], ['b'|T], [B|Rest]) :- str_array([A,B,C,D,E,F,G], T, Rest).
str_array([A,B,C,D,E,F,G], ['c'|T], [C|Rest]) :- str_array([A,B,C,D,E,F,G], T, Rest).
str_array([A,B,C,D,E,F,G], ['d'|T], [D|Rest]) :- str_array([A,B,C,D,E,F,G], T, Rest).
str_array([A,B,C,D,E,F,G], ['e'|T], [E|Rest]) :- str_array([A,B,C,D,E,F,G], T, Rest).
str_array([A,B,C,D,E,F,G], ['f'|T], [F|Rest]) :- str_array([A,B,C,D,E,F,G], T, Rest).
str_array([A,B,C,D,E,F,G], ['g'|T], [G|Rest]) :- str_array([A,B,C,D,E,F,G], T, Rest).
str_array(_, [], []).

resolve_string([A,B,C,D,E,F,G], Str, N) :-
  string_chars(Str, Chars),
  str_array([A,B,C,D,E,F,G], Chars, Out),
  resolve(Out, N).

resolve_from_strings([S1,S2,S3,S4,S5,S6,S7,S8,S9,S10], [E1,E2,E3,E4], Value) :-
  resolve_string([A,B,C,D,E,F,G], S1, N1),
  resolve_string([A,B,C,D,E,F,G], S2, N2),
  resolve_string([A,B,C,D,E,F,G], S3, N3),
  resolve_string([A,B,C,D,E,F,G], S4, N4),
  resolve_string([A,B,C,D,E,F,G], S5, N5),
  resolve_string([A,B,C,D,E,F,G], S6, N6),
  resolve_string([A,B,C,D,E,F,G], S7, N7),
  resolve_string([A,B,C,D,E,F,G], S8, N8),
  resolve_string([A,B,C,D,E,F,G], S9, N9),
  resolve_string([A,B,C,D,E,F,G], S10, N10),
  write("resolve_from_strings:"),write([N1,N2,N3,N4,N5,N6,N7,N8,N9,N10]),nl,
  resolve_string([A,B,C,D,E,F,G], E1, O1),
  resolve_string([A,B,C,D,E,F,G], E2, O2),
  resolve_string([A,B,C,D,E,F,G], E3, O3),
  resolve_string([A,B,C,D,E,F,G], E4, O4),
  write("resolve_from_strings:"),write([O1,O2,O3,O4]),nl,
  Value is O1 * 1000 + O2 * 100 + O3 * 10 + O4.

do_line(Line, Value) :-
  split_string(Line, "|", " ", [Before,After]),
  write("Bef:"),write(Before), nl, write("Aft:"),write(After), nl,
  split_string(Before, " ", "", BefS),
  split_string(After, " ", "", AftE),
  write("BefS:"),write(BefS), nl, write("AftE:"),write(AftE), nl,
  resolve_from_strings(BefS, AftE, Value),
  write("Value:"),write(Value), nl, nl.

process_all_lines([], Acc) :- write("All done now:"), X is Acc, write(X), nl.
process_all_lines([X|Xs], Acc) :-
  do_line(X, Vals),
  process_all_lines(Xs, Acc+Vals).

main :- stream_lines(user_input, Lines),
  process_all_lines(Lines, 0).

?-main.
