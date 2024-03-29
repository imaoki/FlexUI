/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
登録されたアイテムの内一つのみを表示する。

通知
:   | 通知名               | 通知データ                   | タイミング                         |
    | -------------------- | ---------------------------- | ---------------------------------- |
    | `#CurrentIndex`      | 新たな`currentIndex`値       | `currentIndex`を設定した後         |
    | `#LayoutAdded`       | 追加したセル                 | レイアウトを追加した後             |
    | `#RectUpdated`       | 各セルの矩形                 | レイアウトの矩形を設定した後       |
    | `#VisibilityChanged` | 新たなセルのアイテムの可視性 | セルのアイテムの可視性を設定した後 |
    | `#WidgetAdded`       | 追加したセル                 | ウィジェットを追加した後           |
*/
struct FlexStackedLayoutStruct (
  /*- @prop <Struct:FlexLayoutOptionsStruct> 既定値は`undefined`。未指定の場合は既定値で作成される。 */
  public Options,

  /*- @prop <Array[<Struct:FlexBoxCellStruct>]> セルのアイテム。既定値は`#()`。 */
  private cells = #(),
  /*- @prop <Integer> 現在表示されているアイテムのインデックス。既定値は`0`。 */
  private currentIndex = 0,
  /*- @prop <BooleanClass> レイアウトの可視性。既定値は`true`。 */
  private visibility = true,

  /*- @prop <StructDef:FlexBoxCellStruct> */
  private boxCellDef,

  /*
  public fn AddLayout layout index: = (),
  public fn AddWidget widget index: = (),
  public fn GetCells = (),
  public fn GetCurrentIndex = (),
  public fn GetVisibility = (),
  public fn SetCurrentIndex index = (),
  public fn SetRect rect = (),
  public fn SetVisibility input = (),

  private fn addCell cell index = (),
  private fn findWidget widget = (),
  private fn isMatchStructName obj pattern = (),
  private fn isValidLayoutOptions obj = (),
  private fn isValidWidget obj = (),
  private fn updateCellVisibility = (),
  */

  /*-
  レイアウトを追加する。
  @param layout <Struct>
  @param index: <Integer> 挿入先インデックス。既定値は`unsupplied`。
  @returns <Struct:FlexBoxCellStruct|UndefinedClass>
  @remarks 無効な値の場合は`undefined`を返す。
  */
  public fn AddLayout layout index: = (
    local cell = this.boxCellDef layout
    if cell.GetType() == #Layout and layout != this then (
      this.addCell cell index
      this.StateChanged.Notify #LayoutAdded cell
    )
    else (
      cell = undefined
    )
    cell
  ),

  /*-
  ウィジェットを追加する。
  @param widget <Struct>
  @param index: <Integer> 挿入先インデックス。既定値は`unsupplied`。
  @returns <Struct:FlexBoxCellStruct|UndefinedClass>
  @remarks 無効な値の場合は`undefined`を返す。
  ウィジェットの重複登録は出来ない。
  */
  public fn AddWidget widget index: = (
    local cell = this.boxCellDef widget
    if cell.GetType() == #Widget and this.findWidget widget == 0 then (
      this.addCell cell index
      this.StateChanged.Notify #WidgetAdded cell
    )
    else (
      cell = undefined
    )
    cell
  ),

  /*-
  セルのアイテムを取得する。
  @returns <Array[<Struct:FlexBoxCellStruct>]>
  */
  public fn GetCells = (
    this.cells
  ),

  /*-
  現在表示されているアイテムのインデックスを取得する。
  @returns <Integer>
  */
  public fn GetCurrentIndex = (
    this.currentIndex
  ),

  /*-
  レイアウトの可視性を取得する。
  @returns <BooleanClass>
  */
  public fn GetVisibility = (
    this.visibility
  ),

  /*-
  現在表示されているアイテムのインデックスを設定する。
  @param index <Integer> `0`以上の整数。
  @returns <Integer>
  */
  public fn SetCurrentIndex index = (
    if classOf index == Integer and 0 <= index and index <= this.cells.Count do (
      this.currentIndex = index
      this.updateCellVisibility()
      this.StateChanged.Notify #CurrentIndex this.currentIndex
    )
    this.GetCurrentIndex()
  ),

  /*-
  レイアウトの矩形を設定する。
  @param rect <Box2>
  @returns <Array[<Box2>]>
  @remarks 一貫性のため戻り値は配列で返す。
  */
  public fn SetRect rect = (
    local cellCount = this.cells.Count
    local paddingB = this.Options.GetPaddingB()
    local paddingL = this.Options.GetPaddingL()
    local paddingR = this.Options.GetPaddingR()
    local paddingT = this.Options.GetPaddingT()
    local cellX = rect.X + paddingL
    local cellY = rect.Y + paddingT
    local cellW = rect.W - paddingL - paddingR
    local cellH = rect.H - paddingT - paddingB
    if cellW < 1 do cellW = 1
    if cellH < 1 do cellH = 1
    local cellRect = Box2 cellX cellY cellW cellH
    local cellRects = for i = 1 to cellCount collect (
      local cell = this.cells[i]
      local cellItem = cell.GetItem()
      local cellType = cell.GetType()
      if cellType == #Layout or cellType == #Widget do (
        cellItem.SetRect cellRect
      )
      cellRect
    )
    this.StateChanged.Notify #RectUpdated cellRects
    cellRects
  ),

  /*-
  セルのアイテムの可視性を設定する。
  @param input <BooleanClass>
  @returns <BooleanClass|UndefinedClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetVisibility input = (
    if classOf input == BooleanClass do (
      this.visibility = input
      this.updateCellVisibility()
      this.StateChanged.Notify #VisibilityChanged undefined
    )
    this.GetVisibility()
  ),

  /*-
  @param cell <Struct:FlexBoxCellStruct>
  @param index <Integer|UnsuppliedClass>
  @returns <Integer> 追加後のセルのインデックス。
  */
  private fn addCell cell index = (
    if classOf index == Integer \
        and 1 <= index and index <= this.cells.Count then (
      insertItem cell this.cells index
    )
    else (
      append this.cells cell
      index = this.cells.Count
    )
    this.updateCellVisibility()
    index
  ),

  /*-
  @param widget <Struct>
  @returns <Integer>
  */
  private fn findWidget widget = (
    local index = 0
    for i = 1 to this.cells.Count while index == 0 do (
      if this.cells[i].GetType() == #Widget do (
        local cellItem = this.cells[i].GetItem()
        if this.isValidWidget cellItem and cellItem.Equals widget do (
          index = 1
        )
      )
    )
    index
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
  private fn isValidLayoutOptions obj = (
    isStruct obj \
        and isProperty obj #StructName \
        and classOf obj.StructName == MAXScriptFunction \
        and obj.StructName() == #FlexLayoutOptionsStruct
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isValidWidget obj = (
    isStruct obj and this.isMatchStructName obj "Flex*WidgetStruct"
  ),

  /*-
  セルのアイテムの可視性を更新する。
  @returns <OkClass>
  */
  private fn updateCellVisibility = (
    local cellCount = this.cells.Count
    for i = 1 to cellCount do (
      local cell = this.cells[i]
      local cellItem = cell.GetItem()
      local cellType = cell.GetType()
      if (cellType == #Layout or cellType == #Widget) \
          and isProperty cellItem #SetVisibility \
          and classOf cellItem.SetVisibility == MAXScriptFunction do (
        cellItem.SetVisibility (this.visibility and i == this.currentIndex)
      )
    )
    ok
  ),

  /*- @returns <Name> */
  public fn StructName = #FlexStackedLayoutStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%FlexStackedLayoutStruct\n" indent to:out
    format "%  Options:\n" indent to:out
    this.Options.Dump indent:(indent + "    ") out:out
    format "%  currentIndex:%\n" indent this.currentIndex to:out
    format "%  visibility:%\n" indent this.visibility to:out
    format "%  cells:%\n" indent this.cells.Count to:out
    for i = 1 to this.cells.Count do (
      format "%    [%]:\n" indent i to:out
      this.cells[i].Dump indent:(indent + "      ") out:out
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

    local isEqualProperties = isProperty obj #GetCells \
        and classOf obj.GetCells == MAXScriptFunction \
        and isProperty obj #GetCurrentIndex \
        and classOf obj.GetCurrentIndex == MAXScriptFunction \
        and obj.GetCurrentIndex() == this.GetCurrentIndex() \
        and isProperty obj #GetVisibility \
        and classOf obj.GetVisibility == MAXScriptFunction \
        and obj.GetVisibility() == this.GetVisibility()

    if isEqualProperties do (
      local ov = obj.GetCells()
      local tv = this.GetCells()
      isEqualProperties = classOf ov == Array and ov.Count == tv.Count
      if isEqualProperties do (
        for i = 1 to tv.Count while isEqualProperties do (
          isEqualProperties = tv[i].Equals ov[i]
        )
      )
    )

    isEqualStructName and isEqualProperties
  ),

  /*- @prop <Struct:ObservableStruct> */
  public StateChanged,

  on Create do (
    this.StateChanged = ::std.ObservableStruct()
    if not this.isValidLayoutOptions this.Options do (
      this.Options = (::flexUIDefinitionPool[@"Model\Layout\FlexLayoutOptions.ms"])()
    )
    this.boxCellDef = ::flexUIDefinitionPool[@"Model\Layout\FlexBoxCell.ms"]
  )
)
