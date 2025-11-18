# msgpack4cj库

## 介绍

msgpack4cj是基于[msgpack](https://github.com/msgpack/msgpack)序列化协议的仓颉实现。旨在为仓颉应用提供高效、紧凑的二进制数据交换格式。支持快速的数据序列化和反序列化操作，适用于需要高性能和低开销的数据传输场景。

## 1 二进制与仓颉数据类型的序列化和反序列化功能

### 1.1 仓颉数据类型的序列化

仓颉数据类型的序列化

#### 1.1.1 MessagePacker

````cangjie
public class MessagePacker {

    /**
     * 序列化Int8类型数据
     *
     * 参数 value - Int8 序列化Int8类型数据
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public func packInt8(value: Int8): MessagePacker

    /**
     * 序列化Int16类型数据
     *
     * 参数 value - Int16 数据
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public func packInt16(value: Int16): MessagePacker

    /**
     * 序列化Int32类型数据
     *
     * 参数 value - Int32 数据
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public func packInt32(value: Int32): MessagePacker

    /**
     * 序列化Int64类型数据
     *
     * 参数 value - Int64 数据
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public func packInt64(value: Int64): MessagePacker

    /**
     * 序列化UInt16类型数据
     *
     * 参数 value - UInt16 数据
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public func packUInt16(value: UInt16): MessagePacker

    /**
     * 序列化UInt8类型数据
     *
     * 参数 value - UInt8 数据
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public func packUInt8(value: UInt8): MessagePacker

    /**
     * 序列化UInt32类型数据
     *
     * 参数 value - UInt32 数据
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public func packUInt32(value: UInt32): MessagePacker

    /**
     * 序列化UInt64类型数据
     *
     * 参数 value - UInt64 数据
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public func packUInt64(value: UInt64): MessagePacker

    /**
     * 序列化String类型数据
     *
     * 参数 value - String 数据
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public func packString(value: String): MessagePacker

    /**
     * 序列化Bool类型数据
     *
     * 参数 value - Bool 数据
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public func packBool(value: Bool): MessagePacker

    /**
     * 序列化Float64类型数据
     *
     * 参数 value - Float64 数据
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public func packFloat64(value: Float64): MessagePacker

    /**
     * 序列化Float32类型数据
     *
     * 参数 value - Float32 数据
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public func packFloat32(value: Float32): MessagePacker

    /**
     * 序列化Null类型数据
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public func packNull(): MessagePacker

    /**
     * 序列化Map对象的标识头
     *
     * 参数 value - Int 数据
     */
    public func packMapHeader(value: Int): Unit

    /**
     * 序列化Array对象的标识头
     *
     * 参数 value - Int 数据
     */
    public func packArrayHeader(value: Int): Unit

    /**
     * 序列化DateTime类型数据 - 时间时区为UTC
     *
     * 参数 dateTime - DateTime 数据
     */
    public func packTimestamp(dateTime: DateTime): Unit

    /**
     * 序列化DateTime类型数据 - 时间时区为UTC 
     *
     * 参数 sec - Int64 秒数据 距离1970年至今的秒
     * 参数 nsec - Int64 纳秒数据 
     */
    public func packTimestamp(sec: Int64, nsec: Int64): Unit

    /**
     * 序列化Value 对象
     *
     * 参数 value - Value 对象
     */
    public func packValue(value: Value)

    /**
     * 序列化Byte数组类型数据
     *
     * 参数 value - Array<Byte> 数据
     */
    public func packBinary(value: Array<Byte>): Unit

    /**
     * 序列化 拓展类型 头数据
     *
     * 参数 extType - Byte 类型
     * 参数 payloadLen - Int32 数据长度
     */
    public func packExtensionTypeHeader(extType: Byte, payloadLen: Int32)

    /**
     * 序列化 map， array， 拓展类型的负载部分
     *
     * 参数 value - Array<Byte> 数据
     */
    public func writePayload(src: Array<Byte>)
}
````



### 1.2 仓颉数据类型的反序列化

仓颉数据类型的反序列化

#### 1.2.1 MessageUnpacker

````cangjie
public class MessageUnpacker {

    /**
     * 读取流中数据,反序列为 Bool
     *
     * 返回值 Bool - 反序列化后数据
     */
    public func unpackBool(): Bool

    /**
     * 读取流中数据,反序列为 Null
     */
    public func unpackNull(): Unit

    /**
     * 反序列化 value 对象
     *
     * 返回值 ImmutableValue - ImmutableValue 对象
     */
    public func unpackValue(): ImmutableValue

    /**
     * 读取流中数据,反序列为 Float64
     *
     * 返回值 Float64 - 反序列化后数据
     */
    public func unpackFloat64(): Float64

    /**
     * 读取流中数据,反序列为 String
     *
     * 返回值 String - 反序列化后数据
     */
    public func unpackString(): String

    /**
     * 反序列化Map对象的标识头
     *
     * 返回值 Int - 反序列化后数据
     */
    public func unpackMapHeader(): Int

    /**
     * 反序列化Array对象的标识头
     *
     * 返回值 Int - 反序列化后数据
     */
    public func unpackArrayHeader(): Int

    /**
     * 读取流中数据,反序列为 Int8
     *
     * 返回值 Int8 - 反序列化后数据
     */
    public func unpackInt8(): Int8

    /**
     * 读取流中数据,反序列为 Int16
     *
     * 返回值 Int16 - 反序列化后数据
     */
    public func unpackInt16(): Int16

    /**
     * 读取流中数据,反序列为 Int32
     *
     * 返回值 Int32 - 反序列化后数据
     */
    public func unpackInt32(): Int32

    /**
     * 读取流中数据,反序列为 Int64
     *
     * 返回值 Int64 - 反序列化后数据
     */
    public func unpackInt64(): Int64

    /**
     * 读取流中数据,反序列为 UInt8
     *
     * 返回值 UInt8 - 反序列化后数据
     */
    public func unpackUInt8(): UInt8

    /**
     * 读取流中数据,反序列为 UInt16
     *
     * 返回值 UInt16 - 反序列化后数据
     */
    public func unpackUInt16(): UInt16

    /**
     * 读取流中数据,反序列为 UInt32
     *
     * 返回值 UInt32 - 反序列化后数据
     */
    public func unpackUInt32(): UInt32

    /**
     * 读取流中数据,反序列为 UInt64
     *
     * 返回值 UInt64 - 反序列化后数据
     */
    public func unpackUInt64(): UInt64

    /**
     * 读取流中数据,反序列为 DateTime
     *
     * 返回值 DateTime - 反序列化后数据
     */
    public func unpackTimestamp(): DateTime

    /**
     * 读取流中数据,反序列为 DateTime
     *
     * 参数 ext - ExtensionTypeHeader 拓展类型
     * 返回值 DateTime - 反序列化后数据
     */
    public func unpackTimestamp(ext: ExtensionTypeHeader): DateTime

    /**
     * 读取流中数据,获取拓展类型
     *
     * 返回值 ExtensionTypeHeader - 拓展类型
     */
    public func unpackExtensionTypeHeader(): ExtensionTypeHeader

    /**
     * 读取流中数据,反序列为 Array<Byte>
     *
     * 返回值 Array<Byte> - 反序列化后数据
     */
    public func unpackBinary(): Array<Byte>

    /**
     * 读取流中数据,反序列为 拓展类型头
     *
     * 返回值 ExtensionTypeHeader - 拓展类型头
     */
    public func unpackExtensionTypeHeader(): ExtensionTypeHeader
}
````

### 1.3 DataModel封装 实现与json的转化

实现与json的转化

#### 1.3.1 DataModel

````cangjie
extend DataModel <: ToMessagePack{

    /**
     * 实现json数据转化成字节数组
     *
     * 返回值 Array<Byte> - 序列化后的字节数组
     */
    public func toMessagePack(): Array<Byte>

    /**
     * 实现json数据转化成字节数组
     *
     * 参数 data - Array<Byte> 待转化为json的字节数组
     * 返回值 DataModel - 转化后的DataModel对象
     */
    public static func fromMessagePack(data: Array<Byte>): DataModel
}
````

### 1.4 封装为不可变类

将数据类型封装为对应的不可变类

#### 1.4.1 ValueFactory

````cangjie
public class ValueFactory {

    /**
     * 构建None封装类
     *
     * 返回值 ImmutableNilValue - 不可变None封装类
     */
    public static func newNil(): ImmutableNilValue

    /**
     * 构建Bool封装类
     *
     * 参数 value - Bool
     * 返回值 ImmutableBooleanValue - 不可变Bool封装类
     */
    public static func newBoolean(value: Bool): ImmutableBooleanValue

    /**
     * 构建Int8封装类
     *
     * 参数 value - Int8
     * 返回值 ImmutableIntValue - 不可变Int8封装类
     */
    public static func newInt(v: Int8): ImmutableIntValue

    /**
     * 构建Int16封装类
     *
     * 参数 value - Int16
     * 返回值 ImmutableIntValue - 不可变Int16封装类
     */
    public static func newInt(v: Int16): ImmutableIntValue

    /**
     * 构建Int32封装类
     *
     * 参数 value - Int32
     * 返回值 ImmutableIntValue - 不可变Int32封装类
     */
    public static func newInt(v: Int32): ImmutableIntValue
    
    /**
     * 构建Float32封装类
     *
     * 参数 value - Float32
     * 返回值 ImmutableFloatValue - 不可变Float32封装类
     */
    public static func newFloat32(v: Float32): ImmutableFloatValue

    /**
     * 构建Float64封装类
     *
     * 参数 value - Float64
     * 返回值 ImmutableFloatValue - 不可变Float64封装类
     */
    public static func newFloat64(v: Float64): ImmutableFloatValue

    /**
     * 构建不可变String封装类
     *
     * 参数 value - String
     * 返回值 ImmutableStringValue - 不可变String封装类
     */
    public static func newString(value: String): ImmutableStringValue

    /**
     * 构建不可变Array封装类
     *
     * 参数 value - Array<Value>
     * 返回值 ImmutableArrayValueImpl - 不可变Array封装类
     */
    public static func newArray(list: Array<Value>): ImmutableArrayValueImpl

    /**
     * 构建不可变Map封装类
     *
     * 参数 value - String
     * 返回值 ImmutableMapValue - 不可变Map封装类
     */
    public static func newMap(value: Map<Value>): ImmutableMapValue

    /**
     * 构建不可变Extension封装类
     *
     * 参数 type - 类型
     * 参数 data - data数据
     * 返回值 ImmutableExtensionValue - 不可变Extension封装类
     */
    public static func newExtension(type: Byte, data: Array<Byte>): ImmutableExtensionValue

    /**
     * 构建不可变Timestamp封装类
     *
     * 参数 epochSecond - 秒
     * 参数 nanoAdjustment - 纳秒
     * 返回值 ImmutableTimestampValue - 不可变Timestamp封装类
     */
    public static func newTimestamp(epochSecond: Int64, nanoAdjustment: Int32): ImmutableTimestampValue
}
````

#### 1.4.2 封装类

##### 1.4.2.1 ImmutableNilValueImpl

````cangjie
public class ImmutableNilValueImpl <: AbstractImmutableValue & ImmutableNilValue & Hashable & ToString {

    /**
     * 静态获取None封装类
     *
     * 返回值 ImmutableNilValue - None封装类
     */
    public static func get(): ImmutableNilValue

    /**
     * 值类型
     *
     * 返回值 ValueType - ValueType.NONE
     */
    public override func getValueType(): ValueType

    /**
     * 静态获取None封装类
     *
     * 返回值 ImmutableNilValue - ValueType.NONE
     */
    public override func asNilValue(): ImmutableNilValue

    /**
     * 静态获取None封装类
     *
     * 返回值 ImmutableNilValue - ValueType.NONE
     */
    public override func immutableValue(): ImmutableNilValue

    /**
     * 静态获取None封装类
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- 0
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String- "None"
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- "None"
     */
    public func toString(): String
}
````

##### 1.4.2.2 ImmutableBooleanValueImpl

````cangjie
public class ImmutableBooleanValueImpl <: AbstractImmutableValue & ImmutableBooleanValue & Hashable & ToString{

    /**
     * 值类型
     *
     * 返回值 ValueType - ValueType.BOOL
     */
    public override func getValueType(): ValueType

    /**
     * 静态获取 Bool 封装类
     *
     * 返回值 ImmutableBooleanValue - Bool 封装类
     */
    public override func asBooleanValue(): ImmutableBooleanValue

    /**
     * 静态获取 Bool 封装类
     *
     * 返回值 ImmutableBooleanValue - Bool 封装类
     */
    public override func immutableValue(): ImmutableBooleanValue


    /**
     * 获取 Bool值
     *
     * 返回值 Bool -  Bool值
     */
    public override func getBoolean(): Bool
    
    /**
     * 静态获取None封装类
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- 0
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String- "None"
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- "None"
     */
    public func toString(): String
}
````

##### 1.4.2.3 ImmutableInt64ValueImpl

````cangjie
public class ImmutableInt64ValueImpl <: AbstractImmutableValue & ImmutableIntValue & Hashable & ToString{

    /**
     * 值类型
     *
     * 返回值 ValueType - ValueType.INT
     */
    public override func getValueType(): ValueType

    /**
     * 获取 Number 封装类
     *
     * 返回值 ImmutableNumberValue - Number 封装类
     */
    public override func asNumberValue(): ImmutableNumberValue

    /**
     * 获取 Int 封装类
     *
     * 返回值 ImmutableIntValue - Int 封装类
     */
    public override func asIntValue(): ImmutableIntValue


    /**
     * 获取 Int8 值
     *
     * 返回值 Int8 - Int8 值
     */
    public override func toInt8(): Int8
    
    /**
     * 获取 Int16 值
     *
     * 返回值 Int16 - Int16 值
     */
    public override func toInt16(): Int16
    
    /**
     * 获取 Int32 值
     *
     * 返回值 Int32 - Int32 值
     */
    public override func toInt32(): Int32
    
    /**
     * 获取 Int64 值
     *
     * 返回值 Int64 - Int64 值
     */
    public override func toInt64(): Int64

    /**
     * 获取 Float32 值
     *
     * 返回值 Float32 - Float32 值
     */
    public override func toFloat32(): Float32

    /**
     * 获取 Float64 值
     *
     * 返回值 Float64 - Float64 值
     */
    public override func toFloat64(): Float64
    
    /**
     * 获取 是否 Int8 范围
     *
     * 返回值 Bool - Bool 值
     */
    public override func isInInt8Range(): Bool

    /**
     * 获取 是否 Int16 范围
     *
     * 返回值 Bool - Bool 值
     */
    public override func isInInt16Range(): Bool
    
    /**
     * 获取 是否 Int32 范围
     *
     * 返回值 Bool - Bool 值
     */
    public override func isInInt32Range(): Bool
    
    /**
     * 获取 是否 Int64 范围
     *
     * 返回值 Bool - Bool 值
     */
    public override func isInInt64Range(): Bool
    
    
    
    /**
     * 静态获取None封装类
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- 0
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String- "None"
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- "None"
     */
    public func toString(): String
}
````

##### 1.4.2.4 ImmutableExtensionValueImpl

````cangjie
public class ImmutableExtensionValueImpl <: AbstractImmutableValue & ImmutableExtensionValue & Hashable & ToString{

    /**
     * 初始化
     *
     * 参数 type - type
     * 参数 data - 值
     */
    public init(type: Byte, data：Array<Byte>)

    /**
     * 值类型
     *
     * 返回值 ValueType - ValueType.EXTENSION
     */
    public override func getValueType(): ValueType
    
    
    /**
     * 获取 Extension 封装类
     *
     * 返回值 ImmutableExtensionValue - Extension 封装类
     */
    public override func asNumberValue(): ImmutableExtensionValue

    /**
     * 获取 Extension 封装类
     *
     * 返回值 ImmutableExtensionValue - Extension 封装类
     */
    public override func asExtensionValue(): ImmutableExtensionValue

    /**
     * 静态获取None封装类
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- 0
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String- "None"
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- "None"
     */
    public func toString(): String
}
````



##### 1.4.2.5 ImmutableStringValueImpl

````cangjie
public class ImmutableStringValueImpl <: AbstractImmutableValue & ImmutableStringValue & Hashable & ToString{

    /**
     * 初始化
     *
     * 参数 string - String 值
     */
    public init(string: String)

    /**
     * 值类型
     *
     * 返回值 ValueType - ValueType.EXTENSION
     */
    public override func getValueType(): ValueType
   
    /**
     * 获取 String 封装类
     *
     * 返回值 ImmutableStringValue - String 封装类
     */
    public override func asNumberValue(): ImmutableStringValue

    /**
     * 获取 String 封装类
     *
     * 返回值 ImmutableStringValue - String 封装类
     */
    public override func asStringValue(): ImmutableStringValue

    /**
     * 静态获取None封装类
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- 0
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String- "None"
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- "None"
     */
    public func toString(): String
}
````



##### 1.4.2.6 ImmutableTimestampValueImpl

````cangjie
public class ImmutableTimestampValueImpl <: AbstractImmutableValue & ImmutableExtensionValue & Hashable & ToString{

    /**
     * 初始化
     *
     * 参数 dateTime - DateTime 值
     */
    public init(dateTime: DateTime)

    /**
     * 值类型
     *
     * 返回值 ValueType - ValueType.EXT_TIMESTAMP
     */
    public override func getValueType(): ValueType
   
    /**
     * 获取 Timestamp 封装类
     *
     * 返回值 ImmutableExtensionValue - Timestamp 封装类
     */
    public override func asExtensionValue(): ImmutableExtensionValue

    /**
     * 获取 Timestamp 封装类
     *
     * 返回值 ImmutableTimestampValue - Timestamp 封装类
     */
    public override func asTimestampValue(): ImmutableTimestampValue

    /**
     * 静态获取None封装类
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- 0
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String- "None"
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- "None"
     */
    public func toString(): String
}
````



##### 1.4.2.7 ImmutableArrayValueImpl

````cangjie
public class ImmutableArrayValueImpl <: AbstractImmutableValue & ImmutableArrayValue & Hashable & ToString {

    /**
     * 初始化
     *
     * 参数 dateTime - DateTime 值
     */
    public init(dateTime: DateTime)

    /**
     * 值类型
     *
     * 返回值 ValueType - ValueType.ARRAY
     */
    public override func getValueType(): ValueType
   
    /**
     * 获取 Array 封装类
     *
     * 返回值 ImmutableArrayValue - Array 封装类
     */
    public override func immutableValue(): ImmutableArrayValue

    /**
     * 获取 Array 封装类
     *
     * 返回值 ImmutableArrayValue - Array 封装类
     */
    public override func asArrayValue(): ImmutableArrayValue

    /**
     * 静态获取None封装类
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- 0
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String- "None"
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- "None"
     */
    public func toString(): String
}
````

##### 1.4.2.8 ImmutableMapValueImpl

````cangjie
public class ImmutableMapValueImpl <: AbstractImmutableValue & ImmutableMapValue & Hashable & ToString {

    /**
     * 值类型
     *
     * 返回值 ValueType - ValueType.MAP
     */
    public override func getValueType(): ValueType
   
    /**
     * 获取 Map 封装类
     *
     * 返回值 ImmutableMapValue - Map 封装类
     */
    public override func immutableValue(): ImmutableMapValue

    /**
     * 获取 Map 封装类
     *
     * 返回值 ImmutableMapValue - Map 封装类
     */
    public override func asMapValue(): ImmutableMapValue

    /**
     * 静态获取Map封装类
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- 0
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String- "None"
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- "None"
     */
    public func toString(): String
}
````

#### 

````cangjie
extend DataModel <: ToMessagePack{

    /**
     * 实现json数据转化成字节数组
     *
     * 返回值 Array<Byte> - 序列化后的字节数组
     */
    public func toMessagePack(): Array<Byte>

    /**
     * 实现json数据转化成字节数组
     *
     * 参数 data - Array<Byte> 待转化为json的字节数组
     * 返回值 DataModel - 转化后的DataModel对象
     */
    public static func fromMessagePack(data: Array<Byte>): DataModel
}
````