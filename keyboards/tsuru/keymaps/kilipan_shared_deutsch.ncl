let { make_base, .. } = import "lib/kilipan_base_deutsch.ncl" in

let paddings = {
  top = { left = 1, middle = 0, right = 0 },
  mid = { left = 0, middle = 0, right = 0 },
  bot = { left = 1, middle = 3, right = 0 },
  thm = { left = 0, middle = 1, right = 0 },
} in
let base = make_base paddings in

let { alph, numb, navi, symb, func, over } = base.keymap in

let tsuruize =
 fun fingers thumbs combos =>
      (std.array.slice 0 19 fingers)
    @ (std.array.slice 0 1 thumbs)
    @ (std.array.slice 20 23 fingers)
    @ (std.array.slice 1 4 thumbs)
    @ (std.array.slice 26 29 fingers)
    @ (std.array.slice 4 5 thumbs)
    @ combos
in

### default FAK keymap definition
{
  virtual_keys = base.virtual_keys,
  layers = [
    # Alpha layer
    (tsuruize alph.fingers alph.thumbs base.combos_base),
    # Num layer
    (tsuruize numb.fingers numb.thumbs base.combos_trans),
    # Nav layer
    (tsuruize navi.fingers navi.thumbs base.combos_trans),
    # Sym layer
    (tsuruize symb.fingers symb.thumbs base.combos_trans),
    # Fun layer
    (tsuruize func.fingers func.thumbs base.combos_trans),
    # Overlay layer
    (tsuruize over.fingers over.thumbs base.combos_overlay),
  ],
}
