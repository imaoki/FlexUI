/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
水平方向にアイテムを配置する。
@remarks 矩形の指定に`Box2`値を使用する都合上、各セルの幅と高さの最小値は`1`となる。
*/
struct FlexHBoxLayoutStruct (
  /*- @prop <Struct:FlexLayoutOptionsStruct> 既定値は`undefined`。未指定の場合は既定値で作成される。 */
  public Options,

  /*- @prop <Array[<Struct:FlexBoxCellStruct>]> セルのアイテム。既定値は`#()`。 */
  private cells = #(),

  /*- @prop <StructDef:FlexBoxCellStruct> */
  private boxCellDef,

  /*
  public fn AddLayout layout stretch:1 = (),
  public fn AddSpace input = (),
  public fn AddStretch stretch:1 = (),
  public fn AddWidget widget stretch:1 = (),
  public fn GetCells = (),
  public fn SetRect rect = (),

  private fn findWidget widget = (),
  private fn isMatchStructName obj pattern = (),
  private fn isValidLayoutOptions obj = (),
  private fn isValidWidget obj = (),
  */

  /*-
  レイアウトを追加する。
  @param layout <Struct>
  @param minimum: <Integer> 幅の最小値。`1`以上の整数。既定値は`1`。
  @param stretch: <Integer> ストレッチ係数。`1`以上の整数。既定値は`1`。
  @returns <Struct:FlexBoxCellStruct|UndefinedClass>
  @remarks 無効な値の場合は`undefined`を返す。
  */
  public fn AddLayout layout minimum:1 stretch:1 = (
    local cell = this.boxCellDef layout stretch minimum
    if cell.GetType() == #Layout and layout != this then (
      append this.cells cell
      this.notify #(#LayoutAdded)
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
      this.notify #(#SpaceAdded)
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
      this.notify #(#StretchAdded)
    )
    else (
      cell = undefined
    )
    cell
  ),

  /*-
  ウィジェットを追加する。
  @param widget <Struct>
  @param minimum: <Integer> 幅の最小値。`1`以上の整数。既定値は`1`。
  @param stretch: <Integer> ストレッチ係数。`1`以上の整数。既定値は`1`。
  @returns <Struct:FlexBoxCellStruct|UndefinedClass>
  @remarks 無効な値の場合は`undefined`を返す。
  ウィジェットの重複登録は出来ない。
  */
  public fn AddWidget widget minimum:1 stretch:1 = (
    local cell = this.boxCellDef widget stretch minimum
    if cell.GetType() == #Widget and this.findWidget widget == 0 then (
      append this.cells cell
      this.notify #(#WidgetAdded)
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
  レイアウトの矩形を設定する。
  @param rect <Box2>
  @returns <Array[<Box2>]>
  */
  public fn SetRect rect = (
    local cellCount = this.cells.Count
    local marginH = this.Options.GetMarginH()
    local paddingB = this.Options.GetPaddingB()
    local paddingL = this.Options.GetPaddingL()
    local paddingR = this.Options.GetPaddingR()
    local paddingT = this.Options.GetPaddingT()
    -- 幅の種類と値を収集し、固定長とストレッチ係数を合算
    local cellItems = #()
    local cellLengths = #()
    local cellLengthTypes = #()
    local cellMinimums = #()
    local cellTypes = #()
    local totalFixed = paddingL + paddingR
    local totalStretch = 0
    for i = 1 to cellCount do (
      if i > 1 do totalFixed += marginH
      local cell = this.cells[i]
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
          append cellLengths cellStretch
          append cellLengthTypes #Stretch
          totalStretch += cellStretch
        )
      )
      else (
        -- 不明なアイテムの場合はストレッチにする
        append cellLengths 1
        append cellLengthTypes #Stretch
        totalStretch += 1
      )
    )
    -- 単位係数あたりの幅の比率を算出
    local needsRecalculation = true
    local unitRatio = 0.0
    while needsRecalculation do (
      -- 算出した幅が最小値を下回る場合は幅を固定長に変更して比率を再定義する
      needsRecalculation = false
      unitRatio = 0.0
      if totalStretch > 0 do (
        unitRatio = (rect.W - totalFixed) as Float / totalStretch as Float
      )
      for i = 1 to cellCount while needsRecalculation == false do (
        if cellLengthTypes[i] == #Stretch do (
          local cellStretch = copy cellLengths[i]
          local cellW = (cellStretch * unitRatio) as Integer
          needsRecalculation = cellW < cellMinimums[i]
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
    local cellH = rect.H - paddingT - paddingB
    if cellH < 1 do cellH = 1
    local cellRects = for i = 1 to cellCount collect (
      if i > 1 do cellX += marginH
      local cellItem = cellItems[i]
      local cellLength = cellLengths[i]
      local cellLengthType = cellLengthTypes[i]
      local cellType = cellTypes[i]
      local cellW = copy cellLength
      if cellLengthType == #Stretch do (
        cellW = (cellW * unitRatio) as Integer
      )
      if cellW < 1 do cellW = 1
      local cellRect = Box2 cellX cellY cellW cellH
      if cellType == #Layout or cellType == #Widget do (
        cellItem.SetRect cellRect
      )
      cellX += cellW
      cellRect
    )
    this.notify #(#RectUpdated)
    cellRects
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
  public fn StructName = #FlexHBoxLayoutStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%FlexHBoxLayoutStruct\n" indent to:out
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
      this.Options = (fileIn "FlexLayoutOptions.ms")()
    )
    this.boxCellDef = fileIn "FlexBoxCell.ms"
  )
)