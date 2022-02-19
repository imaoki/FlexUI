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
  local expectedMarginH = 0
  local expectedMarginV = 0
  local expectedPaddingB = 0
  local expectedPaddingL = 0
  local expectedPaddingR = 0
  local expectedPaddingT = 0

  local updateObject
  fn updateObject context params type: = (
    -- format "updateObject params:% type:%\n" params type
    if classOf params == Array do (
      for param in params do (
        case param of (
          (#MarginH): (
            actual = ::TestValueStruct (testObj.GetMarginH())
            expected = ::TestValueStruct expectedMarginH
            assert (actual.Equals expected == true)
          )
          (#MarginV): (
            actual = ::TestValueStruct (testObj.GetMarginV())
            expected = ::TestValueStruct expectedMarginV
            assert (actual.Equals expected == true)
          )
          (#PaddingB): (
            actual = ::TestValueStruct (testObj.GetPaddingB())
            expected = ::TestValueStruct expectedPaddingB
            assert (actual.Equals expected == true)
          )
          (#PaddingL): (
            actual = ::TestValueStruct (testObj.GetPaddingL())
            expected = ::TestValueStruct expectedPaddingL
            assert (actual.Equals expected == true)
          )
          (#PaddingR): (
            actual = ::TestValueStruct (testObj.GetPaddingR())
            expected = ::TestValueStruct expectedPaddingR
            assert (actual.Equals expected == true)
          )
          (#PaddingT): (
            actual = ::TestValueStruct (testObj.GetPaddingT())
            expected = ::TestValueStruct expectedPaddingT
            assert (actual.Equals expected == true)
          )
          default: ()
        )
      )
    )
    ok
  )

  testDef = fileIn (pathUtility.GetFullPath @"..\FlexLayoutOptions.ms")
  testObj = testDef()

  testObj.AddObserver (::ObserverStruct updateObject testObj)
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* GetMarginH */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetMarginH())
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)

  /* GetMarginV */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetMarginV())
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)

  /* GetPaddingB */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetPaddingB())
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)

  /* GetPaddingL */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetPaddingL())
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)

  /* GetPaddingR */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetPaddingR())
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)

  /* GetPaddingT */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetPaddingT())
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)

  /* SetMarginH */
  -- 無効な値
  expectedMarginH = 0
  actual = ::TestValueStruct (testObj.SetMarginH undefined)
  expected = ::TestValueStruct expectedMarginH
  assert (actual.Equals expected == true)
  -- 範囲外
  expectedMarginH = 0
  actual = ::TestValueStruct (testObj.SetMarginH -1)
  expected = ::TestValueStruct expectedMarginH
  assert (actual.Equals expected == true)
  -- 成功
  expectedMarginH = 5
  actual = ::TestValueStruct (testObj.SetMarginH 5)
  expected = ::TestValueStruct expectedMarginH
  assert (actual.Equals expected == true)

  /* SetMarginV */
  -- 無効な値
  expectedMarginV = 0
  actual = ::TestValueStruct (testObj.SetMarginV undefined)
  expected = ::TestValueStruct expectedMarginV
  assert (actual.Equals expected == true)
  -- 範囲外
  expectedMarginV = 0
  actual = ::TestValueStruct (testObj.SetMarginV -1)
  expected = ::TestValueStruct expectedMarginV
  assert (actual.Equals expected == true)
  -- 成功
  expectedMarginV = 5
  actual = ::TestValueStruct (testObj.SetMarginV 5)
  expected = ::TestValueStruct expectedMarginV
  assert (actual.Equals expected == true)

  /* SetMargin */
  expectedMarginH = 1
  expectedMarginV = 2
  actual = ::TestValueStruct (testObj.SetMargin 1 2)
  expected = ::TestValueStruct #(
    expectedMarginH,
    expectedMarginV
  )
  assert (actual.Equals expected == true)

  /* SetPaddingB */
  -- 無効な値
  expectedPaddingB = 0
  actual = ::TestValueStruct (testObj.SetPaddingB undefined)
  expected = ::TestValueStruct expectedPaddingB
  assert (actual.Equals expected == true)
  -- 範囲外
  expectedPaddingB = 0
  actual = ::TestValueStruct (testObj.SetPaddingB -1)
  expected = ::TestValueStruct expectedPaddingB
  assert (actual.Equals expected == true)
  -- 成功
  expectedPaddingB = 10
  actual = ::TestValueStruct (testObj.SetPaddingB 10)
  expected = ::TestValueStruct expectedPaddingB
  assert (actual.Equals expected == true)

  /* SetPaddingL */
  -- 無効な値
  expectedPaddingL = 0
  actual = ::TestValueStruct (testObj.SetPaddingL undefined)
  expected = ::TestValueStruct expectedPaddingL
  assert (actual.Equals expected == true)
  -- 範囲外
  expectedPaddingL = 0
  actual = ::TestValueStruct (testObj.SetPaddingL -1)
  expected = ::TestValueStruct expectedPaddingL
  assert (actual.Equals expected == true)
  -- 成功
  expectedPaddingL = 15
  actual = ::TestValueStruct (testObj.SetPaddingL 15)
  expected = ::TestValueStruct expectedPaddingL
  assert (actual.Equals expected == true)

  /* SetPaddingR */
  -- 無効な値
  expectedPaddingR = 0
  actual = ::TestValueStruct (testObj.SetPaddingR undefined)
  expected = ::TestValueStruct expectedPaddingR
  assert (actual.Equals expected == true)
  -- 範囲外
  expectedPaddingR = 0
  actual = ::TestValueStruct (testObj.SetPaddingR -1)
  expected = ::TestValueStruct expectedPaddingR
  assert (actual.Equals expected == true)
  -- 成功
  expectedPaddingR = 20
  actual = ::TestValueStruct (testObj.SetPaddingR 20)
  expected = ::TestValueStruct expectedPaddingR
  assert (actual.Equals expected == true)

  /* SetPaddingT */
  -- 無効な値
  expectedPaddingT = 0
  actual = ::TestValueStruct (testObj.SetPaddingT undefined)
  expected = ::TestValueStruct expectedPaddingT
  assert (actual.Equals expected == true)
  -- 範囲外
  expectedPaddingT = 0
  actual = ::TestValueStruct (testObj.SetPaddingT -1)
  expected = ::TestValueStruct expectedPaddingT
  assert (actual.Equals expected == true)
  -- 成功
  expectedPaddingT = 25
  actual = ::TestValueStruct (testObj.SetPaddingT 25)
  expected = ::TestValueStruct expectedPaddingT
  assert (actual.Equals expected == true)

  /* SetPadding */
  expectedPaddingT = 1
  expectedPaddingR = 2
  expectedPaddingB = 3
  expectedPaddingL = 4
  actual = ::TestValueStruct (testObj.SetPadding 1 2 3 4)
  expected = ::TestValueStruct #(
    expectedPaddingT,
    expectedPaddingR,
    expectedPaddingB,
    expectedPaddingL
  )
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
