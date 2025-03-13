let { make_base, .. } = import "lib/kilipan_base.ncl" in

let paddings = {
  top = { left = 1, middle = 0, right = 0 },
  mid = { left = 0, middle = 0, right = 0 },
  bot = { left = 0, middle = 1, right = 0 },
  thm = { left = 0, middle = 0, right = 0 },
} in
let base = make_base paddings in

let { alph, numb, navi, symb, func, over } = base.keymap in

### default FAK keymap definition
{
  virtual_keys = base.virtual_keys,
  layers = [
    # Alpha layer
    let a = fun index => std.array.at index alph.fingers in
    let t = fun index => std.array.at index alph.thumbs in
    [
        a 0, a 1,  a 2,  a 3,  a 4,   a 5,  a 6,  a 7,  a 8,
       a 9, a 10, a 11, a 12, a 13,    a 14, a 15, a 16, a 17, a 18,
      t 0, a 19, a 20, a 21, t 1,  t 0, t 2,  a 24, a 25, a 26, t 3
    ]
    alph.fingers @ alph.thumbs @ base.combos_base,
    # Num layer
    numb.fingers @ numb.thumbs @ base.combos_trans,
    # Nav layer
    navi.fingers @ navi.thumbs @ base.combos_trans,
    # Sym layer
    symb.fingers @ symb.thumbs @ base.combos_trans,
    # Fun layer
    func.fingers @ func.thumbs @ base.combos_trans,
    # Override layer
    over.fingers @ over.thumbs @ base.combos_trans,
  ],
}
