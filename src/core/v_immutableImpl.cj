/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package msgpack4cj.core

import std.math.numeric.*
import std.io.InputStream
import std.io.ByteBuffer
import std.binary.BigEndianOrder
import std.time.DateTime
import std.core.StringBuilder
public class ImmutableNilValueImpl <: AbstractImmutableValue & ImmutableNilValue & Hashable & ToString {


    public static let instance: ImmutableNilValue = ImmutableNilValueImpl()


    public static func get(): ImmutableNilValue {
        return instance
    }

    private init() {
    }

    public override func getValueType(): ValueType {
        return ValueType.NONE(false, false)
    }

    public override func asNilValue(): ImmutableNilValue {
        return this
    }

    public override func immutableValue(): ImmutableNilValue {
        return this
    }


    public override func writeTo(packer: MessagePacker): Unit {
        packer.packNull()
    }

    public override func equals(v: Value): Bool {
        return v.isNilValue()
    }

    public override func hashCode(): Int64 {
        return 0
    }

    public override func toJson(): String {
        return "None"
    }

    public override func toString(): String {
        return toJson()
    }
}

public class ImmutableBooleanValueImpl <: AbstractImmutableValue & ImmutableBooleanValue & Hashable & ToString {


    public static let TRUE: ImmutableBooleanValue = ImmutableBooleanValueImpl(true)
    public static let FALSE: ImmutableBooleanValue = ImmutableBooleanValueImpl(false)
    private let value: Bool

    private init(value: Bool) {
        this.value = value
    }

    public override func getValueType(): ValueType {
        return ValueType.BOOL(false, false)
    }

    public override func asBooleanValue(): ImmutableBooleanValue {
        return this
    }

    public override func immutableValue(): ImmutableBooleanValue {
        return this
    }

    public override func getBoolean(): Bool {
        return value
    }

    public override func writeTo(packer: MessagePacker): Unit {
        packer.packBool(value)
    }

    public override func equals(v: Value): Bool {
        if (!v.isBooleanValue()) {
            return false
        }
        return value == v.asBooleanValue().getBoolean()
    }

    public override func hashCode(): Int64 {
        if (value) {
            return 1231
        }
        else {
            return 1237
        }
    }

    public override func toJson(): String {
        return value.toString()
    }

    public override func toString(): String {
        return toJson()
    }
}

public class ImmutableInt64ValueImpl <: AbstractImmutableValue & ImmutableIntValue & Hashable & ToString {


    private let value: Int64

    public static let BYTE_MIN: Int64 = Int64(Int8.Min)
    public static let BYTE_MAX: Int64 = Int64(Int8.Max)

    public static let INT16_MIN: Int64 = Int64(Int16.Min)
    public static let INT16_MAX: Int64 = Int64(Int16.Max)

    public static let INT32_MIN: Int64 = Int64(Int32.Min)
    public static let INT32_MAX: Int64 = Int64(Int32.Max)


    public init(value: Int64) {
        this.value = value
    }

    public override func getValueType(): ValueType {
        return ValueType.INT(true, false)
    }

    public override func immutableValue(): ImmutableIntValue {
        return this
    }

    public override func asNumberValue(): ImmutableNumberValue {
        return this
    }

    public override func asIntValue(): ImmutableIntValue {
        return this
    }

    @OverflowWrapping
    public override func toInt8(): Int8 {
        return Int8(value)
    }

    @OverflowWrapping
    public override func toInt16(): Int16 {
        return Int16(value)
    }

    @OverflowWrapping
    public override func toInt32(): Int32 {
        return Int32(value)
    }

    public override func toInt64(): Int64 {
        return value
    }

    public override func toFloat32(): Float32 {
        return Float32(value)
    }

    public override func toFloat64(): Float64 {
        return Float64(value)
    }

    public override func isInInt8Range(): Bool
    {
        return BYTE_MIN <= value && value <= BYTE_MAX
    }

    public override func isInInt16Range(): Bool
    {
        return INT16_MIN <= value && value <= INT16_MAX
    }

    public override func isInInt32Range(): Bool
    {
        return INT32_MIN <= value && value <= INT32_MAX
    }

    public override func isInInt64Range(): Bool
    {
        return true
    }

    public override func asInt8(): Int8
    {
        if (!isInInt8Range()) {
            throw MessageIntegerOverflowException(BigInt(value))
        }
        return Int8(value)
    }

    public override func asInt16(): Int16
    {
        if (!isInInt16Range()) {
            throw MessageIntegerOverflowException(BigInt(value))
        }
        return Int16(value)
    }

    public override func asInt32(): Int32
    {
        if (!isInInt32Range()) {
            throw MessageIntegerOverflowException(BigInt(value))
        }
        return Int32(value)
    }

    public override func asInt64(): Int64
    {
        return value
    }

    public override func writeTo(packer: MessagePacker): Unit {
        packer.packInt64(value)
    }

    public override func equals(v: Value): Bool {
        if (!v.isIntValue()) {
            return false
        }
        var intvalue: IntValue = v.asIntValue()
        if (!intvalue.isInInt64Range()) {
            return false
        }
        return value == intvalue.toInt64()
    }

    public override func hashCode(): Int64 {
        if (INT32_MIN <= value && value <= INT32_MAX) {
            return Int64(value)
        }
        else {
            return Int64(value ^ rightShift(value, 32))
        }
    }

    func rightShift(value: Int64, bits: Int64): Int64 {
        let max: Int64 = Int64.Max
        let b = max >> (bits - 1)
        return b & (value >> bits)
    }

    public override func toJson(): String {
        return value.toString()
    }

    public override func toString(): String {
        return toJson()
    }
}

public class ImmutableFloat64ValueImpl <: AbstractImmutableValue & ImmutableFloat64Value & Hashable & ToString {

    private let value: Float64

    public init(value: Float64) {
        this.value = value
    }

    public override func getValueType(): ValueType {
        return ValueType.FLOAT(true, false)
    }

    public override func immutableValue(): ImmutableFloat64ValueImpl {
        return this
    }

    public override func asNumberValue(): ImmutableNumberValue {
        return this
    }

    public override func asFloat64Value(): ImmutableFloat64Value {
        return this
    }

    public override func toInt8(): Int8 {
        return Int8(value)
    }

    public override func toInt16(): Int16 {
        return Int16(value)
    }

    public override func toInt32(): Int32 {
        return Int32(value)
    }

    public override func toInt64(): Int64 {
        return Int64(value)
    }

    public override func toFloat32(): Float32 {
        return Float32(value)
    }

    public override func toFloat64(): Float64 {
        return Float64(value)
    }

    public override func writeTo(packer: MessagePacker): Unit {
        packer.packFloat64(value)
    }

    public override func equals(v: Value): Bool {
        if (!v.isFloat64Value()) {
            return false
        }
        var float64Value: Float64Value = v.asFloat64Value()

        return value == float64Value.toFloat64()
    }

    public override func hashCode(): Int64 {
        let v =  Int64(value)
        return Int64(v ^ rightShift(v, 32))
    }

    func rightShift(value: Int64, bits: Int64): Int64 {
        let max: Int64 = Int64.Max
        let b = max >> (bits - 1)
        return b & (value >> bits)
    }

    public override func toJson(): String {
        return value.toString()
    }

    public override func toString(): String {
        return toJson()
    }
}

public class ImmutableExtensionValueImpl <: AbstractImmutableValue & ImmutableExtensionValue & Hashable & ToString {

    private let dataType: Byte
    private let data: Array<Byte>

    public init(dataType: Byte, data: Array<Byte>) {
        this.dataType = dataType
        this.data = data
    }

    public override func getValueType(): ValueType {
        return ValueType.EXTENSION(false, false)
    }

    public override func immutableValue(): ImmutableExtensionValue {
        return this
    }

    public override func asExtensionValue(): ImmutableExtensionValue {
        return this
    }

    public override func getType(): Byte {
        return dataType
    }

    public override func getData(): Array<Byte> {
        return data
    }

    public override func writeTo(packer: MessagePacker): Unit {
        packer.packExtensionTypeHeader(dataType, Int32(data.size))
    }

    public override func equals(v: Value): Bool {
        if (!v.isExtensionValue()) {
            return false
        }
        var extensionValue: ExtensionValue = v.asExtensionValue()

        return dataType == extensionValue.getType() && data == extensionValue.getData()
    }

    public override func hashCode(): Int64 {
        var hash: Int64 =  31 + Int64(dataType)
        for (e in data) {
            hash = 31 * hash + Int64(e)
        }
        return hash
    }

    public override func toJson(): String {
        var sb: StringBuilder = StringBuilder()
        sb.append('[')
        sb.append(dataType.toString())
        sb.append(",\"")

        for (e in data) {
            sb.append(e.toString())
        }
        sb.append("\"]")
        return sb.toString()
    }

    public override func toString(): String {
        var sb: StringBuilder = StringBuilder()
        sb.append('(')
        sb.append(dataType.toString())
        sb.append(",0x")

        for (e in data) {
            sb.append(e.toString())
        }
        sb.append(")")
        return sb.toString()
    }
}

public class ImmutableStringValueImpl <: AbstractImmutableValue & ImmutableStringValue & Hashable & ToString {

    private let string: String
    public init(string: String) {
        this.string = string
    }

    public override func getValueType(): ValueType {
        return ValueType.STRING(false, true)
    }

    public override func immutableValue(): ImmutableStringValue {
        return this
    }

    public override func asStringValue(): ImmutableStringValue {
        return this
    }

    public override func getString(): String {
        return string
    }

    public override func writeTo(packer: MessagePacker): Unit {
        packer.packString(string)
    }

    public override func equals(v: Value): Bool {
        if (!v.isStringValue()) {
            return false
        }
        var stringValue: StringValue = v.asStringValue()

        return string == stringValue.getString()
    }

    public override func hashCode(): Int64 {
        var hash: Int64 =  1
        var data: Array<Byte>
        unsafe {
            data = string.rawData()
        }
        for (e in data) {
            hash = 31 * hash + Int64(e)
        }
        return hash
    }


    public override func toJson(): String {

        return string
    }

    public override func toString(): String {
        toJson()
    }
}

public class ImmutableTimestampValueImpl <: AbstractImmutableValue & ImmutableTimestampValue & ImmutableExtensionValue & Hashable & ToString {

    private let dateTime: DateTime
    private var data: Array<Byte> = []

    public init(dateTime: DateTime) {
        this.dateTime = dateTime
    }

    public override func isTimestampValue(): Bool {
        return true
    }

    public override func getType(): Byte {
        return EXT_TIMESTAMP
    }

    public override func getValueType(): ValueType {
        return ValueType.EXTENSION(false, true)
    }

    public override func immutableValue(): ImmutableTimestampValue {
        return this
    }

    public override func asExtensionValue(): ImmutableExtensionValue {
        return this
    }

    public override func asTimestampValue(): ImmutableTimestampValue {
        return this
    }

    public override func getEpochSecond(): Int64 {
        return dateTime.toUnixTimeStamp().toSeconds()
    }

    public override func getNano(): Int64 {
        return dateTime.nanosecond
    }

    public override func getData(): Array<Byte> {
        return []
    }

    public override func toDataTime(): DateTime {
        return dateTime
    }

    public override func writeTo(packer: MessagePacker): Unit {
        packer.packTimestamp(dateTime)
    }

    public override func equals(v: Value): Bool {
        if (!v.isTimestampValue()) {
            return false
        }
        var timestampValue: TimestampValue = v.asTimestampValue()

        return (getEpochSecond() == timestampValue.getEpochSecond()) && (getNano() == timestampValue.getNano())
    }

    public override func hashCode(): Int64 {
        var hash: Int64 = Int64(EXT_TIMESTAMP)
        hash = hash * 31
        hash = dateTime.hashCode()
        return hash
    }


    public override func toJson(): String {

        return toDataTime().toString()
    }

    public override func toString(): String {
        return toDataTime().toString()
    }
}

public class ImmutableArrayValueImpl <: AbstractImmutableValue & ImmutableArrayValue & Hashable & ToString {


    public static let EMPTY: ImmutableArrayValueImpl = ImmutableArrayValueImpl([])
    private let array: Array<Value>

    public init(array: Array<Value>) {
        this.array = array
    }

    public static func empty(): ImmutableArrayValue {
        return EMPTY
    }


    public override func getValueType(): ValueType {
        return ValueType.ARRAY(false, false)
    }

    public override func immutableValue(): ImmutableArrayValue {
        return this
    }

    public override func asArrayValue(): ImmutableArrayValue {
        return this
    }

    public override func size(): Int64 {
        return array.size
    }

    public override func get(index: Int64): ?Value {
        if (index < array.size && index >= 0) {
            return array[index]
        } else {
            return Option<Value>.None
        }
         
    }

    public override func iterator(): Iterator<Value> {
        return Ite(array)
    }

    public override func list(): List<Value> {
        return ArrayList<Value>(array)
    }

    public override func writeTo(packer: MessagePacker): Unit {
        packer.packArrayHeader(array.size)
        for (i in 0..array.size) {
            array[i].writeTo(packer)
        }
    }

    public override func equals(v: Value): Bool {
        if (!v.isArrayValue()) {
            return false
        }
        var arrayValue: ArrayValue = v.asArrayValue()
        if (size() != arrayValue.size()) {
            return false
        }

        return true
    }

    public override func hashCode(): Int64 {
        var h = 1
        for (i in 0..array.size) {
            var obj: Value = array[i]
            h = 31 * h + obj.hashCode()
        }
        return h
    }


    public override func toJson(): String {

        if (array.size == 0) {
            return "[]"
        }
        var sb: StringBuilder = StringBuilder()
        sb.append("[")
        sb.append(array[0].toJson())
        for (i in 0..array.size) {
            sb.append(",")
            sb.append(array[i].toJson())
        }
        sb.append("]")
        return sb.toString()
    }

    public override func toString(): String {
        if (array.size == 0) {
            return "[]"
        }
        var sb: StringBuilder = StringBuilder()
        sb.append("[")
        sb.append(array[0].toJson())
        for (i in 0..array.size) {
            sb.append(",")
            sb.append(array[i].toJson())
        }
        sb.append("]")
        return sb.toString()
    }
}

private class Ite
        <: Iterator<Value>
{
    private let array: Array<Value>
    private var index: Int64

    public init(array: Array<Value>)
    {
        this.array = array
        this.index = 0
    }

    public override func next(): ?Value
    {
        var i = index
        if (i >= array.size) {
            throw MessagePackException()
        }
        index = i + 1
        return array[i]
    }
}

public class ImmutableMapValueImpl <: AbstractImmutableValue & ImmutableMapValue & Hashable & ToString {


    public static let EMPTY: ImmutableMapValueImpl = ImmutableMapValueImpl([])
    private let kvs: Array<Value>

    public init(kvs: Array<Value>) {
        this.kvs = kvs
    }

    public static func empty(): ImmutableMapValue {
        return EMPTY
    }

    public override func getValueType(): ValueType {
        return ValueType.MAP(false, false)
    }

    public override func immutableValue(): ImmutableMapValue {
        return this
    }

    public override func asMapValue(): ImmutableMapValue {
        return this
    }

    public override func size(): Int64 {
        return kvs.size / 2
    }

    public override func writeTo(packer: MessagePacker): Unit {
        packer.packMapHeader(kvs.size / 2)
        for (i in 0..kvs.size) {
            kvs[i].writeTo(packer)
        }
    }

    public override func equals(v: Value): Bool {
        if (!v.isMapValue()) {
            return false
        }
        var mapValue: MapValue = v.asMapValue()
        if (size() != mapValue.size()) {
            return false
        }

        return true
    }

    public override func hashCode(): Int64 {
        var h = 1
        for (i in 0..kvs.size: 2) {
            h = h + kvs[i].hashCode() ^ kvs[i + 1].hashCode()
        }
        return h
    }

    public override func toJson(): String {

        if (kvs.size == 0) {
            return "{}"
        }
        var sb: StringBuilder = StringBuilder()
        sb.append("{")
        sb.append(kvs[0].toJson())
        for (i in 0..kvs.size: 2) {
            sb.append(",")
            sb.append(kvs[i].toJson())
            sb.append(":")
            sb.append(kvs[i + 1].toJson())
        }
        sb.append("}")
        return sb.toString()
    }

    public override func toString(): String {
        if (kvs.size == 0) {
            return "{}"
        }
        var sb: StringBuilder = StringBuilder()
        sb.append("{")
        sb.append(kvs[0].toJson())
        sb.append(":")
        sb.append(kvs[1].toJson())
        for (i in 2..kvs.size: 2) {
            sb.append(",")
            sb.append(kvs[i].toJson())
            sb.append(":");
            sb.append(kvs[i + 1].toJson())
        }
        sb.append("}")
        return sb.toString()
    }
}