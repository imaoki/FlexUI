/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  local RltTest
  rollout RltTest "Controls" (
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

    on RltTest Open do (
      local nameTexts = #()
      local classTexts = #()
      local superClassTexts = #()
      local getHeightTexts = #()
      local setHeightTexts = #()
      local getWidthTexts = #()
      local setWidthTexts = #()
      local posTexts = #()
      local nameLength = "Name".Count
      local classLength = "Class".Count
      local superClassLength = "SuperClass".Count
      local getHeightLength = "Get Height".Count
      local setHeightLength = "Set Height".Count
      local getWidthLength = "Get Width".Count
      local setWidthLength = "Set Width".Count
      local posLength = "Pos".Count

      local controlCount = RltTest.Controls.Count
      for i = 1 to controlCount do (
        local control = RltTest.Controls[i]
        format "control:% hwnd:%\n" control control.Hwnd.Count
        for j = 1 to control.Hwnd.Count do (
          format "  [%]:%\n" j (Windows.GetHwndData control.Hwnd[j])
        )
        local nameText = ::std.StringUtility.ToPascalCase control.Name
        local classText = ::std.StringUtility.ToPascalCase (classOf control as String)
        local superClassText = ::std.StringUtility.ToPascalCase (superClassOf control as String)

        local getHeight = true
        local setHeight = true
        local getWidth = true
        local setWidth = true
        try control.Height catch getHeight = false
        try control.Height = 5 catch setHeight = false
        try control.Width catch getWidth = false
        try control.Width = 5 catch setWidth = false
        local getHeightText = getHeight as String
        local setHeightText = setHeight as String
        local getWidthText = getWidth as String
        local setWidthText = setWidth as String
        local posText = isProperty control #Pos as String

        append nameTexts nameText
        append classTexts classText
        append superClassTexts superClassText
        append getHeightTexts getHeightText
        append setHeightTexts setHeightText
        append getWidthTexts getWidthText
        append setWidthTexts setWidthText
        append posTexts posText
        if nameText.Count > nameLength do nameLength = nameText.Count
        if classText.Count > classLength do classLength = classText.Count
        if superClassText.Count > superClassLength do superClassLength = superClassText.Count
        if getHeightText.Count > getHeightLength do getHeightLength = getHeightText.Count
        if setHeightText.Count > setHeightLength do setHeightLength = setHeightText.Count
        if getWidthText.Count > getWidthLength do getWidthLength = getWidthText.Count
        if setWidthText.Count > setWidthLength do setWidthLength = setWidthText.Count
        if posText.Count > posLength do posLength = posText.Count
      )
      local out = StringStream ""
      format "| % | % | % | % | % | % | % |\n" \
          (::std.StringUtility.PadRight "Name" nameLength " ") \
          (::std.StringUtility.PadRight "Class" classLength " ") \
          (::std.StringUtility.PadRight "Get Height" getHeightLength " ") \
          (::std.StringUtility.PadRight "Set Height" setHeightLength " ") \
          (::std.StringUtility.PadRight "Get Width" getWidthLength " ") \
          (::std.StringUtility.PadRight "Set Width" setWidthLength " ") \
          (::std.StringUtility.PadRight "Pos" posLength " ") \
          to:out
      format "| % | % | % | % | % | % | % |\n" \
          (::std.StringUtility.PadRight "" nameLength "-") \
          (::std.StringUtility.PadRight "" classLength "-") \
          (::std.StringUtility.PadRight "" getHeightLength "-") \
          (::std.StringUtility.PadRight "" setHeightLength "-") \
          (::std.StringUtility.PadRight "" getWidthLength "-") \
          (::std.StringUtility.PadRight "" setWidthLength "-") \
          (::std.StringUtility.PadRight "" posLength "-") \
          to:out
      for i = 1 to controlCount do (
        format "| % | % | % | % | % | % | % |\n" \
            (::std.StringUtility.PadRight nameTexts[i] nameLength " ") \
            (::std.StringUtility.PadRight classTexts[i] classLength " ") \
            (::std.StringUtility.PadRight getHeightTexts[i] getHeightLength " ") \
            (::std.StringUtility.PadRight setHeightTexts[i] setHeightLength " ") \
            (::std.StringUtility.PadRight getWidthTexts[i] getWidthLength " ") \
            (::std.StringUtility.PadRight setWidthTexts[i] setWidthLength " ") \
            (::std.StringUtility.PadRight posTexts[i] posLength " ") \
            to:out
      )
      format "%" (out as String)
    )
    on RltTest Resized v do ()
  )
  createDialog RltTest 320 1300 \
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
  ok
)
