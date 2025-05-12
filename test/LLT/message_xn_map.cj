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
        let counts = [1]
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

        let data = packer.toByteArray()

        let unpacker = MessagePack.newDefaultUnpacker(data)
        var map2: HashMap<String, Any> = HashMap<String, Any>()

        for(i in 0..counts) {
            var mapSize = unpacker.unpackMapHeader()
            for (j in 0..mapSize) {
                var key: String = unpacker.unpackString()
                var value: Any = unpackValue(unpacker)
                map2.put(key, value)
            }
        }
            
        var value1 = map2.get("field1").getOrThrow()
        check(value1)
        var value2 = map2.get("field2").getOrThrow()
        check(value2)
        var value3 = map2.get("field3").getOrThrow()
        check(value3)
        var value4 = map2.get("field4").getOrThrow()
        check(value4)
    }
    private func check(value: Any) {   
        if (value is String) {
            println((value as String).getOrThrow())
            @Assert((value as String).getOrThrow(), "xingneng")
        } else if (value is Int64) {
            println((value as Int64).getOrThrow())
            @Assert((value as Int64).getOrThrow(), 123456789)
        } else if (value is Float64) {
            println((value as Float64).getOrThrow())
            @Assert((value as Float64).getOrThrow(), 123.456789)
        } else if (value is Bool) {
            println((value as Bool).getOrThrow())
            @Assert((value as Bool).getOrThrow(), false)
        }
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