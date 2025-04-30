let { tap, hold, td, combo, macro, ..} = import "fak/keycode.ncl" in
let util = import "fak/util_functions.ncl" in  # Import utility functions

# Define all combos first
let virtual_keys' = [
    # Row 0L
    combo.make 0 [0,1],  # QW - ESC
    combo.make 1 [1,2],  # WF - printscreen
    combo.make 2 [2,3],  # FP - copy
    
    # Row 1L
    combo.make 3 [10,11], # AR, RS - {
    combo.make 4 [11,12], # RS, ST - [
    combo.make 5 [12,13], # ST - (
    
    # Row 2L
    combo.make 6 [20,21], # ZX, XC - <
    combo.make 7 [21,22], # XC, CD - =
    combo.make 8 [23,24], # CD - paste
    
    # Row 0R
    combo.make 9 [7,8],   # LU, UY - home
    combo.make 10 [8,9],  # UY, Y - none
    combo.make 11 [9,10], # Y: - :
    
    # Row 1R
    combo.make 12 [17,18], # NE, EI - )
    combo.make 13 [18,19], # EI, IO - ]
    combo.make 14 [19,20], # IO - }
    
    # Row 2R
    combo.make 15 [27,28], # H<, <> - END
    combo.make 16 [28,29], # <>, >? - ::
    combo.make 17 [29,30], # >? - >
] in

# Number of combo actions we've defined
let virtual_key_count = std.array.length virtual_keys' in
let key_count = 34 + virtual_key_count in

# Convenience aliases
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
let xx = tap.none & hold.none in

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

# Custom keycodes in a tidy container
let cu = {
  COPY = md.lctl & kc.INS, # md.lctl & kc.C,
  PSTE = md.lsft & kc.INS, # md.lctl & kc.V,
  CUT  = md.lctl & kc.X,
  KILL = md.lalt & kc.F4,
} in

# Home row mods
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

# Define double_colon as a proper macro
let double_colon = macro.make [
  macro.tap ks.COLN,
  macro.tap ks.COLN
] in

# Define the actual combo actions
let combos_base = [
  kc.ESC,            # 0: QW
  kc.PSCR,           # 1: WF
  cu.COPY,           # 2: FP
  ks.LCBR,           # 3: AR - { (use ks.LCBR for left curly brace)
  kc.LBRC,           # 4: RS - [ (use kc.LBRC for left bracket)
  ks.LPRN,           # 5: ST - ( (use ks.LPRN for left parenthesis)
  ks.LABK,           # 6: ZX - < (use ks.LABK for less than sign)
  kc.EQL,            # 7: XC - =
  cu.PSTE,           # 8: CD - paste
  kc.HOME,           # 9: LU - Home
  fak.BOOT,                # 10: UY - none
  ks.COLN,           # 11: Y: - : (use ks.COLN for colon)
  ks.RPRN,           # 12: NE - ) (use ks.RPRN for right parenthesis)
  kc.RBRC,           # 13: EI - ] (use kc.RBRC for right bracket)
  ks.RCBR,           # 14: IO - } (use ks.RCBR for right curly brace)
  kc.END,            # 15: H< - END
  double_colon,      # 16: <> - ::
  ks.RABK,           # 17: >? - > (use ks.RABK for greater than sign)
] in

# Create transparent versions for other layers
let combos_trans = std.array.replicate virtual_key_count (tt & ht) in

# Thumb keys defined here
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
  virtual_keys = virtual_keys',
  layers = [
    # ALPHAS (COLEMAK-DH variant)
    [
      kc.Q,    kc.W,    kc.F,    kc.P,    kc.B,        kc.J,    kc.L,    kc.U,    kc.Y,   kc.SCLN,
      hrm.A,   hrm.R,   hrm.S,   hrm.T,   kc.G,        kc.M,    hrm.N,   hrm.E,   hrm.I,  hrm.O,
      kc.Z,    kc.X,    kc.C,    kc.D,    kc.V,        kc.K,    kc.H,    kc.COMM, kc.DOT, kc.SLSH,
                                 # thumb keys are defined above in the function "thumb"
                                 thumb 0, thumb 1,     thumb 2, thumb 3,
    ] @ combos_base,
    
    # FUNCTION KEYS
    [
      kc.F1,  kc.F2,    kc.F3,  kc.F4,    xx,          xx,      kc.HOME,  kc.PGUP,  xx,       xx,
      kc.F5,  kc.F6,    kc.F7,  kc.F8,    xx,          kc.LEFT, kc.DOWN,  kc.UP,    kc.RIGHT, xx,
      kc.F9,  kc.F10,   kc.F11, kc.F12,   xx,          xx,      kc.END,   kc.PGDN,  xx,       xx,
                                 tt & ht,  tt & ht,     tt & ht, tt & ht,
    ] @ combos_trans,
    
    # NUM
    [
      tx & hx,      tx & hx,      tx & hx,      tx & hx,      tx & hx,   tx & hx, kc.N7,   kc.N8,   kc.N9,   tx & hx,
      kc.PPLS & ht, kc.PMNS & ht, kc.PAST & ht, kc.PSLS & ht, tx & ht,   tx & hx, kc.N4,   kc.N5,   kc.N6,   kc.DOT,
      tx & hx,      tx & hx,      tx & hx,      tx & hx,      tx & hx,   tx & hx, kc.N1,   kc.N2,   kc.N3,   tx & hx,
                                                tt & ht,      tt & ht,   kc.E,    kc.N0,
    ] @ combos_trans,
    
    # NAV
    [
      tx & hx,    tx & hx,      tx & hx,      tx & hx,      media.VOLU,       cu.COPY,    kc.HOME,    kc.UP,    kc.END,   tx & hx,
      tx & hx,    tx & hx,      tx & hx,      tx & hx,      media.VOLD,       media.MUTE, kc.LEFT,    kc.DOWN,  kc.RGHT,  kc.TAB,
      tx & hx,    cu.COPY,      cu.CUT,       cu.PSTE,      tx & hx,          tx & hx,    tx & hx,    kc.PGUP,  tx & hx,  tx & hx,
                                              tt & ht,      tt & ht,          tt & ht,    tt & ht,
    ] @ combos_trans,
    
    # SYM
    [
      tt,      tx & hx, tx & hx, tx & hx, tx & hx,   tx & hx, tx & hx, tx & hx, tx & hx, tx & hx,
      ks.EXLM, ks.AT,   ks.HASH, ks.DLR,  tx & hx,   tx & hx, ks.AMPR, ks.ASTR, ks.PERC, ks.CIRC,
      tx & hx, kc.GRV,  ks.DQUO, ks.UNDS, tx & hx,   tx & hx, kc.BSLS, ks.PIPE, kc.EQL,  tx & hx,
                                 ks.TILD, tt & ht,   tt & ht, tt & ht,
    ] @ combos_trans,
  ]
}