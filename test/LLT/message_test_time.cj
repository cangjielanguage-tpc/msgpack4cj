// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.time.MonoTime
import std.unittest.*
import std.unittest.testmacro.*
import serialization.serialization.{DataModel, DataModelStruct, field, Serializable}
import msgpack4cj.core.*
import msgpack4cj.serialization.*

import std.io.ByteBuffer
import std.io.readToEnd
import std.binary.BigEndianOrder
import std.collection.ArrayList
import std.time.*

@Test
public class MessageTestTime {

    @OverflowWrapping
    @TestCase
    public func testTT(): Unit {
        println("ssss")
        println("曲")
        println(Int8(255))

        println(DateTime.nowUTC().toUnixTimeStamp().toSeconds()) // 1743561319
        println(DateTime.nowUTC().nanosecond) // 598995227

        // [-41, -1, -114, -49, -60, 108, 103, -20, -94, 103]
        println(UInt8(-64))
        println("zzz")
        // [215, 255, 142, 207, 196, 108, 103, 236, 162, 103]
        
    }

    @OverflowWrapping
    @TestCase
    public func testDateTime(): Unit {
        // String utcTime = "2024-05-22T04:00:00Z";
        // [-42, -1, 102, 77, 109, -64]
        // [214, 255, 102, 77, 109, 192]
        var packer1 = MessagePacker()
        let datetime = DateTime.of(year: 2024, month: May, dayOfMonth: 22, hour: 12, timeZone: TimeZone.load("Asia/Shanghai"))

        packer1.packTimestamp(datetime)
        let Int8Array1 = packer1.toByteArray()
        let javaArray: Array<UInt8> = [214, 255, 102, 77, 109, 192]

        @Assert(Int8Array1, javaArray)


        var unpacker1 = MessageUnpacker(Int8Array1)
        
        let dateTime: DateTime = unpacker1.unpackTimestamp()
        @Assert(dateTime.toString(),"2024-05-22T04:00:00Z")
    }

    @OverflowWrapping
    @TestCase
    public func testTimestamp32(): Unit {
        var packer1 = MessagePacker()
        // [-42, -1, 103, -20, -94, 103]
        // [214, 255, 103, 236, 162, 103]
        packer1.packTimestamp(1743561319, 0) // 2025-04-02T02:35:19Z
        let Int8Array1 = packer1.toByteArray()
        let javaArray: Array<UInt8> = [214, 255, 103, 236, 162, 103]

        @Assert(Int8Array1, javaArray)

        var unpacker1 = MessageUnpacker(Int8Array1)
        
        let dateTime: DateTime = unpacker1.unpackTimestamp()
        @Assert(dateTime.toString(),"2025-04-02T02:35:19Z")
    }

    @OverflowWrapping
    @TestCase
    public func testTimestamp64(): Unit {
        var packer1 = MessagePacker()
        // [-41, -1, -114, -49, -60, 108, 103, -20, -94, 103]
        // [215, 255, 142, 207, 196, 108, 103, 236, 162, 103]
        packer1.packTimestamp(1743561319, 598995227) // 2025-04-02T02:35:19.598995227Z
        let Int8Array1 = packer1.toByteArray()
        let javaArray: Array<UInt8> = [215, 255, 142, 207, 196, 108, 103, 236, 162, 103]

        @Assert(Int8Array1, javaArray)

        var unpacker1 = MessageUnpacker(Int8Array1)
        let dateTime: DateTime = unpacker1.unpackTimestamp()
        @Assert(dateTime.toString(),"2025-04-02T02:35:19.598995227Z")

    }

    @OverflowWrapping
    @TestCase
    public func testTimestamp96(): Unit {
        // [-57, 12, -1, 0, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1]
        // [199, 12, 255, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255]
        var packer1 = MessagePacker()

        packer1.packTimestamp(-1, 0) // 1969-12-31T23:59:59Z
        let Int8Array1 = packer1.toByteArray()
        let javaArray: Array<UInt8> = [199, 12, 255, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255]
        @Assert(Int8Array1, javaArray)

        var unpacker1 = MessageUnpacker(Int8Array1)
        let dateTime: DateTime = unpacker1.unpackTimestamp()
        println("1969-12-31T23:59:59Z")
        println(dateTime.toString())
        println("1969-12-31T23:59:59Z")
        @Assert(dateTime.toString(),"1969-12-31T23:59:59Z")

    }

}