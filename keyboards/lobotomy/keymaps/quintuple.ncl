let { tap, hold, td, combo, macro, ..} = import "fak/keycode.ncl" in
let util = import "fak/util_functions.ncl" in 

let virtual_keys' = [
    combo.make 50 [0, 9],
] in

let virtual_key_count = std.array.length virtual_keys' in
let key_count = 34 + virtual_key_count in 

let cu = {
    COPY = md.lctl & kc.C,
    PSTE = md.lctl & kc.V,
    CUT  = md.lctl & kc.X,
    KILL = md.lalt & kc.F4,
}

# convenience aliases
# taps
let kc = tap.reg.kc in
let ks = tap.reg.ks in
let md = tap.reg.mod in
# holds
# let kch = hold.reg.kc in
# let ksh = hold.reg.ks in
let mdh = hold.reg.mod in
# sticky key
let sk' = tap.sticky.mod in
# layer control
let lt = hold.reg.layer in
# boot, reset, etc
let fak = tap.custom.fak in
# media and mouse control
let media = tap.custom.media in
let mouse = tap.custom.mouse in
# keymap stuff
let tx = tap.none in
let tt = tap.trans in
let hx = hold.none in
let ht = hold.trans in

let ki = {
  hp = { decision = 'hold, trigger_on = 'press },
  tp = { decision = 'tap, trigger_on = 'press },
  hr = { decision = 'hold, trigger_on = 'release },
  tr = { decision = 'tap, trigger_on = 'release },
  xx = { decision = 'none },
} in

let sticky_behavior = {
  timeout_ms = 150,
  timeout_decision = 'hold,
  key_interrupts = std.array.replicate key_count ki.hr,
} in

let layouts = {
    COLEMAK_DH = "QWFPBJLUY;ARSTGMNEIOZXCDVKH,./",
    QWERTY = "QWERTYUIOPASDFGHJKL;ZXCVBNM,./",
} in