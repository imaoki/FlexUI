/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  rollout RltCalc "Calc" (
    groupBox GbxOutput ""
    label LblOutput "0"
    button Btn0 "0"
    button Btn1 "1"
    button Btn2 "2"
    button Btn3 "3"
    button Btn4 "4"
    button Btn5 "5"
    button Btn6 "6"
    button Btn7 "7"
    button Btn8 "8"
    button Btn9 "9"
    button BtnClear "C"
    button BtnChangeSign "+/-"
    button BtnPercent "%"
    button BtnDivision "÷"
    button BtnMultiplication "x"
    button BtnSubtraction "-"
    button BtnAddition "+"
    button BtnDecimalPoint "."
    button BtnResult "="

    local layout = undefined

    fn getRect = (
      local size = getDialogSize RltCalc
      local w = size.X as Integer
      local h = size.Y as Integer
      if w < 1 do w = 1
      if h < 1 do h = 1
      Box2 0 0 w h
    )

    fn updateControl = (
      local rects = layout.SetRect (getRect())
      ok
    )

    on RltCalc Open do (
      local outputLayout = ::flexUI.CreateGroupLayout (::flexUI.CreateWidget GbxOutput)
      local outputWidget = ::flexUI.CreateWidget LblOutput
      outputWidget.SetAlignmentH #Right
      outputLayout.SetCell outputWidget

      layout = ::flexUI.CreateGridLayout()
      layout.Options.SetMargin 2 2
      layout.Options.SetPadding 0 2 2 2
      layout.AddLayout outputLayout 1 1 columnSpan:4
      layout.AddWidget (::flexUI.CreateWidget BtnClear) 2 1
      layout.AddWidget (::flexUI.CreateWidget BtnChangeSign) 2 2
      layout.AddWidget (::flexUI.CreateWidget BtnPercent) 2 3
      layout.AddWidget (::flexUI.CreateWidget BtnDivision) 2 4
      layout.AddWidget (::flexUI.CreateWidget Btn7) 3 1
      layout.AddWidget (::flexUI.CreateWidget Btn8) 3 2
      layout.AddWidget (::flexUI.CreateWidget Btn9) 3 3
      layout.AddWidget (::flexUI.CreateWidget BtnMultiplication) 3 4
      layout.AddWidget (::flexUI.CreateWidget Btn4) 4 1
      layout.AddWidget (::flexUI.CreateWidget Btn5) 4 2
      layout.AddWidget (::flexUI.CreateWidget Btn6) 4 3
      layout.AddWidget (::flexUI.CreateWidget BtnSubtraction) 4 4
      layout.AddWidget (::flexUI.CreateWidget Btn1) 5 1
      layout.AddWidget (::flexUI.CreateWidget Btn2) 5 2
      layout.AddWidget (::flexUI.CreateWidget Btn3) 5 3
      layout.AddWidget (::flexUI.CreateWidget BtnAddition) 5 4
      layout.AddWidget (::flexUI.CreateWidget Btn0) 6 1 columnSpan:2
      layout.AddWidget (::flexUI.CreateWidget BtnDecimalPoint) 6 3
      layout.AddWidget (::flexUI.CreateWidget BtnResult) 6 4
      layout.SetRowMinimumHeight 1 40
      layout.SetRowStretch 1 3
      for i = 2 to 6 do (
        layout.SetRowStretch i 2
      )
      updateControl()
    )
    on RltCalc Resized v do updateControl()
  )
  createDialog RltCalc 160 320 \
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
)
