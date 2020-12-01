 ⎕io←0
 x←⍎¨⊃⎕nget'input'1
 ⍝ Part 1
 ×/x[⊃⍸2020=x∘.+x]
 ⍝ Part 2
 ×/x[⊃⍸2020=⊃∘.+/3⍴⊂x]
