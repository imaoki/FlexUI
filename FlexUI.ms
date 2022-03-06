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
  public fn Install = (),
  public fn Uninstall = (),

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
  インストールする。
  @returns <OkClass>
  @remarks 静的メソッド。
  */
  public fn Install = (
    ::FlexUIStruct()
    if isProperty ::startupLoader #RegisterFile do (
      ::startupLoader.RegisterFile (getSourceFileName()) installer:true
    )
    format "[install]::flexUI\n"
    ok
  ),

  /*-
  アンインストールする。
  @returns <OkClass>
  @remarks 静的メソッド。
  */
  public fn Uninstall = (
    if isProperty ::startupLoader #UnregisterFile do (
      ::startupLoader.UnregisterFile (getSourceFileName())
    )
    ::flexUI = undefined
    format "[uninstall]::flexUI\n"
    ok
  ),

  /*-
  内部状態を初期化する。
  @returns <OkClass>
  */
  private fn initialize = (
    this.layoutDefTable = Dictionary #Name
    this.widgetDefTable = Dictionary #Name

    -- local pathUtility = ::std.PathUtilityStruct (getSourceFileName())
    -- local layoutDir = pathUtility.GetFullPath @".\Model\Layout"
    -- local widgetDir = pathUtility.GetFullPath @".\Model\Widget"

    -- local layoutFiles = ::std.FileUtility.GetFiles layoutDir "*Layout.ms" recursive:false
    -- for layoutFile in layoutFiles do (
    --   local key = (pathUtility.GetFileNameWithoutExtension layoutFile) as Name
    --   format "this.layoutDefTable[%] = fileIn @\"%\"\n" key layoutFile
    --   this.layoutDefTable[key] = fileIn layoutFile
    -- )
    this.layoutDefTable[#FlexGridLayout] = fileIn @"Model\Layout\FlexGridLayout.ms"
    this.layoutDefTable[#FlexGroupLayout] = fileIn @"Model\Layout\FlexGroupLayout.ms"
    this.layoutDefTable[#FlexHBoxLayout] = fileIn @"Model\Layout\FlexHBoxLayout.ms"
    this.layoutDefTable[#FlexVBoxLayout] = fileIn @"Model\Layout\FlexVBoxLayout.ms"

    -- local widgetFiles = ::std.FileUtility.GetFiles widgetDir "*Widget.ms" recursive:false
    -- for widgetFile in widgetFiles do (
    --   local key = (pathUtility.GetFileNameWithoutExtension widgetFile) as Name
    --   format "this.widgetDefTable[%] = fileIn @\"%\"\n" key widgetFile
    --   this.widgetDefTable[key] = fileIn widgetFile
    -- )
    this.widgetDefTable[#FlexAngleControlWidget] = fileIn @"Model\Widget\FlexAngleControlWidget.ms"
    this.widgetDefTable[#FlexBitmapControlWidget] = fileIn @"Model\Widget\FlexBitmapControlWidget.ms"
    this.widgetDefTable[#FlexButtonControlWidget] = fileIn @"Model\Widget\FlexButtonControlWidget.ms"
    this.widgetDefTable[#FlexCheckBoxControlWidget] = fileIn @"Model\Widget\FlexCheckBoxControlWidget.ms"
    this.widgetDefTable[#FlexCheckButtonControlWidget] = fileIn @"Model\Widget\FlexCheckButtonControlWidget.ms"
    this.widgetDefTable[#FlexColorPickerControlWidget] = fileIn @"Model\Widget\FlexColorPickerControlWidget.ms"
    this.widgetDefTable[#FlexComboBoxControlWidget] = fileIn @"Model\Widget\FlexComboBoxControlWidget.ms"
    this.widgetDefTable[#FlexDotNetControlWidget] = fileIn @"Model\Widget\FlexDotNetControlWidget.ms"
    this.widgetDefTable[#FlexEditTextControlWidget] = fileIn @"Model\Widget\FlexEditTextControlWidget.ms"
    this.widgetDefTable[#FlexGroupBoxControlWidget] = fileIn @"Model\Widget\FlexGroupBoxControlWidget.ms"
    this.widgetDefTable[#FlexImgTagWidget] = fileIn @"Model\Widget\FlexImgTagWidget.ms"
    this.widgetDefTable[#FlexLabelControlWidget] = fileIn @"Model\Widget\FlexLabelControlWidget.ms"
    this.widgetDefTable[#FlexLinkControlWidget] = fileIn @"Model\Widget\FlexLinkControlWidget.ms"
    this.widgetDefTable[#FlexListBoxControlWidget] = fileIn @"Model\Widget\FlexListBoxControlWidget.ms"
    this.widgetDefTable[#FlexMapButtonControlWidget] = fileIn @"Model\Widget\FlexMapButtonControlWidget.ms"
    this.widgetDefTable[#FlexMaxCurveCtlWidget] = fileIn @"Model\Widget\FlexMaxCurveCtlWidget.ms"
    this.widgetDefTable[#FlexMtlButtonControlWidget] = fileIn @"Model\Widget\FlexMtlButtonControlWidget.ms"
    this.widgetDefTable[#FlexMultiListBoxControlWidget] = fileIn @"Model\Widget\FlexMultiListBoxControlWidget.ms"
    this.widgetDefTable[#FlexPickerControlWidget] = fileIn @"Model\Widget\FlexPickerControlWidget.ms"
    this.widgetDefTable[#FlexProgressBarWidget] = fileIn @"Model\Widget\FlexProgressBarWidget.ms"
    this.widgetDefTable[#FlexRadioControlWidget] = fileIn @"Model\Widget\FlexRadioControlWidget.ms"
    this.widgetDefTable[#FlexSliderControlWidget] = fileIn @"Model\Widget\FlexSliderControlWidget.ms"
    this.widgetDefTable[#FlexSpinnerControlWidget] = fileIn @"Model\Widget\FlexSpinnerControlWidget.ms"
    this.widgetDefTable[#FlexSubRolloutWidget] = fileIn @"Model\Widget\FlexSubRolloutWidget.ms"
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
    ::flexUI = this
    this.layoutOptionsDef = fileIn @"Model\Layout\FlexLayoutOptions.ms"
    this.initialize()
  )
)
