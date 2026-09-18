import { benchmarkPack, benchmarkUnpack } from './benchmark';

@Entry
@Component
struct test_performance {
  @State packResult: string = ''
  @State unpackResult: string = ''

  build() {
    Scroll() {
      Column() {
        Text("压缩性能测试")
        Button("压缩 10").fontSize($r('app.float.page_text_font_size')).onClick(async n => {
          this.unpackResult = ''
          this.packResult = await benchmarkPack(10)
        })
        Button("压缩 100").fontSize($r('app.float.page_text_font_size')).onClick(async n=> {
          this.unpackResult = ''
          this.packResult = await benchmarkPack(100)
        })
        Button("压缩 1000").fontSize($r('app.float.page_text_font_size')).onClick(async n => {
          this.unpackResult = ''
          this.packResult = await benchmarkPack(1000)
        })
        Button("压缩 10000").fontSize($r('app.float.page_text_font_size')).onClick(async n => {
          this.unpackResult = ''
          this.packResult = await benchmarkPack(10000)
        })
        Button("压缩 50000").fontSize($r('app.float.page_text_font_size')).onClick(async n => {
          this.unpackResult = ''
          this.packResult = await benchmarkPack(50000)
        })
        Text(this.packResult)
        Text(this.unpackResult)

        Text("解压缩性能测试")
        Button("解压缩 10").fontSize($r('app.float.page_text_font_size')).onClick(async n => {
          this.packResult = ''
          this.unpackResult = await benchmarkUnpack(10)
        })
        Button("解压缩 100").fontSize($r('app.float.page_text_font_size')).onClick(async n => {
          this.packResult = ''
          this.unpackResult = await benchmarkUnpack(100)
        })
        Button("解压缩 1000").fontSize($r('app.float.page_text_font_size')).onClick(async n => {
          this.packResult = ''
          this.unpackResult = await benchmarkUnpack(1000)
        })
        Button("解压缩 10000").fontSize($r('app.float.page_text_font_size')).onClick(async n => {
          this.packResult = ''
          this.unpackResult = await benchmarkUnpack(10000)
        })
        Button("解压缩 50000").fontSize($r('app.float.page_text_font_size')).onClick(async n => {
          this.packResult = ''
          this.unpackResult = await benchmarkUnpack(50000)
        })
      }
    }
  }
}
