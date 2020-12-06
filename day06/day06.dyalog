 p←⊃⎕NGET'input'1
 p←(~p∊⊂'')⊆p
 +/{≢⊃∪/⍵}¨p  ⍝ Part 1
 +/{≢⊃∩/⍵}¨p  ⍝ Part 2
