

import std.unittest.*
import std.unittest.testmacro.*
import msgpack4cj.core.*
import std.time.MonoTime



main() {    
    let uuidTest = UUIDTest()
    uuidTest.testString()
    uuidTest.testBool()
    uuidTest.testByte()
    uuidTest.testByteArray()
    uuidTest.testInt64()
    uuidTest.testFloat32()
    uuidTest.testFloat64()
    uuidTest.testNull()
    uuidTest.testMapHeader()
    uuidTest.testArrayHeader()
}

@Test
public class UUIDTest {

    @TestCase
    public func testString(): Unit {
        let counts = 100000
        let stringSize = 10 * 1024
        let targetString = String(Array<Rune>(stringSize, repeat: r'x'))
        println("测试字符串长度: ${stringSize} bytes ${targetString.size}" )

        var totalTime: Int64 = 0
        var totalTime2: Int64 = 0

        for (i in 0..counts) {
            var packer = MessagePacker()

            let startTime = MonoTime.now()
            packer.packString(targetString)
        
            let packerArray = packer.toByteArray()
            let duration = (MonoTime.now() - startTime).toNanoseconds()

            let startTime2 = MonoTime.now()
            var unpacker = MessageUnpacker(packerArray)
            var a = unpacker.unpackString()
            let duration2 = (MonoTime.now() - startTime2).toNanoseconds()
             
            totalTime += duration
            totalTime2 += duration2

        }
        println("序列化 String 耗时s - 平均：${totalTime / counts} ns")
        println("反序列化 String 耗时s - 平均：${totalTime2 / counts} ns")
    }

    @TestCase
    public func testBool(): Unit {
        let counts = 100000

        var totalTime: Int64 = 0
        var totalTime2: Int64 = 0

        for (i in 0..counts) {
            var packer = MessagePacker()

            let startTime = MonoTime.now()
            packer.packBool(true)
            let packerArray = packer.toByteArray()
            let duration = (MonoTime.now() - startTime).toNanoseconds()

            let startTime2 = MonoTime.now()
            var unpacker = MessageUnpacker(packerArray)
            var a = unpacker.unpackBool()
            let duration2 = (MonoTime.now() - startTime2).toNanoseconds()
            
            totalTime += duration
            totalTime2 += duration2

        }
        println("序列化 Bool 耗时s - 平均：${totalTime / counts} ns ")
        println("反序列化 Bool 耗时s - 平均：${totalTime2 / counts} ns ")
    }

    @TestCase
    public func testByte(): Unit {
        let counts = 100000

        var totalTime: Int64 = 0
        var totalTime2: Int64 = 0

        for (i in 0..counts) {
            var packer = MessagePacker()

            let startTime = MonoTime.now()
            packer.packBinary(98)
            let packerArray = packer.toByteArray()
            let duration = (MonoTime.now() - startTime).toNanoseconds()

            let startTime2 = MonoTime.now()
            var unpacker = MessageUnpacker(packerArray)
            var a = unpacker.unpackBinary()
            let duration2 = (MonoTime.now() - startTime2).toNanoseconds()
            
            totalTime += duration
            totalTime2 += duration2

        }
        println("序列化 Byte 耗时s - 平均：${totalTime / counts} ns ")
        println("反序列化 Byte 耗时s - 平均：${totalTime2 / counts} ns ")
    }

    @TestCase
    public func testByteArray(): Unit {
        let counts = 100000

        var totalTime: Int64 = 0
        var totalTime2: Int64 = 0

        for (i in 0..counts) {
            var packer = MessagePacker()

            let startTime = MonoTime.now()
            packer.packBinary([1, 2, 3, 4, 5, 6, 7, 8, 9, 0])
            let packerArray = packer.toByteArray()
            let duration = (MonoTime.now() - startTime).toNanoseconds()

            let startTime2 = MonoTime.now()
            var unpacker = MessageUnpacker(packerArray)
            var a = unpacker.unpackBinary()
            let duration2 = (MonoTime.now() - startTime2).toNanoseconds()
            
            totalTime += duration
            totalTime2 += duration2

        }
        println("序列化 ByteArray 耗时s - 平均：${totalTime / counts} ns ")
        println("反序列化 ByteArray 耗时s - 平均：${totalTime2 / counts} ns ")
    }

    @TestCase
    public func testInt64(): Unit {
        let counts = 100000

        var totalTime: Int64 = 0
        var totalTime2: Int64 = 0

        for (i in 0..counts) {
            var packer = MessagePacker()

            let startTime = MonoTime.now()
            packer.packInt(128)
            let packerArray = packer.toByteArray()
            let duration = (MonoTime.now() - startTime).toNanoseconds()

            let startTime2 = MonoTime.now()
            var unpacker = MessageUnpacker(packerArray)
            var a = unpacker.unpackInt()
            let duration2 = (MonoTime.now() - startTime2).toNanoseconds()
            
            totalTime += duration
            totalTime2 += duration2

        }
        println("序列化 Int64 耗时s - 平均：${totalTime / counts} ns ")
        println("反序列化 Int64 耗时s - 平均：${totalTime2 / counts} ns ")
    }

    @TestCase
    public func testFloat32(): Unit {
        let counts = 100000

        var totalTime: Int64 = 0
        var totalTime2: Int64 = 0

        for (i in 0..counts) {
            var packer = MessagePacker()

            let startTime = MonoTime.now()
            packer.packFloat32(128.0)
            let packerArray = packer.toByteArray()
            let duration = (MonoTime.now() - startTime).toNanoseconds()

            let startTime2 = MonoTime.now()
            var unpacker = MessageUnpacker(packerArray)
            var a = unpacker.unpackFloat64()
            let duration2 = (MonoTime.now() - startTime2).toNanoseconds()
            
            totalTime += duration
            totalTime2 += duration2

        }
        println("序列化 Float32 耗时s - 平均：${totalTime / counts} ns ")
        println("反序列化 Float32 耗时s - 平均：${totalTime2 / counts} ns ")
    }

    @TestCase
    public func testFloat64(): Unit {
        let counts = 100000

        var totalTime: Int64 = 0
        var totalTime2: Int64 = 0

        for (i in 0..counts) {
            var packer = MessagePacker()

            let startTime = MonoTime.now()
            packer.packFloat64(256.0)
            let packerArray = packer.toByteArray()
            let duration = (MonoTime.now() - startTime).toNanoseconds()

            let startTime2 = MonoTime.now()
            var unpacker = MessageUnpacker(packerArray)
            var a = unpacker.unpackFloat64()
            let duration2 = (MonoTime.now() - startTime2).toNanoseconds()
            
            totalTime += duration
            totalTime2 += duration2

        }
        println("序列化 Float64 耗时s - 平均：${totalTime / counts} ns ")
        println("反序列化 Float64 耗时s - 平均：${totalTime2 / counts} ns ")
    }

    @TestCase
    public func testNull(): Unit {
        let counts = 100000

        var totalTime: Int64 = 0
        var totalTime2: Int64 = 0

        for (i in 0..counts) {
            var packer = MessagePacker()

            let startTime = MonoTime.now()
            packer.packNull()
            let packerArray = packer.toByteArray()
            let duration = (MonoTime.now() - startTime).toNanoseconds()

            let startTime2 = MonoTime.now()
            var unpacker = MessageUnpacker(packerArray)
            var a = unpacker.unpackNull()
            let duration2 = (MonoTime.now() - startTime2).toNanoseconds()
            
            totalTime += duration
            totalTime2 += duration2

        }
        println("序列化 Null 耗时s - 平均：${totalTime / counts} ns ")
        println("反序列化 Null 耗时s - 平均：${totalTime2 / counts} ns ")   
         
    }

    @TestCase
    public func testMapHeader(): Unit {
        let counts = 100000

        var totalTime: Int64 = 0
        var totalTime2: Int64 = 0

        for (i in 0..counts) {
            var packer = MessagePacker()

            let startTime = MonoTime.now()
            packer.packMapHeader(128)
            let packerArray = packer.toByteArray()
            let duration = (MonoTime.now() - startTime).toNanoseconds()

            let startTime2 = MonoTime.now()
            var unpacker = MessageUnpacker(packerArray)
            var a = unpacker.unpackMapHeader()
            let duration2 = (MonoTime.now() - startTime2).toNanoseconds()
            
            totalTime += duration
            totalTime2 += duration2

        }
        println("序列化 MapHeader 耗时s - 平均：${totalTime / counts} ns ")
        println("反序列化 MapHeader 耗时s - 平均：${totalTime2 / counts} ns ")   
    }

    @TestCase
    public func testArrayHeader(): Unit {
        let counts = 100000

        var totalTime: Int64 = 0
        var totalTime2: Int64 = 0

        for (i in 0..counts) {
            var packer = MessagePacker()

            let startTime = MonoTime.now()
            packer.packArrayHeader(128)
            let packerArray = packer.toByteArray()
            let duration = (MonoTime.now() - startTime).toNanoseconds()

            let startTime2 = MonoTime.now()
            var unpacker = MessageUnpacker(packerArray)
            var a = unpacker.unpackArrayHeader()
            let duration2 = (MonoTime.now() - startTime2).toNanoseconds()
            
            totalTime += duration
            totalTime2 += duration2

        }
        println("序列化 ArrayHeader 耗时s - 平均：${totalTime / counts} ns ")
        println("反序列化 ArrayHeader 耗时s - 平均：${totalTime2 / counts} ns ")   
    }
}