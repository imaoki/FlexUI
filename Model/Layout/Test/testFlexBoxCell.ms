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
  local FlexTestLayoutStruct
  local FlexTestWidgetStruct

  struct FlexTestLayoutStruct (
    public fn SetRect rect = (),

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

    /*-
    @returns <Integer|UndefinedClass>
    */
    public fn GetId = (
      this.id
    ),

    public fn SetRect rect = (),

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
          and obj.GetId() == this.GetId()

      isEqualStructName and isEqualProperties
    ),

    on Create do (
      this.id = copy this._CP1_
    )
  )

  local expectedFixedLength = undefined
  local expectedItem = undefined
  local expectedMinimum = 1
  local expectedStretch = 1
  local expectedType = undefined

  local testNotification
  fn testNotification type param = (
    -- format "testNotification type:% param:%\n" type param
    case type of (
      (#FixedLength): (
        actual = ::TestValueStruct (testObj.GetFixedLength())
        expected = ::TestValueStruct expectedFixedLength
        assert (actual.Equals expected == true)
      )
      (#Item): (
        actual = ::TestValueStruct (testObj.GetItem())
        expected = ::TestValueStruct expectedItem
        assert (actual.Equals expected == true)
        actual = ::TestValueStruct (testObj.GetType())
        expected = ::TestValueStruct expectedType
        assert (actual.Equals expected == true)
      )
      (#Minimum): (
        actual = ::TestValueStruct (testObj.GetMinimum())
        expected = ::TestValueStruct expectedMinimum
        assert (actual.Equals expected == true)
      )
      (#Stretch): (
        actual = ::TestValueStruct (testObj.GetStretch())
        expected = ::TestValueStruct expectedStretch
        assert (actual.Equals expected == true)
      )
      default: ()
    )
    ok
  )

  local layout = FlexTestLayoutStruct()
  local widget = FlexTestWidgetStruct()

  fileIn (pathUtility.GetFullPath @"..\..\..\definitionPool.ms")
  testDef = ::flexUIDefinitionPool[@"Model\Layout\FlexBoxCell.ms"]
  testObj = testDef()

  testObj.StateChanged.Subscribe (::std.ObserverStruct testNotification)
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* GetFixedLength */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetFixedLength())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetItem */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetItem())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetMinimum */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetMinimum())
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)

  /* GetStretch */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetStretch())
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)

  /* GetType */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetType())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* SetFixedLength */
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetFixedLength widget)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetFixedLength #Foo)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 成功
  expectedFixedLength = 3
  actual = ::TestValueStruct (testObj.SetFixedLength 3)
  expected = ::TestValueStruct expectedFixedLength
  assert (actual.Equals expected == true)
  -- 浮動小数
  expectedFixedLength = 2
  actual = ::TestValueStruct (testObj.SetFixedLength 2.0)
  expected = ::TestValueStruct expectedFixedLength
  assert (actual.Equals expected == true)
  -- 範囲外
  expectedFixedLength = 1
  actual = ::TestValueStruct (testObj.SetFixedLength 0)
  expected = ::TestValueStruct expectedFixedLength
  assert (actual.Equals expected == true)

  /* SetItem */
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetItem undefined)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetItem 0)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetItem -2)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetItem 1.0)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetItem #Foo)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- レイアウト
  expectedItem = layout
  expectedType = #Layout
  actual = ::TestValueStruct (testObj.SetItem layout)
  expected = ::TestValueStruct expectedItem
  assert (actual.Equals expected == true)
  -- スペース
  expectedItem = 1
  expectedType = #Space
  actual = ::TestValueStruct (testObj.SetItem 1)
  expected = ::TestValueStruct expectedItem
  assert (actual.Equals expected == true)
  -- ストレッチ
  expectedItem = -1
  expectedType = #Stretch
  actual = ::TestValueStruct (testObj.SetItem -1)
  expected = ::TestValueStruct expectedItem
  assert (actual.Equals expected == true)
  -- ウィジェット
  expectedItem = widget
  expectedType = #Widget
  actual = ::TestValueStruct (testObj.SetItem widget)
  expected = ::TestValueStruct expectedItem
  assert (actual.Equals expected == true)

  /* SetMinimum */
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetMinimum widget)
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetMinimum #Foo)
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- 成功
  expectedMinimum = 3
  actual = ::TestValueStruct (testObj.SetMinimum 3)
  expected = ::TestValueStruct expectedMinimum
  assert (actual.Equals expected == true)
  -- 浮動小数
  expectedMinimum = 2
  actual = ::TestValueStruct (testObj.SetMinimum 2.0)
  expected = ::TestValueStruct expectedMinimum
  assert (actual.Equals expected == true)
  -- 範囲外
  expectedMinimum = 1
  actual = ::TestValueStruct (testObj.SetMinimum 0)
  expected = ::TestValueStruct expectedMinimum
  assert (actual.Equals expected == true)

  /* SetStretch */
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetStretch widget)
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetStretch #Foo)
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- 成功
  expectedStretch = 3
  actual = ::TestValueStruct (testObj.SetStretch 3)
  expected = ::TestValueStruct expectedStretch
  assert (actual.Equals expected == true)
  -- 浮動小数
  expectedStretch = 2
  actual = ::TestValueStruct (testObj.SetStretch 2.0)
  expected = ::TestValueStruct expectedStretch
  assert (actual.Equals expected == true)
  -- 範囲外
  expectedStretch = 1
  actual = ::TestValueStruct (testObj.SetStretch 0)
  expected = ::TestValueStruct expectedStretch
  assert (actual.Equals expected == true)

  /* 作成パラメータ */
  -- レイアウト
  expectedFixedLength = 20
  expectedItem = layout
  expectedMinimum = 10
  expectedStretch = 2
  expectedType = #Layout
  testObj = testDef layout 2 10 20
  testObj.StateChanged.Subscribe (::std.ObserverStruct testNotification)
  actual = ::TestValueStruct (testObj.GetFixedLength())
  expected = ::TestValueStruct expectedFixedLength
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetItem())
  expected = ::TestValueStruct expectedItem
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetMinimum())
  expected = ::TestValueStruct expectedMinimum
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetStretch())
  expected = ::TestValueStruct expectedStretch
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetType())
  expected = ::TestValueStruct expectedType
  assert (actual.Equals expected == true)
  -- スペース
  expectedFixedLength = 20
  expectedItem = 5
  expectedMinimum = 10
  expectedStretch = 2
  expectedType = #Space
  testObj = testDef 5 2 10 20
  testObj.StateChanged.Subscribe (::std.ObserverStruct testNotification)
  actual = ::TestValueStruct (testObj.GetFixedLength())
  expected = ::TestValueStruct expectedFixedLength
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetItem())
  expected = ::TestValueStruct expectedItem
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetMinimum())
  expected = ::TestValueStruct expectedMinimum
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetStretch())
  expected = ::TestValueStruct expectedStretch
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetType())
  expected = ::TestValueStruct expectedType
  assert (actual.Equals expected == true)
  -- ストレッチ
  expectedFixedLength = 20
  expectedItem = -1
  expectedMinimum = 10
  expectedStretch = 2
  expectedType = #Stretch
  testObj = testDef -1 2 10 20
  testObj.StateChanged.Subscribe (::std.ObserverStruct testNotification)
  actual = ::TestValueStruct (testObj.GetFixedLength())
  expected = ::TestValueStruct expectedFixedLength
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetItem())
  expected = ::TestValueStruct expectedItem
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetMinimum())
  expected = ::TestValueStruct expectedMinimum
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetStretch())
  expected = ::TestValueStruct expectedStretch
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetType())
  expected = ::TestValueStruct expectedType
  assert (actual.Equals expected == true)
  -- ウィジェット
  expectedFixedLength = 20
  expectedItem = widget
  expectedMinimum = 10
  expectedStretch = 2
  expectedType = #Widget
  testObj = testDef widget 2 10 20
  testObj.StateChanged.Subscribe (::std.ObserverStruct testNotification)
  actual = ::TestValueStruct (testObj.GetFixedLength())
  expected = ::TestValueStruct expectedFixedLength
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetItem())
  expected = ::TestValueStruct expectedItem
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetMinimum())
  expected = ::TestValueStruct expectedMinimum
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetStretch())
  expected = ::TestValueStruct expectedStretch
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetType())
  expected = ::TestValueStruct expectedType
  assert (actual.Equals expected == true)

  -- testObj.Dump()

  /* Equals */
  -- 等しくない
  actual = ::TestValueStruct (testDef layout)
  expected = ::TestValueStruct (testDef widget)
  assert (actual.Equals expected == false)
  -- 等しくない
  actual = ::TestValueStruct (testDef layout 1)
  expected = ::TestValueStruct (testDef layout 2)
  assert (actual.Equals expected == false)
  -- 等しい
  actual = ::TestValueStruct (testDef layout)
  expected = ::TestValueStruct (testDef layout)
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
