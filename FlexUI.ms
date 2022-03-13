/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
fileIn @"definitionPool.ms"
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
  public fn CreateWidget control explicitW:undefined explicitH:undefined = (),
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
  @param explicitW: <Integer|UndefinedClass> キャプションを含まない明示的な幅。`0`以上の整数、または`undefined`。既定値は`undefined`。
  @param explicitH: <Integer|UndefinedClass> キャプションを含まない明示的な高さ。`0`以上の整数、または`undefined`。既定値は`undefined`。
  @returns <Struct|UndefinedClass>
  @remarks 不明なコントロールの場合は`undefined`を返す。
  */
  public fn CreateWidget control explicitW:undefined explicitH:undefined = (
    local widget = undefined
    local key = ("Flex" + (classOf control) as String + "Widget") as Name
    if hasDictValue this.widgetDefTable key do (
      widget = this.widgetDefTable[key] control
      widget.SetExplicitH explicitH
      widget.SetExplicitW explicitW
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
    this.layoutDefTable[#FlexGridLayout] = ::flexUIDefinitionPool[@"Model\Layout\FlexGridLayout.ms"]
    this.layoutDefTable[#FlexGroupLayout] = ::flexUIDefinitionPool[@"Model\Layout\FlexGroupLayout.ms"]
    this.layoutDefTable[#FlexHBoxLayout] = ::flexUIDefinitionPool[@"Model\Layout\FlexHBoxLayout.ms"]
    this.layoutDefTable[#FlexVBoxLayout] = ::flexUIDefinitionPool[@"Model\Layout\FlexVBoxLayout.ms"]

    -- local widgetFiles = ::std.FileUtility.GetFiles widgetDir "*Widget.ms" recursive:false
    -- for widgetFile in widgetFiles do (
    --   local key = (pathUtility.GetFileNameWithoutExtension widgetFile) as Name
    --   format "this.widgetDefTable[%] = fileIn @\"%\"\n" key widgetFile
    --   this.widgetDefTable[key] = fileIn widgetFile
    -- )
    this.widgetDefTable[#FlexAngleControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexAngleControlWidget.ms"]
    this.widgetDefTable[#FlexBitmapControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexBitmapControlWidget.ms"]
    this.widgetDefTable[#FlexButtonControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexButtonControlWidget.ms"]
    this.widgetDefTable[#FlexCheckBoxControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexCheckBoxControlWidget.ms"]
    this.widgetDefTable[#FlexCheckButtonControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexCheckButtonControlWidget.ms"]
    this.widgetDefTable[#FlexColorPickerControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexColorPickerControlWidget.ms"]
    this.widgetDefTable[#FlexComboBoxControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexComboBoxControlWidget.ms"]
    this.widgetDefTable[#FlexDotNetControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexDotNetControlWidget.ms"]
    this.widgetDefTable[#FlexEditTextControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexEditTextControlWidget.ms"]
    this.widgetDefTable[#FlexGroupBoxControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexGroupBoxControlWidget.ms"]
    this.widgetDefTable[#FlexImgTagWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexImgTagWidget.ms"]
    this.widgetDefTable[#FlexLabelControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexLabelControlWidget.ms"]
    this.widgetDefTable[#FlexLinkControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexLinkControlWidget.ms"]
    this.widgetDefTable[#FlexListBoxControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexListBoxControlWidget.ms"]
    this.widgetDefTable[#FlexMapButtonControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexMapButtonControlWidget.ms"]
    this.widgetDefTable[#FlexMaxCurveCtlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexMaxCurveCtlWidget.ms"]
    this.widgetDefTable[#FlexMtlButtonControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexMtlButtonControlWidget.ms"]
    this.widgetDefTable[#FlexMultiListBoxControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexMultiListBoxControlWidget.ms"]
    this.widgetDefTable[#FlexPickerControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexPickerControlWidget.ms"]
    this.widgetDefTable[#FlexProgressBarWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexProgressBarWidget.ms"]
    this.widgetDefTable[#FlexRadioControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexRadioControlWidget.ms"]
    this.widgetDefTable[#FlexSliderControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexSliderControlWidget.ms"]
    this.widgetDefTable[#FlexSpinnerControlWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexSpinnerControlWidget.ms"]
    this.widgetDefTable[#FlexSubRolloutWidget] = ::flexUIDefinitionPool[@"Model\Widget\FlexSubRolloutWidget.ms"]
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

  /*- @prop <String> バージョン番号。メジャー、マイナー、パッチの順。 */
  private version = "1.2.1",

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

  /*-
  @returns <String>
  */
  public fn GetVersion = (
    this.version
  ),

  on Create do (
    ::flexUI = this
    this.layoutOptionsDef = ::flexUIDefinitionPool[@"Model\Layout\FlexLayoutOptions.ms"]
    this.initialize()
  )
)
