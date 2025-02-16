How do i do combos?

you should have something like `let virtual_keys' = [` in your keyboard somewhere,
there you can define which buttons together make a combo and the combo timeout, lets just say you have a 3x3 matrix, here things would look like this

|1|2|3|
|4|5|6|
|7|8|9| 

and we want a combo for 1 & 2 for a combo and 2 & 5 & 8 both with a 50 ms timeout

```nickel
let virtual_keys' = [
  combo.make 50 [1, 2],
  combo.make 50 [2,5,8],
] in

# Keymap definition
{
  virtual_keys = [
    combo.make 50 [1, 2],
    combo.make 50 [2,5,8],
  ],

  layers = [
    [ # Layer 0
      cu.COPY, cu.PSTE, cu.CUT,
      me.VOLU, me.VOLD, me.MUTE,
      cu.SCSH, cu.CLOS, cu.":P",

      # Combos start here in the same order we defined them above
      hold.reg.layer 1,
      hold.reg.layer 2,
    
    ]]
}

```