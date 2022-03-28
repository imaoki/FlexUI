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

  local testCellItemVisibility
  fn testCellItemVisibility expectedValues = (
    local passCount = 0
    local cells = testObj.GetCells()
    local cellCount = cells.Count
    for i = 1 to cellCount do (
      local cell = cells[i]
      local cellItem = cells[i].GetItem()
      local cellType = cell.GetType()
      if cellType == #Layout or cellType == #Widget \
          and isProperty cellItem #GetVisibility \
          and classOf cellItem.GetVisibility == MAXScriptFunction do (
        local actualValue = ::TestValueStruct (cellItem.GetVisibility())
        local expectedValue = ::TestValueStruct expectedValues[i]
        if assert (actualValue.Equals expectedValue == true) do passCount += 1
      )
    )
    passCount == cellCount
  )

  local expectedCells = #()
  local expectedCurrentIndex = 0
  local expectedVisibility = true

  local testNotification
  fn testNotification context type param = (
    -- format "testNotification type:% param:%\n" type param
    case type of (
      (#CurrentIndex): (
        actual = ::TestValueStruct (testObj.GetCurrentIndex())
        expected = ::TestValueStruct expectedCurrentIndex
        assert (actual.Equals expected == true)
      )
      (#LayoutAdded): (
        actual = ::TestValueStruct (testObj.GetCells())
        expected = ::TestValueStruct expectedCells
        assert (actual.Equals expected == true)
      )
      (#RectUpdated): ()
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
  local layout3 = undefined
  local widget1 = FlexTestWidgetStruct 1
  local widget2 = FlexTestWidgetStruct 2

  testDef = ::flexUIDefinitionPool[@"Model\Layout\FlexStackedLayout.ms"]
  testObj = testDef()

  testObj.AddObserver (::std.ObserverStruct testNotification testObj)
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* AddLayout */
  -- 無効な値
  actual = ::TestValueStruct (testObj.AddLayout 1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.AddLayout testObj)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 成功（ストレッチ）
  expectedCells = #(
    boxCellDef layout1
  )
  actual = ::TestValueStruct (testObj.AddLayout layout1 index:1)
  expected = ::TestValueStruct expectedCells[1]
  assert (actual.Equals expected == true)
  -- 成功（固定長）
  expectedCells = #(
    boxCellDef layout2,
    boxCellDef layout1
  )
  actual = ::TestValueStruct (testObj.AddLayout layout2)
  expected = ::TestValueStruct expectedCells[1]
  assert (actual.Equals expected == true)

  /* AddWidget */
  -- 無効な値
  actual = ::TestValueStruct (testObj.AddWidget 1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.AddWidget layout1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 成功（ストレッチ）
  expectedCells = #(
    boxCellDef layout2,
    boxCellDef layout1,
    boxCellDef widget1
  )
  actual = ::TestValueStruct (testObj.AddWidget widget1)
  expected = ::TestValueStruct expectedCells[3]
  assert (actual.Equals expected == true)
  -- 重複登録はできない
  actual = ::TestValueStruct (testObj.AddWidget widget1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 成功（固定長）
  expectedCells = #(
    boxCellDef layout2,
    boxCellDef layout1,
    boxCellDef widget2,
    boxCellDef widget1
  )
  actual = ::TestValueStruct (testObj.AddWidget widget2 index:3)
  expected = ::TestValueStruct expectedCells[3]
  assert (actual.Equals expected == true)

  /* GetCells */
  expectedCells = #(
    boxCellDef layout2,
    boxCellDef layout1,
    boxCellDef widget2,
    boxCellDef widget1
  )
  actual = ::TestValueStruct (testObj.GetCells())
  expected = ::TestValueStruct expectedCells
  assert (actual.Equals expected == true)

  /* GetCurrentIndex */
  -- 既定値
  expectedCurrentIndex = 0
  actual = ::TestValueStruct (testObj.GetCurrentIndex())
  expected = ::TestValueStruct expectedCurrentIndex
  assert (actual.Equals expected == true)

  /* GetVisibility */
  -- 既定値
  expectedVisibility = true
  actual = ::TestValueStruct (testObj.GetVisibility())
  expected = ::TestValueStruct expectedVisibility
  assert (actual.Equals expected == true)
  -- セルのアイテムの可視性を確認
  assert (testCellItemVisibility #{})

  /* SetCurrentIndex */
  -- 無効な値
  expectedCurrentIndex = 0
  actual = ::TestValueStruct (testObj.SetCurrentIndex #Foo)
  expected = ::TestValueStruct expectedCurrentIndex
  assert (actual.Equals expected == true)
  -- 範囲外
  expectedCurrentIndex = 0
  actual = ::TestValueStruct (testObj.SetCurrentIndex -1)
  expected = ::TestValueStruct expectedCurrentIndex
  assert (actual.Equals expected == true)
  -- 範囲外
  expectedCurrentIndex = 0
  actual = ::TestValueStruct (testObj.SetCurrentIndex 5)
  expected = ::TestValueStruct expectedCurrentIndex
  assert (actual.Equals expected == true)
  -- 成功
  expectedCurrentIndex = 2
  actual = ::TestValueStruct (testObj.SetCurrentIndex 2)
  expected = ::TestValueStruct expectedCurrentIndex
  assert (actual.Equals expected == true)
  -- セルのアイテムの可視性を確認
  assert (testCellItemVisibility #{2})

  /* SetRect */
  -- 余白を設定
  testObj.Options.SetMargin 10 10
  testObj.Options.SetPadding 10 10 10 10
  -- 通常
  actual = ::TestValueStruct (testObj.SetRect (Box2 10 10 100 100))
  expected = ::TestValueStruct #(
    Box2 20 20 80 80,
    Box2 20 20 80 80,
    Box2 20 20 80 80,
    Box2 20 20 80 80
  )
  assert (actual.Equals expected == true)
  -- 最小値
  actual = ::TestValueStruct (testObj.SetRect (Box2 10 10 10 10))
  expected = ::TestValueStruct #(
    Box2 20 20 1 1,
    Box2 20 20 1 1,
    Box2 20 20 1 1,
    Box2 20 20 1 1
  )
  assert (actual.Equals expected == true)

  /* SetVisibility */
  expectedVisibility = false
  actual = ::TestValueStruct (testObj.SetVisibility false)
  expected = ::TestValueStruct expectedVisibility
  assert (actual.Equals expected == true)
  -- セルのアイテムの可視性を確認
  assert (testCellItemVisibility #{})

  -- testObj.Dump()

  /* プロパティを既定値に設定 */
  expectedCurrentIndex = 0
  actual = ::TestValueStruct (testObj.SetCurrentIndex 0)
  expected = ::TestValueStruct expectedCurrentIndex
  assert (actual.Equals expected == true)
  expectedVisibility = true
  actual = ::TestValueStruct (testObj.SetVisibility true)
  expected = ::TestValueStruct expectedVisibility
  assert (actual.Equals expected == true)

  /* Equals */
  layout3 = testDef()
  layout3.AddLayout layout1
  layout3.AddLayout layout2 index:1
  layout3.AddWidget widget1
  layout3.AddWidget widget2 index:3
  actual = ::TestValueStruct testObj
  expected = ::TestValueStruct layout3
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
