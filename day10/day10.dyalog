 ⎕IO←0 ⋄ ⎕PP←15
 p←⍎¨⊃⎕NGET'input'1
 p←0,p[⍋p],3+⌈/p
 ×/⊢∘≢⌸2-/p  ⍝ Part 1
 c←0,0,1,(⌈/p)⍴0  ⍝ paths counts
 {c[⍵+2]←+/c[⍵+¯1 0 1]}¨1↓p
 ⊃⌽c  ⍝ Part 2

 a←(0∘<∧≤∘3)∘.-⍨p  ⍝ adjacency matrix
 +/{⊃⊖({a+.×⍵}⍣⍵)a}¨⍳⍴p  ⍝ Part 2, the matrix way
