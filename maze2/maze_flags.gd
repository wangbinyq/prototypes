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

static func is_dead_end(f: int) -> bool:
	return f == PassageN or f == PassageS or f == PassageE or f == PassageW

static func is_straight(f: int) -> bool:
	return f == PassageN | PassageS or f == PassageE | PassageW

static func is_corner(f: int) -> bool:
	return f == PassageN | PassageE or f == PassageE | PassageS or f == PassageS | PassageW or f == PassageW | PassageN

static func is_t_junction(f: int) -> bool:
	return f == (PassageAll & ~PassageW) or f == (PassageAll & ~PassageN) or f == (PassageAll & ~PassageE) or f == (PassageAll & ~PassageS)

static func rotation(f: int) -> Vector3:
	if f == PassageE or f == PassageE | PassageW or f == PassageE | PassageS or f == PassageAll & ~PassageN:
		return Vector3(0, PI / 2, 0)
	elif f == PassageS or f == PassageS | PassageW or f == PassageAll & ~PassageE:
		return Vector3(0, PI, 0)
	elif f == PassageW or f == PassageW | PassageN or f == PassageAll & ~PassageS:
		return Vector3(0, 3 * PI / 2, 0)
	return Vector3.ZERO
