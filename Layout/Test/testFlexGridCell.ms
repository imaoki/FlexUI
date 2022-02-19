/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  -- clearListener()

  local nowTime = (DotNetClass "System.DateTime").Now.ToString "HH:mm:ss"
  local sw = DotNetObject "System.Diagnostics.Stopwatch"

  local currentFile = getSourceFileName()
  local pathUtility = ::PathUtilityStruct currentFile

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

  local expectedColumn = 1
  local expectedColumnSpan = 1
  local expectedItem = undefined
  local expectedRow = 1
  local expectedRowSpan = 1
  local expectedType = undefined

  local updateObject
  fn updateObject context params type: = (
    -- format "updateObject params:% type:%\n" params type
    if classOf params == Array do (
      for param in params do (
        case param of (
          (#Column): (
            actual = ::TestValueStruct (testObj.GetColumn())
            expected = ::TestValueStruct expectedColumn
            assert (actual.Equals expected == true)
          )
          (#ColumnSpan): (
            actual = ::TestValueStruct (testObj.GetColumnSpan())
            expected = ::TestValueStruct expectedColumnSpan
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
          (#Row): (
            actual = ::TestValueStruct (testObj.GetRow())
            expected = ::TestValueStruct expectedRow
            assert (actual.Equals expected == true)
          )
          (#RowSpan): (
            actual = ::TestValueStruct (testObj.GetRowSpan())
            expected = ::TestValueStruct expectedRowSpan
            assert (actual.Equals expected == true)
          )
          default: ()
        )
      )
    )
    ok
  )

  local layout = FlexTestLayoutStruct()
  local widget = FlexTestWidgetStruct()

  testDef = fileIn (pathUtility.GetFullPath @"..\FlexGridCell.ms")
  testObj = testDef()

  testObj.AddObserver (::ObserverStruct updateObject testObj)
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* GetColumn */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetColumn())
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)

  /* GetColumnSpan */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetColumnSpan())
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)

  /* GetItem */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetItem())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetRow */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetRow())
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)

  /* GetRowSpan */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetRowSpan())
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)

  /* GetType */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetType())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* SetColumn */
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetColumn widget)
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetColumn #Foo)
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- 成功
  expectedColumn = 3
  actual = ::TestValueStruct (testObj.SetColumn 3)
  expected = ::TestValueStruct expectedColumn
  assert (actual.Equals expected == true)
  -- 浮動小数
  expectedColumn = 2
  actual = ::TestValueStruct (testObj.SetColumn 2.0)
  expected = ::TestValueStruct expectedColumn
  assert (actual.Equals expected == true)
  -- 範囲外
  expectedColumn = 1
  actual = ::TestValueStruct (testObj.SetColumn 0)
  expected = ::TestValueStruct expectedColumn
  assert (actual.Equals expected == true)

  /* SetColumnSpan */
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetColumnSpan widget)
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetColumnSpan #Foo)
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- 成功
  expectedColumnSpan = 3
  actual = ::TestValueStruct (testObj.SetColumnSpan 3)
  expected = ::TestValueStruct expectedColumnSpan
  assert (actual.Equals expected == true)
  -- 浮動小数
  expectedColumnSpan = 2
  actual = ::TestValueStruct (testObj.SetColumnSpan 2.0)
  expected = ::TestValueStruct expectedColumnSpan
  assert (actual.Equals expected == true)
  -- 範囲外
  expectedColumnSpan = 1
  actual = ::TestValueStruct (testObj.SetColumnSpan 0)
  expected = ::TestValueStruct expectedColumnSpan
  assert (actual.Equals expected == true)

  /* SetItem */
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetItem undefined)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetItem 1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetItem -1)
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
  -- ウィジェット
  expectedItem = widget
  expectedType = #Widget
  actual = ::TestValueStruct (testObj.SetItem widget)
  expected = ::TestValueStruct expectedItem
  assert (actual.Equals expected == true)

  /* SetRow */
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetRow widget)
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetRow #Foo)
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- 成功
  expectedRow = 3
  actual = ::TestValueStruct (testObj.SetRow 3)
  expected = ::TestValueStruct expectedRow
  assert (actual.Equals expected == true)
  -- 浮動小数
  expectedRow = 2
  actual = ::TestValueStruct (testObj.SetRow 2.0)
  expected = ::TestValueStruct expectedRow
  assert (actual.Equals expected == true)
  -- 範囲外
  expectedRow = 1
  actual = ::TestValueStruct (testObj.SetRow 0)
  expected = ::TestValueStruct expectedRow
  assert (actual.Equals expected == true)

  /* SetRowSpan */
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetRowSpan widget)
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetRowSpan #Foo)
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- 成功
  expectedRowSpan = 3
  actual = ::TestValueStruct (testObj.SetRowSpan 3)
  expected = ::TestValueStruct expectedRowSpan
  assert (actual.Equals expected == true)
  -- 浮動小数
  expectedRowSpan = 2
  actual = ::TestValueStruct (testObj.SetRowSpan 2.0)
  expected = ::TestValueStruct expectedRowSpan
  assert (actual.Equals expected == true)
  -- 範囲外
  expectedRowSpan = 1
  actual = ::TestValueStruct (testObj.SetRowSpan 0)
  expected = ::TestValueStruct expectedRowSpan
  assert (actual.Equals expected == true)

  /* 作成パラメータ */
  -- レイアウト
  local expectedColumn = 2
  local expectedColumnSpan = 4
  local expectedItem = layout
  local expectedRow = 1
  local expectedRowSpan = 3
  local expectedType = #Layout
  testObj = testDef layout 1 2 3 4
  testObj.AddObserver (::ObserverStruct updateObject testObj)
  actual = ::TestValueStruct (testObj.GetColumn())
  expected = ::TestValueStruct expectedColumn
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetColumnSpan())
  expected = ::TestValueStruct expectedColumnSpan
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetItem())
  expected = ::TestValueStruct expectedItem
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetRow())
  expected = ::TestValueStruct expectedRow
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetRowSpan())
  expected = ::TestValueStruct expectedRowSpan
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetType())
  expected = ::TestValueStruct expectedType
  assert (actual.Equals expected == true)
  -- ウィジェット
  local expectedColumn = 2
  local expectedColumnSpan = 4
  local expectedItem = widget
  local expectedRow = 1
  local expectedRowSpan = 3
  local expectedType = #Widget
  testObj = testDef widget 1 2 3 4
  testObj.AddObserver (::ObserverStruct updateObject testObj)
  actual = ::TestValueStruct (testObj.GetColumn())
  expected = ::TestValueStruct expectedColumn
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetColumnSpan())
  expected = ::TestValueStruct expectedColumnSpan
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetItem())
  expected = ::TestValueStruct expectedItem
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetRow())
  expected = ::TestValueStruct expectedRow
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (testObj.GetRowSpan())
  expected = ::TestValueStruct expectedRowSpan
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
