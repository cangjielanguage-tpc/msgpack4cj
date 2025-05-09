<div align="center">
<h1>msgpack4cj</h1>
</div>
<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v0.59.6-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-90.6%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>


## <img alt="" src="./doc/readme-image/readme-icon-introduction.png" style="display: inline-block;" width=3%/> 1 介绍

msgpack4cj是基于[msgpack](https://github.com/msgpack/msgpack)序列化协议的仓颉实现。旨在为仓颉应用提供高效、紧凑的二进制数据交换格式。支持快速的数据序列化和反序列化操作，适用于需要高性能和低开销的数据传输场景。

**特性**：

- 🚀 基础数据类型的序列化和反序列化操作

- 🌍 序列化DataModle实现类

- 💪 构建​不可变值的封装类


## <img alt="" src="./doc/readme-image/readme-icon-framework.png" style="display: inline-block;" width=3%/> 2 架构

### 项目结构

```
├── doc
    └── readme-image
    └── feature_api.md
└── src
    ├── core 		  //msgpack序列化核心类库
    └── serialization //序列化DataModle实现类
└── test
    ├── HLT
    └── LLT
├── CHANGELOG
├── cjpm.toml
├── LICENSE
├── README.md
├── README.OpenSource
```

- `doc`  文档目录，用于存API接口文档
- `src`  是库源码目录
- `test` 存放 HLT 测试用例、LLT 自测用例

### 接口说明

主要核心类和全局函数说明,详情见 [API](./doc/feature_api.md)

### <img alt="" src="./doc/readme-image/readme-icon-compile.png" style="display: inline-block;" width=3%/> 3 使用说明

### 编译
    ```
    cjpm build
    ```

### 功能示例

#### 序列化/反序列化基本数据类型

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

#### 序列化/反序列化对象

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

## 约束与限制

在下述版本验证通过：

    Cangjie Version: 0.59.6

## 开源协议
本项目基于 [Apache License 2.0](./LICENSE)，请自由的享受和参与开源。

## <img alt="" src="./doc/readme-image/readme-icon-contribute.png" style="display: inline-block;" width=3%/>4 参与贡献

本项目由Yesokim实现并维护。技术支持和意见反馈请提Issue。

本项目基于 Apache License 2.0，欢迎给我们提交PR，欢迎参与任何形式的贡献。

本项目commiter：[@Yesokim](https://gitcode.com/weixin_64400442)
