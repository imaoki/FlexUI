/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
レイアウトの枠の設定を格納する構造体。
@remarks 作成パラメータ
:   ```maxscript
    ::FlexLayoutOptionsStruct marginH marginV paddingT paddingR paddingB paddingL
    ```

通知
:   | 通知名      | 通知データ         | タイミング             |
    | ----------- | ------------------ | ---------------------- |
    | `#MarginH`  | 新たな`marginH`値  | `marginH`を設定した後  |
    | `#MarginV`  | 新たな`marginV`値  | `marginV`を設定した後  |
    | `#PaddingB` | 新たな`paddingB`値 | `paddingB`を設定した後 |
    | `#PaddingL` | 新たな`paddingL`値 | `paddingL`を設定した後 |
    | `#PaddingR` | 新たな`paddingR`値 | `paddingR`を設定した後 |
    | `#PaddingT` | 新たな`paddingT`値 | `paddingT`を設定した後 |
*/
struct FlexLayoutOptionsStruct (
  /*- @prop <Integer> 作成パラメータ1。セル間の水平方向の余白。既定値は`0`。 */
  public _CP1_ = 0,
  /*- @prop <Integer> 作成パラメータ2。セル間の垂直方向の余白。既定値は`0`。 */
  public _CP2_ = 0,
  /*- @prop <Integer> 作成パラメータ6。レイアウト外周の上側の余白。既定値は`0`。 */
  public _CP3_ = 0,
  /*- @prop <Integer> 作成パラメータ5。レイアウト外周の右側の余白。既定値は`0`。 */
  public _CP4_ = 0,
  /*- @prop <Integer> 作成パラメータ3。レイアウト外周の下側の余白。既定値は`0`。 */
  public _CP5_ = 0,
  /*- @prop <Integer> 作成パラメータ4。レイアウト外周の左側の余白。既定値は`0`。 */
  public _CP6_ = 0,

  /*- @prop <Integer> セル間の水平方向の余白。既定値は`0`。 */
  private marginH = 0,
  /*- @prop <Integer> セル間の垂直方向の余白。既定値は`0`。 */
  private marginV = 0,
  /*- @prop <Integer> レイアウト外周の下側の余白。既定値は`0`。 */
  private paddingB = 0,
  /*- @prop <Integer> レイアウト外周の左側の余白。既定値は`0`。 */
  private paddingL = 0,
  /*- @prop <Integer> レイアウト外周の右側の余白。既定値は`0`。 */
  private paddingR = 0,
  /*- @prop <Integer> レイアウト外周の上側の余白。既定値は`0`。 */
  private paddingT = 0,

  /*
  public fn GetMarginH = (),
  public fn GetMarginV = (),
  public fn GetPaddingB = (),
  public fn GetPaddingL = (),
  public fn GetPaddingR = (),
  public fn GetPaddingT = (),
  public fn SetMargin inputH inputV = (),
  public fn SetMarginH input = (),
  public fn SetMarginV input = (),
  public fn SetPadding inputT inputR inputB inputL = (),
  public fn SetPaddingB input = (),
  public fn SetPaddingL input = (),
  public fn SetPaddingR input = (),
  public fn SetPaddingT input = (),
  */

  /*-
  セル間の水平方向の余白を取得する。
  @returns <Integer>
  */
  public fn GetMarginH = (
    this.marginH
  ),

  /*-
  セル間の垂直方向の余白を取得する。
  @returns <Integer>
  */
  public fn GetMarginV = (
    this.marginV
  ),

  /*-
  レイアウト外周の下側の余白を取得する。
  @returns <Integer>
  */
  public fn GetPaddingB = (
    this.paddingB
  ),

  /*-
  レイアウト外周の左側の余白を取得する。
  @returns <Integer>
  */
  public fn GetPaddingL = (
    this.paddingL
  ),

  /*-
  レイアウト外周の右側の余白を取得する。
  @returns <Integer>
  */
  public fn GetPaddingR = (
    this.paddingR
  ),

  /*-
  レイアウト外周の上側の余白を取得する。
  @returns <Integer>
  */
  public fn GetPaddingT = (
    this.paddingT
  ),

  /*-
  セル間の余白を一括設定する。
  @param inputH <Integer> 水平方向の余白。`0`以上の整数。
  @param inputV <Integer> 垂直方向の余白。`0`以上の整数。
  @returns <Array[<Integer>]>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetMargin inputH inputV = (
    #(
      this.SetMarginH inputH,
      this.SetMarginV inputV
    )
  ),

  /*-
  セル間の水平方向の余白を設定する。
  @param input <Integer> `0`以上の整数。
  @returns <Integer>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetMarginH input = (
    if superClassOf input == Number do (
      input = input as Integer
      if input < 0 do input = 0
      this.marginH = input
      this.StateChanged.Notify #MarginH this.marginH
    )
    this.GetMarginH()
  ),

  /*-
  セル間の垂直方向の余白を設定する。
  @param input <Integer> `0`以上の整数。
  @returns <Integer>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetMarginV input = (
    if superClassOf input == Number do (
      input = input as Integer
      if input < 0 do input = 0
      this.marginV = input
      this.StateChanged.Notify #MarginV this.marginV
    )
    this.GetMarginV()
  ),

  /*-
  レイアウト外周の余白を一括設定する。
  @param inputT <Integer> 上側の余白。`0`以上の整数。
  @param inputR <Integer> 右側の余白。`0`以上の整数。
  @param inputB <Integer> 下側の余白。`0`以上の整数。
  @param inputL <Integer> 左側の余白。`0`以上の整数。
  @returns <Array[<Integer>]>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetPadding inputT inputR inputB inputL = (
    #(
      this.SetPaddingT inputT,
      this.SetPaddingR inputR,
      this.SetPaddingB inputB,
      this.SetPaddingL inputL
    )
  ),

  /*-
  レイアウト外周の下側の余白を設定する。
  @param input <Integer> `0`以上の整数。
  @returns <Integer>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetPaddingB input = (
    if superClassOf input == Number do (
      input = input as Integer
      if input < 0 do input = 0
      this.paddingB = input
      this.StateChanged.Notify #PaddingB this.paddingB
    )
    this.GetPaddingB()
  ),

  /*-
  レイアウト外周の左側の余白を設定する。
  @param input <Integer> `0`以上の整数。
  @returns <Integer>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetPaddingL input = (
    if superClassOf input == Number do (
      input = input as Integer
      if input < 0 do input = 0
      this.paddingL = input
      this.StateChanged.Notify #PaddingL this.paddingL
    )
    this.GetPaddingL()
  ),

  /*-
  レイアウト外周の右側の余白を設定する。
  @param input <Integer> `0`以上の整数。
  @returns <Integer>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetPaddingR input = (
    if superClassOf input == Number do (
      input = input as Integer
      if input < 0 do input = 0
      this.paddingR = input
      this.StateChanged.Notify #PaddingR this.paddingR
    )
    this.GetPaddingR()
  ),

  /*-
  レイアウト外周の上側の余白を設定する。
  @param input <Integer> `0`以上の整数。
  @returns <Integer>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetPaddingT input = (
    if superClassOf input == Number do (
      input = input as Integer
      if input < 0 do input = 0
      this.paddingT = input
      this.StateChanged.Notify #PaddingT this.paddingT
    )
    this.GetPaddingT()
  ),

  /*- @returns <Name> */
  public fn StructName = #FlexLayoutOptionsStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%FlexLayoutOptionsStruct\n" indent to:out
    format "%  marginH:%\n" indent this.marginH to:out
    format "%  marginV:%\n" indent this.marginV to:out
    format "%  paddingB:%\n" indent this.paddingB to:out
    format "%  paddingL:%\n" indent this.paddingL to:out
    format "%  paddingR:%\n" indent this.paddingR to:out
    format "%  paddingT:%\n" indent this.paddingT to:out
    ok
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  @remarks 大文字と小文字を区別する。
  */
  public fn Equals obj = (
    local isEqualStructName = isStruct obj \
        and isProperty obj #StructName \
        and classOf obj.StructName == MAXScriptFunction \
        and obj.StructName() == this.StructName()

    local isEqualProperties = true

    isEqualStructName and isEqualProperties
  ),

  /*- @prop <Struct:ObservableStruct> */
  public StateChanged,

  on Create do (
    this.StateChanged = ::std.ObservableStruct()
    this.SetMargin this._CP1_ this._CP2_
    this.SetPadding this._CP3_ this._CP4_ this._CP5_ this._CP6_
  )
)
