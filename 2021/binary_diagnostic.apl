⎕IO ← 1

EI ← ExampleInput
EL ← ExampleLen
EI ← RealInput
EL ← RealLen

matrix ← (EL⍴10)⊤EI
sums ← +⌿⍉matrix
signs ← sums - (⍴EI)÷2
gamma ← signs > 0
epsilon ← signs < 0
answer1 ← (2 ⊥ gamma) × (2 ⊥ epsilon)

count0 ← {+/0=⍵}
count1 ← {+/1=⍵}

oxygen ← {
  c0 ← count0 ⍵
  c1 ← count1 ⍵
  c0 > c1: 0
  1
}

co2 ← {
  c0 ← count0 ⍵
  c1 ← count1 ⍵
  c0 = 0: 1
  c1 = 0: 0
  c1 < c0: 1
  0
}

dooxy ← {
  ox ← oxygen ⍺ ⌷ ⍵
  matchidx ← ⍺⌷⍵ = ox
  matchidx / ⍵
}

doco2 ← {
  c ← co2 ⍺ ⌷ ⍵
  matchidx ← ⍺⌷⍵ = c
  matchidx / ⍵
}

oxgenrating ← ⊃dooxy / (⌽⍳EL) ⍪ ⊂matrix
coscrubrating ← ⊃doco2 / (⌽⍳EL) ⍪ ⊂matrix

answer2 ← (2 ⊥ oxgenrating) × (2 ⊥ coscrubrating)

⎕ ← 'yo'
⎕ ← sums
⎕ ← signs
⎕ ← 2 ⊥ gamma
⎕ ← 2 ⊥ epsilon
⎕ ← 'answer1:'
⎕ ← answer1
⎕ ← 2 ⊥ oxgenrating
⎕ ← 2 ⊥ coscrubrating
⎕ ← 'answer2:'
⎕ ← answer2
⎕ ← 'done'
