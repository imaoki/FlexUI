/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  rollout RltForm "Form" (
    label LblRadius1Label "Radius1:"
    spinner SpnRadius1Value "" range:[0.0, 100.0, 20.0] scale:1.0 type:#Float
    label LblRadius2Label "Radius2:"
    spinner SpnRadius2Value "" range:[0.0, 100.0, 10.0] scale:1.0 type:#Float
    label LblRotationLabel "Rotation:"
    spinner SpnRotationValue "" range:[-360.0, 360.0, 0.0] scale:1.0 type:#Float
    label LblTwistLabel "Twist:"
    spinner SpnTwistValue "" range:[-360.0, 360.0, 0.0] scale:1.0 type:#Float
    label LblSegmentsLabel "Segments:"
    spinner SpnSegmentsValue "" range:[3, 200, 24] scale:1 type:#Integer
    label LblSidesLabel "Sides:"
    spinner SpnSidesValue "" range:[3, 200, 12] scale:1 type:#Integer
    groupBox GbxSmoothGroup "Smooth:"
    radioButtons RdbtnSmooth "" columns:2 default:1 labels:#("All", "Sides", "None", "Segments")
    checkBox CkbxSliceOn "Slice On"
    label LblSliceFromLabel "Slice From:"
    spinner SpnSliceFromValue "" range:[-360.0, 360.0, 0.0] scale:1.0 type:#Float
    label LblSliceToLabel "Slice To:"
    spinner SpnSliceToValue "" range:[-360.0, 360.0, 0.0] scale:1.0 type:#Float
    checkBox CkbxGenerateMappingCoords "Generate Mapping Coords."
    checkBox CkbxRealWorldMapSize "Real-World Map Size"

    local layout = undefined

    fn getRect = (
      local size = getDialogSize RltForm
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

    on RltForm Open do (
      local radius1LabelWidget = ::flexUI.CreateWidget LblRadius1Label
      local radius1ValueWidget = ::flexUI.CreateWidget SpnRadius1Value
      local radius2LabelWidget = ::flexUI.CreateWidget LblRadius2Label
      local radius2ValueWidget = ::flexUI.CreateWidget SpnRadius2Value
      local rotationLabelWidget = ::flexUI.CreateWidget LblRotationLabel
      local rotationValueWidget = ::flexUI.CreateWidget SpnRotationValue
      local twistLabelWidget = ::flexUI.CreateWidget LblTwistLabel
      local twistValueWidget = ::flexUI.CreateWidget SpnTwistValue
      local segmentsLabelWidget = ::flexUI.CreateWidget LblSegmentsLabel
      local segmentsValueWidget = ::flexUI.CreateWidget SpnSegmentsValue
      local sidesLabelWidget = ::flexUI.CreateWidget LblSidesLabel
      local sidesValueWidget = ::flexUI.CreateWidget SpnSidesValue
      local smoothGroupWidget = ::flexUI.CreateWidget GbxSmoothGroup
      local smoothWidget = ::flexUI.CreateWidget RdbtnSmooth explicitW:120 explicitH:35
      local sliceOnWidget = ::flexUI.CreateWidget CkbxSliceOn
      local sliceFromLabelWidget = ::flexUI.CreateWidget LblSliceFromLabel
      local sliceFromValueWidget = ::flexUI.CreateWidget SpnSliceFromValue
      local sliceToLabelWidget = ::flexUI.CreateWidget LblSliceToLabel
      local sliceToValueWidget = ::flexUI.CreateWidget SpnSliceToValue
      local generateMappingCoordsWidget = ::flexUI.CreateWidget CkbxGenerateMappingCoords
      local realWorldMapSizeWidget = ::flexUI.CreateWidget CkbxRealWorldMapSize

      radius1LabelWidget.SetAlignmentH #Right
      radius2LabelWidget.SetAlignmentH #Right
      rotationLabelWidget.SetAlignmentH #Right
      twistLabelWidget.SetAlignmentH #Right
      segmentsLabelWidget.SetAlignmentH #Right
      sidesLabelWidget.SetAlignmentH #Right
      sliceFromLabelWidget.SetAlignmentH #Right
      sliceToLabelWidget.SetAlignmentH #Right

      sliceOnWidget.SetAlignmentH #Left
      generateMappingCoordsWidget.SetAlignmentH #Left
      realWorldMapSizeWidget.SetAlignmentH #Left

      local smoothGroupLayout = ::flexUI.CreateGroupLayout smoothGroupWidget
      smoothGroupLayout.SetCell smoothWidget

      layout = ::flexUI.CreateGridLayout()
      layout.Options.SetMargin 2 2
      layout.Options.SetPadding 5 5 5 5
      layout.AddWidget radius1LabelWidget 1 1
      layout.AddWidget radius1ValueWidget 1 2
      layout.AddWidget radius2LabelWidget 2 1
      layout.AddWidget radius2ValueWidget 2 2
      layout.AddWidget rotationLabelWidget 3 1
      layout.AddWidget rotationValueWidget 3 2
      layout.AddWidget twistLabelWidget 4 1
      layout.AddWidget twistValueWidget 4 2
      layout.AddWidget segmentsLabelWidget 5 1
      layout.AddWidget segmentsValueWidget 5 2
      layout.AddWidget sidesLabelWidget 6 1
      layout.AddWidget sidesValueWidget 6 2
      layout.AddLayout smoothGroupLayout 7 1 rowSpan:2 columnSpan:2
      layout.AddWidget sliceOnWidget 9 2
      layout.AddWidget sliceFromLabelWidget 10 1
      layout.AddWidget sliceFromValueWidget 10 2
      layout.AddWidget sliceToLabelWidget 11 1
      layout.AddWidget sliceToValueWidget 11 2
      layout.AddWidget generateMappingCoordsWidget 12 1 columnSpan:2
      layout.AddWidget realWorldMapSizeWidget 13 1 columnSpan:2
      layout.SetColumnStretch 1 2
      layout.SetColumnStretch 2 3
      layout.SetRowMinimumHeight 1 16
      layout.SetRowMinimumHeight 2 16
      layout.SetRowMinimumHeight 3 16
      layout.SetRowMinimumHeight 4 16
      layout.SetRowMinimumHeight 5 16
      layout.SetRowMinimumHeight 6 16
      layout.SetRowFixedLength 7 35
      layout.SetRowFixedLength 8 35
      layout.SetRowMinimumHeight 9 15
      layout.SetRowMinimumHeight 10 16
      layout.SetRowMinimumHeight 11 16
      layout.SetRowMinimumHeight 12 15
      layout.SetRowMinimumHeight 13 15
      updateControl()
    )
    on RltForm Resized v do updateControl()
  )
  createDialog RltForm 160 320 \
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
