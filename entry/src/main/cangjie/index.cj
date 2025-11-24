package ohos_app_cangjie_entry

internal import ohos.base.LengthProp
internal import ohos.component.Column
internal import ohos.component.Row
internal import ohos.component.Text
internal import ohos.component.CustomView
internal import ohos.component.CJEntry
internal import ohos.component.loadNativeView
internal import ohos.component.FontWeight
internal import ohos.state_manage.SubscriberManager
internal import ohos.state_manage.ObservedProperty
internal import ohos.state_manage.LocalStorage
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import msgpack4cj.*
import ohos.component.Button
import ohos.settings.Date
import std.time.MonoTime
import std.time.DateTime
import ohos.i18n.TimeZone
import stdx.serialization.serialization.DataModel
import stdx.encoding.json.*

@Entry
@Component
class EntryView {
    @State
    var message: String = "Hello World"

    @State
    var message2: String = "Hello World"

///
    func pack_type(): String {
        var c = MessagePack.newDefaultBufferPacker()
        c.packBool(true)
        c.packInt8(8)
        c.packInt16(16)
        c.packInt32(555)
        c.packInt64(6666)
        c.packString('zzz')
        c.packFloat64(3.1415)
        c.packNull()
        return c.toByteArray().toString()
    }

    func unpack_type(): String {
        let value: Array<Byte> = [195,8,16,205,2,43,205,26,10,163,122,122,122,203,64,9,33,202,192,131,18,111,192]
        let c = MessagePack.newDefaultUnpacker(value)
        let bool = c.unpackBool().toString()
        let int8 = c.unpackInt8().toString()
        let int16 = c.unpackInt16().toString()
        let int32 = c.unpackInt32().toString()
        let int64 = c.unpackInt64().toString()
        let str = c.unpackString().toString()
        let float = c.unpackFloat64().toString()
        c.unpackNull()
        return bool + "," + int8 + "," + int16 + "," + int32 + "," + int64 + "," + str + "," + float
    }

///
    func pack_array(): String {
        var c = MessagePack.newDefaultBufferPacker()
        let a: Array<Byte> = [5,6,7]
        c.packBinary(a)

        return c.toByteArray().toString()
    }

    func unpack_array(): String {
        let value: Array<Byte> = [196, 3,5,6,7]
        let c = MessagePack.newDefaultUnpacker(value)
        let array = c.unpackBinary().toString()
        return array
    }

///
    func pack_map(): String {
        var packer = MessagePack.newDefaultBufferPacker()
        packer.packMapHeader(3)
        packer.packString("name")
        packer.packString("yesokim")
        packer.packString("age")
        packer.packInt8(22)
        packer.packString("hobby")
        packer.packArrayHeader(1)
        packer.packString("code")

        return packer.toByteArray().toString()
    }

    func unpack_map(): String {
        let value: Array<Byte> = [131,164,110,97,109,101,167,121,101,115,111,107,105,109,163,97,103,101,22,165,104,111,98,98,121,145,164,99,111,100,101]
        let unpacker = MessagePack.newDefaultUnpacker(value)

        let mapSize = unpacker.unpackMapHeader().toString()
        let key1 = unpacker.unpackString().toString()
        let name = unpacker.unpackString().toString()
        let key2 = unpacker.unpackString().toString()
        let age = unpacker.unpackInt8().toString()
        let key3= unpacker.unpackString().toString()
        let arraySize = unpacker.unpackArrayHeader().toString()
        let hobby = unpacker.unpackString().toString()
        return mapSize + "," + key1 + "," + name + "," + key2 + "," + age + "," + key3 + "," + arraySize + "," + hobby
    }

///
    func pack_timestamp(): String {
        var packer = MessagePack.newDefaultBufferPacker()
        let datetime = DateTime.of(year: 2025, month: 5, dayOfMonth: 28, hour: 14,minute:36,second: 56,nanosecond: 9882)
        packer.packTimestamp(datetime)

        return packer.toByteArray().toString()
    }

    func unpack_timestamp(): String {
        let value: Array<Byte> = [215,255,172,218,125,0,104,153,180,244]

        let c = MessagePack.newDefaultUnpacker(value)

        let array = c.unpackTimestamp().toString()
        return array
    }

    ///
    func pack_json(): String {
        let str = '{"name": "Alice","age": 30,"isStudent": false,"grades": [85.5, 90.0, 78.5],"address": {"street": "123 Main St", "city": "Wonderland"},"hobbies": "篮球"}'
         var array: Array<Byte> = DataModel.fromJson(JsonValue.fromStr(str)).toMessagePack()

        return array.toString()
    }

    func unpack_json(): String {
        let v: Array<Byte> = [134,164,110,97,109,101,165,65,108,105,99,101,163,97,103,101,30,169,105,115,83,116,117,100,101,110,116,194,166,103,114,97,100,101,115,147,203,64,85,96,0,0,0,0,0,203,64,86,128,0,0,0,0,0,203,64,83,160,0,0,0,0,0,167,97,100,100,114,101,115,115,130,166,115,116,114,101,101,116,171,49,50,51,32,77,97,105,110,32,83,116,164,99,105,116,121,170,87,111,110,100,101,114,108,97,110,100,167,104,111,98,98,105,101,115,166,231,175,174,231,144,131]

        var model = DataModel.fromMessagePack(v)
        return model.toJson().toJsonString()
    }

    ///
    func pack_extension(): String {
        let EXT_TYPE_DATETIME: Byte = 0x0A; // 自定义类型标识（如 0x0A 表示日期）
        let data: Array<Byte> = [0x01, 0x02, 0x03]

        var packer = MessagePack.newDefaultBufferPacker()
        packer.packExtensionTypeHeader(EXT_TYPE_DATETIME, Int32(data.size))
        packer.writePayload(data)
        return packer.toByteArray().toString()
    }

    func unpack_extension(): String {
        let v: Array<Byte> = [199,3,10,1,2,3]
        let unpacker = MessagePack.newDefaultUnpacker(v)
        let header: ExtensionTypeHeader = unpacker.unpackExtensionTypeHeader()

        let res: Array<Byte> = unpacker.readPayload(Int64(header.getLength()))
        return header.getLength().toString() + " " +header.getType().toString() + " " + res.toString()

    }


    func build() {
        Row {
            Column {
                    Button("压缩:基本类型").fontSize(14).onClick {
                        => this.message = pack_type()
                    }
                    Button("解压缩:基本类型").fontSize(14).onClick {
                        => this.message2 = unpack_type()
                    }

                    Button("压缩:array").fontSize(14).onClick {
                        => this.message = pack_array()
                    }
                    Button("解压缩:array").fontSize(14).onClick {
                        => this.message2 = unpack_array()
                    }

                    Button("压缩:map").fontSize(14).onClick {
                        => this.message = pack_map()
                    }
                    Button("解压缩:map").fontSize(14).onClick {
                        => this.message2 = unpack_map()
                    }

                    Button("压缩:time").fontSize(14).onClick {
                        => this.message = pack_timestamp()
                    }
                    Button("解压缩:time").fontSize(14).onClick {
                        => this.message2 = unpack_timestamp()
                    }

                    Button("压缩:json").fontSize(14).onClick {
                        => this.message = pack_json()
                    }
                    Button("解压缩:json").fontSize(14).onClick {
                        => this.message2 = unpack_json()
                    }

                    Button("压缩:自定义类型").fontSize(14).onClick {
                        => this.message = pack_extension()
                    }
                    Button("解压缩:自定义类型").fontSize(14).onClick {
                        => this.message2 = unpack_extension()
                    }
                    // ------
                    Text(this.message)
                    Text(this.message2)
            }.width(100.percent)
        }.height(100.percent)
    }
}
