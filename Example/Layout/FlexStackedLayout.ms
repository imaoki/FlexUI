/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  rollout RltTest "FlexStackedLayout" (
    dropdownList DdlPageList ""

    angle Ang "AngleControl"
    bitmap Bmp "BitmapControl"
    button Btn "ButtonControl"
    checkBox Ckbx "CheckBoxControl"
    checkButton Ckbtn "CheckButtonControl"
    colorPicker Cpk "ColorPickerControl" color:(Color 63 63 63)
    curveControl Cc "MaxCurveCtl"
    dotNetControl Lvw "System.Windows.Forms.ListView"
    dropDownList Ddl "ComboBoxControl" height:4 items:#("a", "b", "c")
    editText Edt "EditTextControl"
    groupBox Gbx "GroupBoxControl"
    hyperLink Hlk "LinkControl" address:"https://www.autodesk.com/"
    imgTag Itg "ImgTag" bitmap:(BitMap 1 1 Color:(Color 127 127 127))
    label Lbl "LabelControl"
    listBox Lbx "ListBoxControl" height:3 items:#("a", "b", "c")
    mapButton Mpbtn "MapButtonControl"
    materialButton Mtbtn "MtlButtonControl"
    multiListBox Mlbx "MultiListBoxControl" height:3 items:#("a", "b", "c")
    pickButton Pkbtn "PickerControl"
    progressBar Pbr "ProgressBar"
    radioButtons Rdbtn "RadioControl" labels:#("a", "b", "c")
    slider Sld "SliderControl"
    spinner Spn "SpinnerControl"

    radioButtons RdbtnSubPageList "" columns:2 labels:#("Button", "Spinner")
    button BtnSub "Button"
    spinner SpnSub "Spinner"

    spinner SpnMarginH "MarginH" fieldWidth:40 range:[0, 10000, 0] scale:1 type:#Integer
    spinner SpnMarginV "MarginV" fieldWidth:40 range:[0, 10000, 0] scale:1 type:#Integer
    spinner SpnPaddingT "PaddingT" fieldWidth:40 range:[0, 10000, 0] scale:1 type:#Integer
    spinner SpnPaddingR "PaddingR" fieldWidth:40 range:[0, 10000, 0] scale:1 type:#Integer
    spinner SpnPaddingB "PaddingB" fieldWidth:40 range:[0, 10000, 0] scale:1 type:#Integer
    spinner SpnPaddingL "PaddingL" fieldWidth:40 range:[0, 10000, 0] scale:1 type:#Integer

    local containerLayout = undefined
    local stackedLayout = undefined
    local subContainerLayout = undefined
    local subStackedLayout = undefined

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
      local rects = containerLayout.SetRect (getRect())
      ok
    )

    fn setMarginH = (
      containerLayout.Options.SetMarginH SpnMarginH.Value
      ok
    )

    fn setMarginV = (
      containerLayout.Options.SetMarginV SpnMarginV.Value
      ok
    )

    fn setPaddingT = (
      containerLayout.Options.SetPaddingT SpnPaddingT.Value
      ok
    )

    fn setPaddingR = (
      containerLayout.Options.SetPaddingR SpnPaddingR.Value
      ok
    )

    fn setPaddingB = (
      containerLayout.Options.SetPaddingB SpnPaddingB.Value
      ok
    )

    fn setPaddingL = (
      containerLayout.Options.SetPaddingL SpnPaddingL.Value
      ok
    )

    fn setCurrentIndex = (
      stackedLayout.SetCurrentIndex DdlPageList.Selection
      ok
    )

    fn setSubCurrentIndex = (
      subStackedLayout.SetCurrentIndex RdbtnSubPageList.State
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

    on DdlPageList Selected index do setCurrentIndex()
    on RdbtnSubPageList Changed state do setSubCurrentIndex()
    on SpnMarginH Changed v do setMarginH()
    on SpnMarginV Changed v do setMarginV()
    on SpnPaddingT Changed v do setPaddingT()
    on SpnPaddingR Changed v do setPaddingR()
    on SpnPaddingB Changed v do setPaddingB()
    on SpnPaddingL Changed v do setPaddingL()
    on RltTest Open do (
      local containerLayoutOptions = ::flexUI.CreateLayoutOptions()
      containerLayoutOptions.SetMargin 5 5
      containerLayoutOptions.SetPadding 5 5 5 5
      containerLayoutOptions.StateChanged.Subscribe (::std.ObserverStruct updateLayout)
      SpnMarginH.Value = containerLayoutOptions.GetMarginH()
      SpnMarginV.Value = containerLayoutOptions.GetMarginV()
      SpnPaddingT.Value = containerLayoutOptions.GetPaddingT()
      SpnPaddingR.Value = containerLayoutOptions.GetPaddingR()
      SpnPaddingB.Value = containerLayoutOptions.GetPaddingB()
      SpnPaddingL.Value = containerLayoutOptions.GetPaddingL()

      subStackedLayout = ::flexUI.CreateStackedLayout()
      local subPageControls = #(BtnSub, SpnSub)
      for subPageControl in subPageControls do (
        subStackedLayout.AddWidget (::flexUI.CreateWidget subPageControl)
      )
      subStackedLayout.SetCurrentIndex 1
      RdbtnSubPageList.State = subStackedLayout.GetCurrentIndex()

      subContainerLayout = ::flexUI.CreateVBoxLayout options:containerLayoutOptions
      subContainerLayout.AddWidget (::flexUI.CreateWidget RdbtnSubPageList) fixedLength:15
      subContainerLayout.AddLayout subStackedLayout

      stackedLayout = ::flexUI.CreateStackedLayout()
      local pageControls = #(Ang, Bmp, Btn, Ckbx, Ckbtn, Cpk, Cc, Lvw, Ddl, Edt, Gbx, Hlk, Itg, Lbl, Lbx, Mpbtn, Mtbtn, Mlbx, Pkbtn, Pbr, Rdbtn, Sld, Spn)
      local pageNames = for pageControl in pageControls collect (
        stackedLayout.AddWidget (::flexUI.CreateWidget pageControl)
        ::std.StringUtility.ToPascalCase (classOf pageControl as String)
      )
      stackedLayout.AddLayout subContainerLayout
      append pageNames "SubStackedLayout"
      stackedLayout.SetCurrentIndex 1
      DdlPageList.Items = pageNames
      DdlPageList.Selection = stackedLayout.GetCurrentIndex()

      containerLayout = ::flexUI.CreateVBoxLayout options:containerLayoutOptions
      containerLayout.AddWidget (::flexUI.CreateWidget DdlPageList) fixedLength:21
      containerLayout.AddLayout stackedLayout
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
