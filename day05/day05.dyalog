 ⎕IO←0
 p←⊃⎕NGET'input'1
 f←{+/8 1×2⊥¨'BR'⍷¨7((⊂↑),(⊂↓))⍵}
 ⌈/f¨p  ⍝ Part 1
 ⊢/((⍳⌈/)~⊢)f¨p  ⍝ Part 2
