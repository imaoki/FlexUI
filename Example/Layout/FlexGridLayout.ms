/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  rollout RltTest "FlexGridLayout" (
    imgTag Itg1 "ImgTag" bitmap:(BitMap 1 1 Color:(Color 159 31 31))
    imgTag Itg2 "ImgTag" bitmap:(BitMap 1 1 Color:(Color 31 159 31))
    imgTag Itg3 "ImgTag" bitmap:(BitMap 1 1 Color:(Color 31 31 159))
    imgTag Itg4 "ImgTag" bitmap:(BitMap 1 1 Color:(Color 31 159 159))
    imgTag Itg5 "ImgTag" bitmap:(BitMap 1 1 Color:(Color 159 31 159))
    imgTag Itg6 "ImgTag" bitmap:(BitMap 1 1 Color:(Color 159 159 31))

    spinner SpnMarginH "MarginH" fieldWidth:40 range:[0, 10000, 0] scale:1 type:#Integer
    spinner SpnMarginV "MarginV" fieldWidth:40 range:[0, 10000, 0] scale:1 type:#Integer
    spinner SpnPaddingT "PaddingT" fieldWidth:40 range:[0, 10000, 0] scale:1 type:#Integer
    spinner SpnPaddingR "PaddingR" fieldWidth:40 range:[0, 10000, 0] scale:1 type:#Integer
    spinner SpnPaddingB "PaddingB" fieldWidth:40 range:[0, 10000, 0] scale:1 type:#Integer
    spinner SpnPaddingL "PaddingL" fieldWidth:40 range:[0, 10000, 0] scale:1 type:#Integer

    local layout = undefined

    local padding = 80
    local bgColor = Color 31 95 95
    local rectColor = Color 63 127 127

    fn getRect = (
      local size = getDialogSize RltTest
      if size.X < 1 do size.X = 1
      if size.Y < 1 do size.Y = 1
      local x = padding
      local y = padding
      local w = size.X as Integer - padding * 2
      local h = size.Y as Integer - padding * 2
      if w < 1 do w = 1
      if h < 1 do h = 1
      Box2 x y w h
    )

    fn updateBackgroundImage = (
      local size = getDialogSize RltTest
      if size.X < 1 do size.X = 1
      if size.Y < 1 do size.Y = 1
      local imageW = size.X as Integer
      local imageH = size.Y as Integer
      local bgImage = Bitmap imageW imageH Color:bgColor Gamma:(1.0 / 2.2)
      local rect = getRect()
      local rectImage = Bitmap rect.W rect.H Color:rectColor
      pasteBitmap rectImage bgImage [0, 0] [rect.X, rect.Y] type:#Paste
      setDialogBitmap RltTest bgImage
      ok
    )

    fn updateOptionControls = (
      local size = getDialogSize RltTest
      if size.X < 1 do size.X = 1
      if size.Y < 1 do size.Y = 1
      local w = size.X as Integer
      local h = size.Y as Integer
      SpnMarginH.Pos = [90, 0]
      SpnMarginV.Pos = [190, 00]
      SpnPaddingT.Pos = [90, 20]
      SpnPaddingR.Pos = [190, 20]
      SpnPaddingB.Pos = [90, 40]
      SpnPaddingL.Pos = [190, 40]
      ok
    )

    fn updateControl = (
      updateBackgroundImage()
      updateOptionControls()
      local rects = layout.SetRect (getRect())
      ok
    )

    fn setMarginH = (
      layout.Options.SetMarginH SpnMarginH.Value
      ok
    )

    fn setMarginV = (
      layout.Options.SetMarginV SpnMarginV.Value
      ok
    )

    fn setPaddingT = (
      layout.Options.SetPaddingT SpnPaddingT.Value
      ok
    )

    fn setPaddingR = (
      layout.Options.SetPaddingR SpnPaddingR.Value
      ok
    )

    fn setPaddingB = (
      layout.Options.SetPaddingB SpnPaddingB.Value
      ok
    )

    fn setPaddingL = (
      layout.Options.SetPaddingL SpnPaddingL.Value
      ok
    )

    fn updateLayout type param = (
      -- format "updateLayout type:% param:%\n" type param
      case type of (
        (#MarginH): updateControl()
        (#MarginV): updateControl()
        (#PaddingB): updateControl()
        (#PaddingL): updateControl()
        (#PaddingR): updateControl()
        (#PaddingT): updateControl()
        default: ()
      )
      ok
    )

    on SpnMarginH Changed v do setMarginH()
    on SpnMarginV Changed v do setMarginV()
    on SpnPaddingT Changed v do setPaddingT()
    on SpnPaddingR Changed v do setPaddingR()
    on SpnPaddingB Changed v do setPaddingB()
    on SpnPaddingL Changed v do setPaddingL()
    on RltTest Open do (
      local widget1 = ::flexUI.CreateWidget Itg1
      local widget2 = ::flexUI.CreateWidget Itg2
      local widget3 = ::flexUI.CreateWidget Itg3
      local widget4 = ::flexUI.CreateWidget Itg4
      local widget5 = ::flexUI.CreateWidget Itg5
      local widget6 = ::flexUI.CreateWidget Itg6
      layout = ::flexUI.CreateGridLayout()
      layout.Options.SetMargin 5 5
      layout.Options.SetPadding 5 5 5 5
      layout.Options.StateChanged.Subscribe (::std.ObserverStruct updateLayout)
      SpnMarginH.Value = layout.Options.GetMarginH()
      SpnMarginV.Value = layout.Options.GetMarginV()
      SpnPaddingT.Value = layout.Options.GetPaddingT()
      SpnPaddingR.Value = layout.Options.GetPaddingR()
      SpnPaddingB.Value = layout.Options.GetPaddingB()
      SpnPaddingL.Value = layout.Options.GetPaddingL()
      layout.AddWidget widget1 1 1
      layout.AddWidget widget2 2 1
      layout.AddWidget widget3 3 1 rowSpan:2 columnSpan:2
      layout.AddWidget widget4 1 2 rowSpan:2 columnSpan:2
      layout.AddWidget widget5 3 3
      layout.AddWidget widget6 4 3
      layout.SetColumnMinimumWidth 2 10
      layout.SetColumnStretch 2 2
      layout.SetRowMinimumHeight 3 10
      layout.SetRowStretch 3 2
      updateControl()
    )
    on RltTest Resized v do updateControl()
  )
  createDialog RltTest 320 320 \
      bmpStyle:#Bmp_Tile \
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
