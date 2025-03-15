<div align="center">
<h1>msgpack4cj</h1>
</div>
<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v0.59.6-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-88.90%25-brightgreen" style="display: inline-block;" />
</p>


## <img alt="" src="./doc/readme-image/readme-icon-introduction.png" style="display: inline-block;" width=3%/> 1 介绍

msgpack4cj是基于[msgpack](https://github.com/msgpack/msgpack)序列化协议的仓颉实现。旨在为仓颉应用提供高效、紧凑的二进制数据交换格式。支持快速的数据序列化和反序列化操作，适用于需要高性能和低开销的数据传输场景。

## <img alt="" src="./doc/readme-image/readme-icon-framework.png" style="display: inline-block;" width=3%/> 2 架构

### 2.1 项目结构

```
├── doc
    └── readme-image
└── src
    ├── core 		  //msgpack序列化核心类库
    └── serialization //序列化DataModle实现类
├── CHANGELOG
├── cjpm.lock
├── cjpm.toml
├── LICENSE
├── README.md
```

### 2.2 接口说明

#### 1. MessagePacker

用于将仓颉数据类型以msgpack格式序列化的类。

````cangjie
public class MessagePacker {

	public func packInt(): Unit
	
	public func packBool(): Unit
	
	public func packNull(): Unit
	
	public func packMapHeader(): Unit
	
	//...省略其他方法
}
````

#### 2. MessageUnpacker

用于反序列化msgpack数据的类。

```cangjie
public class MessageUnpacker {

	public func unpackInt(): Int
	
	public func unpackBool(): Bool
	
	public func unpackNull(): Unit
	
	public func unpackMapHeader(): unit
	
	//...省略其他方法
}
```

#### 3. ToMessagePack

用于将msgpack格式的二进制数据和DataModel对象之间相互转换的接口。

```cangjie
public interface ToMessagePack {

    static func fromMsgPack(data: Array<Byte>): DataModel
  
    func toMessagePack(): Array<Byte>

}
```

## <img alt="" src="./doc/readme-image/readme-icon-compile.png" style="display: inline-block;" width=3%/> 3 使用说明

#### 1. 序列化/反序列化基本数据类型

```cangjie
import msgpack4cj.core.*
import serialization.serialization.*

main(): Unit {
    //序列化
    let packer = MessagePacker()
    packer.packMapHeader(3)
    packer.packString("name")
    packer.packString("yesokim")
    packer.packString("age")
    packer.packInt(22)
    packer.packString("hobby")
    packer.packArrayHeader(1)
    packer.packString("code")
    let data = packer.toByteArray()
    //反序列化
    let unpacker = MessageUnpacker(data)
    let mapSize = unpacker.unpackMapHeader()
    let key1 = unpacker.unpackString()
    let name = unpacker.unpackString()
    let key2 = unpacker.unpackString()
    let age = unpacker.unpackInt()
    let key3= unpacker.unpackString()
    let arraySize = unpacker.unpackArrayHeader()
    let hobby = unpacker.unpackString()
    println("${key1}: ${name}, ${key2}: ${age}, ${key3}: ${hobby}")
}
```

#### 2. 序列化/反序列化对象

```cangjie
import msgpack4cj.serialization.*
import serialization.serialization.*

main(): Unit {
    let student = Student("yesokim", 22, ["code"])
    //序列化
    let data = student.serialize().toMessagePack()
    //反序列化
    let stu = Student.deserialize(DataModel.fromMessagePack(data))
    println(stu.name)
    println(stu.age)
    println(stu.hobby)
}

public class Student <: Serializable<Student> {

    public let name: String

    public let age: Int

    public let hobby: Array<String>

    public init(name: String, age: Int, hobby: Array<String>) {
        this.name = name
        this.age = age
        this.hobby = hobby
    }

    public func serialize(): DataModel {
        let model = DataModelStruct()
        model.add(field<String>("name", name))
        model.add(field<Int>("age", age))
        model.add(field<Array<String>>("hobby", hobby))
        return model
    }

    public static func deserialize(dataModel: DataModel): Student {
        let model = match (dataModel) {
            case v: DataModelStruct => v
            case _ => throw Exception("") 
        }
        let name = String.deserialize(model.get("name"))
        let age = Int.deserialize(model.get("age"))
        let hobby = Array<String>.deserialize(model.get("hobby"))
        return Student(name, age, hobby)
    }

}
```

## <img alt="" src="./doc/readme-image/readme-icon-contribute.png" style="display: inline-block;" width=3%/>4 参与贡献

本项目由Yesokim实现并维护。技术支持和意见反馈请提Issue。

本项目基于 Apache License 2.0，欢迎给我们提交PR，欢迎参与任何形式的贡献。

本项目commiter：[@Yesokim](https://gitcode.com/weixin_64400442)
