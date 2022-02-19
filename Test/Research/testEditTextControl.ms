/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  clearListener()
  local RltTest
  rollout RltTest "EditTextControl" (
    radioButtons RdbtnMode "" columns:6 default:1 labels:#("0", "1", "2", "3", "4", "5") pos:[146, 305]

    editText Edt1 "EditTextControl" pos:[190, 30] width:100
    editText Edt2 "" text:"a" height:17 pos:[190, 80] width:100
    editText Edt3 "" text:"aaa\nbb" height:32 pos:[30, 190] width:100
    editText Edt4 "" text:"aaa\nbb\nc" height:45 pos:[190, 190] width:100
    editText Edt5 "" text:"a" height:17 pos:[190, 240] width:5

    fn setControlVisibility v = (
      local controlCount = RltTest.Controls.Count
      for i = 1 to controlCount where i > 1 do (
        local control = RltTest.Controls[i]
        control.Visible = v
      )
      ok
    )

    fn changeMode v = (
      setControlVisibility (v == 1)
      if v == 1 then (
        setDialogBitmap RltTest undefined
      )
      else (
        local bgColor = if v == 1 then Color 31 95 95 else Color 0 0 0
        local bgImage = Bitmap 320 320 Color:bgColor
        local rectColor = case v of (
          (2): Color 255 0 0
          (3): Color 0 255 0
          (4): Color 0 0 255
          (5): Color 255 0 255
          (6): Color 0 255 255
          default: Color 255 255 255
        )
        local controlCount = RltTest.Controls.Count
        local handleIndex = v - 1
        for i = 1 to controlCount where i > 1 do (
          local control = RltTest.Controls[i]
          local handleCount = control.Hwnd.Count
          if 1 <= handleIndex and handleIndex <= handleCount do (
            local hwnd = control.Hwnd[handleIndex]
            local parentHwnd = (Windows.GetHwndData hwnd)[2]
            local rect = Windows.GetWindowPos hwnd
            local pos = Windows.ScreenToClient parentHwnd rect.X rect.Y
            local x = pos.X as Integer
            local y = pos.Y as Integer
            local h = rect.H
            local w = rect.W
            local rectColors = for j = 1 to w collect rectColor
            for j = 1 to h do (
              setPixels bgImage [x, y + j - 1] rectColors
            )
          )
        )
        setDialogBitmap RltTest bgImage
      )
      ok
    )

    fn showControlRect = (
      local controlCount = RltTest.Controls.Count
      for i = 1 to controlCount where i > 1 do (
        local control = RltTest.Controls[i]
        format "% % %\n" control control.Name (classOf control)
        format "  Hwnd:%\n" control.Hwnd
        local handleCount = control.Hwnd.Count
        for j = 1 to handleCount do (
          local hwnd = control.Hwnd[j]
          local parentHwnd = (Windows.GetHwndData hwnd)[2]
          local rect = Windows.GetWindowPos hwnd
          local pos = Windows.ScreenToClient parentHwnd rect.X rect.Y
          local x = formattedPrint (pos.X as Integer) format:"3d"
          local y = formattedPrint (pos.Y as Integer) format:"3d"
          local h = formattedPrint rect.H format:"3d"
          local w = formattedPrint rect.W format:"3d"
          format "    [%]: X:% Y:% W:% H:%\n" j x y w h
        )
      )
      ok
    )

    on RdbtnMode Changed v do changeMode v
    on Edt1 Entered v do format "Edt1 Entered v:\"%\"\n" v
    on Edt2 Entered v do format "Edt2 Entered v:\"%\"\n" v
    on Edt3 Entered v do format "Edt3 Entered v:\"%\"\n" v
    on RltTest Open do (
      -- Edt1.Height = 17
      Edt1.Width = 100
      Edt1.Pos = [190, 30]
      Edt2.Height = 17
      Edt2.Width = 100
      Edt2.Pos = [190, 80]
      Edt3.Height = 32
      Edt3.Width = 100
      Edt3.Pos = [30, 190]
      Edt4.Height = 45
      Edt4.Width = 100
      Edt4.Pos = [190, 190]
      Edt5.Height = 17
      Edt5.Width = 5
      Edt5.Pos = [190, 240]

      showControlRect()
    )
  )
  createDialog RltTest 320 320 \
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
