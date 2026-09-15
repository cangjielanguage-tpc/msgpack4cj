import { pack_type, pack_array, pack_map, unpack_type, unpack_array, unpack_map, pack_json,
  unpack_json,
  pack_json2,
  unpack_json2,
  pack_timestamp,
  unpack_timestamp,
  pack_extension,
  unpack_extension} from './pack_bool';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World packer';
  @State message2: string = 'Hello World unpacker';

  build() {
    Scroll() {
    Column() {
      Button("压缩:基本类型").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message = pack_type()
        hilog.error(0, "", this.message)
      })
      Button("压缩:array").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message = pack_array()
      })
      Button("压缩:map").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message = pack_map()
        hilog.error(0, "", this.message)
      })

      Button("压缩:time").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message = pack_timestamp()
        hilog.error(0, "", this.message)
      })

      Button("压缩:自定义类型").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message = pack_extension()
        hilog.error(0, "", this.message)
      })

      Button("压缩:json").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message = pack_json()
        hilog.error(0, "", this.message)
      })

      Button("压缩:json2").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message = pack_json2()
        hilog.error(0, "", this.message)
      })

      Text(this.message)
      Button("解压缩:基本类型").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message2 = unpack_type()
      })
      Button("解压缩:array").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message2 = unpack_array()
      })
      Button("解压缩:map").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message2 = unpack_map()
      })
      Button("解压缩:time").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message2 = unpack_timestamp()
      })
      Button("解压缩:自定义类型").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message2 = unpack_extension()
      })
      Button("解压缩:json").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message2 = unpack_json()
        hilog.error(0, "", this.message2)
      })
      Button("解压缩:json2").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        this.message2 = unpack_json2()
        hilog.error(0, "", this.message2)
      })
      Text(this.message2)
      Button("HLT").fontSize($r('app.float.page_text_font_size')).onClick(n => {
        router.pushUrl({ url: "pages/test_hlt"} )
      })
    }}
  }
}