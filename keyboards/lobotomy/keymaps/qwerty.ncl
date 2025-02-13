let { tap, hold, td, combo, macro, ..} = import "fak/keycode.ncl" in

let virtual_keys' = [
  combo.make 50 [0, 9],
] in

let virtual_key_count = std.array.length virtual_keys' in
let key_count = 34 + virtual_key_count in

# convenience aliases
# taps
let kc = tap.reg.kc in # normal keys
let ks = tap.reg.ks in # shifted keys
let md = tap.reg.mod in # combinable mods (ex.: md.lsft & kc.N1 will result in a shifted One ("!" on US layout))
# mod-hold
let mdh = hold.reg.mod in
# layer control
let lt = hold.reg.layer in
# boot, reset, etc
let fak = tap.custom.fak in
# media and mouse control
let media = tap.custom.media in
let mouse = tap.custom.mouse in
# unmapped / transparent taps and holds (transparent hold can make hrm work on any layer!)
let tx = tap.none in
let tt = tap.trans in
let hx = hold.none in
let ht = hold.trans in

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
  S = mdh.lalt & kc.S & hold.reg.behavior {},
  D = mdh.lctl & kc.D & hold.reg.behavior {},
  F = mdh.lsft & kc.F & hold.reg.behavior {},
  J = mdh.rsft & kc.J & hold.reg.behavior {},
  K = mdh.rctl & kc.K & hold.reg.behavior {},
  L = mdh.ralt & kc.L & hold.reg.behavior {},
  ";" = mdh.rgui & kc.SCLN & hold.reg.behavior {},
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
      kc.Q,    kc.W,    kc.E,    kc.R,    kc.T,        kc.Y,    kc.U,    kc.I,    kc.O,   kc.P,
      hrm.A,   hrm.S,   hrm.D,   hrm.F,   kc.G,        kc.H,    hrm.J,   hrm.K,   hrm.L,  hrm.";",
      kc.Z,    kc.X,    kc.C,    kc.V,    kc.B,        kc.N,    kc.M,    kc.COMM, kc.DOT, kc.SLSH,
                                 # thumb keys are defined above in the function "thumb"
                                 thumb 0, thumb 1,     thumb 2, thumb 3,
      # combos:
      fak.BOOT,
    ],
    # NUM, transparent holds makes hrm work on the left hand here
    [
      tx & hx,      tx & hx,      tx & hx,      tx & hx,      tx & hx,   tx & hx, kc.N7,   kc.N8,   kc.N9,   tx & hx,
      kc.PPLS & ht, kc.PMNS & ht, kc.PAST & ht, kc.PSLS & ht, tx & ht,   tx & hx, kc.N4,   kc.N5,   kc.N6,   kc.DOT,
      tx & hx,      tx & hx,      tx & hx,      tx & hx,      tx & hx,   tx & hx, kc.N1,   kc.N2,   kc.N3,   tx & hx,
                                                tt & ht,      tt & ht,   kc.E,    kc.N0,
      # combos (need to add these to every layer)
      tx & hx,
    ],
    # NAV
    [
      tx & hx,    tx & hx,      tx & hx,      tx & hx,      media.VOLU,       cu.COPY,    kc.HOME,    kc.UP,    kc.END,   tx & hx,
      tx & hx,    tx & hx,      tx & hx,      tx & hx,      media.VOLD,       media.MUTE, kc.LEFT,    kc.DOWN,  kc.RGHT,  kc.TAB,
      tx & hx,    cu.COPY,      cu.CUT,       cu.PSTE,      tx & hx,          tx & hx,    hx & tx,    kc.PGUP,  hx & tx,  tx & hx,
                                              tt & ht,      tt & ht,          tt & ht,    tt & ht,
      # combos (need to add these to every layer)
      tx & hx,
    ],
    # SYM
    [
      tt,      tx & hx, tx & hx, tx & hx, tx & hx,   tx & hx, tx & hx, tx & hx, tx & hx, tx & hx,
      ks.EXLM, ks.AT,   ks.HASH, ks.DLR,  tx & hx,   tx & hx, ks.AMPR, ks.ASTR, ks.PERC, ks.CIRC,
      tx & hx, kc.GRV,  ks.DQUO, ks.UNDS, tx & hx,   tx & hx, kc.BSLS, ks.PIPE, kc.EQL,  hx & hx,
                                 ks.TILD, tt & ht,   tt & ht, tt & ht,
      # combos (need to add these to every layer)
      tx & hx,
    ],
    # FUN
    [
      tt,      fak.BOOT, tt & ht, tt & ht, tt & ht,   tt & ht, kc.F7,   kc.F8,   kc.F8,   tt & ht,
      tt & ht, kc.F12,   kc.F11,  kc.F10,  tt & ht,   tt & ht, kc.F4,   kc.F5,   kc.F6,   tt & ht,
      tx & hx, kc.F9,    kc.F8,   kc.F7,   tx & hx,   tx & hx, kc.F1,   kc.F2,   kc.F3,   tx & hx,
                                  tt & ht, tt & ht,   tt & ht, tt & ht,
      # combos (need to add these to every layer)
      tx & hx,
    ],
  ]
}
