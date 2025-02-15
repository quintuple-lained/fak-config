let keycode = import "../../subprojects/fak/ncl/fak/keycode.ncl" in

# define key interrupt behaviors to use with Home Row Mods
let ki_ = {
  hp = { decision = 'hold, trigger_on = 'press },
  tp = { decision = 'tap, trigger_on = 'press },
  hr = { decision = 'hold, trigger_on = 'release },
  tr = { decision = 'tap, trigger_on = 'release },
  xx = { decision = 'none },
} in

# utility functions for padding the 28-key base layout
let rec padding = {
  # add the appropriate padding to a given base index
  pad_idx | std.number.Nat -> Dyn -> std.number.Nat =
    fun idx paddings =>
      idx + paddings.top.left
          + (if idx >  3 then paddings.top.middle 
             + (if idx > 7 then paddings.top.right + paddings.mid.left 
                + (if idx > 12 then paddings.mid.middle
                   + (if idx > 17 then paddings.mid.right + paddings.bot.left
                      + (if idx > 20 then paddings.bot.middle
                         + (if idx > 23 then paddings.bot.right + paddings.thm.left
                            + (if idx > 25 then paddings.thm.middle
                               else 0)
                            else 0)
                         else 0)
                      else 0)
                   else 0)
                else 0)
             else 0),
  # Add the appropriate padding to a combo
  pad_combo | Array std.number.Nat -> Dyn -> Array std.number.Nat =
    fun combo paddings =>
      std.array.map (fun x => pad_idx x paddings) combo,
  # Add the appropriate padding to an array of combos
  pad_combo_array | Array Dyn -> Dyn =
    fun combos paddings =>
      std.array.map (fun x => pad_combo x paddings) combos,
  # Count extra keys compared to base layout (add up all entries in paddings)
  extra_keys = fun paddings =>
    std.record.values paddings
      |> std.array.map std.record.values
      |> std.array.flatten
      |> std.array.fold_left (+) 0,

  # turn base combos into padded version and make the keycodes for vanilla FAK
  make_virtual_keys = fun paddings combo_term combo_indices =>
    std.array.map
      (fun combo => keycode.combo.make combo_term combo)
      (pad_combo_array combo_indices paddings),

  # n_base_keys = {
  #   top_left = 4, top_middle = 0, top_right = 4,
  #   mid_left = 5, mid_middle = 0, mid_right = 5,
  #   bot_left = 3, bot_middle = 0, bot_right = 3,
  #   thm_left = 2, thm_middle = 0, thm_right = 2,
  # },

  # create appropriately padded versions of the positional hold-tap config for left hand
  padded_hrm_left = fun paddings =>
      (std.array.replicate (paddings.top.left + 4) ki_.tp)
    @ (std.array.replicate (paddings.top.middle + 4 + paddings.top.right) ki_.hr)
    @ (std.array.replicate (paddings.mid.left + 5) ki_.tr)
    @ (std.array.replicate (paddings.mid.middle + 5 + paddings.mid.right) ki_.hr)
    @ (std.array.replicate (paddings.bot.left + 3) ki_.tp)
    @ (std.array.replicate (paddings.bot.middle + 3 + paddings.bot.right) ki_.hr)
    @ (std.array.replicate (paddings.thm.left + 2 + paddings.thm.middle + 2 + paddings.thm.right) ki_.hr),

  # create appropriately padded versions of the positional hold-tap config for right hand
  padded_hrm_right = fun paddings =>
      (std.array.replicate (paddings.top.left + 4 + paddings.top.middle) ki_.hr)
    @ (std.array.replicate (4 + paddings.top.right) ki_.tp)
    @ (std.array.replicate (paddings.mid.left + 5 + paddings.mid.middle) ki_.hr)
    @ (std.array.replicate (5 + paddings.mid.right) ki_.tr)
    @ (std.array.replicate (paddings.bot.left + 3 + paddings.bot.middle) ki_.hr)
    @ (std.array.replicate (3 + paddings.bot.right) ki_.tp)
    @ (std.array.replicate (paddings.thm.left + 2 + paddings.thm.middle + 2 + paddings.thm.right) ki_.hr),

  # pad an existing finger-keymap with 'tx & hx' on the positions indicated by paddings
  pad_fingers = fun fingers padding_value paddings =>
    let split_1 = std.array.split_at 4 fingers in       # 4 | 24
    let top_left = split_1.left in                      # top left 4 keys
    let split_2 = std.array.split_at 4 split_1.right in # 4 | 20
    let top_right = split_2.left in                     # top right 4 keys
    let split_3 = std.array.split_at 5 split_2.right in # 5 | 15
    let mid_left = split_3.left in                      # middle left 5 keys
    let split_4 = std.array.split_at 5 split_3.right in # 5 | 10
    let mid_right = split_4.left in                     # middle right 5 keys
    let split_5 = std.array.split_at 3 split_4.right in # 3 | 7
    let bot_left = split_5.left in                      # bottom left 3 keys
    let bot_right = split_5.right in                    # bottom right 3 keys
      (std.array.replicate paddings.top.left padding_value)
    @ top_left
    @ (std.array.replicate paddings.top.middle padding_value)
    @ top_right
    @ (std.array.replicate paddings.top.right padding_value)
    @ (std.array.replicate paddings.mid.left padding_value)
    @ mid_left
    @ (std.array.replicate paddings.mid.middle padding_value)
    @ mid_right
    @ (std.array.replicate paddings.mid.right padding_value)
    @ (std.array.replicate paddings.bot.left padding_value)
    @ bot_left
    @ (std.array.replicate paddings.bot.middle padding_value)
    @ bot_right
    @ (std.array.replicate paddings.bot.right padding_value),
  # pad an existing thumb-keymap with 'tx & hx' on the positions indicated by paddings
  pad_thumbs = fun thumbs padding_value paddings =>
      (std.array.replicate paddings.thm.left padding_value)
    @ (std.array.split_at 2 thumbs).left
    @ (std.array.replicate paddings.thm.middle padding_value)
    @ (std.array.split_at 2 thumbs).right
    @ (std.array.replicate paddings.thm.right padding_value),
} in

{
  ki = ki_,
  pad_combo = padding.pad_combo,
  extra_keys = padding.extra_keys,
  make_virtual_keys = padding.make_virtual_keys,
  padded_hrm_left = padding.padded_hrm_left,
  padded_hrm_right = padding.padded_hrm_right,
  pad_fingers = padding.pad_fingers,
  pad_thumbs = padding.pad_thumbs,
}
