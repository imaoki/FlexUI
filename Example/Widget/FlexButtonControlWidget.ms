/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  rollout RltTest "FlexButtonControlWidget" (
    button Btn "ButtonControl"

    radioButtons RdbtnAlignmentH "AlignmentH" columns:3 default:2 labels:#("Left", "Center", "Right")
    radioButtons RdbtnAlignmentV "AlignmentV" columns:1 default:2 labels:#("Top", "Center", "Bottom")
    checkBox CkbxCaption "Caption" checked:true
    radioButtons RdbtnPosition "" columns:1 default:1 labels:#("Left", "Top")
    checkBox CkbxExplicitW "ExplicitW" checked:false
    spinner SpnExplicitW "" fieldWidth:40 range:[0, 10000, 100] scale:1 type:#Integer
    checkBox CkbxExplicitH "ExplicitH" checked:false
    spinner SpnExplicitH "" fieldWidth:40 range:[0, 10000, 100] scale:1 type:#Integer

    local controlCaption = "ButtonControl"
    local widget = undefined

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
      RdbtnAlignmentH.Pos = [60, 16]
      RdbtnAlignmentV.Pos = [0, 16]
      CkbxCaption.Pos = [0, h - 45]
      RdbtnPosition.Pos = [0, h - 30]
      CkbxExplicitW.Pos = [70, h - 45]
      SpnExplicitW.Pos = [180, h - 45]
      CkbxExplicitH.Pos = [70, h - 25]
      SpnExplicitH.Pos = [180, h - 25]
      ok
    )

    fn updateControl = (
      updateBackgroundImage()
      updateOptionControls()
      local rect = widget.SetRect (getRect())
      ok
    )

    fn setAlignmentH = (
      local alignment = #(#Left, #Center, #Right)[RdbtnAlignmentH.State]
      if classOf alignment == Name do (
        widget.SetAlignmentH alignment
      )
      ok
    )

    fn setAlignmentV = (
      local alignment = #(#Top, #Center, #Bottom)[RdbtnAlignmentV.State]
      if classOf alignment == Name do (
        widget.SetAlignmentV alignment
      )
      ok
    )

    fn setCaption = (
      if CkbxCaption.Checked then (
        Btn.Caption = controlCaption
      )
      else (
        Btn.Caption = ""
      )
      updateControl()
      ok
    )

    fn setCaptionPosition = (
      local position = #(#Left, #Top)[RdbtnPosition.State]
      if classOf position == Name do (
        widget.SetCaptionPosition position
      )
      ok
    )

    fn setExplicitW = (
      if CkbxExplicitW.Checked then (
        widget.SetExplicitW SpnExplicitW.Value
      )
      else (
        widget.SetExplicitW undefined
      )
      ok
    )

    fn setExplicitH = (
      if CkbxExplicitH.Checked then (
        widget.SetExplicitH SpnExplicitH.Value
      )
      else (
        widget.SetExplicitH undefined
      )
      ok
    )

    fn updateWidget context params type: = (
      -- format "updateWidget params:% type:%\n" params type
      if classOf params == Array do (
        for param in params do (
          case param of (
            (#AlignmentH): updateControl()
            (#AlignmentV): updateControl()
            (#CaptionMargin): updateControl()
            (#CaptionPosition): updateControl()
            (#Control): ()
            (#ExplicitH): updateControl()
            (#ExplicitW): updateControl()
            (#RectUpdated): ()
            default: ()
          )
        )
      )
      ok
    )

    on RdbtnAlignmentH Changed v do setAlignmentH()
    on RdbtnAlignmentV Changed v do setAlignmentV()
    on CkbxCaption Changed state do setCaption()
    on RdbtnPosition Changed v do setCaptionPosition()
    on CkbxExplicitW Changed state do setExplicitW()
    on SpnExplicitW Changed v do setExplicitW()
    on CkbxExplicitH Changed state do setExplicitH()
    on SpnExplicitH Changed v do setExplicitH()
    on RltTest Open do (
      local pathUtility = ::std.PathUtilityStruct (getSourceFileName())
      local widgetDef = fileIn (pathUtility.GetFullPath @"..\..\Model\Widget\FlexButtonControlWidget.ms")
      widget = widgetDef Btn
      widget.AddObserver (::std.ObserverStruct updateWidget widget)
      RdbtnAlignmentH.State = findItem #(#Left, #Center, #Right) (widget.GetAlignmentH())
      RdbtnAlignmentV.State = findItem #(#Top, #Center, #Bottom) (widget.GetAlignmentV())
      RdbtnPosition.State = findItem #(#Left, #Top) (widget.GetCaptionPosition())
      SpnExplicitW.Range.X = widget.GetMinW()
      SpnExplicitH.Range.X = widget.GetMinH()
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
