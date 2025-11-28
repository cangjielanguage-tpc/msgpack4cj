# msgpack4cj库

## 介绍

msgpack4cj是基于[msgpack](https://github.com/msgpack/msgpack)序列化协议的仓颉实现。旨在为仓颉应用提供高效、紧凑的二进制数据交换格式。支持快速的数据序列化和反序列化操作，适用于需要高性能和低开销的数据传输场景。

## 1 二进制与仓颉数据类型的序列化和反序列化功能

### 1.1 仓颉数据类型的序列化

仓颉数据类型的序列化

````cangjie
public class MessagePack {
    
    /**
     * 构造 MessagePacker 对象
     *
     * 参数 output - 输出流
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public static func newDefaultPacker(output: OutputStream): MessagePacker
    
    /**
     * 构造 MessagePacker 对象
     *
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public static func newDefaultPacker(): MessagePacker
    
    /**
     * 构造 MessageUnpacker 对象
     *
     * 参数 input - 输入流
     * 返回值 MessageUnpacker - MessageUnpacker 对象
     */
    public static func newDefaultUnpacker(input: InputStream): MessageUnpacker
    
    /**
     * 构造 MessageUnpacker 对象
     *
     * 参数 content - 数组
     * 返回值 MessageUnpacker - MessageUnpacker 对象
     */
    public static func newDefaultUnpacker(content: Array<Byte>): MessageUnpacker
    
    /**
     * 构造 MessagePacker 对象
     *
     * 参数 output - 输出流
     * 参数 config - PackerConfig 对象
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public static func newPacker(output: OutputStream, config: PackerConfig): MessagePacker
    
    /**
     * 构造 MessagePacker 对象
     *
     * 参数 config - PackerConfig 对象
     * 返回值 MessagePacker - MessagePacker 对象
     */
    public static func newBufferPacker(config: PackerConfig): MessageBufferPacker
    
    /**
     * 构造 MessageUnpacker 对象
     *
     * 参数 input - 输入流
     * 参数 config - UnpackerConfig 对象
     * 返回值 MessageUnpacker - MessageUnpacker 对象
     */
    public static func newUnpacker(input: InputStream, config: UnpackerConfig): MessageUnpacker


    /**
     * 构造 MessageUnpacker 对象
     *
     * 参数 content - 数组
     * 参数 config - UnpackerConfig 对象
     * 返回值 MessageUnpacker - MessageUnpacker 对象
     */
    public static func newUnpacker(content: Array<Byte>, config: UnpackerConfig): MessageUnpacker

}
````

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
     * 读取流中数据,反序列为 Float32
     *
     * 返回值 Float32 - 反序列化后数据
     */
    public func unpackFloat32(): Float32
    
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
     * 参数 v - Int8
     * 返回值 ImmutableIntValue - 不可变Int8封装类
     */
    public static func newInt(v: Int8): ImmutableIntValue

    /**
     * 构建Int16封装类
     *
     * 参数 v - Int16
     * 返回值 ImmutableIntValue - 不可变Int16封装类
     */
    public static func newInt(v: Int16): ImmutableIntValue

    /**
     * 构建Int32封装类
     *
     * 参数 v - Int32
     * 返回值 ImmutableIntValue - 不可变Int32封装类
     */
    public static func newInt(v: Int32): ImmutableIntValue

    /**
     * 构建Int64封装类
     *
     * 参数 v - Int64
     * 返回值 ImmutableIntValue - 不可变Int64封装类
     */
    public static func newInt(v: Int64): ImmutableIntValue

    /**
     * 构建Float32封装类
     *
     * 参数 v - Float32
     * 返回值 ImmutableFloatValue - 不可变Float32封装类
     */
    public static func newFloat32(v: Float32): ImmutableFloatValue

    /**
     * 构建Float64封装类
     *
     * 参数 v - Float64
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
     * 参数 list - Array<Value>
     * 返回值 ImmutableArrayValue - 不可变Array封装类
     */
    public static func newArray(list: Array<Value>): ImmutableArrayValue

    /**
     * 构建不可变Map封装类
     *
     * 参数 list - List<Value>
     * 返回值 ImmutableMapValue - 不可变Map封装类
     */
    public static func newMap(list: List<Value>): ImmutableMapValue

    /**
     * 构建不可变Extension封装类
     *
     * 参数 dataType - 类型
     * 参数 data - data数据
     * 返回值 ImmutableExtensionValue - 不可变Extension封装类
     */
    public static func newExtension(dataType: Byte, data: Array<Byte>): ImmutableExtensionValue

    /**
     * 构建不可变Timestamp封装类
     *
     * 参数 dataTime - 时间
     * 返回值 ImmutableTimestampValue - 不可变Timestamp封装类
     */
    public static func newTimestamp(dataTime: DateTime): ImmutableTimestampValue
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
     * 写入None数据
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     * 返回值 Bool - 比较结果
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
     * 写入 Bool 值
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     * 返回值 Bool - 比较结果
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- hashCode
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String - bool 值
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- bool 值
     */
    public func toString(): String
}
````

##### 1.4.2.3 ImmutableInt64ValueImpl

````cangjie
public class ImmutableInt64ValueImpl <: AbstractImmutableValue & ImmutableIntValue & Hashable & ToString{

    /**
     * 构建 Int64 不可变类
     *
     * 参数 value - Int64 值
     */
    public init(value: Int64): Unit

    /**
     * 值类型
     *
     * 返回值 ValueType - ValueType.INT
     */
    public override func getValueType(): ValueType

    /**
     * 获取 Int 封装类
     *
     * 返回值 ImmutableIntValue - Int 封装类
     */
    public override func immutableValue(): ImmutableIntValue

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
     * 写入 Int64 类型的值
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     * 返回值 Bool - 比较结果
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- Int64 值
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String- Int64 转成String
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- Int64 转成String
     */
    public func toString(): String
}
````


##### 1.4.2.4 ImmutableFloat64ValueImpl

````cangjie
public class ImmutableFloat64ValueImpl <: AbstractImmutableValue & ImmutableIntValue & Hashable & ToString{

    /**
     * 构建 Float64 不可变类
     *
     * 参数 value - Float64 值
     */
    public init(value: Float64): Unit

    /**
     * 值类型
     *
     * 返回值 ValueType - ValueType.FLOAT
     */
    public override func getValueType(): ValueType

    /**
     * 获取 Float64 封装类
     *
     * 返回值 ImmutableFloat64Value - Float64 封装类
     */
    public override func asFloat64Value(): ImmutableFloat64Value

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
     * 写入 Float64 类型的值
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     * 返回值 Bool - 比较结果
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- hashCode 值
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String- Float64 转成String
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- Float64 转成String
     */
    public func toString(): String
}
````

##### 1.4.2.5 ImmutableExtensionValueImpl

````cangjie
public class ImmutableExtensionValueImpl <: AbstractImmutableValue & ImmutableExtensionValue & Hashable & ToString{

    /**
     * 初始化
     *
     * 参数 type - type
     * 参数 data - 值
     */
    public init(type: Byte, data：Array<Byte>): Unit

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
    public override func immutableValue(): ImmutableExtensionValue

    /**
     * 获取 Extension 封装类
     *
     * 返回值 ImmutableExtensionValue - Extension 封装类
     */
    public override func asExtensionValue(): ImmutableExtensionValue

    /**
     * 获取 类型
     *
     * 返回值 Byte - 类型
     */
    public override func getType(): Byte

    /**
     * 获取 data数据
     *
     * 返回值 Array<Byte> - 数据
     */
    public override func getData(): Array<Byte>

    /**
     * 写入 数据
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     * 返回值 Bool - 比较结果
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- hashCode 值
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String- toJson
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- toString
     */
    public func toString(): String
}
````



##### 1.4.2.6 ImmutableStringValueImpl

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
     * 返回值 ValueType - ValueType.STRING
     */
    public override func getValueType(): ValueType
   
    /**
     * 获取 String 封装类
     *
     * 返回值 ImmutableStringValue - String 封装类
     */
    public override func immutableValue(): ImmutableStringValue

    /**
     * 获取 String 封装类
     *
     * 返回值 ImmutableStringValue - String 封装类
     */
    public override func asStringValue(): ImmutableStringValue

    /**
     * 获取 String 值
     *
     * 返回值 String - String 值
     */
    public override func getString(): String

    /**
     * 写入 String 值
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     * 返回值 Bool - 比较结果
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- hashCode 值
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String- toJson
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- toString
     */
    public func toString(): String
}
````



##### 1.4.2.7 ImmutableTimestampValueImpl

````cangjie
public class ImmutableTimestampValueImpl <: AbstractImmutableValue & ImmutableExtensionValue & Hashable & ToString{

    /**
     * 初始化
     *
     * 参数 dateTime - DateTime 值
     */
    public init(dateTime: DateTime): Unit

    /**
     * 确认是时间戳封装类 - true
     *
     * 返回值 Bool - true
     */
    public override func isTimestampValue(): Bool

    /**
     * 获取时间戳类型 - 255
     *
     * 返回值 Byte - 类型
     */
    public override func getType(): Byte

    /**
     * 值类型
     *
     * 返回值 ValueType - ValueType.EXT_TIMESTAMP
     */
    public override func getValueType(): ValueType

    /**
     * 获取 Timestamp 封装类
     *
     * 返回值 ImmutableTimestampValue - Timestamp 封装类
     */
    public override func immutableValue(): ImmutableTimestampValue

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
     * 获取 具体时间戳的值 - 秒
     *
     * 返回值 Int64 - 具体时间戳的值
     */
    public override func getEpochSecond(): Int64

    /**
     * 获取 具体时间戳的值 - 纳秒
     *
     * 返回值 Int64 - 具体时间戳的值
     */
    public override func getNano(): Int64

    /**
     * 获取 data - 接口必须实现 无具体意义
     *
     * 返回值 Array<Byte> - []
     */
    public override func getData(): Array<Byte>

    /**
     * 获取 时间戳的值
     *
     * 返回值 DateTime - 时间戳的值
     */
    public override func toDataTime(): DateTime

    /**
     * 写入时间戳
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     * 返回值 Bool - 比较结果
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- hashCode的值
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String- toJson
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- toString
     */
    public func toString(): String
}
````



##### 1.4.2.8 ImmutableArrayValueImpl

````cangjie
public class ImmutableArrayValueImpl <: AbstractImmutableValue & ImmutableArrayValue & Hashable & ToString {

    /**
     * 初始化
     *
     * 参数 array - Array 值
     */
    public init(array: Array<Value>): Unit

    /**
     * 获取空数组类 - []
     *
     * 返回值 ImmutableArrayValue - 空数组类
     */
    public static func empty(): ImmutableArrayValue

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
     * 获取 Array的大小
     *
     * 返回值 Int64 - Array的大小
     */
    public override func size(): Int64

    /**
     * 根据index 获取Array的值
     *
     * 参数 idnex - Array的idnex
     * 返回值 ?Value - Array的值
     */
    public override func get(index: Int64): ?Value

    /**
     * 根据Array的迭代器
     *
     * 返回值 Iterator<Value> - 迭代器
     */
    public override func iterator(): Iterator<Value>

    /**
     * 转成 ArrayList
     *
     * 返回值 List<Value> - ArrayList
     */
    public override func list(): List<Value>

    /**
     * 写入 Array
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     * 返回值 Bool - 比较结果
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- hashCode
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String- toJson
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- toString
     */
    public func toString(): String
}
````

##### 1.4.2.9 ImmutableMapValueImpl

````cangjie
public class ImmutableMapValueImpl <: AbstractImmutableValue & ImmutableMapValue & Hashable & ToString {

    /**
     * 初始化
     *
     * 参数 kvs - Array 值
     */
    public init(kvs: Array<Value>): Unit

    /**
     * 获取空Map类
     *
     * 返回值 ImmutableMapValue - 空Map类
     */
    public static func empty(): ImmutableMapValue

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
     * 获取 Map的大小
     *
     * 返回值 Int64 - Map的大小
     */
    public override func size(): Int64

    /**
     * 写入 Map
     *
     * 参数 packer - 序列化对象
     */
    public override func writeTo(packer: MessagePacker): Unit

    /**
     * 相等
     *
     * 参数 v - 比较对象
     * 返回值 Bool - 比较结果
     */
    public override func equals(v: Value): Bool

    /**
     * 获取hashcode
     *
     * 返回值 Int64- hashCode
     */
    public func hashCode(): Int64

    /**
     * toJson
     *
     * 返回值 String- toJson
     */
    public func toJson(): String

    /**
     * toString
     *
     * 返回值 String- toString
     */
    public func toString(): String
}
````

####