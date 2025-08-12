<div align="center">
<h1>msgpack4cj</h1>
</div>
<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.0.3-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.0.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-90.6%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>


1 介绍

msgpack4cj是基于[msgpack](https://github.com/msgpack/msgpack)序列化协议的仓颉实现。旨在为仓颉应用提供高效、紧凑的二进制数据交换格式。支持快速的数据序列化和反序列化操作，适用于需要高性能和低开销的数据传输场景。

**特性**：

- 🚀 基础数据类型的序列化和反序列化操作

- 🌍 序列化DataModle实现类

- 💪 构建​不可变值的封装类

### 项目结构

```shell
├─ AppScope
├─ doc                      # API文档        
├─ entry                    # 示例代码文件夹                  
├─ msgpack                   # msgpack 库源目录                  
│  └─ src
│      └─ main
│          ├─ cangjie       # cangjie 源码
│          ├─ ets           # ets 源码                       
│          └─ resources     # 资源文件
├─ hvigor                   # 构建工具目录
└─ README.md                # msgpack 介绍及使用说明
```


### 接口说明

主要核心类和全局函数说明,详情见 [API]

3 使用说明

### 编译构建

```text
ohpm install @cangjie-tpc/msgpack
```

### 功能示例

#### 序列化/反序列化基本数据类型

```ets
import { MessagePacker, MessageUnPacker, DataModel } from '@cangjie-tpc/msgpack';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Column(){
        Row(){
          Button("pack_type")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
                let c = new MessagePacker()
                c.packBool(true)
                c.packInt8(8)
                c.packInt16(16)
                c.packInt32(555)
                c.packInt64(6666)
                c.packString('zzz')
                c.packFloat64(3.1415)
                c.packNull()
                hilog.error(0X000000, "msgpack", `${c.toByteArray().toString()}`)
            })
        }
        .margin({ top: 10 })                    
      }
    }
    .height('100%')
    .width('100%')
  }
}
```

#### 序列化/反序列化对象

```ets
import { MessagePacker, MessageUnPacker, DataModel } from '@cangjie-tpc/msgpack';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Column(){
        Row(){
          Button("unpack_type")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
                let value = [195,8,16,205,2,43,205,26,10,163,122,122,122,203,64,9,33,202,192,131,18,111,192]
                let c = new MessageUnPacker(value)
                let bool = c.unpackBool()
                let int8 = c.unpackInt8()
                let int16 = c.unpackInt16()
                let int32 = c.unpackInt32()
                let int64 = c.unpackInt64()
                let str = c.unpackString()
                let float = c.unpackFloat64()
                c.unpackNull()
                let s = bool + ', ' + int8 + ', ' + int16 + ', ' + int32 + ', ' + int64 + ', ' + str + ', ' + float
                hilog.error(0X000000, "msgpack", `${s}`)
            })
        }
        .margin({ top: 10 })                    
      }
    }
    .height('100%')
    .width('100%')
  }
}
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio  5.1.0.828SP1
- Cangjie Plugin Canary  5.1.0.828

## 开源协议
本项目基于 [Apache License 2.0](./LICENSE)，请自由的享受和参与开源。

4 参与贡献

本项目由Yesokim实现并维护。技术支持和意见反馈请提Issue。

本项目基于 Apache License 2.0，欢迎给我们提交PR，欢迎参与任何形式的贡献。

本项目commiter：[@Yesokim](https://gitcode.com/weixin_64400442)
