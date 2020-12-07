 ⎕IO←0
 p←'(^|\d )\w+ \w+ bag'⎕S'&'¨⊃⎕NGET'input'1
 bags←⊃¨p
 edges←1↓¨p
 adj←edges∘.{0⌈48-⍨⎕UCS⊃⊃(∨/¨(⊂⍵)⍷¨⍺)/⍺}bags
 gold←bags⍳⊂'shiny gold bag'
 ¯1+⍴({∪⍵,⊃¨⍸1⌊adj[;⍵]}⍣≡)1⍴gold  ⍝ Part 1
 inside←{⊃{∊1↓¨⍸adj[⍵;]}¨⊂⍵}
 ¯1+⍴∊{(inside⍣⍵)1⍴gold}¨⍳100  ⍝ Part 2
