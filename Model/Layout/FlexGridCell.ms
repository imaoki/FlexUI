/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
グリッドレイアウトのセル情報を格納する構造体。
@remarks インスタンス作成時のパラメータ指定順は以下の通り。

```maxscript
::FlexGridCellStruct item row column rowSpan columnSpan
```

通知
:   | 通知名        | 通知データ           | タイミング               |
    | ------------- | -------------------- | ------------------------ |
    | `#Column`     | 新たな`column`値     | `column`を設定した後     |
    | `#ColumnSpan` | 新たな`columnSpan`値 | `columnSpan`を設定した後 |
    | `#Item`       | 新たな`item`値       | `item`を設定した後       |
    | `#Row`        | 新たな`row`値        | `row`を設定した後        |
    | `#RowSpan`    | 新たな`rowSpan`値    | `rowSpan`を設定した後    |
*/
struct FlexGridCellStruct (
  /*- @prop <Struct> 作成パラメータ1。セルのアイテム。既定値は`undefined`。 */
  public _CP1_,
  /*- @prop <Integer> 作成パラメータ2。セルを配置する行。既定値は`1`。 */
  public _CP2_ = 1,
  /*- @prop <Integer> 作成パラメータ3。セルを配置する列。既定値は`1`。 */
  public _CP3_ = 1,
  /*- @prop <Integer> 作成パラメータ4。セルが専有する行数。既定値は`1`。 */
  public _CP4_ = 1,
  /*- @prop <Integer> 作成パラメータ5。セルが専有する列数。既定値は`1`。 */
  public _CP5_ = 1,

  /*- @prop <Integer> セルを配置する列。既定値は`1`。 */
  private column = 1,
  /*- @prop <Integer> セルが専有する列数。既定値は`1`。 */
  private columnSpan = 1,
  /*- @prop <Struct> セルのアイテム。既定値は`undefined`。 */
  private item,
  /*- @prop <Integer> セルを配置する行。既定値は`1`。 */
  private row = 1,
  /*- @prop <Integer> セルが専有する行数。既定値は`1`。 */
  private rowSpan = 1,

  /*
  public fn GetColumn = (),
  public fn GetColumnSpan = (),
  public fn GetItem = (),
  public fn GetRow = (),
  public fn GetRowSpan = (),
  public fn GetType = (),
  public fn SetColumn input = (),
  public fn SetColumnSpan input = (),
  public fn SetItem obj = (),
  public fn SetRow input = (),
  public fn SetRowSpan input = (),

  private fn isMatchStructName obj pattern = (),
  private fn isValidLayout obj = (),
  private fn isValidWidget obj = (),
  private fn typeOf obj = (),
  */

  /*-
  セルを配置する列を取得する。
  @returns <Integer>
  */
  public fn GetColumn = (
    this.column
  ),

  /*-
  セルが専有する列数を取得する。
  @returns <Integer>
  */
  public fn GetColumnSpan = (
    this.columnSpan
  ),

  /*-
  セルのアイテムを取得する。
  @returns <Struct>
  */
  public fn GetItem = (
    this.item
  ),

  /*-
  セルを配置する行を取得する。
  @returns <Integer>
  */
  public fn GetRow = (
    this.row
  ),

  /*-
  セルが専有する行数を取得する。
  @returns <Integer>
  */
  public fn GetRowSpan = (
    this.rowSpan
  ),

  /*-
  セルの種類を取得する。
  @returns <Name|UndefinedClass>
  | 値        | 種類         |
  | --------- | ------------ |
  | `#Layout` | レイアウト   |
  | `#Widget` | ウィジェット |
  @remarks 不明の場合は`undefined`を返す。
  */
  public fn GetType = (
    this.typeOf this.item
  ),

  /*-
  セルを配置する列を設定する。
  @param input <Integer> `1`以上の整数。
  @returns <Integer>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetColumn input = (
    if superClassOf input == Number do (
      input = input as Integer
      if input < 1 do input = 1
      this.column = input
      this.StateChanged.Notify #Column this.column
    )
    this.GetColumn()
  ),

  /*-
  セルが専有する列数を設定する。
  @param input <Integer> `1`以上の整数。
  @returns <Integer>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetColumnSpan input = (
    if superClassOf input == Number do (
      input = input as Integer
      if input < 1 do input = 1
      this.columnSpan = input
      this.StateChanged.Notify #ColumnSpan this.columnSpan
    )
    this.GetColumnSpan()
  ),

  /*-
  セルのアイテムを設定する。
  @param obj <Struct>
  @returns <Struct>
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
  セルを配置する行を設定する。
  @param input <Integer> `1`以上の整数。
  @returns <Integer>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetRow input = (
    if superClassOf input == Number do (
      input = input as Integer
      if input < 1 do input = 1
      this.row = input
      this.StateChanged.Notify #Row this.row
    )
    this.GetRow()
  ),

  /*-
  セルが専有する行数を設定する。
  @param input <Integer> `1`以上の整数。
  @returns <Integer>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetRowSpan input = (
    if superClassOf input == Number do (
      input = input as Integer
      if input < 1 do input = 1
      this.rowSpan = input
      this.StateChanged.Notify #RowSpan this.rowSpan
    )
    this.GetRowSpan()
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
      (this.isValidWidget obj): #Widget
      default: undefined
    )
  ),

  /*- @returns <Name> */
  public fn StructName = #FlexGridCellStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%FlexGridCellStruct\n" indent to:out
    format "%  type:%\n" indent (this.GetType()) to:out
    format "%  column:%\n" indent this.column to:out
    format "%  columnSpan:%\n" indent this.columnSpan to:out
    format "%  row:%\n" indent this.row to:out
    format "%  rowSpan:%\n" indent this.rowSpan to:out
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
        and isProperty obj #GetColumn \
        and classOf obj.GetColumn == MAXScriptFunction \
        and obj.GetColumn() == this.GetColumn() \
        and isProperty obj #GetColumnSpan \
        and classOf obj.GetColumnSpan == MAXScriptFunction \
        and obj.GetColumnSpan() == this.GetColumnSpan() \
        and isProperty obj #GetItem \
        and classOf obj.GetItem == MAXScriptFunction \
        and isProperty obj #GetRow \
        and classOf obj.GetRow == MAXScriptFunction \
        and obj.GetRow() == this.GetRow() \
        and isProperty obj #GetRowSpan \
        and classOf obj.GetRowSpan == MAXScriptFunction \
        and obj.GetRowSpan() == this.GetRowSpan() \
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
    this.SetRow this._CP2_
    this.SetColumn this._CP3_
    this.SetRowSpan this._CP4_
    this.SetColumnSpan this._CP5_
  )
)
