/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
グリッドにアイテムを配置する。
@remarks 矩形の指定に`Box2`値を使用する都合上、各セルの幅と高さの最小値は`1`となる。
*/
struct FlexGridLayoutStruct (
  /*- @prop <Struct:FlexLayoutOptionsStruct> 既定値は`undefined`。未指定の場合は既定値で作成される。 */
  public Options,

  /*- @prop <Array[<Struct:FlexGridCellStruct>]> セルのアイテム。既定値は`#()`。 */
  private cells = #(),
  /*- @prop <Array[<Struct:FlexBoxCellStruct>]> 列を構成するセル。既定値は`#()`。 */
  private columnCells = #(),
  /*- @prop <Array[<Struct:FlexBoxCellStruct>]> 行を構成するセル。既定値は`#()`。 */
  private rowCells = #(),

  /*- @prop <StructDef:FlexBoxCellStruct> */
  private boxCellDef,
  /*- @prop <StructDef:FlexGridCellStruct> */
  private gridCellDef,

  /*
  public fn AddLayout layout row column rowSpan:1 columnSpan:1 = (),
  public fn AddWidget widget row column rowSpan:1 columnSpan:1 = (),
  public fn GetCells = (),
  public fn GetColumnCells = (),
  public fn GetRowCells = (),
  public fn SetColumnMinimumWidth column minimum = (),
  public fn SetColumnStretch column stretch = (),
  public fn SetRect rect = (),
  public fn SetRowMinimumHeight row minimum = (),
  public fn SetRowStretch row stretch = (),

  private fn addGrid row column rowSpan columnSpan = (),
  private fn findWidget widget = (),
  private fn generateColumnRects rect = (),
  private fn generateRowRects rect = (),
  private fn isMatchStructName obj pattern = (),
  private fn isValidLayoutOptions obj = (),
  private fn isValidStretchCell obj = (),
  private fn isValidWidget obj = (),
  */

  /*-
  レイアウトを追加する。
  @param layout <Struct>
  @param row <Integer> セルを配置する行。`1`以上の整数。
  @param column <Integer> セルを配置する列。`1`以上の整数。
  @param rowSpan: <Integer> セルが専有する行数。`1`以上の整数。既定値は`1`。
  @param columnSpan: <Integer> セルが専有する列数。`1`以上の整数。既定値は`1`。
  @returns <Struct:FlexGridCellStruct|UndefinedClass>
  @remarks 無効な値の場合は`undefined`を返す。
  */
  public fn AddLayout layout row column rowSpan:1 columnSpan:1 = (
    local cell = this.gridCellDef layout row column rowSpan columnSpan
    if cell.GetType() == #Layout and layout != this then (
      if this.addGrid row column rowSpan columnSpan then (
        append this.cells cell
        this.notify #(#LayoutAdded)
      )
      else (
        cell = undefined
      )
    )
    else (
      cell = undefined
    )
    cell
  ),

  /*-
  ウィジェットを追加する。
  @param widget <Struct>
  @param row <Integer> セルを配置する行。`1`以上の整数。
  @param column <Integer> セルを配置する列。`1`以上の整数。
  @param rowSpan: <Integer> セルが専有する行数。`1`以上の整数。既定値は`1`。
  @param columnSpan: <Integer> セルが専有する列数。`1`以上の整数。既定値は`1`。
  @returns <Struct:FlexGridCellStruct|UndefinedClass>
  @remarks 無効な値の場合は`undefined`を返す。
  */
  public fn AddWidget widget row column rowSpan:1 columnSpan:1 = (
    local cell = this.gridCellDef widget row column rowSpan columnSpan
    if cell.GetType() == #Widget and this.findWidget widget == 0 then (
      if this.addGrid row column rowSpan columnSpan then (
        append this.cells cell
        this.notify #(#WidgetAdded)
      )
      else (
        cell = undefined
      )
    )
    else (
      cell = undefined
    )
    cell
  ),

  /*-
  セルのアイテムを取得する。
  @returns <Array[<Struct:FlexGridCellStruct>]>
  */
  public fn GetCells = (
    this.cells
  ),

  /*-
  列を構成するセルを取得する。
  @returns <Array[<Struct:FlexBoxCellStruct>]>
  */
  public fn GetColumnCells = (
    this.columnCells
  ),

  /*-
  行を構成するセルを取得する。
  @returns <Array[<Struct:FlexBoxCellStruct>]>
  */
  public fn GetRowCells = (
    this.rowCells
  ),

  /*-
  列の最小幅を設定する。
  @param column <Integer> 対象の列。`1`以上の整数。
  @param minimum <Integer> 最小幅。`1`以上の整数。
  @returns <Integer|UndefinedClass>
  @remarks 無効な値を指定した場合は何もしない。
  */
  public fn SetColumnMinimumWidth column minimum = (
    local columnMinimum = undefined
    if superClassOf column == Number do (
      column = column as Integer
      if column > 0 and this.isValidStretchCell this.columnCells[column] do (
        columnMinimum = this.columnCells[column].SetMinimum minimum
        this.notify #(#ColumnMinimumWidth)
      )
    )
    columnMinimum
  ),

  /*-
  列のストレッチ係数を設定する。
  @param column <Integer> 対象の列。`1`以上の整数。
  @param stretch <Integer> ストレッチ係数。`1`以上の整数。
  @returns <Integer|UndefinedClass>
  @remarks 無効な値を指定した場合は何もしない。
  */
  public fn SetColumnStretch column stretch = (
    local columnStretch = undefined
    if superClassOf column == Number do (
      column = column as Integer
      if column > 0 and this.isValidStretchCell this.columnCells[column] do (
        columnStretch = this.columnCells[column].SetStretch stretch
        this.notify #(#ColumnStretch)
      )
    )
    columnStretch
  ),

  /*-
  レイアウトの矩形を設定する。
  @param rect <Box2>
  @returns <Array[<Box2>]>
  */
  public fn SetRect rect = (
    local columnRects = this.generateColumnRects rect
    local rowRects = this.generateRowRects rect
    local cellCount = this.cells.Count
    local cellRects = for i = 1 to cellCount collect (
      local cell = this.cells[i]
      local cellItem = cell.GetItem()
      local cellType = cell.GetType()
      local columnStart = cell.GetColumn()
      local columnEnd = columnStart + (cell.GetColumnSpan() - 1)
      local rowStart = cell.GetRow()
      local rowEnd = rowStart + (cell.GetRowSpan() - 1)
      local cellX = columnRects[columnStart].X
      local cellY = rowRects[rowStart].Y
      local cellW = columnRects[columnEnd].X + columnRects[columnEnd].W - cellX
      local cellH = rowRects[rowEnd].Y + rowRects[rowEnd].H - cellY
      local cellRect = Box2 cellX cellY cellW cellH
      if cellType == #Layout or cellType == #Widget do (
        cellItem.SetRect cellRect
      )
      cellRect
    )
    this.notify #(#RectUpdated)
    cellRects
  ),

  /*-
  行の最小高を設定する。
  @param row <Integer> 対象の列。`1`以上の整数。
  @param minimum <Integer> 最小高。`1`以上の整数。
  @returns <Integer|UndefinedClass>
  @remarks 無効な値を指定した場合は何もしない。
  */
  public fn SetRowMinimumHeight row minimum = (
    local rowMinimum = undefined
    if superClassOf row == Number do (
      row = row as Integer
      if row > 0 and this.isValidStretchCell this.rowCells[row] do (
        rowMinimum = this.rowCells[row].SetMinimum minimum
        this.notify #(#RowMinimumHeight)
      )
    )
    rowMinimum
  ),

  /*-
  行のストレッチ係数を設定する。
  @param row <Integer> 対象の行。`1`以上の整数。
  @param stretch <Integer> ストレッチ係数。`1`以上の整数。
  @returns <Integer|UndefinedClass>
  @remarks 無効な値を指定した場合は何もしない。
  */
  public fn SetRowStretch row stretch = (
    local rowStretch = undefined
    if superClassOf row == Number do (
      row = row as Integer
      if row > 0 and this.isValidStretchCell this.rowCells[row] do (
        rowStretch = this.rowCells[row].SetStretch stretch
        this.notify #(#RowStretch)
      )
    )
    rowStretch
  ),

  /*-
  グリッドを構成するセルを追加する。
  @param row <Integer> 開始行。`1`以上の整数。
  @param column <Integer> 開始列。`1`以上の整数。
  @param rowSpan <Integer> 行の数。`1`以上の整数。
  @param columnSpan <Integer> 列の数。`1`以上の整数。
  @returns <BooleanClass> 指定した範囲のセルが全て存在する場合は`true`、一つでも存在しない場合は`false`。
  */
  private fn addGrid row column rowSpan columnSpan = (
    local columnCellCount = 0
    local rowCellCount = 0
    if superClassOf column == Number and superClassOf columnSpan == Number \
        and superClassOf row == Number and superClassOf rowSpan == Number do (
      column = column as Integer
      columnSpan = columnSpan as Integer
      if column > 0 and columnSpan > 0 do (
        local columnStart = column
        local columnEnd = column + (columnSpan - 1)
        for i = columnStart to columnEnd do (
          if not this.isValidStretchCell this.columnCells[i] do (
            this.columnCells[i] = this.boxCellDef -1 1
          )
          if this.isValidStretchCell this.columnCells[i] do (
            columnCellCount += 1
          )
        )
      )
      row = row as Integer
      rowSpan = rowSpan as Integer
      if row > 0 and rowSpan > 0 do (
        local rowStart = row
        local rowEnd = row + (rowSpan - 1)
        for i = rowStart to rowEnd do (
          if not this.isValidStretchCell this.rowCells[i] do (
            this.rowCells[i] = this.boxCellDef -1 1
          )
          if this.isValidStretchCell this.rowCells[i] do (
            rowCellCount += 1
          )
        )
      )
    )
    columnCellCount > 0 and rowCellCount > 0 \
        and columnCellCount == columnSpan and rowCellCount == rowSpan
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
  列の矩形を生成する。
  @param rect <Box2>
  @returns <Array[<Box2>]>
  */
  private fn generateColumnRects rect = (
    local cellCount = this.columnCells.Count
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
    local totalFixed = paddingL + paddingR
    local totalStretch = 0
    for i = 1 to cellCount do (
      if i > 1 do totalFixed += marginH
      local cell = this.columnCells[i]
      local cellItem = cell.GetItem()
      local cellMinimum = cell.GetMinimum()
      local cellStretch = cell.GetStretch()
      append cellItems cellItem
      append cellLengths cellStretch
      append cellLengthTypes #Stretch
      append cellMinimums cellMinimum
      totalStretch += cellStretch
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
    for i = 1 to cellCount collect (
      if i > 1 do cellX += marginH
      local cellItem = cellItems[i]
      local cellLength = cellLengths[i]
      local cellLengthType = cellLengthTypes[i]
      local cellW = copy cellLength
      if cellLengthType == #Stretch do (
        cellW = (cellW * unitRatio) as Integer
      )
      if cellW < 1 do cellW = 1
      local cellRect = Box2 cellX cellY cellW cellH
      cellX += cellW
      cellRect
    )
  ),

  /*-
  行の矩形を生成する。
  @param rect <Box2>
  @returns <Array[<Box2>]>
  */
  private fn generateRowRects rect = (
    local cellCount = this.rowCells.Count
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
    local totalFixed = paddingT + paddingB
    local totalStretch = 0
    for i = 1 to cellCount do (
      if i > 1 do totalFixed += marginV
      local cell = this.rowCells[i]
      local cellItem = cell.GetItem()
      local cellMinimum = cell.GetMinimum()
      local cellStretch = cell.GetStretch()
      append cellItems cellItem
      append cellLengths cellStretch
      append cellLengthTypes #Stretch
      append cellMinimums cellMinimum
      totalStretch += cellStretch
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
    for i = 1 to cellCount collect (
      if i > 1 do cellY += marginV
      local cellItem = cellItems[i]
      local cellLength = cellLengths[i]
      local cellLengthType = cellLengthTypes[i]
      local cellH = copy cellLength
      if cellLengthType == #Stretch do (
        cellH = (cellH * unitRatio) as Integer
      )
      if cellH < 1 do cellH = 1
      local cellRect = Box2 cellX cellY cellW cellH
      cellY += cellH
      cellRect
    )
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
  private fn isValidStretchCell obj = (
    isStruct obj \
        and isProperty obj #StructName \
        and classOf obj.StructName == MAXScriptFunction \
        and obj.StructName() == #FlexBoxCellStruct \
        and obj.GetType() == #Stretch
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isValidWidget obj = (
    isStruct obj and this.isMatchStructName obj "Flex*WidgetStruct"
  ),

  /*- @returns <Name> */
  public fn StructName = #FlexGridLayoutStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%FlexGridLayoutStruct\n" indent to:out
    format "%  Options:\n" indent to:out
    this.Options.Dump indent:(indent + "    ") out:out
    format "%  cells:%\n" indent this.cells.Count to:out
    for i = 1 to this.cells.Count do (
      format "%    [%]:\n" indent i to:out
      this.cells[i].Dump indent:(indent + "      ") out:out
    )
    format "%  columnCells:%\n" indent this.columnCells.Count to:out
    for i = 1 to this.columnCells.Count do (
      format "%    [%]:\n" indent i to:out
      this.columnCells[i].Dump indent:(indent + "      ") out:out
    )
    format "%  rowCells:%\n" indent this.rowCells.Count to:out
    for i = 1 to this.rowCells.Count do (
      format "%    [%]:\n" indent i to:out
      this.rowCells[i].Dump indent:(indent + "      ") out:out
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
        and isProperty obj #GetColumnCells \
        and classOf obj.GetColumnCells == MAXScriptFunction \
        and isProperty obj #GetRowCells \
        and classOf obj.GetRowCells == MAXScriptFunction

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

    if isEqualProperties do (
      local ov = obj.GetColumnCells()
      local tv = this.GetColumnCells()
      isEqualProperties = classOf ov == Array and ov.Count == tv.Count
      if isEqualProperties do (
        for i = 1 to tv.Count while isEqualProperties do (
          isEqualProperties = tv[i].Equals ov[i]
        )
      )
    )

    if isEqualProperties do (
      local ov = obj.GetRowCells()
      local tv = this.GetRowCells()
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
      this.Options = (fileIn @"FlexLayoutOptions.ms")()
    )
    this.boxCellDef = fileIn @"FlexBoxCell.ms"
    this.gridCellDef = fileIn @"FlexGridCell.ms"
  )
)
