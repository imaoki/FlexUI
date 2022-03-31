/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
`GroupBoxControl`用のレイアウト。
@remarks レイアウトオプションの状態に関係なく上側`15`ピクセル、下側と左右にそれぞれ`5`ピクセルの余白を設ける。
矩形の指定に`Box2`値を使用する都合上、各セルの幅と高さの最小値は`1`となる。
*/
struct FlexGroupLayoutStruct (
  /*- @prop <Struct:FlexGroupBoxControlWidgetStruct> 作成パラメータ1。`GroupBoxControl`ウィジェット。既定値は`undefined`。 */
  public _CP1_,

  /*- @prop <Struct:FlexBoxCellStruct> セルのアイテム。既定値は`undefined`。 */
  private cell,
  /*- @prop <Struct:FlexGroupBoxControlWidgetStruct> `GroupBoxControl`ウィジェット。 */
  private groupBoxWidget,

  /*- @prop <StructDef:FlexBoxCellStruct> */
  private boxCellDef,
  /*- @prop <Integer> レイアウト外周の下側の余白。既定値は`5`。 */
  private paddingB = 5,
  /*- @prop <Integer> レイアウト外周の左側の余白。既定値は`5`。 */
  private paddingL = 5,
  /*- @prop <Integer> レイアウト外周の右側の余白。既定値は`5`。 */
  private paddingR = 5,
  /*- @prop <Integer> レイアウト外周の上側の余白。既定値は`15`。 */
  private paddingT = 15,

  /*
  public fn GetCell = (),
  public fn GetGroupBoxWidget = (),
  public fn GetVisibility = (),
  public fn SetCell obj = (),
  public fn SetRect rect = (),
  public fn SetVisibility input = (),

  private fn isValidBoxCell obj = (),
  private fn isValidGroupBoxControlWidget obj = (),
  private fn setGroupBoxWidget obj = (),
  */

  /*-
  セルのアイテムを取得する。
  @returns <Struct:FlexBoxCellStruct|UndefinedClass>
  */
  public fn GetCell = (
    this.cell
  ),

  /*-
  `GroupBoxControl`ウィジェットを取得する。
  @returns <Struct:FlexGroupBoxControlWidgetStruct|UndefinedClass>
  */
  public fn GetGroupBoxWidget = (
    this.groupBoxWidget
  ),

  /*-
  セルのアイテムの可視性を取得する。
  @returns <BooleanClass|UndefinedClass>
  @remarks 値を取得できない場合や真偽混合の場合は`undefined`を返す。
  */
  public fn GetVisibility = (
    local visibility = unsupplied
    if this.isValidGroupBoxControlWidget this.groupBoxWidget do (
      visibility = this.groupBoxWidget.GetVisibility()
    )
    if this.isValidBoxCell this.cell do (
      local cellItem = this.cell.GetItem()
      local cellType = this.cell.GetType()
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
  セルのアイテムを設定する。
  @param obj <Struct> レイアウトまたはウィジェット。
  @returns <Struct:FlexBoxCellStruct|UndefinedClass>
  */
  public fn SetCell obj = (
    local boxCell = this.boxCellDef obj
    local boxCellType = boxCell.GetType()
    if boxCellType == #Layout or boxCellType == #Widget do (
      this.cell = boxCell
      this.StateChanged.Notify #CellSet this.cell
    )
    this.GetCell()
  ),

  /*-
  レイアウトの矩形を設定する。
  @param rect <Box2>
  @returns <Array[<Box2>]>
  @remarks 一貫性のため戻り値は配列で返す。
  */
  public fn SetRect rect = (
    local cellRects = #()
    if this.isValidGroupBoxControlWidget this.groupBoxWidget \
        and this.isValidBoxCell this.cell do (
      local minH = this.groupBoxWidget.GetMinH()
      local minW = this.groupBoxWidget.GetMinW()
      local rectX = copy rect.X
      local rectY = copy rect.Y
      local rectH = copy rect.H
      local rectW = copy rect.W
      if rectH < minH do rectH = minH
      if rectW < minW do rectW = minW
      local groupBoxRect = Box2 rectX rectY rectW rectH
      this.groupBoxWidget.SetRect groupBoxRect

      local cellItem = this.cell.GetItem()
      local cellType = this.cell.GetType()
      local cellX = rectX + this.paddingL
      local cellY = rectY + this.paddingT
      local cellW = rectW - this.paddingL - this.paddingR
      local cellH = rectH - this.paddingT - this.paddingB
      if cellW < 1 do cellW = 1
      if cellH < 1 do cellH = 1
      local cellRect = Box2 cellX cellY cellW cellH
      if cellType == #Layout or cellType == #Widget do (
        cellItem.SetRect cellRect
      )
      append cellRects cellRect
      this.StateChanged.Notify #RectUpdated cellRects
    )
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
      if this.isValidGroupBoxControlWidget this.groupBoxWidget do (
        this.groupBoxWidget.SetVisibility input
      )
      if this.isValidBoxCell this.cell do (
        local cellItem = this.cell.GetItem()
        local cellType = this.cell.GetType()
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
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isValidBoxCell obj = (
    isStruct obj \
        and isProperty obj #StructName \
        and classOf obj.StructName == MAXScriptFunction \
        and obj.StructName() == #FlexBoxCellStruct
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

  /*-
  @param obj <Any>
  @returns <Struct:FlexGroupBoxControlWidgetStruct|UndefinedClass>
  */
  private fn setGroupBoxWidget obj = (
    if this.isValidGroupBoxControlWidget obj do (
      this.groupBoxWidget = obj
    )
    this.GetGroupBoxWidget()
  ),

  /*- @returns <Name> */
  public fn StructName = #FlexGroupLayoutStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%FlexGroupLayoutStruct\n" indent to:out
    if this.isValidBoxCell this.cell then (
      format "%  cell:\n" indent to:out
      this.cell.Dump indent:(indent + "    ") out:out
    )
    else (
      format "%  cell:%\n" indent this.cell to:out
    )
    if this.isValidGroupBoxControlWidget this.groupBoxWidget then (
      format "%  groupBoxWidget:\n" indent to:out
      this.groupBoxWidget.Dump indent:(indent + "    ") out:out
    )
    else (
      format "%  groupBoxWidget:%\n" indent this.groupBoxWidget to:out
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
        and isProperty obj #GetCell \
        and classOf obj.GetCell == MAXScriptFunction \
        and isProperty obj #GetGroupBoxWidget \
        and classOf obj.GetGroupBoxWidget == MAXScriptFunction \

    if isEqualProperties do (
      local ov = obj.GetCell()
      local tv = this.GetCell()
      if isStruct tv \
          and isProperty tv #Equals \
          and classOf tv.Equals == MAXScriptFunction then (
        isEqualProperties = tv.Equals ov
      )
      else (
        isEqualProperties = ov == tv
      )
    )

    if isEqualProperties do (
      local ov = obj.GetGroupBoxWidget()
      local tv = this.GetGroupBoxWidget()
      if isStruct tv \
          and isProperty tv #Equals \
          and classOf tv.Equals == MAXScriptFunction then (
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
    this.boxCellDef = ::flexUIDefinitionPool[@"Model\Layout\FlexBoxCell.ms"]
    this.setGroupBoxWidget this._CP1_
  )
)
