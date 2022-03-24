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
  local expectedAlignmentH = #Center
  local expectedAlignmentV = #Center
  local expectedCaptionMargin = 3
  local expectedCaptionPosition = #CenterLeft
  local expectedControl = undefined
  local expectedExplicitH = undefined
  local expectedExplicitW = undefined
  local expectedRect = undefined
  local expectedVisibility = undefined

  local updateObject
  fn updateObject context params type: = (
    -- format "updateObject params:% type:%\n" params type
    if classOf params == Array do (
      for param in params do (
        case param of (
          (#AlignmentH): (
            actual = ::TestValueStruct (testObj.GetAlignmentH())
            expected = ::TestValueStruct expectedAlignmentH
            assert (actual.Equals expected == true)
          )
          (#AlignmentV): (
            actual = ::TestValueStruct (testObj.GetAlignmentV())
            expected = ::TestValueStruct expectedAlignmentV
            assert (actual.Equals expected == true)
          )
          (#CaptionMargin): (
            actual = ::TestValueStruct (testObj.GetCaptionMargin())
            expected = ::TestValueStruct expectedCaptionMargin
            assert (actual.Equals expected == true)
          )
          (#CaptionPosition): (
            actual = ::TestValueStruct (testObj.GetCaptionPosition())
            expected = ::TestValueStruct expectedCaptionPosition
            assert (actual.Equals expected == true)
          )
          (#Control): (
            actual = ::TestValueStruct (testObj.GetControl())
            expected = ::TestValueStruct expectedControl
            assert (actual.Equals expected == true)
          )
          (#ExplicitH): (
            actual = ::TestValueStruct (testObj.GetExplicitH())
            expected = ::TestValueStruct expectedExplicitH
            assert (actual.Equals expected == true)
          )
          (#ExplicitW): (
            actual = ::TestValueStruct (testObj.GetExplicitW())
            expected = ::TestValueStruct expectedExplicitW
            assert (actual.Equals expected == true)
          )
          (#RectUpdated): (
            actual = ::TestValueStruct (testObj.GetRect())
            expected = ::TestValueStruct expectedRect
            assert (actual.Equals expected == true)
          )
          (#Visibility): (
            actual = ::TestValueStruct (testObj.GetVisibility())
            expected = ::TestValueStruct expectedVisibility
            assert (actual.Equals expected == true)
          )
          default: ()
        )
      )
    )
    ok
  )

  local RltTest
  rollout RltTest "FlexColorPickerControlWidget" (
    colorPicker Cpk "ColorPickerControl" color:(Color 63 63 63)

    on RltTest Open do (
      testObj = testDef Cpk

      /* SetAlignmentH */
      expectedAlignmentH = #Left
      actual = ::TestValueStruct (testObj.SetAlignmentH #Left)
      expected = ::TestValueStruct expectedAlignmentH
      assert (actual.Equals expected == true)

      /* SetAlignmentV */
      expectedAlignmentV = #Top
      actual = ::TestValueStruct (testObj.SetAlignmentV #Top)
      expected = ::TestValueStruct expectedAlignmentV
      assert (actual.Equals expected == true)

      /* SetRect */
      expectedRect = Box2 30 30 100 20
      actual = ::TestValueStruct (testObj.SetRect (Box2 30 30 100 100))
      expected = ::TestValueStruct expectedRect
      assert (actual.Equals expected == true)

      /* GetRect */
      actual = ::TestValueStruct (testObj.GetRect())
      expected = ::TestValueStruct expectedRect
      assert (actual.Equals expected == true)

      /* GetVisibility */
      expectedVisibility = true
      actual = ::TestValueStruct (testObj.GetVisibility())
      expected = ::TestValueStruct expectedVisibility
      assert (actual.Equals expected == true)

      /* SetVisibility */
      expectedVisibility = false
      actual = ::TestValueStruct (testObj.SetVisibility false)
      expected = ::TestValueStruct expectedVisibility
      assert (actual.Equals expected == true)

      /* UI非表示 */
      destroyDialog RltTest
    )
    on RltTest Resized v do ()
  )

  fileIn (pathUtility.GetFullPath @"..\..\..\definitionPool.ms")
  testDef = ::flexUIDefinitionPool[@"Model\Widget\FlexColorPickerControlWidget.ms"]
  testObj = testDef()

  testObj.AddObserver (::std.ObserverStruct updateObject testObj)
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* Equals */
  actual = ::TestValueStruct testObj
  expected = ::TestValueStruct (testDef())
  assert (actual.Equals expected == true)

  /* GetAlignmentH */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetAlignmentH())
  expected = ::TestValueStruct #Center
  assert (actual.Equals expected == true)

  /* GetAlignmentV */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetAlignmentV())
  expected = ::TestValueStruct #Center
  assert (actual.Equals expected == true)

  /* GetCaptionMargin */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetCaptionMargin())
  expected = ::TestValueStruct 3
  assert (actual.Equals expected == true)

  /* GetCaptionPosition */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetCaptionPosition())
  expected = ::TestValueStruct #Left
  assert (actual.Equals expected == true)

  /* GetControl */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetControl())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetDefaultH */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetDefaultH())
  expected = ::TestValueStruct 20
  assert (actual.Equals expected == true)

  /* GetDefaultW */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetDefaultW())
  expected = ::TestValueStruct -1
  assert (actual.Equals expected == true)

  /* GetExplicitH */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetExplicitH())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetExplicitW */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetExplicitW())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetMinH */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetMinH())
  expected = ::TestValueStruct 5
  assert (actual.Equals expected == true)

  /* GetMinW */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetMinW())
  expected = ::TestValueStruct 5
  assert (actual.Equals expected == true)

  /* GetRect */
  actual = ::TestValueStruct (testObj.GetRect())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetResizableH */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetResizableH())
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  /* GetResizableW */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetResizableW())
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  /* GetVisibility */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetVisibility())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* SetAlignmentH */
  -- 無効な値
  expectedAlignmentH = #Center
  actual = ::TestValueStruct (testObj.SetAlignmentH 0)
  expected = ::TestValueStruct expectedAlignmentH
  assert (actual.Equals expected == true)
  -- 無効な値
  expectedAlignmentH = #Center
  actual = ::TestValueStruct (testObj.SetAlignmentH #Foo)
  expected = ::TestValueStruct expectedAlignmentH
  assert (actual.Equals expected == true)
  -- 成功
  expectedAlignmentH = #Left
  actual = ::TestValueStruct (testObj.SetAlignmentH #Left)
  expected = ::TestValueStruct expectedAlignmentH
  assert (actual.Equals expected == true)

  /* SetAlignmentV */
  -- 無効な値
  expectedAlignmentV = #Center
  actual = ::TestValueStruct (testObj.SetAlignmentV 0)
  expected = ::TestValueStruct expectedAlignmentV
  assert (actual.Equals expected == true)
  -- 無効な値
  expectedAlignmentV = #Center
  actual = ::TestValueStruct (testObj.SetAlignmentV #Foo)
  expected = ::TestValueStruct expectedAlignmentV
  assert (actual.Equals expected == true)
  -- 成功
  expectedAlignmentV = #Top
  actual = ::TestValueStruct (testObj.SetAlignmentV #Top)
  expected = ::TestValueStruct expectedAlignmentV
  assert (actual.Equals expected == true)

  /* SetCaptionMargin */
  -- 無効な値
  expectedCaptionMargin = 3
  actual = ::TestValueStruct (testObj.SetCaptionMargin #Foo)
  expected = ::TestValueStruct expectedCaptionMargin
  assert (actual.Equals expected == true)
  -- 範囲外の値は補正される
  expectedCaptionMargin = 0
  actual = ::TestValueStruct (testObj.SetCaptionMargin -1)
  expected = ::TestValueStruct expectedCaptionMargin
  assert (actual.Equals expected == true)
  -- 成功
  expectedCaptionMargin = 10
  actual = ::TestValueStruct (testObj.SetCaptionMargin 10)
  expected = ::TestValueStruct expectedCaptionMargin
  assert (actual.Equals expected == true)

  /* SetCaptionPosition */
  -- 無効な値
  expectedCaptionPosition = #Left
  actual = ::TestValueStruct (testObj.SetCaptionPosition 0)
  expected = ::TestValueStruct expectedCaptionPosition
  assert (actual.Equals expected == true)
  -- 無効な値
  expectedCaptionPosition = #Left
  actual = ::TestValueStruct (testObj.SetCaptionPosition #Foo)
  expected = ::TestValueStruct expectedCaptionPosition
  assert (actual.Equals expected == true)
  -- 成功
  expectedCaptionPosition = #Top
  actual = ::TestValueStruct (testObj.SetCaptionPosition #Top)
  expected = ::TestValueStruct expectedCaptionPosition
  assert (actual.Equals expected == true)

  /* SetControl */
  -- 無効な値
  expectedControl = undefined
  actual = ::TestValueStruct (testObj.SetControl RltTest)
  expected = ::TestValueStruct expectedControl
  assert (actual.Equals expected == true)
  -- 成功
  expectedControl = RltTest.Cpk
  actual = ::TestValueStruct (testObj.SetControl RltTest.Cpk)
  expected = ::TestValueStruct expectedControl
  assert (actual.Equals expected == true)

  /* SetExplicitH */
  -- 無効な値
  expectedExplicitH = undefined
  actual = ::TestValueStruct (testObj.SetExplicitH #Foo)
  expected = ::TestValueStruct expectedExplicitH
  assert (actual.Equals expected == true)
  -- 範囲外の値は補正される
  expectedExplicitH = 0
  actual = ::TestValueStruct (testObj.SetExplicitH -1)
  expected = ::TestValueStruct expectedExplicitH
  assert (actual.Equals expected == true)
  -- 成功
  expectedExplicitH = 10
  actual = ::TestValueStruct (testObj.SetExplicitH 10)
  expected = ::TestValueStruct expectedExplicitH
  assert (actual.Equals expected == true)
  -- 成功
  expectedExplicitH = undefined
  actual = ::TestValueStruct (testObj.SetExplicitH undefined)
  expected = ::TestValueStruct expectedExplicitH
  assert (actual.Equals expected == true)

  /* SetExplicitW */
  -- 無効な値
  expectedExplicitW = undefined
  actual = ::TestValueStruct (testObj.SetExplicitW #Foo)
  expected = ::TestValueStruct expectedExplicitW
  assert (actual.Equals expected == true)
  -- 範囲外の値は補正される
  expectedExplicitW = 0
  actual = ::TestValueStruct (testObj.SetExplicitW -1)
  expected = ::TestValueStruct expectedExplicitW
  assert (actual.Equals expected == true)
  -- 成功
  expectedExplicitW = 10
  actual = ::TestValueStruct (testObj.SetExplicitW 10)
  expected = ::TestValueStruct expectedExplicitW
  assert (actual.Equals expected == true)
  -- 成功
  expectedExplicitW = undefined
  actual = ::TestValueStruct (testObj.SetExplicitW undefined)
  expected = ::TestValueStruct expectedExplicitW
  assert (actual.Equals expected == true)

  /* SetRect */
  -- ロールアウトコントロールが無効
  expectedRect = undefined
  actual = ::TestValueStruct (testObj.SetRect (Box2 0 0 100 100))
  expected = ::TestValueStruct expectedRect
  assert (actual.Equals expected == true)

  /* SetVisibility */
  -- 無効な値
  expectedVisibility = true
  actual = ::TestValueStruct (testObj.SetVisibility #Foo)
  expected = ::TestValueStruct expectedVisibility
  assert (actual.Equals expected == true)
  -- 無効な値
  expectedVisibility = true
  actual = ::TestValueStruct (testObj.SetVisibility 1)
  expected = ::TestValueStruct expectedVisibility
  assert (actual.Equals expected == true)
  -- 成功
  expectedVisibility = false
  actual = ::TestValueStruct (testObj.SetVisibility false)
  expected = ::TestValueStruct expectedVisibility
  assert (actual.Equals expected == true)

  /* UI表示 */
  createDialog RltTest 160 160 \
      bgColor:(Color 31 95 95) \
      style:#(
        /* #Style_Border, */
        /* #Style_MaximizeBox, */
        /* #Style_MinimizeBox, */
        /* #Style_Sunkenedge, */
        /* #Style_TitleBar, */
        #Style_Resizing,
        #Style_Sysmenu,
        #Style_ToolWindow
      )
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
