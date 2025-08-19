class_name CellState

# 0-6 代表周围的雷数
const ZERO: int = 0
const ONE: int = 1
const TWO: int = 2
const THREE: int = 3
const FOUR: int = 4
const FIVE: int = 5
const SIX: int = 6
const NUMBER_MASK: int = 0b111 # 用于获取数字部分
# 使用位标志来存储额外状态
const MINE: int = 1 << 3
const MARKED_SURE: int = 1 << 4
const MARKED_UNSURE: int = 1 << 5
const REVEALED: int = 1 << 6
const MARKED: int = MARKED_SURE | MARKED_UNSURE
const MARKED_OR_REVEALED: int = MARKED | REVEALED
const MARKED_SURE_OR_MINE: int = MARKED_SURE | MINE

static func is_(s: int, mask: int) -> bool:
    return (s & mask) != 0

static func is_not(s: int, mask: int) -> bool:
    return (s & mask) == 0

static func with(s: int, mask: int) -> int:
    return s | mask

static func without(s: int, mask: int) -> int:
    return s & ~mask