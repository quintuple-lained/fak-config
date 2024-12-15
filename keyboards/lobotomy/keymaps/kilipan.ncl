let { tap, hold, td, combo, macro, ..} = import "fak/keycode.ncl" in
let util = import "fak/util_functions.ncl" in

let virtual_keys' = [
  # alpha
  combo.make 25 [1, 2],   # V
  combo.make 25 [2, 3],   # Q
  combo.make 25 [20, 21], # Z
  combo.make 25 [1, 3],   # SCH
  combo.make 25 [11, 28],  # SZ
  combo.make 25 [17, 29], # AE
  combo.make 25 [19, 29], # OE
  combo.make 25 [7, 29],  # UE
  # sym
  combo.make 25 [24, 25], # SLSH
  combo.make 25 [23, 24], # MINS
  combo.make 25 [24, 29], # SEMI
  combo.make 25 [17, 24], # SEMI vertical
  combo.make 25 [25, 29], # COLON
  combo.make 25 [18, 25], # COLON vertical
  # parentheticals
  combo.make 25 [1, 11],  # {
  combo.make 25 [2, 12], # [
  combo.make 25 [3, 13], # (
  combo.make 25 [4, 14], # <
  combo.make 25 [5, 15], # >
  combo.make 25 [6, 16], # )
  combo.make 25 [7, 17], # ]
  combo.make 25 [8, 18], # }
  # nav
  combo.make 25 [21, 22], # ESC
  combo.make 25 [23, 25], # ENT
  combo.make 25 [6, 7], # BSPC
  combo.make 25 [7, 8], # DEL
  combo.make 25 [6, 8], # C-BSPC
  # caps
  combo.make 25 [13, 16], # caps word
  combo.make 25 [1, 8], # caps lock
] in

let virtual_key_count = std.array.length virtual_keys' in
let key_count = 34 + virtual_key_count in

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
let sk = {
  lctl = sk'.lctl & mdh.lctl & hold.reg.behavior sticky_behavior,
  rctl = sk'.rctl & mdh.rctl & hold.reg.behavior sticky_behavior,
  lalt = sk'.lalt & mdh.lalt & hold.reg.behavior sticky_behavior,
  ralt = sk'.ralt & mdh.ralt & hold.reg.behavior sticky_behavior,
  lgui = sk'.lgui & mdh.lgui & hold.reg.behavior sticky_behavior,
  rgui = sk'.rgui & mdh.rgui & hold.reg.behavior sticky_behavior,
  lsft = sk'.lsft & mdh.lsft & hold.reg.behavior sticky_behavior,
  rsft = sk'.rsft & mdh.rsft & hold.reg.behavior sticky_behavior,
} in

let layouts = {
  APTMAK = "WFPBJLUYRSTHKXNAIOCGDM,.",
  APTMAK_DE = "WFPBJLUZRSTHKXNAIOCGDM,.",
} in

let make_hrm = fun key_idx =>
  let htb_hrm_base = fun eager => {
    timeout_ms = 150,
    # quick_tap_ms = 100,
    # quick_tap_interrupt_ms = 500,
    # global_quick_tap_ms = 80,
    eager_decision = eager,
    timeout_decision = 'hold,
  } in

  let virtual_interrupts = std.array.replicate virtual_key_count ki.hr in

  let htb_hrm_left = fun eager => htb_hrm_base eager & {
    key_interrupts = [
      ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,    ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,
      ki.tr, ki.tr, ki.tr, ki.tr, ki.tr,    ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,
      ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,    ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,
                           ki.hr, ki.hr,    ki.hr, ki.hr,
    ] @ virtual_interrupts
  } in

  let htb_hrm_right = fun eager => htb_hrm_base eager & {
    key_interrupts = [
      ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,    ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,
      ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,    ki.tr, ki.tr, ki.tr, ki.tr, ki.tr,
      ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,    ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,
                           ki.hr, ki.hr,    ki.hr, ki.hr,
    ] @ virtual_interrupts
  } in

  let hrm_mods = [
    mdh.lctl, mdh.lalt, mdh.lgui, mdh.lsft, mdh.ralt,
    mdh.ralt, mdh.rsft, mdh.rgui, mdh.lalt, mdh.rctl,
  ] in

  let hrm_key_indices = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17] in

  if std.array.elem key_idx hrm_key_indices then
    let mod_idx = util.array.index_of key_idx hrm_key_indices in
    let side = if mod_idx < (std.array.length hrm_mods / 2) then 'left else 'right in
    let mod = std.array.at mod_idx hrm_mods in

    mod & hold.reg.behavior (
      (if side == 'left then htb_hrm_left else htb_hrm_right)
      (if mod == mdh.lgui || mod == mdh.lalt then 'none else 'hold)
    )
  else
    {}
in

let alphas = fun layout => layout
  |> std.string.characters
  |> util.array.enumerate
  |> std.array.map (
      fun { index, value } => kc."%{value}"
      & make_hrm index
    )
in

let thumb = fun thumb_idx =>
  let thumb_behavior = {
    timeout_ms = 150,
    timeout_decision = 'hold,
    key_interrupts = std.array.replicate key_count ki.hr,
  } in
  [
    kc.QUOT & lt 1 & hold.reg.behavior thumb_behavior,
    kc.SPC  & lt 2 & hold.reg.behavior thumb_behavior,
    kc.E    & lt 3 & hold.reg.behavior thumb_behavior,
    kc.TAB  & lt 4 & hold.reg.behavior thumb_behavior,    
  ]
  |> std.array.at thumb_idx
in

let cu = {
  # copy custom stuff from example
  COPY = md.lctl & kc.INS, # md.lctl & kc.C,
  PSTE = md.lsft & kc.INS, # md.lctl & kc.V,
  CUT  = md.lctl & kc.X,
  SCH  = macro.make [
    macro.tap kc.S,
    macro.release mdh.rsft,
    macro.tap kc.C,
    macro.tap kc.H,
  ],
  SZ = macro.make [ macro.press mdh.ralt, macro.tap kc.S,    macro.release mdh.ralt, ],
  AE = macro.make [ macro.press mdh.ralt, macro.tap ks.DQUO, macro.release mdh.ralt, macro.tap kc.A, ],
  OE = macro.make [ macro.press mdh.ralt, macro.tap ks.DQUO, macro.release mdh.ralt, macro.tap kc.O, ],
  UE = macro.make [ macro.press mdh.ralt, macro.tap ks.DQUO, macro.release mdh.ralt, macro.tap kc.U, ],
} in

let combos_base = [
  kc.V, kc.Q, kc.Z, cu.SCH, cu.SZ, cu.AE, cu.OE, cu.UE,
  kc.SLSH, kc.MINS, kc.SCLN, kc.SCLN, ks.COLN, ks.COLN,
  ks.LCBR, kc.LBRC, ks.LPRN, ks.LABK, ks.RABK, ks.RPRN, kc.RBRC, ks.RCBR,
  kc.ESC, kc.ENT, kc.BSPC, kc.DEL, md.lctl & kc.BSPC,
  fak.CWTG, kc.CAPS_LOCK,
] in

### Keymap itself! ###
{
  virtual_keys = virtual_keys',
  layers = [
    let base = fun key_idx => (alphas layouts.APTMAK) |> std.array.at key_idx in
    # ALPHAS
    [
      tx & hx, base 0,  base 1,  base 2,  base 3,      base 4,  base 5,  base 6,  base 7,  tx & hx,
      base 8,  base 9,  base 10, base 11, base 12,     base 13, base 14, base 15, base 16, base 17,
      tx & hx, base 18, base 19, base 20, tx & hx,     tx & hx, base 21, base 22, base 23, tx & hx,
                                 thumb 0, thumb 1,     thumb 2, thumb 3,
    ] @ combos_base,
    # NUM
    [
      tx & hx,      tx & hx,      tx & hx,      tx & hx,      tx & hx,   tx & hx, kc.N7,   kc.N8,   kc.N9,   tx & hx,
      kc.PPLS & ht, kc.PMNS & ht, kc.PAST & ht, kc.PSLS & ht, tx & ht,   tx & hx, kc.N4,   kc.N5,   kc.N6,   kc.DOT,
      tx & hx,      kc.N9,        kc.N8,        kc.N7,        tx & hx,   tx & hx, kc.N1,   kc.N2,   kc.N3,   tx & hx,
                                                tt & ht,      tt & ht,   kc.E,    kc.N0,
    ] @ combos_base,
    # NAV
    [
      tx & hx,    tx & hx,      tx & hx,      tx & hx,      media.VOLU,       cu.CUT,     cu.COPY,    cu.PSTE,  tx & hx,    tx & hx,
      sk.lctl,    sk.lalt,      sk.lgui,      sk.lsft,      media.VOLD,       media.MUTE, kc.LEFT,    kc.DOWN,  kc.UP,      kc.RGHT,
      tx & hx,    kc.HOME,      kc.PGDN,      kc.END,       tx & hx,          tx & hx,    kc.HOME,    kc.PGUP,  kc.END,     tx & hx,
                                              tt & ht,      tt & ht,          tt & ht,    tt & ht,
    ] @ combos_base,
    # SYM
    [
      tt,      tx & hx, tx & hx, tx & hx, tx & hx,   tx & hx, tx & hx, tx & hx, tx & hx, tx & hx,
      ks.EXLM, ks.AT,   ks.HASH, ks.DLR,  tx & hx,   tx & hx, ks.AMPR, ks.ASTR, ks.PERC, ks.CIRC,
      tx & hx, kc.GRV,  ks.DQUO, ks.UNDS, tx & hx,   tx & hx, kc.BSLS, ks.PIPE, kc.EQL,  hx & hx,
                                 ks.TILD, tt & ht,   tt & ht, tt & ht,
    ] @ combos_base,
    # FUN
    [
      tt,      fak.BOOT, tt & ht, tt & ht, tt & ht,   tt & ht, kc.F7,   kc.F8,   kc.F8,   tt & ht,
      tt & ht, kc.F12,   kc.F11,  kc.F10,  tt & ht,   tt & ht, kc.F4,   kc.F5,   kc.F6,   tt & ht,
      tx & hx, kc.F9,    kc.F8,   kc.F7,   tx & hx,   tx & hx, kc.F1,   kc.F2,   kc.F3,   tx & hx
                                  tt & ht, tt & ht,   tt & ht, tt & ht,
    ] @ combos_base,
  ]
}
