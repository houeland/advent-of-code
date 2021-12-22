CREATE abuf 80 CHARS ALLOT

VARIABLE inpchr
VARIABLE firstbad
VARIABLE tmp
VARIABLE fullstop
VARIABLE answer
VARIABLE toremove

: printmystack
." depth=" depth .
depth
." :"
BEGIN
dup 0 <> WHILE
dup pick emit
1 -
REPEAT
drop
cr
;

: printmystacknum
." depth=" depth .
depth
." :"
BEGIN
dup 0 <> WHILE
dup pick .
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

inpchr @ 'X' = IF 1 fullstop ! drop drop drop EXIT ENDIF

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

firstbad @ 0 = IF
  ." ok completing:"
  0 tmp !
  BEGIN
    0 pick 'X' <> WHILE
    inpchr !
    \ ." handle:" inpchr @ emit cr

    inpchr @ '(' = IF tmp @ 5 * 1 + tmp ! ENDIF
    inpchr @ '[' = IF tmp @ 5 * 2 + tmp ! ENDIF
    inpchr @ '{' = IF tmp @ 5 * 3 + tmp ! ENDIF
    inpchr @ '<' = IF tmp @ 5 * 4 + tmp ! ENDIF
  REPEAT
  drop drop drop
  tmp @ dup .
ELSE
  ." very corrupt: "
  BEGIN
    0 pick 'X' <> WHILE
    DROP
  REPEAT
  drop drop drop
ENDIF

." final .S stack:" .S cr
\ firstbad @
;

: runprogram
BEGIN
  fullstop @ 1 = IF ." ok i'm out " EXIT ENDIF
  doline
  \ ." got:" dup . cr
AGAIN
;

: getsmallest
999999999999999 tmp !

depth
BEGIN
dup 0 <> WHILE
dup pick
dup tmp @ < IF dup tmp ! ENDIF
drop
1 -
REPEAT
drop

tmp @
;

: getbiggest
-999999999999999 tmp !

depth
BEGIN
dup 0 <> WHILE
dup pick
dup tmp @ > IF dup tmp ! ENDIF
drop
1 -
REPEAT
drop

tmp @
;

: doremove
\ printmystacknum

depth
BEGIN
dup 0 <> WHILE
dup pick
toremove @ = IF dup answer ! ENDIF
1 -
REPEAT
drop

\ cr cr
\ printmystacknum
\ ." remove idx:" answer @ . cr
answer @ 1 - roll drop
\ printmystacknum
\ cr cr
;

: sortem
runprogram cr cr cr
." sort stack:" printmystacknum cr cr

BEGIN
depth 1 <> WHILE
getsmallest toremove ! doremove
getbiggest toremove ! doremove
." reduced stack:" printmystacknum cr cr
REPEAT

." final stack:" printmystacknum cr cr

;

sortem
