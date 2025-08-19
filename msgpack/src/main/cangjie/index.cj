package msgpack

import ohos.ark_interop.*
import ohos.hilog.Hilog
import ohos.ark_interop.*
import ohos.ark_interop_macro.Interop
import msgpack.core.MessageUnpacker
import stdx.serialization.serialization.DataModel
import stdx.encoding.json.*
import stdx.encoding.hex.*
import msgpack.core.MessagePack
import msgpack.serialization.ToMessagePack
import std.time.DateTime
import msgpack.core.ExtensionTypeHeader

@Interop[ArkTS]
public class DataModelTs {
    public init(){}

    public func packJson(value: String): JSArrayEx<UInt8>  {
        var array = DataModel.fromJson(JsonValue.fromStr(value)).toMessagePack()
        return JSArrayEx<UInt8>(array)
    }

    public func unpackJson(value: JSArrayEx<UInt8> ): String {
        var model = DataModel.fromMessagePack(value.toArray())
        return model.toJson().toJsonString()
    }
}


@Interop[ArkTS]
public class MessagePackerTs {

    var packer = MessagePack.newDefaultBufferPacker()

    public init(){}

    public func packBool(value: Bool): Unit {
        this.packer.packBool(value)
    }

    public func packInt8(value: Int8): Unit {
        this.packer.packInt8(value)
    }

    public func packInt16(value: Int16): Unit {
        this.packer.packInt16(value)
    }

    public func packInt32(value: Int32): Unit {
        this.packer.packInt32(value)
    }

    public func packInt64(value: Int64): Unit {
        this.packer.packInt64(value)
    }

    public func packString(value: String): Unit {
        this.packer.packString(value)
    }

    public func packFloat64(value: Float64): Unit {
        this.packer.packFloat64(value)
    }

    public func packArray(value: JSArrayEx<UInt8>): Unit {
        this.packer.packBinary(value.toArray())
    }

    public func packMapHeader(value: Int64): Unit {
        this.packer.packMapHeader(value)
    }

    public func packArrayHeader(value: Int64): Unit {
        this.packer.packArrayHeader(value)
    }

    public func packTimestamp(time: Int64): Unit {
        var dateTime: DateTime = DateTime.fromUnixTimeStamp(Duration.millisecond * time)
        this.packer.packTimestamp(dateTime.toUnixTimeStamp().toSeconds(), dateTime.nanosecond)
    }

    public func packNull(): Unit {
        this.packer.packNull()
    }

    public func packExtensionTypeHeader(extType: UInt8, payloadLen: Int32): Unit {
        this.packer.packExtensionTypeHeader(extType, payloadLen)
    }

    public func writePayload(value: JSArrayEx<UInt8>): Unit {
        this.packer.writePayload(value.toArray())
    }

    public func toByteArray(): JSArrayEx<UInt8> {
       return JSArrayEx<UInt8>(this.packer.toByteArray())
    }
}

@Interop[ArkTS]
public class MessageUnPackerTs {
    var unpacker: MessageUnpacker

    public init(value: JSArrayEx<UInt8>){
        unpacker = MessagePack.newDefaultUnpacker(value.toArray())
    }

    public func unpackBool(): Bool {
        return this.unpacker.unpackBool()
    }

    public func unpackInt8(): Int8 {
        return this.unpacker.unpackInt8()
    }
    public func unpackInt16(): Int16 {
        return this.unpacker.unpackInt16()
    }

    public func unpackInt32(): Int32 {
        return this.unpacker.unpackInt32()
    }

    public func unpackInt64(): Int64 {
        return this.unpacker.unpackInt64()
    }

    public func unpackString(): String {
        return this.unpacker.unpackString()
    }

    public func unpackFloat64(): Float64 {
        return this.unpacker.unpackFloat64()
    }

    public func unpackNull(): Unit {
        this.unpacker.unpackNull()
    }

    public func unpackArray(): JSArrayEx<UInt8> {
        return JSArrayEx<UInt8>(this.unpacker.unpackBinary())
    }

    public func unpackMapHeader(): Int64 {
        return this.unpacker.unpackMapHeader()
    }

    public func unpackArrayHeader(): Int64 {
        return this.unpacker.unpackArrayHeader()
    }

    public func unpackExtensionTypeHeader(): JSArrayEx<Int64> {
        let header: ExtensionTypeHeader = this.unpacker.unpackExtensionTypeHeader()
        var array: Array<Int64> = Array<Int64>(2, repeat: 0)
        array[0] = Int64(header.getType())
        array[1] = Int64(header.getLength())
        return JSArrayEx<Int64>(array)
    }

    public func readPayload(value: Int64): JSArrayEx<UInt8> {
        let payload: Array<UInt8> = unpacker.readPayload(value)
        return JSArrayEx<UInt8>(payload)
    }

    public func unpackTimestamp(): Int64 {
        return this.unpacker.unpackTimestamp().toUnixTimeStamp().toMilliseconds()
    }

}


//public func packBool(context: JSContext, callInfo: JSCallInfo): JSValue {
//    let value: Bool = callInfo[0].toBoolean()
//
//    var packer = MessagePack.newDefaultBufferPacker()
//    packer.packBool(value)
//    var bytes: Array<UInt8> = packer.toByteArray()
//    Hilog.error(0, "zz", "sss ${bytes}")
//    var s = bytes.toString()
//    return context.string(s).toJSValue()
////    let result = context.arrayBuffer(bytes)
////    return result.toJSValue()
//}
//
//
//
//let EXPORT_MODULE = JSModule.registerModule {
//    runtime, exports =>
//        exports["packBool"] = runtime.function(packBool).toJSValue()
//}
