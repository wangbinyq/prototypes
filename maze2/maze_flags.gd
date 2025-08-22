class_name MazeFlags

const Empty = 0

const PassageN = 0b0001
const PassageE = 0b0010
const PassageS = 0b0100
const PassageW = 0b1000

const PassageAll = 0b1111

static func has(f: int, mask: int) -> bool:
	return (f & mask) == mask

static func has_any(f: int, mask: int) -> bool:
	return (f & mask) != 0
	
static func has_not(f: int, mask: int) -> bool:
	return (f & mask) != mask
	
static func has_exactly_one(f: int) -> bool:
	return f != 0 && (f & (f - 1)) == 0

static func with(f: int, mask: int) -> int:
	return f | mask
	
static func without(f: int, mask) -> int:
	return f & ~mask
