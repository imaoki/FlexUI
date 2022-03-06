/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
ボックスレイアウトのセル情報を格納する構造体。
@remarks インスタンス作成時のパラメータ指定順は以下の通り。

```maxscript
::FlexBoxCellStruct item stretch minimum
```
*/
struct FlexBoxCellStruct (
  /*- @prop <Struct|Integer> 作成パラメータ1。セルのアイテム。既定値は`undefined`。 */
  public _CP1_,
  /*- @prop <Integer> 作成パラメータ2。セルのストレッチ係数。既定値は`1`。 */
  public _CP2_ = 1,
  /*- @prop <Integer> 作成パラメータ3。セルの最小値。既定値は`1`。 */
  public _CP3_ = 1,

  /*- @prop <Struct|Integer> セルのアイテム。既定値は`undefined`。 */
  private item,
  /*- @prop <Integer> セルの最小値。既定値は`1`。 */
  private minimum = 1,
  /*- @prop <Integer> セルのストレッチ係数。既定値は`1`。 */
  private stretch = 1,

  /*
  public fn GetItem = (),
  public fn GetMinimum = (),
  public fn GetStretch = (),
  public fn GetType = (),
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
  セルのアイテムを設定する。
  @param obj <Struct|Integer>
  @returns <Struct|Integer>
  @remarks 無効な値を指定した場合は何もしない。
  */
  public fn SetItem obj = (
    local itemType = this.typeOf obj
    if classOf itemType == Name do (
      this.item = obj
      this.notify #(#Item)
    )
    this.GetItem()
  ),

  /*-
  セルの最小値を設定する。
  @param input <Integer> `1`以上の整数。
  @returns <Integer>
  @remarks 無効な値を指定した場合は何もしない。
  */
  public fn SetMinimum input = (
    if superClassOf input == Number do (
      input = input as Integer
      if input < 1 do input = 1
      this.minimum = input
      this.notify #(#Minimum)
    )
    this.GetMinimum()
  ),

  /*-
  セルのストレッチ係数を設定する。
  @param input <Integer> `1`以上の整数。
  @returns <Integer>
  @remarks 無効な値を指定した場合は何もしない。
  */
  public fn SetStretch input = (
    if superClassOf input == Number do (
      input = input as Integer
      if input < 1 do input = 1
      this.stretch = input
      this.notify #(#Stretch)
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

  /*- @prop <Array[<Struct:ObserverStruct>]> */
  private observers = #(),

  /*-
  @param observer <Struct:ObserverStruct>
  @returns <BooleanClass> 成功した場合は`true`、失敗した場合は`false`。
  */
  public fn AddObserver observer = (
    if this.findObserver observer == 0 do (
      append this.observers observer
    )
    this.findObserver observer > 0
  ),

  /*-
  @param observer <Struct:ObserverStruct>
  @returns <BooleanClass> 成功した場合は`true`、失敗した場合は`false`。
  */
  public fn RemoveObserver observer = (
    local index = this.findObserver observer
    if index > 0 do (
      deleteItem this.observers index
    )
    this.findObserver observer == 0
  ),

  /*-
  @param observer <Struct:ObserverStruct>
  @returns <Integer>
  */
  private fn findObserver observer = (
    local index = 0
    for i = 1 to this.observers.Count while index == 0 do (
      if this.observers[i].Equals observer do (
        index = i
      )
    )
    index
  ),

  /*-
  @param params <Array[<Name>]|Any>
  @param type: <Name>
  @returns <OkClass>
  */
  private fn notify params type: = (
    for observer in this.observers do (
      observer.Callback observer.Context params type:type
    )
    ok
  ),

  on Create do (
    this.SetItem this._CP1_
    this.SetStretch this._CP2_
    this.SetMinimum this._CP3_
  )
)
