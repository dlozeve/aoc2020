 ⎕IO←0 ⋄ (⎕FR ⎕PP)←1287 34
 p←⊃⎕NGET'input'1
 t←⍎⊃p
 b←⍎¨((1<',x'∘⍳)⊆⊢)1⊃p
 b{×/((⊢⍳⌊/)⍵)⌷¨(⊂⍺),⊂⍵}b|-t  ⍝ Part 1
 ⍝ https://www.jsoftware.com/papers/50/50_44.htm
 xea←{(⍺,1 0){0=⊃⍵:⍺ ⋄ ⍵ ∇ ⍺-⍵×⌊(⊃⍺)÷⊃⍵}(⍵,0 1)}
 ∇r←larg cr rarg
  m r←larg
  n s←rarg
  gcd a b←m xea n
  lcm←m×n÷gcd
  c←lcm|gcd÷⍨(r×b×n)+(s×a×m)
  r←lcm,c
 ∇
 c←','(≠⊆⊢)1⊃p
 b←↓⍉⍎¨⍕¨↑(⊂~('x'≡⊃)¨c)/¨(⊂c),⊂-⍳⍴c
 1⊃⊃cr/{x y←⍵ ⋄ 0=y:x,y ⋄ 1:x(x+y)}¨b  ⍝ Part 2
