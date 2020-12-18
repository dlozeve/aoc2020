 ⎕io←0 ⋄ ⎕pp←34
 p←⊃⎕NGET'input'1
 +/⍎¨⌽¨('\(' '\)' '\*'⎕R{')(×'[⍵.PatternNum]})¨p  ⍝ part 1
 +/⍎¨⌽¨('()*'{⍺⍺(⍵⍵⌷⍨∘⊂⍳)@(∊∘⍺⍺)⍵}')(×')¨p  ⍝ part 1 (without regex)
