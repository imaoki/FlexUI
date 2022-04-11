/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  /* 初期化 */
  local mp = ::MxsPackStruct (getSourceFileName())
  /* 出力先ディレクトリ削除 */
  -- mp.DeleteDirectory @".\Distribution"

  /* コード切り出し */
  local definitionPoolCode = mp.ClipFile @".\definitionPool.ms" 1 3836
  local FlexUICode = mp.ClipFile @".\FlexUI.ms" 1 -1

  local FlexBoxCellCode = mp.ClipFile @".\Model\Layout\FlexBoxCell.ms" 602 -1
  local FlexGridCellCode = mp.ClipFile @".\Model\Layout\FlexGridCell.ms" 649 -1
  local FlexGridLayoutCode = mp.ClipFile @".\Model\Layout\FlexGridLayout.ms" 1090 -1
  local FlexGroupLayoutCode = mp.ClipFile @".\Model\Layout\FlexGroupLayout.ms" 610 -1
  local FlexHBoxLayoutCode = mp.ClipFile @".\Model\Layout\FlexHBoxLayout.ms" 794 -1
  local FlexLayoutOptionsCode = mp.ClipFile @".\Model\Layout\FlexLayoutOptions.ms" 681 -1
  local FlexStackedLayoutCode = mp.ClipFile @".\Model\Layout\FlexStackedLayout.ms" 667 -1
  local FlexVBoxLayoutCode = mp.ClipFile @".\Model\Layout\FlexVBoxLayout.ms" 794 -1

  local FlexAngleControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexAngleControlWidget.ms" 1191 -1
  local FlexBitmapControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexBitmapControlWidget.ms" 1192 -1
  local FlexButtonControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexButtonControlWidget.ms" 1192 -1
  local FlexCheckBoxControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexCheckBoxControlWidget.ms" 1194 -1
  local FlexCheckButtonControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexCheckButtonControlWidget.ms" 1197 -1
  local FlexColorPickerControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexColorPickerControlWidget.ms" 1197 -1
  local FlexComboBoxControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexComboBoxControlWidget.ms" 1194 -1
  local FlexDotNetControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexDotNetControlWidget.ms" 1192 -1
  local FlexEditTextControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexEditTextControlWidget.ms" 1194 -1
  local FlexGroupBoxControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexGroupBoxControlWidget.ms" 1194 -1
  local FlexImgTagWidgetCode = mp.ClipFile @".\Model\Widget\FlexImgTagWidget.ms" 1185 -1
  local FlexLabelControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexLabelControlWidget.ms" 1191 -1
  local FlexLinkControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexLinkControlWidget.ms" 1190 -1
  local FlexListBoxControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexListBoxControlWidget.ms" 1193 -1
  local FlexMapButtonControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexMapButtonControlWidget.ms" 1195 -1
  local FlexMaxCurveCtlWidgetCode = mp.ClipFile @".\Model\Widget\FlexMaxCurveCtlWidget.ms" 1190 -1
  local FlexMtlButtonControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexMtlButtonControlWidget.ms" 1195 -1
  local FlexMultiListBoxControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexMultiListBoxControlWidget.ms" 1198 -1
  local FlexPickerControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexPickerControlWidget.ms" 1192 -1
  local FlexProgressBarWidgetCode = mp.ClipFile @".\Model\Widget\FlexProgressBarWidget.ms" 1190 -1
  local FlexRadioControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexRadioControlWidget.ms" 1191 -1
  local FlexSliderControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexSliderControlWidget.ms" 1192 -1
  local FlexSpinnerControlWidgetCode = mp.ClipFile @".\Model\Widget\FlexSpinnerControlWidget.ms" 1193 -1

  /* コード置換 */
  local code = mp.ReplaceText definitionPoolCode 3787 50 FlexSpinnerControlWidgetCode
  code = mp.ReplaceText code 3667 49 FlexSliderControlWidgetCode
  code = mp.ReplaceText code 3549 48 FlexRadioControlWidgetCode
  code = mp.ReplaceText code 3433 47 FlexProgressBarWidgetCode
  code = mp.ReplaceText code 3316 49 FlexPickerControlWidgetCode
  code = mp.ReplaceText code 3191 55 FlexMultiListBoxControlWidgetCode
  code = mp.ReplaceText code 3063 52 FlexMtlButtonControlWidgetCode
  code = mp.ReplaceText code 2943 47 FlexMaxCurveCtlWidgetCode
  code = mp.ReplaceText code 2823 52 FlexMapButtonControlWidgetCode
  code = mp.ReplaceText code 2700 50 FlexListBoxControlWidgetCode
  code = mp.ReplaceText code 2582 47 FlexLinkControlWidgetCode
  code = mp.ReplaceText code 2466 48 FlexLabelControlWidgetCode
  code = mp.ReplaceText code 2355 42 FlexImgTagWidgetCode
  code = mp.ReplaceText code 2241 51 FlexGroupBoxControlWidgetCode
  code = mp.ReplaceText code 2118 51 FlexEditTextControlWidgetCode
  code = mp.ReplaceText code 1997 49 FlexDotNetControlWidgetCode
  code = mp.ReplaceText code 1876 51 FlexComboBoxControlWidgetCode
  code = mp.ReplaceText code 1750 54 FlexColorPickerControlWidgetCode
  code = mp.ReplaceText code 1621 54 FlexCheckButtonControlWidgetCode
  code = mp.ReplaceText code 1495 51 FlexCheckBoxControlWidgetCode
  code = mp.ReplaceText code 1374 49 FlexButtonControlWidgetCode
  code = mp.ReplaceText code 1255 49 FlexBitmapControlWidgetCode
  code = mp.ReplaceText code 1137 48 FlexAngleControlWidgetCode
  code = mp.ReplaceText code 1016 40 FlexGridLayoutCode
  code = mp.ReplaceText code 857 40 FlexVBoxLayoutCode
  code = mp.ReplaceText code 753 43 FlexStackedLayoutCode
  code = mp.ReplaceText code 649 40 FlexHBoxLayoutCode
  code = mp.ReplaceText code 505 41 FlexGroupLayoutCode
  code = mp.ReplaceText code 379 43 FlexLayoutOptionsCode
  code = mp.ReplaceText code 277 38 FlexGridCellCode
  code = mp.ReplaceText code 181 37 FlexBoxCellCode
  code = mp.ClipText code 64 -1
  code = mp.ReplaceText FlexUICode 714 27 code

  /* インストールコード追加 */
  code = mp.AppendText code "::FlexUIStruct.Install()\n::FlexUIStruct\n"
  /* インストーラーオプション削除 */
  code = mp.RemoveInstallerOption code
  /* バンドルファイルを保存 */
  -- mp.WriteAllText @".\Distribution\FlexUI.bundle.ms" code
  /* 最小化ファイルを保存 */
  code = mp.Minify code
  mp.WriteAllText @".\Distribution\FlexUI.min.ms" code
  /* ファイルコピー */
  -- mp.CopyDirectory @".\FlexUI.SubDir" @".\Distribution\FlexUI.SubDir"
  ok
)
