let { make_base, .. } = import "lib/kilipan_base.ncl" in

let paddings = {
  top = { left = 0, middle = 0, right = 0 },
  mid = { left = 0, middle = 0, right = 0 },
  bot = { left = 0, middle = 0, right = 0 },
  thm = { left = 0, middle = 0, right = 0 },
} in
let base = make_base paddings in

let { alph, numb, navi, symb, func } = base.keymap in

### default FAK keymap definition
{
  virtual_keys = base.virtual_keys,
  layers = [
    # Alpha layer
    alph.fingers @ alph.thumbs @ base.combos_base,
    # Num layer
    numb.fingers @ numb.thumbs @ base.combos_base,
    # navv nav
    navi.fingers @ navi.thumbs @ base.combos_base,
    # Sym layer
    symb.fingers @ symb.thumbs @ base.combos_base,
    # Fun layer
    func.fingers @ func.thumbs @ base.combos_base,
    #          alpha 0,   alpha 1, alpha 2,  alpha 3,  alpha 4,  alpha 5,  alpha 6,  alpha 7,
    # alpha 8, alpha 9,  alpha 10, alpha 11, alpha 12, alpha 13, alpha 14, alpha 15, alpha 16, alpha 17, 
    #          alpha 18, alpha 19, alpha 20,                     alpha 21, alpha 22, alpha 23, 
    #                              thumb 0,  thumb 1,  thumb 2,  thumb 3,  
    # ] @ base.combos_base,
  ],
}
