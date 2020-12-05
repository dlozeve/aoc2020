 ⎕IO←0
 p←{2⊥⍵∊'BR'}¨⊃⎕NGET'input'1
 ⌈/p  ⍝ Part 1
 ⊢/(⍳⌈/p)~p  ⍝ Part 2
