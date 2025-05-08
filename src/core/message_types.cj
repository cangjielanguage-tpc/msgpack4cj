/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core

//map
protected const FIXMAP_MIN: Byte = 0x80
protected const POSFIXINT_MASK: Byte = 0x80
protected const FIXMAP_PREFIX: Byte = 0x80


protected const FIXMAP_MAX: Byte = 0x8F

protected const MAP16: Byte = 0xDE

protected const MAP32: Byte = 0xDF

//arr
protected const FIXARR_MIN: Byte = 0x90
protected const FIXARRAY_PREFIX: Byte = 0x90

protected const FIXARR_MAX: Byte = 0x9F

protected const ARR16: Byte = 0xDC

protected const ARR32: Byte = 0xDD

//str
protected const FIXSTR_MIN: Byte = 0xA0
protected const FIXSTR_PREFIX: Byte = 0xA0

protected const FIXSTR_MAX: Byte = 0xBF

protected const STR8: Byte = 0xD9

protected const STR16: Byte = 0xDA

protected const STR32: Byte = 0xDB

//int
protected const POSITIVE_FIXINT_MIN: Byte = 0x00

protected const POSITIVE_FIXINT_MAX: Byte = 0x7F

protected const NEGATIVE_FIXINT_MIN: Byte = 0xE0
protected const NEGFIXINT_PREFIX: Byte = 0xE0

protected const NEGATIVE_FIXINT_MAX: Byte = 0xFF

protected const UINT8: Byte = 0xCC

protected const UINT16: Byte = 0xCD

protected const UINT32: Byte = 0xCE

protected const UINT64: Byte = 0xCF

protected const INT8: Byte = 0xD0

protected const INT16: Byte = 0xD1

protected const INT32: Byte = 0xD2

protected const INT64: Byte = 0xD3

//null
protected const NULL: Byte = 0xC0

//bool
protected const FALSE: Byte = 0xC2

protected const TRUE: Byte = 0xC3

//float
protected const FLOAT32: Byte = 0xCA

protected const FLOAT64: Byte = 0xCB

//binay
protected const BIN8: Byte = 0xC4

protected const BIN16: Byte = 0xC5

protected const BIN32: Byte = 0xC6

protected const FIXEXT1: Byte = 0xD4
protected const FIXEXT2: Byte = 0xD5
protected const FIXEXT4: Byte = 0xD6
protected const FIXEXT8: Byte = 0xD7
protected const FIXEXT16: Byte = 0xD8

protected const EXT_TIMESTAMP: Byte = 255

protected const EXT8: Byte = 0xC7
protected const EXT16: Byte = 0xC8
protected const EXT32: Byte = 0xC9

protected func isFixInt(flag: Byte): Bool {
    return flag >= NEGATIVE_FIXINT_MIN || flag <= POSITIVE_FIXINT_MAX
}

protected func isFixStr(flag: Byte): Bool {
    return flag >= FIXSTR_MIN && flag <= FIXSTR_MAX
}

protected func isFixMap(flag: Byte): Bool {
    return flag >= FIXMAP_MIN && flag <= FIXMAP_MAX
}

protected func isFixArr(flag: Byte): Bool {
    return flag >= FIXARR_MIN && flag <= FIXARR_MAX
}