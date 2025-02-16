let { tap, hold, td, combo, macro, ..} = import "fak/keycode.ncl" in
let util = import "fak/util_functions.ncl" in 

let virtual_keys' = [
    combo.make 50 [0, 9],
    
    # Row 0L, QW, WF, FP
    combo.make 0 [0,1],
    combo.make 1 [1,2],
    combo.make 2 [2,3],

    # Row 1L, AR, RS, ST
    combo.make 3 [10,11],
    combo.make 4 [11,12],
    combo.make 5 [12,13],

    # Row 2L, ZX, XC, CD
    combo.make 6 [20,21],
    combo.make 7 [21,22],
    combo.make 8 [23,24],

    # Row 0R LU, UY, Y:
    combo.make 9 [7,8],
    combo.make 10 [8,9],
    combo.make 11 [9,10],

    # Row 1R NE, EI, IO
    combo.make 12 [17,18],
    combo.make 13 [18,19],
    combo.make 14 [19,20],

    # Row 2R H<, <>, >?
    combo.make 15 [27,28],
    combo.make 16 [28,29],
    combo.make 17 [29,30],

    
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

# custom keycodes in a tidy container (access with `cu.COPY` etc.)
let cu = {
  COPY = md.lctl & kc.INS, # md.lctl & kc.C,
  PSTE = md.lsft & kc.INS, # md.lctl & kc.V,
  CUT  = md.lctl & kc.X,
} in

# home row mods
# hold.reg.behavior is required for all hold-taps!
# I've added empty ones here for simplicity. See thumb function below for a slightly more involved approach.
let hrm = {
  # home row mods
  A = mdh.lgui & kc.A & hold.reg.behavior {},
  R = mdh.lsft & kc.R & hold.reg.behavior {},
  S = mdh.lctl & kc.S & hold.reg.behavior {},
  T = mdh.lalt & kc.T & hold.reg.behavior {},
  
  N = mdh.ralt & kc.N & hold.reg.behavior {},
  E = mdh.rctl & kc.E & hold.reg.behavior {},
  I = mdh.rsft & kc.I & hold.reg.behavior {},
  O = mdh.rgui & kc.O & hold.reg.behavior {},
} in

# thumb keys defined here
# this function maps the numbers 0, 1, 2, 3 to the below behaviors
let thumb = fun thumb_idx =>
  let thumb_behavior = {
    timeout_ms = 150,
    timeout_decision = 'hold,
    key_interrupts = std.array.replicate key_count { decision = 'hold, trigger_on = 'release },
  } in
  [
    kc.QUOT & lt 1 & hold.reg.behavior thumb_behavior, # thumb 0
    kc.SPC  & lt 2 & hold.reg.behavior thumb_behavior, # thumb 1
    kc.BSPC & lt 3 & hold.reg.behavior thumb_behavior, # thumb 2
    kc.ENT  & lt 4 & hold.reg.behavior thumb_behavior, # thumb 3
  ]
  |> std.array.at thumb_idx # pick out the appropriate entry from the above list
in

### Keymap itself! ###
{
  # combos and other virtual keys are defined here
  # (careful, changes here require changes above! marked by "#1")
  virtual_keys = [
    combo.make 50 [0, 9],
  ],
  layers = [
    # ALPHAS
    [
      kc.Q,    kc.W,    kc.F,    kc.P,    kc.B,        kc.J,    kc.L,    kc.U,    kc.Y,   kc.SCLN,
      hrm.A,   hrm.R,   hrm.S,   hrm.T,   kc.G,        kc.M,    hrm.N,   hrm.E,   hrm.I,  hrm.O,
      kc.Z,    kc.X,    kc.C,    kc.D,    kc.V,        kc.K,    kc.H,    kc.COMM, kc.DOT, kc.SLSH,
                                 # thumb keys are defined above in the function "thumb"
                                 thumb 0, thumb 1,     thumb 2, thumb 3,
      # combos:
      fak.BOOT,
    ],
    # 1
    [
      kc.F1,  kc.F2,    kc.F3,  kc.F4,    xx,          xx,      kc.HOME,  kc.PGUP,  xx,       xx,
      kc.F5,  kc.F6,    kc.F7,  kc.F8,    xx,          kc.LEFT, kc.DOWN,  kc.UP,    kc.RIGHT, xx,
      kc.F9,  kc.F10,   kc.F11, kc.F12,   xx,          xx,      kc.END,   kc.PGDN,  xx,       xx,
                          tt & ht,  tt & ht,            tt & ht, tt & ht,
    ]
    # 2
    [

    ]
    # 3
    [

    ]
    # 4
    [

    ]
  ]
}
