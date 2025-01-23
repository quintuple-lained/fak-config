let { ColToRowKey, .. } = import "fak/keyboard.ncl" in
let { CH552T, .. } = import "fak/mcus.ncl" in

{
  mcu = CH552T,
  matrix = {
    cols = [33, 34, 35, 13, 12, 10, 11, 31, 30, 17],
    rows = [15, 16, 14, 32],
  },
  usb_dev = {
    vendor_id = 43962, # 0xABBA
    product_id = 4,
    product_ver = 256, # 0x0100
  },
  keys =
    let M = ColToRowKey in
    [
      M 0 0, M 1 0, M 2 0, M 3 0, M 4 0,  M 5 0, M 6 0, M 7 0, M 8 0, M 9 0,
      M 0 1, M 1 1, M 2 1, M 3 1, M 4 1,  M 5 1, M 6 1, M 7 1, M 8 1, M 9 1,
      M 0 2, M 1 2, M 2 2, M 3 2, M 4 2,  M 5 2, M 6 2, M 7 2, M 8 2, M 9 2,
                    M 2 3,        M 4 3,  M 5 3,        M 7 3,
    ]
}

#  0  1  2  3  4     5  6  7  8  9
# 10 11 12 13 14    15 16 17 18 19
# 20 21 22 23 24    25 26 27 28 29
#          26 27    28 29
