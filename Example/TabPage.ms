/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  rollout RltTabPage "TabPage" (
    dotNetControl TabPage "System.Windows.Forms.TabControl"
    button BtnGrid1 "Grid1"
    button BtnGrid2 "Grid2"
    button BtnGrid3 "Grid3"
    button BtnHBox1 "HBox1"
    button BtnHBox2 "HBox2"
    button BtnHBox3 "HBox3"
    button BtnVBox1 "VBox1"
    button BtnVBox2 "VBox2"
    button BtnVBox3 "VBox3"

    local containerLayout = undefined
    local stackedLayout = undefined

    fn getRect = (
      local size = getDialogSize RltTabPage
      local w = size.X as Integer
      local h = size.Y as Integer
      if w < 1 do w = 1
      if h < 1 do h = 1
      Box2 0 0 w h
    )

    fn updateControl = (
      local rects = containerLayout.SetRect (getRect())
      ok
    )

    fn setCurrentIndex = (
      stackedLayout.SetCurrentIndex (TabPage.SelectedIndex + 1)
      ok
    )

    on TabPage SelectedIndexChanged v do setCurrentIndex()
    on RltTabPage Open do (
      TabPage.TabPages.Add "Grid"
      TabPage.TabPages.Add "HBox"
      TabPage.TabPages.Add "VBox"

      local gridLayout = ::flexUI.CreateGridLayout()
      gridLayout.AddWidget (::flexUI.CreateWidget BtnGrid1) 1 1
      gridLayout.AddWidget (::flexUI.CreateWidget BtnGrid2) 1 2
      gridLayout.AddWidget (::flexUI.CreateWidget BtnGrid3) 2 1 columnSpan:2
      gridLayout.SetRowStretch 1 2
      gridLayout.SetColumnStretch 2 2
      gridLayout.SetRowMinimumHeight 1 20
      gridLayout.SetRowMinimumHeight 2 20
      gridLayout.SetColumnMinimumWidth 1 20
      gridLayout.SetColumnMinimumWidth 2 20

      local hBoxLayout = ::flexUI.CreateHBoxLayout()
      hBoxLayout.AddWidget (::flexUI.CreateWidget BtnHBox1) minimum:20
      hBoxLayout.AddWidget (::flexUI.CreateWidget BtnHBox2) minimum:20 stretch:2
      hBoxLayout.AddWidget (::flexUI.CreateWidget BtnHBox3) minimum:20

      local vBoxLayout = ::flexUI.CreateVBoxLayout()
      vBoxLayout.AddWidget (::flexUI.CreateWidget BtnVBox1) minimum:20
      vBoxLayout.AddWidget (::flexUI.CreateWidget BtnVBox2) minimum:20 stretch:2
      vBoxLayout.AddWidget (::flexUI.CreateWidget BtnVBox3) minimum:20

      stackedLayout = ::flexUI.CreateStackedLayout()
      stackedLayout.AddLayout gridLayout
      stackedLayout.AddLayout hBoxLayout
      stackedLayout.AddLayout vBoxLayout
      stackedLayout.SetCurrentIndex 1
      TabPage.SelectedIndex = stackedLayout.GetCurrentIndex() - 1

      containerLayout = ::flexUI.CreateVBoxLayout()
      containerLayout.Options.SetMargin 5 5
      containerLayout.Options.SetPadding 5 5 5 5
      containerLayout.AddWidget (::flexUI.CreateWidget TabPage) fixedLength:20
      containerLayout.AddLayout stackedLayout minimum:20
      updateControl()
    )
    on RltTabPage Resized v do updateControl()
  )
  createDialog RltTabPage 320 160 \
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
