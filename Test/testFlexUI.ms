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
  fileIn (pathUtility.GetFullPath @"..\definitionPool.ms")
  local groupBoxControlWidgetDef = ::flexUIDefinitionPool[@"Model\Widget\FlexGroupBoxControlWidget.ms"]

  local RltTest
  rollout RltTest "RltTest" (
    angle Ang "AngleControl"
    bitmap Bmp "BitmapControl"
    button Btn "ButtonControl"
    checkBox Ckbx "CheckBoxControl"
    checkButton Ckbtn "CheckButtonControl"
    colorPicker Cpk "ColorPickerControl" color:(Color 63 63 63)
    comboBox Cbx "ComboBoxControl" height:3 items:#("a", "b", "c")
    curveControl Cc "MaxCurveCtl"
    dotNetControl Lvw "System.Windows.Forms.ListView"
    dropDownList Ddl "ComboBoxControl" height:2 items:#("a", "b", "c")
    editText Edt "EditTextControl"
    groupBox Gbx "GroupBoxControl"
    hyperLink Hlk "LinkControl" address:"https://www.autodesk.com/"
    imgTag Itg "ImgTag" bitmap:(BitMap 1 1 Color:(Color 127 127 127))
    label Lbl "LabelControl"
    listBox Lbx "ListBoxControl" height:1 items:#("a", "b", "c")
    mapButton Mpbtn "MapButtonControl"
    materialButton Mtbtn "MtlButtonControl"
    multiListBox Mlbx "MultiListBoxControl" height:1 items:#("a", "b", "c")
    pickButton Pkbtn "PickerControl"
    progressBar Pbr "ProgressBar"
    radioButtons Rdbtn "RadioControl" labels:#("a", "b", "c")
    slider Sld "SliderControl"
    spinner Spn "SpinnerControl"
    subRollout Srlt "SubRollout"

    on RltTest Open do ()
    on RltTest Resized v do ()
  )

  local testInstance
  fn testInstance obj structName = (
    local passCount = 0
    actual = ::TestValueStruct obj
    if assert (actual.IsStructInstance() == true) do (
      passCount += 1
      if assert (actual.HasProp #StructName == true) do (
        passCount += 1
        actual = ::TestValueStruct (obj.StructName())
        expected = ::TestValueStruct structName
        if assert (actual.Equals expected == true) do passCount += 1
      )
    )
    passCount == 3
  )

  local groupBoxWidget = groupBoxControlWidgetDef RltTest.Gbx
  local widget = undefined

  testDef = fileIn (pathUtility.GetFullPath @"..\FlexUI.ms")
  testObj = testDef()
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* CreateLayoutOptions */
  assert (testInstance (testObj.CreateLayoutOptions()) #FlexLayoutOptionsStruct)

  /* CreateGridLayout */
  assert (testInstance (testObj.CreateGridLayout()) #FlexGridLayoutStruct)

  /* CreateGroupLayout */
  -- 失敗
  actual = ::TestValueStruct (testObj.CreateGroupLayout undefined)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 成功
  assert (testInstance (testObj.CreateGroupLayout groupBoxWidget) #FlexGroupLayoutStruct)

  /* CreateHBoxLayout */
  assert (testInstance (testObj.CreateHBoxLayout()) #FlexHBoxLayoutStruct)

  /* CreateVBoxLayout */
  assert (testInstance (testObj.CreateVBoxLayout()) #FlexVBoxLayoutStruct)

  /* CreateWidget */
  -- 無効な値
  actual = ::TestValueStruct (testObj.CreateWidget undefined)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.CreateWidget 1)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.CreateWidget "Foo")
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.CreateWidget #Foo)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 成功
  assert (testInstance (testObj.CreateWidget RltTest.Ang) #FlexAngleControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Bmp) #FlexBitmapControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Btn) #FlexButtonControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Ckbx) #FlexCheckBoxControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Ckbtn) #FlexCheckButtonControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Cpk) #FlexColorPickerControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Cbx) #FlexComboBoxControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Cc) #FlexMaxcurveCtlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Lvw) #FlexDotNetControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Ddl) #FlexComboBoxControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Edt) #FlexEditTextControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Gbx) #FlexGroupBoxControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Hlk) #FlexLinkControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Itg) #FlexImgTagWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Lbl) #FlexLabelControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Lbx) #FlexListBoxControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Mpbtn) #FlexMapButtonControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Mtbtn) #FlexMtlButtonControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Mlbx) #FlexMultiListBoxControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Pkbtn) #FlexPickerControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Pbr) #FlexProgressBarWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Rdbtn) #FlexRadioControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Sld) #FlexSliderControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Spn) #FlexSpinnerControlWidgetStruct)
  assert (testInstance (testObj.CreateWidget RltTest.Srlt) #FlexSubRolloutWidgetStruct)
  -- 明示的なサイズ
  widget = testObj.CreateWidget RltTest.Btn explicitW:40 explicitH:60
  actual = ::TestValueStruct (widget.GetExplicitH())
  expected = ::TestValueStruct 60
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct (widget.GetExplicitW())
  expected = ::TestValueStruct 40
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
