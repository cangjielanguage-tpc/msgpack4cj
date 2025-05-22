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

@Test
public class MainTest_t {

    @TestCase
    public func case3() {
        let count = 1 //10000
        var str = ###'
                {
                "name": "k7#FpL2!9zQx@W5vY8*GcH1jM$nD4%R6fTbN0&U3lKoAqPsV7eXyZ9iJhIuOdSgBmCwEa5rRtLkP8#2jH6$fN1!zQ3*YvX9wG0mU4%5D7eVbKpAqSoIiOuYd8rTlWnMsF4cCxZ2jH6$9k1!L3 * 7pG0mU5%V8bN2fQ4#YqXzW7eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6rTlP8uY3iIoU5%9m2!L4 * 7pG0k1#H6$fNqQ3vXwZ8eJhKoAdS6r",
                "age": 30,
                "isStudent": false,
                "grades": 85.5
                }
                '###

        var dataa: Array<UInt8> = Array<UInt8>(1158, item: 0)
        let time1 = MonoTime.now()
        for (i in 0..=count) {
            dataa = DataModel.fromJson(JsonValue.fromStr(str)).toMessagePack()
        }
        
        let time2 = MonoTime.now()

        let duration1 = time2 - time1
        println("pack   datasize: 1158 ,time: ${duration1.toNanoseconds() / count}ns")

        var model: DataModel
        let time3 = MonoTime.now()
        for (i in 0..=count) {
            model = DataModel.fromMessagePack(dataa)
        }
        let time4 = MonoTime.now()
        let duration2 = time4 - time3
        println("unPack   datasize: 1158 ,time: ${duration2.toNanoseconds() / count}ns")
    }
}