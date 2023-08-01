func int32toUInt16(_ int32: Int32) -> [UInt16] {
    var end = int32.littleEndian
    let count = MemoryLayout<UInt32>.size / MemoryLayout<UInt16>.size
    let bytePtr = withUnsafePointer(to: &end) {
        $0.withMemoryRebound(to: UInt16.self, capacity: count) {
            UnsafeBufferPointer(start: $0, count: count)
        }
    }
    return [UInt16](bytePtr)
}

@inline(__always)
func set3(_ inst: inout UInt16, _ bit3: UInt16, _ offset: UInt8) {
    setMask(&inst, bit3, 0x0007, offset)
}

@inline(__always)
func get3(_ inst: UInt16, _ offset: UInt8) -> UInt16 {
    getMask(inst, 0x0007, offset)
}

@inline(__always)
func set4(_ inst: inout UInt16, _ bit4: UInt16, _ offset: UInt8) {
    setMask(&inst, bit4, 0x000F, offset)
}

func get4(_ inst: UInt16, _ offset: UInt8) -> UInt16 {
    getMask(inst, 0x000F, offset)
}

@inline(__always)
func set5(_ inst: inout UInt16, _ bit5: UInt16, _ offset: UInt8) {
    setMask(&inst, bit5, 0x001F, offset)
}

@inline(__always)
func get5(_ inst: UInt16, _ offset: UInt8) -> UInt16 {
    getMask(inst, 0x001F, offset)
}

@inline(__always)
func set6(_ inst: inout UInt16, _ bit6: UInt16, _ offset: UInt8) {
    setMask(&inst, bit6, 0x003F, offset)
}

@inline(__always)
func get6(_ inst: UInt16, _ offset: UInt8) -> UInt16 {
    getMask(inst, 0x003F, offset)
}

@inline(__always)
func set7(_ inst: inout UInt16, _ bit7: UInt16, _ offset: UInt8) {
    setMask(&inst, bit7, 0x007f, offset)
}

@inline(__always)
func get7(_ inst: UInt16, _ offset: UInt8) -> UInt16 {
    getMask(inst, 0x007f, offset)
}

@inline(__always)
func set8(_ inst: inout UInt16, _ bit3: UInt16, _ offset: UInt8) {
    setMask(&inst, bit3, 0x00ff, offset)
}

@inline(__always)
func get8(_ inst: UInt16, _ offset: UInt8) -> UInt16 {
    getMask(inst, 0x00ff, offset)
}

@inline(__always)
func set10(_ inst: inout UInt16, _ bit11: UInt16, _ offset: UInt8) {
    setMask(&inst, bit11, 0x03ff, offset)
}

@inline(__always)
func get10(_ inst: UInt16, _ offset: UInt8) -> UInt16 {
    getMask(inst, 0x03ff, offset)
}

@inline(__always)
func set11(_ inst: inout UInt16, _ bit11: UInt16, _ offset: UInt8) {
    setMask(&inst, bit11, 0x07ff, offset)
}

@inline(__always)
func get11(_ inst: UInt16, _ offset: UInt8) -> UInt16 {
    getMask(inst, 0x07ff, offset)
}

@inline(__always)
func set12(_ inst: inout UInt16, _ bit11: UInt16, _ offset: UInt8) {
    setMask(&inst, bit11, 0x0fff, offset)
}

@inline(__always)
func get12(_ inst: UInt16, _ offset: UInt8) -> UInt16 {
    getMask(inst, 0x0fff, offset)
}

@inline(__always)
func signExtend8(_ inst: UInt16) -> UInt16 {
    (inst & 0x00FF) | ((inst & 0x0080) != 0 ? 0xFF00 : 0)
}

@inline(__always)
func signExtend11(_ inst: UInt16) -> UInt16 {
    (inst & 0x07FF) | ((inst & 0x0400) != 0 ? 0xF800 : 0)
}

@inline(__always)
func signExtend24(_ inst: UInt32) -> UInt32 {
    (inst & 0x00FFFFFF) | ((inst & 0x00800000) != 0 ? 0xFF000000 : 0)
}

@inline(__always)
func setMask(_ inst: inout UInt16, _ data: UInt16, _ mask: UInt16, _ offset: UInt8) {
    inst |= (data & mask) << offset
}

@inline(__always)
func getMask(_ inst: UInt16, _ mask: UInt16, _ offset: UInt8) -> UInt16 {
    (inst & (mask << offset)) >> offset
}

@inline(__always)
func bitSet(_ data: UInt16, _ n: Int) -> Bool {
    data & (1 << n) != 0
}

@inline(__always)
func setBit(_ inst: inout UInt16, _ n: UInt16) {
    inst |= (1 << n)
}

@inline(__always)
func clearBit(_ inst: inout UInt16, _ n: UInt16) {
    inst &= ~(1 << n)
}

@inline(__always)
func writeBit(_ inst: inout UInt16, _ bit: Bool, _ n: UInt16) {
    bit ? setBit(&inst, n) : clearBit(&inst, n)
}


/// Encodes r1 and r2 into following structure:
/// ```
/// |  7|  6|  5|  4|  3|  2|  1|  0|
/// |r23|r13 r12 r11 r10|r22 r21 r20|
/// ```
func set2reg4(_ inst: inout UInt16, r1: UInt16, r2: UInt16) {
    set4(&inst, r1, 3)
    set3(&inst, r2, 0)
    inst |= (bitSet(r2, 3) ? 1 : 0) << 7
}

/// Decodes r1 and r2 from following structure:
/// ```
/// |  7|  6|  5|  4|  3|  2|  1|  0|
/// |r23|r13 r12 r11 r10|r22 r21 r20|
/// ```
func get2reg4(_ inst: UInt16) -> (r1: UInt16, r2: UInt16) {
    (get4(inst, 3), get3(inst, 0) | (bitSet(inst, 7) ? 0x0008 : 0x0000))
}
