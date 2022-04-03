/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
垂直方向にアイテムを配置する。
@remarks 矩形の指定に`Box2`値を使用する都合上、各セルの幅と高さの最小値は`1`となる。

通知
:   | 通知名               | 通知データ                   | タイミング                           |
    | -------------------- | ---------------------------- | ------------------------------------ |
    | `#LayoutAdded`       | 追加したセル                 | レイアウトを追加した後               |
    | `#RectUpdated`       | 各セルの矩形                 | レイアウトの矩形を設定した後         |
    | `#SpaceAdded`        | 追加したセル                 | 固定スペースを追加した後             |
    | `#StretchAdded`      | 追加したセル                 | ストレッチ可能なスペースを追加した後 |
    | `#VisibilityChanged` | 新たなセルのアイテムの可視性 | セルのアイテムの可視性を設定した後   |
    | `#WidgetAdded`       | 追加したセル                 | ウィジェットを追加した後             |
*/
struct FlexVBoxLayoutStruct (
  /*- @prop <Struct:FlexLayoutOptionsStruct> 既定値は`undefined`。未指定の場合は既定値で作成される。 */
  public Options,

  /*- @prop <Array[<Struct:FlexBoxCellStruct>]> セルのアイテム。既定値は`#()`。 */
  private cells = #(),

  /*- @prop <StructDef:FlexBoxCellStruct> */
  private boxCellDef,

  /*
  public fn AddLayout layout fixedLength:undefined minimum:1 stretch:1 = (),
  public fn AddSpace input = (),
  public fn AddStretch stretch:1 = (),
  public fn AddWidget widget fixedLength:undefined minimum:1 stretch:1 = (),
  public fn GetCells = (),
  public fn GetVisibility = (),
  public fn SetRect rect = (),
  public fn SetVisibility input = (),

  private fn findWidget widget = (),
  private fn isMatchStructName obj pattern = (),
  private fn isValidLayoutOptions obj = (),
  private fn isValidWidget obj = (),
  */

  /*-
  レイアウトを追加する。
  @param layout <Struct>
  @param fixedLength: <Integer> 高さの固定値。`1`以上の整数。既定値は`undefined`。
  @param minimum: <Integer> 高さの最小値。`1`以上の整数。既定値は`1`。
  @param stretch: <Integer> ストレッチ係数。`1`以上の整数。既定値は`1`。
  @returns <Struct:FlexBoxCellStruct|UndefinedClass>
  @remarks 無効な値の場合は`undefined`を返す。
  */
  public fn AddLayout layout fixedLength:undefined minimum:1 stretch:1 = (
    local cell = this.boxCellDef layout stretch minimum fixedLength
    if cell.GetType() == #Layout and layout != this then (
      append this.cells cell
      this.StateChanged.Notify #LayoutAdded cell
    )
    else (
      cell = undefined
    )
    cell
  ),

  /*-
  固定スペースを追加する。
  @param input <Integer> `1`以上の整数。
  @returns <Struct:FlexBoxCellStruct|UndefinedClass>
  @remarks 無効な値の場合は`undefined`を返す。
  */
  public fn AddSpace input = (
    local cell = this.boxCellDef input
    if cell.GetType() == #Space then (
      append this.cells cell
      this.StateChanged.Notify #SpaceAdded cell
    )
    else (
      cell = undefined
    )
    cell
  ),

  /*-
  ストレッチ可能なスペースを追加する。
  @param stretch: <Integer> ストレッチ係数。`1`以上の整数。既定値は`1`。
  @returns <Struct:FlexBoxCellStruct|UndefinedClass>
  @remarks 無効な値の場合は`undefined`を返す。
  */
  public fn AddStretch stretch:1 = (
    local cell = this.boxCellDef -1 stretch
    if cell.GetType() == #Stretch then (
      append this.cells cell
      this.StateChanged.Notify #StretchAdded cell
    )
    else (
      cell = undefined
    )
    cell
  ),

  /*-
  ウィジェットを追加する。
  @param widget <Struct>
  @param fixedLength: <Integer> 高さの固定値。`1`以上の整数。既定値は`undefined`。
  @param minimum: <Integer> 高さの最小値。`1`以上の整数。既定値は`1`。
  @param stretch: <Integer> ストレッチ係数。`1`以上の整数。既定値は`1`。
  @returns <Struct:FlexBoxCellStruct|UndefinedClass>
  @remarks 無効な値の場合は`undefined`を返す。
  ウィジェットの重複登録は出来ない。
  */
  public fn AddWidget widget fixedLength:undefined minimum:1 stretch:1 = (
    local cell = this.boxCellDef widget stretch minimum fixedLength
    if cell.GetType() == #Widget and this.findWidget widget == 0 then (
      append this.cells cell
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
  セルのアイテムの可視性を取得する。
  @returns <BooleanClass|UndefinedClass>
  @remarks 値を取得できない場合や真偽混合の場合は`undefined`を返す。
  */
  public fn GetVisibility = (
    local visibility = unsupplied
    for cell in this.cells do (
      local cellItem = cell.GetItem()
      local cellType = cell.GetType()
      if (cellType == #Layout or cellType == #Widget) \
          and isProperty cellItem #GetVisibility \
          and classOf cellItem.GetVisibility == MAXScriptFunction do (
        local isVisible = cellItem.GetVisibility()
        if visibility == unsupplied do (
          visibility = isVisible
        )
        if classOf visibility != UndefinedClass do (
          if isVisible != visibility do (
            visibility = undefined
          )
        )
      )
    )
    if visibility == unsupplied do (
      visibility = undefined
    )
    visibility
  ),

  /*-
  レイアウトの矩形を設定する。
  @param rect <Box2>
  @returns <Array[<Box2>]>
  */
  public fn SetRect rect = (
    local cellCount = this.cells.Count
    local marginV = this.Options.GetMarginV()
    local paddingB = this.Options.GetPaddingB()
    local paddingL = this.Options.GetPaddingL()
    local paddingR = this.Options.GetPaddingR()
    local paddingT = this.Options.GetPaddingT()
    -- 高さの種類と値を収集し、固定長とストレッチ係数を合算
    local cellItems = #()
    local cellLengths = #()
    local cellLengthTypes = #()
    local cellMinimums = #()
    local cellTypes = #()
    local totalFixed = paddingT + paddingB
    local totalStretch = 0
    for i = 1 to cellCount do (
      if i > 1 do totalFixed += marginV
      local cell = this.cells[i]
      local cellFixedLength = cell.GetFixedLength()
      local cellItem = cell.GetItem()
      local cellMinimum = cell.GetMinimum()
      local cellStretch = cell.GetStretch()
      local cellType = cell.GetType()
      append cellItems cellItem
      append cellMinimums cellMinimum
      append cellTypes cellType
      if classOf cellType == Name then (
        if cellType == #Space then (
          append cellLengths cellItem
          append cellLengthTypes #Fixed
          totalFixed += cellItem
        )
        else (
          if classOf cellFixedLength == Integer then (
            append cellLengths cellFixedLength
            append cellLengthTypes #Fixed
            totalFixed += cellFixedLength
          )
          else (
            append cellLengths cellStretch
            append cellLengthTypes #Stretch
            totalStretch += cellStretch
          )
        )
      )
      else (
        -- 不明なアイテムの場合はストレッチにする
        append cellLengths 1
        append cellLengthTypes #Stretch
        totalStretch += 1
      )
    )
    -- 単位係数あたりの高さの比率を算出
    local needsRecalculation = true
    local unitRatio = 0.0
    while needsRecalculation do (
      -- 算出した高さが最小値を下回る場合は高さを固定長に変更して比率を再定義する
      needsRecalculation = false
      unitRatio = 0.0
      if totalStretch > 0 do (
        unitRatio = (rect.H - totalFixed) as Float / totalStretch as Float
      )
      for i = 1 to cellCount while needsRecalculation == false do (
        if cellLengthTypes[i] == #Stretch do (
          local cellStretch = copy cellLengths[i]
          local cellH = (cellStretch * unitRatio) as Integer
          needsRecalculation = cellH < cellMinimums[i]
          if needsRecalculation do (
            cellLengths[i] = copy cellMinimums[i]
            cellLengthTypes[i] = #Fixed
            totalFixed += cellLengths[i]
            totalStretch -= cellStretch
          )
        )
      )
    )
    -- 最終的なセルの矩形を算出してアイテムに設定
    local cellX = rect.X + paddingL
    local cellY = rect.Y + paddingT
    local cellW = rect.W - paddingL - paddingR
    if cellW < 1 do cellW = 1
    local cellRects = for i = 1 to cellCount collect (
      if i > 1 do cellY += marginV
      local cellItem = cellItems[i]
      local cellLength = cellLengths[i]
      local cellLengthType = cellLengthTypes[i]
      local cellType = cellTypes[i]
      local cellH = copy cellLength
      if cellLengthType == #Stretch do (
        cellH = (cellH * unitRatio) as Integer
      )
      if cellH < 1 do cellH = 1
      local cellRect = Box2 cellX cellY cellW cellH
      if cellType == #Layout or cellType == #Widget do (
        cellItem.SetRect cellRect
      )
      cellY += cellH
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
      for cell in this.cells do (
        local cellItem = cell.GetItem()
        local cellType = cell.GetType()
        if (cellType == #Layout or cellType == #Widget) \
            and isProperty cellItem #SetVisibility \
            and classOf cellItem.SetVisibility == MAXScriptFunction do (
          cellItem.SetVisibility input
        )
      )
      this.StateChanged.Notify #VisibilityChanged undefined
    )
    this.GetVisibility()
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

  /*- @returns <Name> */
  public fn StructName = #FlexVBoxLayoutStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%FlexVBoxLayoutStruct\n" indent to:out
    format "%  Options:\n" indent to:out
    this.Options.Dump indent:(indent + "    ") out:out
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
