/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
ボックスレイアウトのセル情報を格納する構造体。
@remarks 作成パラメータ
:   ```maxscript
    ::FlexBoxCellStruct item stretch minimum fixedLength
    ```

通知
:   | 通知名         | 通知データ            | タイミング                |
    | -------------- | --------------------- | ------------------------- |
    | `#FixedLength` | 新たな`fixedLength`値 | `fixedLength`を設定した後 |
    | `#Item`        | 新たな`item`値        | `item`を設定した後        |
    | `#Minimum`     | 新たな`minimum`値     | `minimum`を設定した後     |
    | `#Stretch`     | 新たな`stretch`値     | `stretch`を設定した後     |
*/
struct FlexBoxCellStruct (
  /*- @prop <Struct|Integer> 作成パラメータ1。セルのアイテム。既定値は`undefined`。 */
  public _CP1_,
  /*- @prop <Integer> 作成パラメータ2。セルのストレッチ係数。既定値は`1`。 */
  public _CP2_ = 1,
  /*- @prop <Integer> 作成パラメータ3。セルの最小値。既定値は`1`。 */
  public _CP3_ = 1,
  /*- @prop <Integer|UndefinedClass> 作成パラメータ4。セルの固定長。既定値は`undefined`。 */
  public _CP4_,

  /*- @prop <Integer|UndefinedClass> セルの固定長。既定値は`undefined`。 */
  private fixedLength,
  /*- @prop <Struct|Integer> セルのアイテム。既定値は`undefined`。 */
  private item,
  /*- @prop <Integer> セルの最小値。既定値は`1`。 */
  private minimum = 1,
  /*- @prop <Integer> セルのストレッチ係数。既定値は`1`。 */
  private stretch = 1,

  /*
  public fn GetFixedLength = (),
  public fn GetItem = (),
  public fn GetMinimum = (),
  public fn GetStretch = (),
  public fn GetType = (),
  public fn SetFixedLength input = (),
  public fn SetItem obj = (),
  public fn SetMinimum input = (),
  public fn SetStretch input = (),

  private fn isMatchStructName obj pattern = (),
  private fn isValidLayout obj = (),
  private fn isValidSpace obj = (),
  private fn isValidStretch obj = (),
  private fn isValidWidget obj = (),
  private fn typeOf obj = (),
  */

  /*-
  セルの固定長を取得する。
  @returns <Integer|UndefinedClass>
  */
  public fn GetFixedLength = (
    this.fixedLength
  ),

  /*-
  セルのアイテムを取得する。
  @returns <Struct|Integer>
  */
  public fn GetItem = (
    this.item
  ),

  /*-
  セルの最小値を取得する。
  @returns <Integer>
  */
  public fn GetMinimum = (
    this.minimum
  ),

  /*-
  セルのストレッチ係数を取得する。
  @returns <Integer>
  */
  public fn GetStretch = (
    this.stretch
  ),

  /*-
  セルの種類を取得する。
  @returns <Name|UndefinedClass>
  | 値         | 種類         |
  | ---------- | ------------ |
  | `#Layout`  | レイアウト   |
  | `#Space`   | スペース     |
  | `#Stretch` | ストレッチ   |
  | `#Widget`  | ウィジェット |
  @remarks 不明の場合は`undefined`を返す。
  */
  public fn GetType = (
    this.typeOf this.item
  ),

  /*-
  セルの固定長を設定する。
  @param input <Integer|UndefinedClass> `1`以上の整数、または`undefined`。
  @returns <Integer|UndefinedClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetFixedLength input = (
    if classOf input == UndefinedClass then (
      this.fixedLength = input
      this.StateChanged.Notify #FixedLength this.fixedLength
    )
    else (
      if superClassOf input == Number do (
        input = input as Integer
        if input < 1 do input = 1
        this.fixedLength = input
        this.StateChanged.Notify #FixedLength this.fixedLength
      )
    )
    this.GetFixedLength()
  ),

  /*-
  セルのアイテムを設定する。
  @param obj <Struct|Integer>
  @returns <Struct|Integer>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetItem obj = (
    local itemType = this.typeOf obj
    if classOf itemType == Name do (
      this.item = obj
      this.StateChanged.Notify #Item this.item
    )
    this.GetItem()
  ),

  /*-
  セルの最小値を設定する。
  @param input <Integer> `1`以上の整数。
  @returns <Integer>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetMinimum input = (
    if superClassOf input == Number do (
      input = input as Integer
      if input < 1 do input = 1
      this.minimum = input
      this.StateChanged.Notify #Minimum this.minimum
    )
    this.GetMinimum()
  ),

  /*-
  セルのストレッチ係数を設定する。
  @param input <Integer> `1`以上の整数。
  @returns <Integer>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetStretch input = (
    if superClassOf input == Number do (
      input = input as Integer
      if input < 1 do input = 1
      this.stretch = input
      this.StateChanged.Notify #Stretch this.stretch
    )
    this.GetStretch()
  ),

  /*-
  構造体名が指定したパターンに一致するかどうかを判定する。
  @param obj <Any>
  @param pattern <String>
  @returns <BooleanClass>
  */
  private fn isMatchStructName obj pattern = (
    isProperty obj #StructName \
        and classOf obj.StructName == MAXScriptFunction \
        and matchPattern (obj.StructName() as String) pattern:pattern
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isValidLayout obj = (
    isStruct obj and this.isMatchStructName obj "Flex*LayoutStruct"
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isValidSpace obj = (
    classOf obj == Integer and obj > 0
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isValidStretch obj = (
    classOf obj == Integer and obj == -1
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isValidWidget obj = (
    isStruct obj and this.isMatchStructName obj "Flex*WidgetStruct"
  ),

  /*-
  オブジェクトの種類を取得する。
  @param obj <Any>
  @returns <Name|UndefinedClass>
  @remarks 不明な値の場合は`undefined`を返す。
  */
  private fn typeOf obj = (
    case of (
      (this.isValidLayout obj): #Layout
      (this.isValidSpace obj): #Space
      (this.isValidStretch obj): #Stretch
      (this.isValidWidget obj): #Widget
      default: undefined
    )
  ),

  /*- @returns <Name> */
  public fn StructName = #FlexBoxCellStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%FlexBoxCellStruct\n" indent to:out
    format "%  type:%\n" indent (this.GetType()) to:out
    format "%  fixedLength:%\n" indent this.fixedLength to:out
    format "%  minimum:%\n" indent this.minimum to:out
    format "%  stretch:%\n" indent this.stretch to:out
    if this.isValidLayout this.item or this.isValidWidget this.item then (
      format "%  item:\n" indent to:out
      this.item.Dump indent:(indent + "    ") out:out
    )
    else (
      format "%  item:%\n" indent this.item to:out
    )
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

    local isEqualProperties = true \
        and isProperty obj #GetFixedLength \
        and classOf obj.GetFixedLength == MAXScriptFunction \
        and obj.GetFixedLength() == this.GetFixedLength() \
        and isProperty obj #GetItem \
        and classOf obj.GetItem == MAXScriptFunction \
        and isProperty obj #GetMinimum \
        and classOf obj.GetMinimum == MAXScriptFunction \
        and obj.GetMinimum() == this.GetMinimum() \
        and isProperty obj #GetStretch \
        and classOf obj.GetStretch == MAXScriptFunction \
        and obj.GetStretch() == this.GetStretch() \
        and isProperty obj #GetType \
        and classOf obj.GetType == MAXScriptFunction \
        and obj.GetType() == this.GetType()

    if isEqualProperties do (
      local ov = obj.GetItem()
      local tv = this.GetItem()
      if (this.isValidLayout ov or this.isValidWidget ov) \
          and (this.isValidLayout tv or this.isValidWidget tv) then (
        isEqualProperties = tv.Equals ov
      )
      else (
        isEqualProperties = ov == tv
      )
    )

    isEqualStructName and isEqualProperties
  ),

  /*- @prop <Struct:ObservableStruct> */
  public StateChanged,

  on Create do (
    this.StateChanged = ::std.ObservableStruct()
    this.SetItem this._CP1_
    this.SetStretch this._CP2_
    this.SetMinimum this._CP3_
    this.SetFixedLength this._CP4_
  )
)
