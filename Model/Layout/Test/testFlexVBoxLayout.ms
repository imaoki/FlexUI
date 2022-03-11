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

  local expectedCells = #()

  local updateObject
  fn updateObject context params type: = (
    -- format "updateObject params:% type:%\n" params type
    if classOf params == Array do (
      for param in params do (
        case param of (
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
          (#WidgetAdded): (
            actual = ::TestValueStruct (testObj.GetCells())
            expected = ::TestValueStruct expectedCells
            assert (actual.Equals expected == true)
          )
          default: ()
        )
      )
    )
    ok
  )

  local layout1 = undefined
  local layout2 = undefined
  local widget = FlexTestWidgetStruct()

  testDef = ::flexUIDefinitionPool[@"Model\Layout\FlexVBoxLayout.ms"]
  testObj = testDef()

  testObj.AddObserver (::std.ObserverStruct updateObject testObj)
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
  -- 成功
  layout1 = testDef()
  expectedCells = #(
    boxCellDef layout1
  )
  actual = ::TestValueStruct (testObj.AddLayout layout1)
  expected = ::TestValueStruct expectedCells[1]
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
    boxCellDef 10
  )
  actual = ::TestValueStruct (testObj.AddSpace 10)
  expected = ::TestValueStruct expectedCells[2]
  assert (actual.Equals expected == true)

  /* AddStretch */
  -- 成功
  expectedCells = #(
    boxCellDef layout1,
    boxCellDef 10,
    boxCellDef -1 2
  )
  actual = ::TestValueStruct (testObj.AddStretch stretch:2)
  expected = ::TestValueStruct expectedCells[3]
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
  -- 成功
  expectedCells = #(
    boxCellDef layout1,
    boxCellDef 10,
    boxCellDef -1 2,
    boxCellDef widget 1 10
  )
  actual = ::TestValueStruct (testObj.AddWidget widget minimum:10)
  expected = ::TestValueStruct expectedCells[4]
  assert (actual.Equals expected == true)
  -- 重複登録はできない
  actual = ::TestValueStruct (testObj.AddWidget widget minimum:10)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetCells */
  expectedCells = #(
    boxCellDef layout1,
    boxCellDef 10,
    boxCellDef -1 2,
    boxCellDef widget 1 10
  )
  actual = ::TestValueStruct (testObj.GetCells())
  expected = ::TestValueStruct expectedCells
  assert (actual.Equals expected == true)

  /* SetRect */
  -- 余白を設定
  testObj.Options.SetMargin 10 10
  testObj.Options.SetPadding 10 10 10 10
  -- 通常
  actual = ::TestValueStruct (testObj.SetRect (Box2 10 10 100 100))
  expected = ::TestValueStruct #(
    Box2 20 20 80 10,
    Box2 20 40 80 10,
    Box2 20 60 80 20,
    Box2 20 90 80 10
  )
  assert (actual.Equals expected == true)
  -- 最小値
  actual = ::TestValueStruct (testObj.SetRect (Box2 10 10 10 10))
  expected = ::TestValueStruct #(
    Box2 20 20 1 1,
    Box2 20 31 1 10,
    Box2 20 51 1 1,
    Box2 20 62 1 10
  )
  assert (actual.Equals expected == true)

  -- testObj.Dump()

  /* Equals */
  layout2 = testDef()
  layout2.AddLayout layout1
  layout2.AddSpace 10
  layout2.AddStretch stretch:2
  layout2.AddWidget widget minimum:10
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
