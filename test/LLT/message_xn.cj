// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import encoding.json.{ToJson, JsonValue}
import encoding.hex.toHexString
import serialization.serialization.{Serializable, DataModel, DataModelStruct, field}
import std.time.MonoTime
import msgpack4cj.core.*
import msgpack4cj.serialization.*
import std.collection.*

@Test
public class messagexn {

    @TestCase
    public func test(): Unit {
        let counts = [5000]
        for(i in counts) {
            simpleTest(i)
        }

    }

    func simpleTest(counts: Int) {
        var map: HashMap<String, Any> = HashMap<String, Any>()
        map.put("field1", "xingneng")
        map.put("field2", 123456789)
        map.put("field3", 123.456789f64)
        map.put("field4", false)
        let keys = map.keys().toArray()
        println("keys ${keys}")

        let packer = MessagePack.newDefaultBufferPacker()
        let time1 = MonoTime.now()
        for(i in 0..counts) {
            packer.packMapHeader(map.size)
            for (j in 0..keys.size) {
                var key = keys[j]
                var value = map.get(key).getOrThrow()
                packer.packString(key)

                if (value is String) {
                    packer.packString((value as String).getOrThrow())
                } else if (value is Int64) {
                    packer.packInt64((value as Int64).getOrThrow())
                } else if (value is Float64) {
                    packer.packFloat64((value as Float64).getOrThrow())
                } else if (value is Bool) {
                    packer.packBool((value as Bool).getOrThrow())
                }
            }
        }

        let time2 = MonoTime.now()
        let duration1 = time2 - time1
        let data = packer.toByteArray()
        println("序列化${counts}次简单对象, 数据量: ${data.size} ,平均耗时: ${duration1.toNanoseconds() /counts }ns")

        let unpacker = MessagePack.newDefaultUnpacker(data)
        var map2: HashMap<String, Any> = HashMap<String, Any>()

        let time3 = MonoTime.now()
        for(i in 0..counts) {
            var mapSize = unpacker.unpackMapHeader()
            for (j in 0..mapSize) {
                var key: String = unpacker.unpackString()
                var value: Any = unpackValue(unpacker)
                map2.put(key, value)
            }
        }
        let time4 = MonoTime.now()
        let duration2 = time4 - time3
        println(" 反序列化${counts}次简单对象, 数据量: ${data.size} ,平均耗时: ${duration2.toNanoseconds() /counts }ns")
    }

    private func unpackValue(unpacker: MessageUnpacker): Any {
         let messageFormat: MessageFormat = unpacker.getType()
         match (messageFormat.getValueType()) {
            case ValueType.BOOL => return unpacker.unpackBool()
            case ValueType.INT => return unpacker.unpackInt64()
            case ValueType.FLOAT => return unpacker.unpackFloat64()
            case ValueType.STRING => return unpacker.unpackString()
            case _ => throw MessagePackException("Unknown value type")
         }

    }
}