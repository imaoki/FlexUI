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

  local expectedCells = #()
  local expectedVisibility = true

  local testNotification
  fn testNotification type param = (
    -- format "testNotification type:% param:%\n" type param
    case type of (
      (#LayoutAdded): (
        actual = ::TestValueStruct (testObj.GetCells())
        expected = ::TestValueStruct expectedCells
        assert (actual.Equals expected == true)
      )
      (#RectUpdated): ()
      (#SpaceAdded): (
        actual = ::TestValueStruct (testObj.GetCells())
        expected = ::TestValueStruct expectedCells
        assert (actual.Equals expected == true)
      )
      (#StretchAdded): (
        actual = ::TestValueStruct (testObj.GetCells())
        expected = ::TestValueStruct expectedCells
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
  local layout3 = undefined
  local widget1 = FlexTestWidgetStruct 1
  local widget2 = FlexTestWidgetStruct 2

  testDef = ::flexUIDefinitionPool[@"Model\Layout\FlexVBoxLayout.ms"]
  testObj = testDef()

  testObj.StateChanged.Subscribe (::std.ObserverStruct testNotification)
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
  actual = ::TestValueStruct (testObj.AddLayout layout1)
  expected = ::TestValueStruct expectedCells[1]
  assert (actual.Equals expected == true)
  -- 成功（固定長）
  expectedCells = #(
    boxCellDef layout1,
    boxCellDef layout2 1 1 20
  )
  actual = ::TestValueStruct (testObj.AddLayout layout2 fixedLength:20)
  expected = ::TestValueStruct expectedCells[2]
  assert (actual.Equals expected == true)

  /* AddSpace */
  -- 無効な値
  actual = ::TestValueStruct (testObj.AddSpace 1.0)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.AddSpace 0)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 成功
  expectedCells = #(
    boxCellDef layout1,
    boxCellDef layout2 1 1 20,
    boxCellDef 10
  )
  actual = ::TestValueStruct (testObj.AddSpace 10)
  expected = ::TestValueStruct expectedCells[3]
  assert (actual.Equals expected == true)

  /* AddStretch */
  -- 成功
  expectedCells = #(
    boxCellDef layout1,
    boxCellDef layout2 1 1 20,
    boxCellDef 10,
    boxCellDef -1 2
  )
  actual = ::TestValueStruct (testObj.AddStretch stretch:2)
  expected = ::TestValueStruct expectedCells[4]
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
    boxCellDef layout1,
    boxCellDef layout2 1 1 20,
    boxCellDef 10,
    boxCellDef -1 2,
    boxCellDef widget1 1 10
  )
  actual = ::TestValueStruct (testObj.AddWidget widget1 minimum:10)
  expected = ::TestValueStruct expectedCells[5]
  assert (actual.Equals expected == true)
  -- 重複登録はできない
  actual = ::TestValueStruct (testObj.AddWidget widget1 minimum:10)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 成功（固定長）
  expectedCells = #(
    boxCellDef layout1,
    boxCellDef layout2 1 1 20,
    boxCellDef 10,
    boxCellDef -1 2,
    boxCellDef widget1 1 10,
    boxCellDef widget2 1 1 20
  )
  actual = ::TestValueStruct (testObj.AddWidget widget2 fixedLength:20)
  expected = ::TestValueStruct expectedCells[6]
  assert (actual.Equals expected == true)

  /* GetCells */
  expectedCells = #(
    boxCellDef layout1,
    boxCellDef layout2 1 1 20,
    boxCellDef 10,
    boxCellDef -1 2,
    boxCellDef widget1 1 10,
    boxCellDef widget2 1 1 20
  )
  actual = ::TestValueStruct (testObj.GetCells())
  expected = ::TestValueStruct expectedCells
  assert (actual.Equals expected == true)

  /* GetVisibility */
  expectedVisibility = true
  actual = ::TestValueStruct (testObj.GetVisibility())
  expected = ::TestValueStruct expectedVisibility
  assert (actual.Equals expected == true)

  /* SetRect */
  -- 余白を設定
  testObj.Options.SetMargin 10 10
  testObj.Options.SetPadding 10 10 10 10
  -- 通常
  actual = ::TestValueStruct (testObj.SetRect (Box2 10 10 160 160))
  expected = ::TestValueStruct #(
    Box2 20 20 140 10,
    Box2 20 40 140 20,
    Box2 20 70 140 10,
    Box2 20 90 140 20,
    Box2 20 120 140 10,
    Box2 20 140 140 20
  )
  assert (actual.Equals expected == true)
  -- 最小値
  actual = ::TestValueStruct (testObj.SetRect (Box2 10 10 10 10))
  expected = ::TestValueStruct #(
    Box2 20 20 1 1,
    Box2 20 31 1 20,
    Box2 20 61 1 10,
    Box2 20 81 1 1,
    Box2 20 92 1 10,
    Box2 20 112 1 20
  )
  assert (actual.Equals expected == true)

  /* SetVisibility */
  expectedVisibility = false
  actual = ::TestValueStruct (testObj.SetVisibility false)
  expected = ::TestValueStruct expectedVisibility
  assert (actual.Equals expected == true)

  -- testObj.Dump()

  /* Equals */
  layout3 = testDef()
  layout3.AddLayout layout1
  layout3.AddLayout layout2 fixedLength:20
  layout3.AddSpace 10
  layout3.AddStretch stretch:2
  layout3.AddWidget widget1 minimum:10
  layout3.AddWidget widget2 fixedLength:20
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
