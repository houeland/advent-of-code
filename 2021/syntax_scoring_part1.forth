CREATE abuf 80 CHARS ALLOT

VARIABLE inpchr
VARIABLE firstbad
VARIABLE tmp
VARIABLE fullstop
VARIABLE answer

: printmystack
." depth=" depth .
depth
BEGIN
dup 0 <> WHILE
dup pick emit
1 -
REPEAT
drop
cr
;

: wantsome
tmp !
= IF
ELSE
  tmp @ firstbad !
ENDIF
;

: getfirsterror
;

: doline
'X' 'Y' 'X'
0 firstbad !
BEGIN
\ printmystack
key inpchr !
\ ." process:" inpchr @ emit cr

inpchr @ 'X' = IF 1 fullstop ! drop 0 EXIT ENDIF

inpchr @ '(' = IF inpchr @ ENDIF
inpchr @ '[' = IF inpchr @ ENDIF
inpchr @ '{' = IF inpchr @ ENDIF
inpchr @ '<' = IF inpchr @ ENDIF

firstbad @ 0 = IF

inpchr @ ')' = IF '(' 3 wantsome ENDIF
inpchr @ ']' = IF '[' 57 wantsome ENDIF
inpchr @ '}' = IF '{' 1197 wantsome ENDIF
inpchr @ '>' = IF '<' 25137 wantsome ENDIF

ENDIF

inpchr @ 10 = UNTIL

\ ." line done" cr

clearstack
firstbad @
;

: runprogram
BEGIN
  fullstop @ 1 = IF ." ok i'm out, answer: " answer @ . EXIT ENDIF
  doline
  ." got:" dup . cr
  answer @ + answer !
AGAIN
;

runprogram
