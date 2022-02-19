/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  clearListener()
  local RltTest
  rollout RltTest "ProgressBar" (
    radioButtons RdbtnMode "" columns:6 default:1 labels:#("0", "1", "2", "3", "4", "5") pos:[146, 305]

    progressBar Pbr1 "ProgressBar" height:100 pos:[30, 30] width:100
    progressBar Pbr2 "ProgressBar" pos:[190, 30] width:100
    progressBar Pbr3 "" pos:[30, 190] width:260
    progressBar Pbr4 "" height:4 pos:[190, 240] width:4

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
    on RltTest Open do (
      Pbr1.Pos = [30, 30]
      Pbr2.Pos = [190, 30]
      Pbr3.Pos = [30, 190]
      Pbr4.Pos = [190, 240]

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
