#!/bin/bash

read -r -d '' OCTOSTRING <<EODATA
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
EODATA

read -r -d '' OCTOSTRING <<EODATA
3113284886
2851876144
2774664484
6715112578
7146272153
6256656367
3148666245
3857446528
7322422833
8152175168
EODATA

declare -A OCTO

for Y in 0 1 2 3 4 5 6 7 8 9
do
    for X in 0 1 2 3 4 5 6 7 8 9
    do
	IDX=$(($Y * 11 + $X))
	OCTO["$X:$Y"]=$((1000 + ${OCTOSTRING:$IDX:1}))
    done
done

function octoprint(){
  for Y in 0 1 2 3 4 5 6 7 8 9
  do
    for X in 0 1 2 3 4 5 6 7 8 9
    do
      CELLVAL=${OCTO[$X:$Y]}
      echo -n "${CELLVAL:2} "
    done
    echo ""
  done
}




#!/bin/bash

echo "OCTO"
echo "${OCTO[@]}"
echo ""

echo "OCTO print"
octoprint

XQUEUE=()
YQUEUE=()

function octoplus(){
  for Y in 0 1 2 3 4 5 6 7 8 9
  do
    for X in 0 1 2 3 4 5 6 7 8 9
    do
      XQUEUE+=($X)
      YQUEUE+=($Y)
    done
  done
}

function octoprocessqueue(){
  unset SEEN
  declare -gA SEEN
  NEWFLASHES=0

  I=0
  while [ $I -lt ${#XQUEUE[@]} ]
  do
    X=${XQUEUE[$I]}
    Y=${YQUEUE[$I]}
    ((I+=1))
    if [ ${SEEN[$X:$Y]} ]
      then
        continue
    fi
    CELLVAL=${OCTO[$X:$Y]}
    NEWVAL=$(($CELLVAL + 1))
    OCTO["$X:$Y"]=$NEWVAL
    if [ $NEWVAL -eq 1010 ]
      then
      ((NEWFLASHES+=1))
      ((OCTO["$X:$Y"] -= 10))
      SEEN[$X:$Y]=789
      for dY in -1 0 +1
      do
        for dX in -1 0 +1
        do
          XQUEUE+=($(($X + $dX)))
          YQUEUE+=($(($Y + $dY)))
        done
      done
    fi
  done
  XQUEUE=()
  YQUEUE=()
  NUMFLASHES=$(($NUMFLASHES + $NEWFLASHES))
  echo "Total flashes: $NUMFLASHES (+$NEWFLASHES)"
  if [ $NEWFLASHES -eq 100 ]
    then
    ALLFLASHES+=($ITER)
  fi
}

NUMFLASHES=0

ALLFLASHES=()

for ITER in {1..300}
do
  echo "plus $ITER"
  octoplus
  octoprocessqueue
  octoprint
done

echo "All flashes: ${ALLFLASHES[@]}"
