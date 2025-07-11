// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import stdx.encoding.json.*
import stdx.encoding.hex.*
import stdx.serialization.serialization.*
import std.deriving.Derive
import std.time.MonoTime
import msgpack4cj.core.*
import msgpack4cj.serialization.*

@Test
public class MainTest {
    @TestCase
    public func case1() {
        var instance = Abc()
        println(instance.serialize().toJson())
        println(instance.serialize().toJson().toString().toArray().size)
        println(instance.serialize().toMessagePack())
        println(instance.serialize().toMessagePack().size)
        println(toHexString(instance.serialize().toMessagePack()))
    }

    @TestCase
    public func case2() {
        var msg: Array<Byte> = [135, 164, 110, 97, 109, 101, 169, 232, 148, 161, 229, 190, 144, 229, 157, 164, 163, 97,
            103, 101, 211, 0, 0, 0, 0, 0, 0, 0, 180, 165, 104, 111, 98, 121, 115, 148, 163, 229, 148, 177, 163, 232,
            183, 179, 163, 114, 97, 112, 166, 231, 175, 174, 231, 144, 131, 163, 108, 111, 99, 130, 164, 116, 105, 109,
            101, 211, 0, 0, 0, 0, 0, 0, 0, 123, 165, 104, 101, 104, 101, 104, 161, 84, 164, 110, 117, 108, 108, 192,
            165, 112, 114, 105, 99, 101, 203, 64, 111, 92, 147, 116, 188, 106, 127, 163, 115, 101, 120, 194]
        var model = DataModel.fromMessagePack(msg)
        println(model.toJson())
    }

    @TestCase
    public func case3() {
        var str = ###'
                {
                "name": "Alice",
                "age": 30,
                "isStudent": false,
                "grades": [85.5, 90.0, 78.5],
                "address": {
                    "street": "123 Main St",
                    "city": "Wonderland"
                    },
                "hobbies": null
                }
                '###
        println(toHexString(DataModel.fromJson(JsonValue.fromStr(str)).toMessagePack()))
    }

    @TestCase
    public func case4() {
        
        //序列化
        var instance = Abc()
        var data = instance.serialize().toMessagePack()
        println(data)
    
        //反序列化
        var de = Abc.deserialize(DataModel.fromMessagePack(data))
        println(de)
        return 0
    }

    /*
    * 序列化效率测试
    */
    @TestCase
    public func case5() {
        var start = MonoTime.now()
        var entity = Entity()
        for(i in 0..=10000) {
            entity.serialize().toMessagePack()
        }
        var end = MonoTime.now()
        var cost = end - start
        println("耗时: ${cost.toMilliseconds()}ms")
    }

    /*
    * 反序列化效率测试
    */
    @TestCase
    public func case6() {
        var start = MonoTime.now()
        var data: Array<Byte> = [134, 166, 102, 105, 101, 108, 100, 49, 175, 229, 186, 143, 229, 136, 151, 229, 140, 150, 230, 181, 139, 232, 175, 149, 166, 102, 105, 101, 108, 100, 50, 0, 166, 102, 105, 101, 108, 100, 51, 203, 0, 0, 0, 0, 0, 0, 0, 0, 166, 102, 105, 101, 108, 100, 52, 194, 166, 102, 105, 101, 108, 100, 53, 192, 166, 102, 105, 101, 108, 100, 54, 154, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        for(i in 0..=10000) {
            var model = DataModel.fromMessagePack(data)
        }
        var end = MonoTime.now()
        var cost = end - start
        println("耗时: ${cost.toMilliseconds()}ms")
    }
}

class Entity <: Serializable<Entity> {

    public var field1: String = "序列化测试"

    public var field2: Int = 0

    public var field3: Float64 = 0.00

    public var field4: Bool = false

    public var field5: Option<Entity> = None

    public var field6: Array<Byte> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    public func serialize(): DataModel {
        var model = DataModelStruct()
        model.add(field<String>("field1", field1))
        model.add(field<Int>("field2", field2))
        model.add(field<Float64>("field3", field3))
        model.add(field<Bool>("field4", field4))
        model.add(field<Option<Entity>>("field5", field5))
        model.add(field<Array<Byte>>("field6", field6))
        return model
    }

    public static func deserialize(dm: DataModel): Entity {
        dm.toJson()
        return Entity()
    }

}


/* 通过实现 Serializable 接口，来实现对自定义类型的序列化和反序列化功能 */
@Derive[ToString]
class Abc <: Serializable<Abc> {
    //DataModelString
    var name: String = "坤坤"
    //DataModelInt
    var age: Int64 = 180
    //DataModelSeq
    var hobys: Array<String> = ["唱", "跳", "rap", "篮球"]
    //DataModelStruct
    var loc: Location = Location()
    //DataModelNull
    var null: ?String = None
    //DataModelFloat
    var price: Float64 = 250.893
    //DataModelBool
    var sex: Bool = false

    var binary: Array<Byte> = [123, 23, 34, 45, 56, 7, 6, 4, 2, 8, 90, 54, 33, 4]

    /* 实现 Serializable 接口的序列化方法 */
    public func serialize(): DataModel {
        return DataModelStruct()
                .add(field<String>("name", name))
                .add(field<Int64>("age", age))
                .add(field<Array<String>>("hobys", hobys))
                .add(field<Location>("loc", loc))
                .add(field<?String>("null", null))
                .add(field<Float64>("price", price))
                .add(field<Bool>("sex", sex))
                .add(field<Array<Byte>>("binary", binary))
    }

    /* 实现反序列化方法 */
    public static func deserialize(dm: DataModel): Abc {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let result = Abc()
        result.name = String.deserialize(dms.get("name"))
        result.age = Int64.deserialize(dms.get("age"))
        result.hobys = Array<String>.deserialize(dms.get("hobys"))
        result.loc = Location.deserialize(dms.get("loc"))
        result.null = Option<String>.deserialize(dms.get("null"))
        result.price = Float64.deserialize(dms.get("price"))
        result.sex = Bool.deserialize(dms.get("sex"))
        result.binary = Array<Byte>.deserialize(dms.get("binary"))
        return result
    }
}

@Derive[ToString]
class Location <: Serializable<Location> {
    var time: Int64 = 123
    var heheh: Rune = 'T'

    /* 实现 Serializable 接口的序列化方法 */
    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<Int64>("time", time))
            .add(field<Rune>("heheh", heheh))
    }

    /* 实现反序列化方法 */
    public static func deserialize(dm: DataModel): Location {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let result = Location()
        result.time = Int64.deserialize(dms.get("time"))
        result.heheh = Rune.deserialize(dms.get("heheh"))
        return result
    }
}