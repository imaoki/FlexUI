/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*- @var <Struct:FlexUIStruct> */
global flexUI
/*-
ロールアウトコントロールをフレキシブルに配置するためのフレームワーク。
*/
struct FlexUIStruct (
  /*- @prop <Dictionary <Name> <StructDef>> レイアウト定義。既定値は`undefined`。 */
  private layoutDefTable,
  /*- @prop <StructDef:FlexLayoutOptionsStruct> */
  private layoutOptionsDef,
  /*- @prop <Dictionary <Name> <StructDef>> ウィジェット定義。既定値は`undefined`。 */
  private widgetDefTable,

  /*
  public fn CreateGridLayout options:undefined = (),
  public fn CreateGroupLayout groupBoxWidget = (),
  public fn CreateHBoxLayout options:undefined = (),
  public fn CreateLayoutOptions = (),
  public fn CreateVBoxLayout options:undefined = (),
  public fn CreateWidget control = (),

  private fn initialize = (),
  private fn isValidGroupBoxControlWidget obj = (),
  */

  /*-
  Gridレイアウトを作成する。
  @param options: <Struct:FlexLayoutOptionsStruct|UndefinedClass> レイアウトオプション。既定値は`undefined`。
  @returns <Struct:FlexGridLayoutStruct|UndefinedClass>
  */
  public fn CreateGridLayout options:undefined = (
    local layout = undefined
    local key = #FlexGridLayout
    if hasDictValue this.layoutDefTable key do (
      layout = this.layoutDefTable[key] options
    )
    layout
  ),

  /*-
  Groupレイアウトを作成する。
  @param groupBoxWidget <Struct:FlexGroupBoxControlWidgetStruct> `GroupBoxControl`ウィジェット。
  @returns <Struct:FlexGroupLayoutStruct|UndefinedClass>
  */
  public fn CreateGroupLayout groupBoxWidget = (
    local layout = undefined
    local key = #FlexGroupLayout
    if hasDictValue this.layoutDefTable key \
        and this.isValidGroupBoxControlWidget groupBoxWidget do (
      layout = this.layoutDefTable[key] groupBoxWidget
    )
    layout
  ),

  /*-
  HBoxレイアウトを作成する。
  @param options: <Struct:FlexLayoutOptionsStruct|UndefinedClass> レイアウトオプション。既定値は`undefined`。
  @returns <Struct:FlexHBoxLayoutStruct|UndefinedClass>
  */
  public fn CreateHBoxLayout options:undefined = (
    local layout = undefined
    local key = #FlexHBoxLayout
    if hasDictValue this.layoutDefTable key do (
      layout = this.layoutDefTable[key] options
    )
    layout
  ),

  /*-
  レイアウトオプションオブジェクトを作成する。
  @returns <Struct:FlexLayoutOptionsStruct>
  */
  public fn CreateLayoutOptions = (
    this.layoutOptionsDef()
  ),

  /*-
  VBoxレイアウトを作成する。
  @param options: <Struct:FlexLayoutOptionsStruct|UndefinedClass> レイアウトオプション。既定値は`undefined`。
  @returns <Struct:FlexVBoxLayoutStruct|UndefinedClass>
  */
  public fn CreateVBoxLayout options:undefined = (
    local layout = undefined
    local key = #FlexVBoxLayout
    if hasDictValue this.layoutDefTable key do (
      layout = this.layoutDefTable[key] options
    )
    layout
  ),

  /*-
  ウィジェットを作成する。
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
  private fn isValidGroupBoxControlWidget obj = (
    isStruct obj \
        and isProperty obj #StructName \
        and classOf obj.StructName == MAXScriptFunction \
        and obj.StructName() == #FlexGroupBoxControlWidgetStruct
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

  on Create do (
    this.layoutOptionsDef = fileIn @"Layout\FlexLayoutOptions.ms"
    this.initialize()
  )
)
