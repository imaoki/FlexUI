/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*- @var <Struct:FlexUIStruct> */
global flexUI
/*-
ロールアウトコントロールをフレキシブルに配置するためのフレームワーク。
*/
struct FlexUIStruct (
    /*- @prop <Struct:FlexLayoutOptionsStruct> 既定値は`undefined`。未指定の場合は既定値で作成される。 */
  public Options,

  /*- @prop <BooleanClass> グローバルレイアウトオプションを使用するかどうか。既定値は`true`。 */
  private useGlobalLayoutOptions = true,

  /*- @prop <Dictionary <Name> <StructDef>> レイアウト定義。既定値は`undefined`。 */
  private layoutDefTable,
  /*- @prop <Dictionary <Name> <StructDef>> ウィジェット定義。既定値は`undefined`。 */
  private widgetDefTable,

  /*
  public fn CreateLayout layoutName = (),
  public fn CreateWidget control = (),
  public fn GetUseGlobalLayoutOptions = (),
  public fn SetUseGlobalLayoutOptions input = (),

  private fn initialize = (),
  private fn isValidLayoutOptions obj = (),
  */

  /*-
  レイアウトオブジェクトを作成する。
  @param layoutName <Name|String> レイアウトの名前。

  | 値      | レイアウト                   |
  | ------- | ---------------------------- |
  | `#Grid` | グリッドにアイテムを配置する |
  | `#HBox` | 水平方向にアイテムを配置する |
  | `#VBox` | 垂直方向にアイテムを配置する |
  @returns <Struct|UndefinedClass>
  @remarks 不明な名前の場合は`undefined`を返す。
  */
  public fn CreateLayout layoutName = (
    local layout = undefined
    local key = ("Flex" + layoutName as String + "Layout") as Name
    if hasDictValue this.layoutDefTable key do (
      if this.useGlobalLayoutOptions then (
        layout = this.layoutDefTable[key] this.Options
      )
      else (
        layout = this.layoutDefTable[key]()
      )
    )
    layout
  ),

  /*-
  ウィジェットオブジェクトを作成する。
  @param control <RolloutControl> ロールアウトコントロール。
  @returns <Struct|UndefinedClass>
  @remarks 不明なコントロールの場合は`undefined`を返す。
  */
  public fn CreateWidget control = (
    local widget = undefined
    local key = ("Flex" + (classOf control) as String + "Widget") as Name
    if hasDictValue this.widgetDefTable key do (
      widget = this.widgetDefTable[key] control
    )
    widget
  ),

  /*-
  グローバルレイアウトオプションを使用するかどうかを取得する。
  @returns <BooleanClass>
  */
  public fn GetUseGlobalLayoutOptions = (
    this.useGlobalLayoutOptions
  ),

  /*-
  グローバルレイアウトオプションを使用するかどうかを設定する。
  @param input <BooleanClass>
  @returns <BooleanClass>
  */
  public fn SetUseGlobalLayoutOptions input = (
    if classOf input == BooleanClass do (
      this.useGlobalLayoutOptions = input
      this.notify #(#UseGlobalLayoutOptions)
    )
    this.GetUseGlobalLayoutOptions()
  ),

  /*-
  内部状態を初期化する。
  @returns <OkClass>
  */
  private fn initialize = (
    this.layoutDefTable = Dictionary #Name
    this.widgetDefTable = Dictionary #Name
    local pathUtility = ::PathUtilityStruct (getSourceFileName())

    local layoutDir = pathUtility.GetFullPath @".\Layout"
    local layoutFiles = ::fileUtility.GetFiles layoutDir "*Layout.ms" recursive:false
    for layoutFile in layoutFiles do (
      local key = (pathUtility.GetFileNameWithoutExtension layoutFile) as Name
      this.layoutDefTable[key] = fileIn layoutFile
    )

    local widgetDir = pathUtility.GetFullPath @".\Widget"
    local widgetFiles = ::fileUtility.GetFiles widgetDir "*Widget.ms" recursive:false
    for widgetFile in widgetFiles do (
      local key = (pathUtility.GetFileNameWithoutExtension widgetFile) as Name
      this.widgetDefTable[key] = fileIn widgetFile
    )
    ok
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isValidLayoutOptions obj = (
    isStruct obj \
        and isProperty obj #StructName \
        and classOf obj.StructName == MAXScriptFunction \
        and obj.StructName() == #FlexLayoutOptionsStruct
  ),

  /*- @returns <Name> */
  public fn StructName = #FlexUIStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%FlexUIStruct\n" indent to:out
    format "%  Options:\n" indent to:out
    this.Options.Dump indent:(indent + "    ") out:out
    format "%  useGlobalLayoutOptions:%\n" indent this.useGlobalLayoutOptions to:out
    format "%  layoutDefTable:%\n" indent this.layoutDefTable.Count to:out
    for key in this.layoutDefTable.Keys do (
      format "%    [%]:%\n" indent key (classOf this.layoutDefTable[key]) to:out
    )
    format "%  widgetDefTable:%\n" indent this.widgetDefTable.Count to:out
    for key in this.widgetDefTable.Keys do (
      format "%    [%]:%\n" indent key (classOf this.widgetDefTable[key]) to:out
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

    local isEqualProperties = true

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
    if not this.isValidLayoutOptions this.Options do (
      this.Options = (fileIn @"Layout\FlexLayoutOptions.ms")()
    )
    this.initialize()
  )
)
