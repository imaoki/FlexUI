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
  local groupBoxControlWidgetDef = ::flexUIDefinitionPool[@"Model\Widget\FlexGroupBoxControlWidget.ms"]

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

  local expectedCell = undefined
  local expectedVisibility = true

  local testNotification
  fn testNotification type param = (
    -- format "testNotification type:% param:%\n" type param
    case type of (
      (#CellSet): (
        actual = ::TestValueStruct (testObj.GetCell())
        expected = ::TestValueStruct expectedCell
        assert (actual.Equals expected == true)
      )
      (#RectUpdated): ()
      (#VisibilityChanged): (
        actual = ::TestValueStruct (testObj.GetVisibility())
        expected = ::TestValueStruct expectedVisibility
        assert (actual.Equals expected == true)
      )
      default: ()
    )
    ok
  )

  local RltTest
  rollout RltTest "RltTest" (
    groupBox Gbx "GroupBoxControl"

    on RltTest Open do ()
    on RltTest Resized v do ()
  )

  local testInstance
  fn testInstance obj structName = (
    local passCount = 0
    actual = ::TestValueStruct obj
    if assert (actual.IsStructInstance() == true) do passCount += 1
    if assert (actual.HasProp #StructName == true) do passCount += 1
    actual = ::TestValueStruct (obj.StructName())
    expected = ::TestValueStruct structName
    if assert (actual.Equals expected == true) do passCount += 1
    passCount == 3
  )

  local groupBoxWidget = groupBoxControlWidgetDef RltTest.Gbx
  local layout1 = FlexTestLayoutStruct()
  local layout2 = undefined
  local widget = FlexTestWidgetStruct()

  testDef = ::flexUIDefinitionPool[@"Model\Layout\FlexGroupLayout.ms"]
  testObj = testDef()

  testObj.StateChanged.Subscribe testNotification
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* GetGroupBoxWidget */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetGroupBoxWidget())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetCell */
  -- 既定値
  expectedCell = undefined
  actual = ::TestValueStruct (testObj.GetCell())
  expected = ::TestValueStruct expectedCell
  assert (actual.Equals expected == true)

  /* GetVisibility */
  expectedVisibility = undefined
  actual = ::TestValueStruct (testObj.GetVisibility())
  expected = ::TestValueStruct expectedVisibility
  assert (actual.Equals expected == true)

  /* `GroupBoxControl`ウィジェットを指定してインスタンス作成 */
  testObj = testDef groupBoxWidget

  /* GetGroupBoxWidget */
  actual = ::TestValueStruct (testObj.GetGroupBoxWidget())
  expected = ::TestValueStruct groupBoxWidget
  assert (actual.Equals expected == true)

  /* GetVisibility */
  expectedVisibility = true
  actual = ::TestValueStruct (testObj.GetVisibility())
  expected = ::TestValueStruct expectedVisibility
  assert (actual.Equals expected == true)

  /* SetCell */
  -- レイアウト
  expectedCell = boxCellDef layout1
  actual = ::TestValueStruct (testObj.SetCell layout1)
  expected = ::TestValueStruct expectedCell
  assert (actual.Equals expected == true)
  -- ウィジェット
  expectedCell = boxCellDef widget
  actual = ::TestValueStruct (testObj.SetCell widget)
  expected = ::TestValueStruct expectedCell
  assert (actual.Equals expected == true)

  /* GetCell */
  expectedCell = boxCellDef widget
  actual = ::TestValueStruct (testObj.GetCell())
  expected = ::TestValueStruct expectedCell
  assert (actual.Equals expected == true)

  /* SetRect */
  -- 通常
  actual = ::TestValueStruct (testObj.SetRect (Box2 10 10 100 100))
  expected = ::TestValueStruct #(Box2 15 25 90 80)
  assert (actual.Equals expected == true)
  -- 最小値
  actual = ::TestValueStruct (testObj.SetRect (Box2 10 10 10 10))
  expected = ::TestValueStruct #(Box2 15 25 1 1)
  assert (actual.Equals expected == true)

  /* SetVisibility */
  expectedVisibility = false
  actual = ::TestValueStruct (testObj.SetVisibility false)
  expected = ::TestValueStruct expectedVisibility
  assert (actual.Equals expected == true)

  -- testObj.Dump()

  /* Equals */
  layout2 = testDef groupBoxWidget
  layout2.SetCell widget
  actual = ::TestValueStruct testObj
  expected = ::TestValueStruct layout2
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
