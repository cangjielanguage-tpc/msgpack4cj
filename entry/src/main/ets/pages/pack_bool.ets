/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
import { MessagePacker, MessageUnPacker, DataModel } from '@cangjie-tpc/msgpack';
import { hilog } from '@kit.PerformanceAnalysisKit';


export function pack_type(): string {
  try {
    let c = new MessagePacker()
    c.packBool(true)
    c.packInt8(8)
    c.packInt16(16)
    c.packInt32(555)
    c.packInt64(6666)
    c.packString('zzz')
    c.packFloat64(3.1415)
    c.packNull()

    return c.toByteArray().toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function unpack_type(): string {
  try {
    let value = [195,8,16,205,2,43,205,26,10,163,122,122,122,203,64,9,33,202,192,131,18,111,192]
    let c = new MessageUnPacker(value)
    let bool = c.unpackBool()
    let int8 = c.unpackInt8()
    let int16 = c.unpackInt16()
    let int32 = c.unpackInt32()
    let int64 = c.unpackInt64()
    let str = c.unpackString()
    let float = c.unpackFloat64()
    c.unpackNull()
    // hilog.error(0, 'mdebug', `${bool} ${int8}`)
    return bool + ', ' + int8 + ', ' + int16 + ', ' + int32 + ', ' + int64 + ', ' + str + ', ' + float
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function pack_array(): string {
  try {
    let c = new MessagePacker()
    let a = [5,6,7]
    c.packArray(a)

    return c.toByteArray().toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function unpack_array(): string {
  try {
    let value = [196, 3,5,6,7]
    let c = new MessageUnPacker(value)
    let array = c.unpackArray()
    // hilog.error(0, 'mdebug', `${bool} ${int8}`)
    return array.toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function pack_map(): string {
  try {
    let packer = new MessagePacker()
    packer.packMapHeader(3)
    packer.packString("name")
    packer.packString("yesokim")
    packer.packString("age")
    packer.packInt8(22)
    packer.packString("hobby")
    packer.packArrayHeader(1)
    packer.packString("code")

    return packer.toByteArray().toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function pack_timestamp(): string {
  try {
    // Unix时间戳 是指从1970年1月1日（UTC）开始到现在经历的时间（毫秒）
    // const time: Date = new Date(1706170405708)    //输出  Thu Jan 25 2024 16:13:25 GMT+0800
    const time =  Date.now()

    let packer = new MessagePacker()
    hilog.error(0, 'zzzzz', `${time}`)
    packer.packTimestamp(time)
    return packer.toByteArray().toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function pack_extension(): string {
  try {
    let EXT_TYPE_DATETIME: number = 0x0A; // 自定义类型标识（如 0x0A 表示日期）
    let data: Array<number> = [0x01, 0x02, 0x03]

    let packer = new MessagePacker()
    packer.packExtensionTypeHeader(EXT_TYPE_DATETIME, data.length)
    packer.writePayload(data)
    return packer.toByteArray().toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function pack_json(): string {
  try {
    let str = '{"name": "Alice","age": 30,"isStudent": false,"grades": [85.5, 90.0, 78.5],"address": {"street": "123 Main St", "city": "Wonderland"},"hobbies": "篮球"}'
    let dataModel = new DataModel()

    return dataModel.packJson(str).toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function pack_json2(): string {
  try {
    let str = '{ "name": "蔡徐坤","age": 180,"hobys": ["唱","跳","rap","篮球"],"loc": {"time": 123,"heheh": "T" },"null": null,"price": 250.893,"sex": false }'
    let dataModel = new DataModel()

    return dataModel.packJson(str).toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function unpack_json2(): string {
  try {
    let v = [135, 164, 110, 97, 109, 101, 169, 232, 148, 161, 229, 190, 144, 229, 157, 164, 163, 97,
      103, 101, 211, 0, 0, 0, 0, 0, 0, 0, 180, 165, 104, 111, 98, 121, 115, 148, 163, 229, 148, 177, 163, 232,
      183, 179, 163, 114, 97, 112, 166, 231, 175, 174, 231, 144, 131, 163, 108, 111, 99, 130, 164, 116, 105, 109,
      101, 211, 0, 0, 0, 0, 0, 0, 0, 123, 165, 104, 101, 104, 101, 104, 161, 84, 164, 110, 117, 108, 108, 192,
      165, 112, 114, 105, 99, 101, 203, 64, 111, 92, 147, 116, 188, 106, 127, 163, 115, 101, 120, 194]
    let dataModel = new DataModel()

    return dataModel.unpackJson(v)
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function unpack_json(): string {
  try {
    let v = [134,164,110,97,109,101,165,65,108,105,99,101,163,97,103,101,30,169,105,115,83,116,117,100,101,110,116,194,166,103,114,97,100,101,115,147,203,64,85,96,0,0,0,0,0,203,64,86,128,0,0,0,0,0,203,64,83,160,0,0,0,0,0,167,97,100,100,114,101,115,115,130,166,115,116,114,101,101,116,171,49,50,51,32,77,97,105,110,32,83,116,164,99,105,116,121,170,87,111,110,100,101,114,108,97,110,100,167,104,111,98,98,105,101,115,166,231,175,174,231,144,131]
    let dataModel = new DataModel()

    return dataModel.unpackJson(v)
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function unpack_map(): string {
  try {
    let value = [131,164,110,97,109,101,167,121,101,115,111,107,105,109,163,97,103,101,22,165,104,111,98,98,121,145,164,99,111,100,101]
    let unpacker = new MessageUnPacker(value)
    let mapSize = unpacker.unpackMapHeader()
    let key1 = unpacker.unpackString()
    let name = unpacker.unpackString()
    let key2 = unpacker.unpackString()
    let age = unpacker.unpackInt8()
    let key3= unpacker.unpackString()
    let arraySize = unpacker.unpackArrayHeader()
    let hobby = unpacker.unpackString()
    // hilog.error(0, 'mdebug', `${bool} ${int8}`)
    return mapSize + ', ' + key1 + ', ' + name + ', ' + key2 + ', ' + age + ', ' + key3 + ', ' + arraySize + ', ' + hobby
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function unpack_timestamp(): string {
  try {
    let value = [215,255,172,218,125,0,104,153,180,244]
    let unpacker = new MessageUnPacker(value)
    let timestamp = unpacker.unpackTimestamp()
    // hilog.error(0, 'mdebug', `${bool} ${int8}`)
    const time: Date = new Date(timestamp)
    return time.toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}

export function unpack_extension(): string {
  try {
    let value = [199,3,10,1,2,3]
    let unpacker = new MessageUnPacker(value)
    let header = unpacker.unpackExtensionTypeHeader()
    let payload = unpacker.readPayload(header[1])
    // hilog.error(0, 'mdebug', `${bool} ${int8}`)
    return header[0] + ' ' + header[1] + ' ' + payload.toString()
  } catch (e) {
    hilog.error(0, 'mdebug', `${e}`)
    return 'fail'
  }
}