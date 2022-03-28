/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  -- clearListener()

  local nowTime = (DotNetClass "System.DateTime").Now.ToString "HH:mm:ss"
  local sw = DotNetObject "System.Diagnostics.Stopwatch"

  local currentFile = getSourceFileName()
  local pathUtility = ::std.PathUtilityStruct currentFile

  local actual
  local expected
  local testDef
  local testObj

  format "[run %]@\"%\"\n" nowTime currentFile
  /* Setup Start ------------------------------------------------------------ */
  fileIn (pathUtility.GetFullPath @"..\..\..\definitionPool.ms")
  local boxCellDef = ::flexUIDefinitionPool[@"Model\Layout\FlexBoxCell.ms"]
  local gridCellDef = ::flexUIDefinitionPool[@"Model\Layout\FlexGridCell.ms"]

  local FlexTestLayoutStruct
  local FlexTestWidgetStruct

  struct FlexTestLayoutStruct (
    /*- @prop <BooleanClass> */
    private isVisible = true,

    /*-
    @returns <BooleanClass>
    */
    public fn GetVisibility = (
      this.isVisible
    ),

    /*-
    @param rect <Box2>
    @returns <Array[<Box2>]>
    */
    public fn SetRect rect = (
      #()
    ),

    /*-
    @param input <BooleanClass>
    @returns <BooleanClass>
    */
    public fn SetVisibility input = (
      if classOf input == BooleanClass do (
        this.isVisible = input
      )
      this.GetVisibility()
    ),

    /*- @returns <Name> */
    public fn StructName = #FlexTestLayoutStruct,

    /*-
    @param indent: <String>
    @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
    @returns <OkClass>
    */
    public fn Dump indent:"" out:listener = (
      format "%FlexTestLayoutStruct\n" indent to:out
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

    on Create do ()
  )

  struct FlexTestWidgetStruct (
    /*- @prop <Any> 作成パラメータ1。既定値は`undefined`。 */
    public _CP1_,

    /*- @prop <Integer|UndefinedClass> */
    private id,
    /*- @prop <BooleanClass> */
    private isVisible = true,

    /*-
    @returns <Integer|UndefinedClass>
    */
    public fn GetId = (
      this.id
    ),

    /*-
    @returns <BooleanClass>
    */
    public fn GetVisibility = (
      this.isVisible
    ),

    /*-
    @param rect <Box2>
    @returns <Array[<Box2>]>
    */
    public fn SetRect rect = (
      #()
    ),

    /*-
    @param input <BooleanClass>
    @returns <BooleanClass>
    */
    public fn SetVisibility input = (
      if classOf input == BooleanClass do (
        this.isVisible = input
      )
      this.GetVisibility()
    ),

    /*- @returns <Name> */
    public fn StructName = #FlexTestWidgetStruct,

    /*-
    @param indent: <String>
    @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
    @returns <OkClass>
    */
    public fn Dump indent:"" out:listener = (
      format "%FlexTestWidgetStruct\n" indent to:out
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

      local isEqualProperties = isProperty obj #GetId \
          and classOf obj.GetId == MAXScriptFunction \
          and obj.GetId() == this.GetId() \
          and isProperty obj #GetVisibility \
          and classOf obj.GetVisibility == MAXScriptFunction \
          and obj.GetVisibility() == this.GetVisibility()

      isEqualStructName and isEqualProperties
    ),

    on Create do (
      this.id = copy this._CP1_
    )
  )

  local expectedCells = #()
  local expectedColumnFixedLengths = #()
  local expectedColumnMinimumWidths = #()
  local expectedColumnStretches = #()
  local expectedRowFixedLengths = #()
  local expectedRowMinimumHeights = #()
  local expectedRowStretches = #()
  local expectedVisibility = true

  local testNotification
  fn testNotification context type param = (
    -- format "testNotification type:% param:%\n" type param
    case type of (
      (#ColumnFixedLength): (
        local cells = testObj.GetColumnCells()
        actual = ::TestValueStruct (for cell in cells collect cell.GetFixedLength())
        expected = ::TestValueStruct expectedColumnFixedLengths
        assert (actual.Equals expected == true)
      )
      (#ColumnMinimumWidth): (
        local cells = testObj.GetColumnCells()
        actual = ::TestValueStruct (for cell in cells collect cell.GetMinimum())
        expected = ::TestValueStruct expectedColumnMinimumWidths
        assert (actual.Equals expected == true)
      )
      (#ColumnStretch): (
        local cells = testObj.GetColumnCells()
        actual = ::TestValueStruct (for cell in cells collect cell.GetStretch())
        expected = ::TestValueStruct expectedColumnStretches
        assert (actual.Equals expected == true)
      )
      (#LayoutAdded): (
        actual = ::TestValueStruct (testObj.GetCells())
        expected = ::TestValueStruct expectedCells
        assert (actual.Equals expected == true)
      )
      (#RectUpdated): ()
      (#RowFixedLength): (
        local cells = testObj.GetRowCells()
        actual = ::TestValueStruct (for cell in cells collect cell.GetFixedLength())
        expected = ::TestValueStruct expectedRowFixedLengths
        assert (actual.Equals expected == true)
      )
      (#RowMinimumHeight): (
        local cells = testObj.GetRowCells()
        actual = ::TestValueStruct (for cell in cells collect cell.GetMinimum())
        expected = ::TestValueStruct expectedRowMinimumHeights
        assert (actual.Equals expected == true)
      )
      (#RowStretch): (
        local cells = testObj.GetRowCells()
        actual = ::TestValueStruct (for cell in cells collect cell.GetStretch())
        expected = ::TestValueStruct expectedRowStretches
        assert (actual.Equals expected == true)
      )
      (#VisibilityChanged): (
        actual = ::TestValueStruct (testObj.GetVisibility())
        expected = ::TestValueStruct expectedVisibility
        assert (actual.Equals expected == true)
      )
      (#WidgetAdded): (
        actual = ::TestValueStruct (testObj.GetCells())
        expected = ::TestValueStruct expectedCells
        assert (actual.Equals expected == true)
      )
      default: ()
    )
    ok
  )

  local layout1 = FlexTestLayoutStruct()
  local layout2 = FlexTestLayoutStruct()
  local layout3 = FlexTestLayoutStruct()
  local layout4 = undefined
  local widget1 = FlexTestWidgetStruct 1
  local widget2 = FlexTestWidgetStruct 2
  local widget3 = FlexTestWidgetStruct 3
  local widget4 = FlexTestWidgetStruct 4

  testDef = ::flexUIDefinitionPool[@"Model\Layout\FlexGridLayout.ms"]
  testObj = testDef()

  testObj.AddObserver (::std.ObserverStruct testNotification testObj)
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* AddLayout */
  -- 無効な値
  actual = ::TestValueStruct (testObj.AddLayout 1 1 1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.AddLayout testObj 1 1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な行
  actual = ::TestValueStruct (testObj.AddLayout layout1 0 1 rowSpan:1 columnSpan:1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な列
  actual = ::TestValueStruct (testObj.AddLayout layout1 1 0 rowSpan:1 columnSpan:1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な行数
  actual = ::TestValueStruct (testObj.AddLayout layout1 1 1 rowSpan:0 columnSpan:1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な列数
  actual = ::TestValueStruct (testObj.AddLayout layout1 1 1 rowSpan:1 columnSpan:0)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 成功
  expectedCells = #(
    gridCellDef layout1 1 1
  )
  actual = ::TestValueStruct (testObj.AddLayout layout1 1 1)
  expected = ::TestValueStruct expectedCells[1]
  assert (actual.Equals expected == true)
  -- 成功
  expectedCells = #(
    gridCellDef layout1 1 1,
    gridCellDef layout2 2 1
  )
  actual = ::TestValueStruct (testObj.AddLayout layout1 2 1)
  expected = ::TestValueStruct expectedCells[2]
  assert (actual.Equals expected == true)
  -- 成功
  expectedCells = #(
    gridCellDef layout1 1 1,
    gridCellDef layout2 2 1,
    gridCellDef layout3 3 1 2 2
  )
  actual = ::TestValueStruct (testObj.AddLayout layout1 3 1 rowSpan:2 columnSpan:2)
  expected = ::TestValueStruct expectedCells[3]
  assert (actual.Equals expected == true)

  /* AddWidget */
  -- 無効な値
  actual = ::TestValueStruct (testObj.AddWidget 1 1 1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.AddWidget layout1 1 1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な行
  actual = ::TestValueStruct (testObj.AddWidget widget1 0 1 rowSpan:1 columnSpan:1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な列
  actual = ::TestValueStruct (testObj.AddWidget widget1 1 0 rowSpan:1 columnSpan:1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な行数
  actual = ::TestValueStruct (testObj.AddWidget widget1 1 1 rowSpan:0 columnSpan:1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な列数
  actual = ::TestValueStruct (testObj.AddWidget widget1 1 1 rowSpan:1 columnSpan:0)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 成功
  expectedCells = #(
    gridCellDef layout1 1 1,
    gridCellDef layout2 2 1,
    gridCellDef layout3 3 1 2 2,
    gridCellDef widget1 1 2 2 2
  )
  actual = ::TestValueStruct (testObj.AddWidget widget1 1 2 rowSpan:2 columnSpan:2)
  expected = ::TestValueStruct expectedCells[4]
  assert (actual.Equals expected == true)
  -- 重複登録はできない
  actual = ::TestValueStruct (testObj.AddWidget widget1 3 3)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 成功
  expectedCells = #(
    gridCellDef layout1 1 1,
    gridCellDef layout2 2 1,
    gridCellDef layout3 3 1 2 2,
    gridCellDef widget1 1 2 2 2,
    gridCellDef widget2 3 3
  )
  actual = ::TestValueStruct (testObj.AddWidget widget2 3 3)
  expected = ::TestValueStruct expectedCells[5]
  assert (actual.Equals expected == true)
  -- 重複登録はできない
  actual = ::TestValueStruct (testObj.AddWidget widget2 4 3)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 成功（ストレッチ）
  expectedCells = #(
    gridCellDef layout1 1 1,
    gridCellDef layout2 2 1,
    gridCellDef layout3 3 1 2 2,
    gridCellDef widget1 1 2 2 2,
    gridCellDef widget2 3 3,
    gridCellDef widget3 4 3
  )
  actual = ::TestValueStruct (testObj.AddWidget widget3 4 3)
  expected = ::TestValueStruct expectedCells[6]
  assert (actual.Equals expected == true)
  -- 重複登録はできない
  actual = ::TestValueStruct (testObj.AddWidget widget3 5 1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 成功（固定長）
  expectedCells = #(
    gridCellDef layout1 1 1,
    gridCellDef layout2 2 1,
    gridCellDef layout3 3 1 2 2,
    gridCellDef widget1 1 2 2 2,
    gridCellDef widget2 3 3,
    gridCellDef widget3 4 3,
    gridCellDef widget4 5 1 1 3
  )
  actual = ::TestValueStruct (testObj.AddWidget widget4 5 1 rowSpan:1 columnSpan:3)
  expected = ::TestValueStruct expectedCells[7]
  assert (actual.Equals expected == true)

  /* GetCells */
  expectedCells = #(
    gridCellDef layout1 1 1,
    gridCellDef layout2 2 1,
    gridCellDef layout3 3 1 2 2,
    gridCellDef widget1 1 2 2 2,
    gridCellDef widget2 3 3,
    gridCellDef widget3 4 3,
    gridCellDef widget4 5 1 1 3
  )
  actual = ::TestValueStruct (testObj.GetCells())
  expected = ::TestValueStruct expectedCells
  assert (actual.Equals expected == true)

  /* GetColumnCells */
  actual = ::TestValueStruct (testObj.GetColumnCells())
  expected = ::TestValueStruct #(
    boxCellDef -1 1,
    boxCellDef -1 1,
    boxCellDef -1 1
  )
  assert (actual.Equals expected == true)

  /* GetRowCells */
  actual = ::TestValueStruct (testObj.GetRowCells())
  expected = ::TestValueStruct #(
    boxCellDef -1 1,
    boxCellDef -1 1,
    boxCellDef -1 1,
    boxCellDef -1 1,
    boxCellDef -1 1
  )
  assert (actual.Equals expected == true)

  /* GetVisibility */
  expectedVisibility = true
  actual = ::TestValueStruct (testObj.GetVisibility())
  expected = ::TestValueStruct expectedVisibility
  assert (actual.Equals expected == true)

  /* SetColumnFixedLength */
  expectedColumnFixedLengths = #(10, undefined, undefined)
  actual = ::TestValueStruct (testObj.SetColumnFixedLength 1 10)
  expected = ::TestValueStruct 10
  assert (actual.Equals expected == true)
  -- 既定値に戻す
  expectedColumnFixedLengths = #(undefined, undefined, undefined)
  actual = ::TestValueStruct (testObj.SetColumnFixedLength 1 undefined)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* SetColumnMinimumWidth */
  expectedColumnMinimumWidths = #(1, 10, 1)
  actual = ::TestValueStruct (testObj.SetColumnMinimumWidth 2 10)
  expected = ::TestValueStruct 10
  assert (actual.Equals expected == true)

  /* SetColumnStretch */
  expectedColumnStretches = #(1, 2, 1)
  actual = ::TestValueStruct (testObj.SetColumnStretch 2 2)
  expected = ::TestValueStruct 2
  assert (actual.Equals expected == true)

  /* SetRowFixedLength */
  expectedRowFixedLengths = #(undefined, undefined, undefined, undefined, 20)
  actual = ::TestValueStruct (testObj.SetRowFixedLength 5 20)
  expected = ::TestValueStruct 20
  assert (actual.Equals expected == true)

  /* SetRowMinimumHeight */
  expectedRowMinimumHeights = #(1, 1, 10, 1, 1)
  actual = ::TestValueStruct (testObj.SetRowMinimumHeight 3 10)
  expected = ::TestValueStruct 10
  assert (actual.Equals expected == true)

  /* SetRowStretch */
  expectedRowStretches = #(1, 1, 2, 1, 1)
  actual = ::TestValueStruct (testObj.SetRowStretch 3 2)
  expected = ::TestValueStruct 2
  assert (actual.Equals expected == true)

  /* SetRect */
  -- 余白を設定
  testObj.Options.SetMargin 10 10
  testObj.Options.SetPadding 10 10 10 10
  -- 通常
  actual = ::TestValueStruct (testObj.SetRect (Box2 10 10 80 130))
  expected = ::TestValueStruct #(
    Box2 20 20 10 10,
    Box2 20 40 10 10,
    Box2 20 60 40 40,
    Box2 40 20 40 30,
    Box2 70 60 10 20,
    Box2 70 90 10 10,
    Box2 20 110 60 20
  )
  assert (actual.Equals expected == true)
  -- 最小値
  actual = ::TestValueStruct (testObj.SetRect (Box2 10 10 10 10))
  expected = ::TestValueStruct #(
    Box2 20 20 1 1,
    Box2 20 31 1 1,
    Box2 20 42 21 21,
    Box2 31 20 21 12,
    Box2 51 42 1 10,
    Box2 51 62 1 1,
    Box2 20 73 32 20
  )
  assert (actual.Equals expected == true)

  /* SetVisibility */
  expectedVisibility = false
  actual = ::TestValueStruct (testObj.SetVisibility false)
  expected = ::TestValueStruct expectedVisibility
  assert (actual.Equals expected == true)

  -- testObj.Dump()

  /* Equals */
  layout4 = testDef()
  layout4.AddLayout layout1 1 1
  layout4.AddLayout layout2 2 1
  layout4.AddLayout layout3 3 1 rowSpan:2 columnSpan:2
  layout4.AddWidget widget1 1 2 rowSpan:2 columnSpan:2
  layout4.AddWidget widget2 3 3
  layout4.AddWidget widget3 4 3
  layout4.AddWidget widget4 5 1 rowSpan:1 columnSpan:3
  layout4.SetColumnMinimumWidth 2 10
  layout4.SetColumnStretch 2 2
  layout4.SetRowFixedLength 5 20
  layout4.SetRowMinimumHeight 3 10
  layout4.SetRowStretch 3 2
  actual = ::TestValueStruct testObj
  expected = ::TestValueStruct layout4
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
