/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  rollout RltExplorer "Explorer" (
    button BtnBack "Back" iconName:@"CommandPanel\Motion\BipedRollout\Previous" iconSize:[20, 20]
    button BtnForward "Forward" iconName:@"CommandPanel\Motion\BipedRollout\Next" iconSize:[20, 20]
    button BtnUp "Up" iconName:@"Common\ArrowUp" iconSize:[16, 16]
    editText EdtPath ""
    button BtnRefresh "Refresh" iconName:@"MaxScript\ParamWiring\Refresh" iconSize:[16, 16]
    imgTag ItgSearchBoxIcon "Search" iconName:@"Common\Zoom" iconSize:[16, 16] style:#Bmp_Center
    editText EdtSearchBox ""
    multiListBox MlbxList ""

    local layout = undefined

    fn getRect = (
      local size = getDialogSize RltExplorer
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

    on RltExplorer Open do (
      local backWidget = ::flexUI.CreateWidget BtnBack explicitW:24 explicitH:24
      local forwardWidget = ::flexUI.CreateWidget BtnForward explicitW:24 explicitH:24
      local upWidget = ::flexUI.CreateWidget BtnUp explicitW:24 explicitH:24
      local pathWidget = ::flexUI.CreateWidget EdtPath explicitH:17
      local refreshWidget = ::flexUI.CreateWidget BtnRefresh explicitW:24 explicitH:24
      local searchBoxIconWidget = ::flexUI.CreateWidget ItgSearchBoxIcon explicitW:17 explicitH:17
      local searchBoxWidget = ::flexUI.CreateWidget EdtSearchBox explicitH:17
      local listWidget = ::flexUI.CreateWidget MlbxList

      local toolBarLayout = ::flexUI.CreateHBoxLayout()
      toolBarLayout.Options.SetMargin 2 0
      toolBarLayout.AddWidget backWidget fixedLength:24
      toolBarLayout.AddWidget forwardWidget fixedLength:24
      toolBarLayout.AddWidget upWidget fixedLength:24
      toolBarLayout.AddWidget pathWidget stretch:2
      toolBarLayout.AddWidget refreshWidget fixedLength:24
      toolBarLayout.AddSpace 4
      toolBarLayout.AddWidget searchBoxIconWidget fixedLength:24
      toolBarLayout.AddWidget searchBoxWidget

      layout = ::flexUI.CreateVBoxLayout()
      layout.Options.SetMargin 0 2
      layout.Options.SetPadding 2 2 2 2
      layout.AddLayout toolBarLayout fixedLength:24
      layout.AddWidget listWidget
      layout.AddSpace 20
      updateControl()
    )
    on RltExplorer Resized v do updateControl()
  )
  createDialog RltExplorer 480 320 \
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
