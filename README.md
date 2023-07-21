# FlexUI

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/imaoki/FlexUI)](https://github.com/imaoki/FlexUI/releases/latest)
[![GitHub](https://img.shields.io/github/license/imaoki/FlexUI)](https://github.com/imaoki/FlexUI/blob/main/LICENSE)

ロールアウトコントロールをフレキシブルに配置するためのフレームワーク。

## 特徴

* 通常はサイズが変更できないコントロールもサイズ変更が可能。

* 23種のロールアウトコントロールに対応。
  （`comboBox`、`subRollout`、`timer`は非対応）

## ライセンス

[MIT License](https://github.com/imaoki/FlexUI/blob/main/LICENSE)

## 要件

* [imaoki/Standard](https://github.com/imaoki/Standard)

* （任意）[imaoki/StartupLoader](https://github.com/imaoki/StartupLoader)
  導入済みの場合はインストール/アンインストールでスタートアップスクリプトの登録/解除が行われる。
  未使用の場合はスクリプトの評価のみ行われる。

## 開発環境

`3ds Max 2024`

## インストール

01. 依存スクリプトは予めインストールしておく。

02. `install.ms`を実行する。

## アンインストール

`uninstall.ms`を実行する。

## 単一ファイル版

### インストール

01. 依存スクリプトは予めインストールしておく。

02. `Distribution\FlexUI.min.ms`を実行する。

### アンインストール

```maxscript
::flexUI.Uninstall()
```

## 例

* Widget(`Example\Widget\FlexEditTextControlWidget.ms`)

  ![Example-Widget](Resource/Example-Widget.gif "Example-Widget")

* Layout(`Example\Layout\FlexGridLayout.ms`)

  ![Example-Layout](Resource/Example-Layout.gif "Example-Layout")

* Calc(`Example\Calc.ms`)

  ![Example-Calc](Resource/Example-Calc.png "Example-Calc")

* Explorer(`Example\Explorer.ms`)

  ![Example-Explorer](Resource/Example-Explorer.png "Example-Explorer")

* Form(`Example\Form.ms`)

  ![Example-Form](Resource/Example-Form.png "Example-Form")

* TabPage(`Example\TabPage.ms`)

  ![Example-TabPage](Resource/Example-TabPage.png "Example-TabPage")

## 使い方

### Widget

* ウィジェットは全種類が共通のプロパティとメソッドを持つ。

* 既定のサイズ、最小サイズ、およびリサイズの可/不可はロールアウトコントロールの特性に合わせて定数として定義されている。

```maxscript
(
  local widget = ::flexUI.CreateWidget Edt

  -- 全体の水平方向の位置合わせを設定
  widget.SetAlignmentH #Center

  -- 全体の垂直方向の位置合わせを設定
  widget.SetAlignmentV #Center

  -- キャプションと本体との余白ピクセルを設定
  widget.SetCaptionMargin 3

  -- キャプションの表示位置を設定
  widget.SetCaptionPosition #Left

  -- キャプションを含まない明示的な高さを設定
  widget.SetExplicitH undefined

  -- キャプションを含まない明示的な幅を設定
  widget.SetExplicitW undefined

  -- ロールアウトコントロールの可視性を設定
  widget.SetVisibility false

  -- ロールアウトコントロールの矩形を設定
  widget.SetRect (Box2 0 0 100 100)
)
```

### Layout

#### GridLayout

* 仮想グリッド上にアイテムを配置するレイアウト。

* グリッドは必要に応じて自動的に拡張される。

```maxscript
(
  -- 任意でレイアウトオプションを設定
  local layoutOptions = ::flexUI.CreateLayoutOptions()
  local gridLayout = ::flexUI.CreateGridLayout options:layoutOptions

  -- レイアウトを追加（セルを配置する行、セルを配置する列）
  gridLayout.AddLayout vBoxLayout 1 1

  -- ウィジェットを追加（セルを配置する行、セルを配置する列、セルが専有する行数、セルが専有する列数）
  gridLayout.AddWidget widget 2 3 rowSpan:1 columnSpan:3

  -- 行の最小高を設定（対象の列、最小高）
  gridLayout.SetRowMinimumHeight 1 10

  -- 列の最小幅を設定（対象の列、最小幅）
  gridLayout.SetColumnMinimumWidth 2 10

  -- 行のストレッチ係数を設定（対象の行、ストレッチ係数）
  gridLayout.SetRowStretch 2 2

  -- 列のストレッチ係数を設定（対象の列、ストレッチ係数）
  gridLayout.SetColumnStretch 3 2

  -- 行の固定高を設定（対象の列、固定高）
  gridLayout.SetRowFixedLength 1 20

  -- 列の固定幅を設定（対象の列、固定幅）
  gridLayout.SetColumnFixedLength 1 20

  -- セルのアイテムの可視性を設定
  gridLayout.SetVisibility false

  -- レイアウトの矩形を設定
  gridLayout.SetRect (Box2 0 0 100 100)
)
```

#### GroupLayout

* `GroupBoxControl`用のレイアウト。

```maxscript
(
  -- `GroupBoxControl`ウィジェットが必須
  local groupBoxWidget = ::flexUI.CreateWidget Gbx
  local groupLayout = ::flexUI.CreateGroupLayout groupBoxWidget

  -- セルのアイテムを設定
  groupLayout.SetCell widget

  -- セルのアイテムの可視性を設定
  groupLayout.SetVisibility false

  -- レイアウトの矩形を設定
  groupLayout.SetRect (Box2 0 0 100 100)
)
```

#### HBoxLayout

* 水平方向にアイテムを配置するレイアウト。

```maxscript
(
  -- 任意でレイアウトオプションを設定
  local layoutOptions = ::flexUI.CreateLayoutOptions()
  local hBoxLayout = ::flexUI.CreateHBoxLayout options:layoutOptions

  -- レイアウトを追加
  hBoxLayout.AddLayout groupLayout

  -- 固定スペースを追加
  hBoxLayout.AddSpace 10

  -- ストレッチ可能なスペースを追加
  hBoxLayout.AddStretch stretch:2

  -- ウィジェットを追加
  hBoxLayout.AddWidget widget stretch:3

  -- 固定幅でレイアウトを追加
  hBoxLayout.AddLayout groupLayout fixedLength:20

  -- 固定幅でウィジェットを追加
  hBoxLayout.AddWidget widget fixedLength:20

  -- セルのアイテムの可視性を設定
  hBoxLayout.SetVisibility false

  -- レイアウトの矩形を設定
  hBoxLayout.SetRect (Box2 0 0 100 100)
)
```

#### VBoxLayout

* 垂直方向にアイテムを配置するレイアウト。

* メソッドは`HBoxLayout`と共通。

```maxscript
(
  -- 任意でレイアウトオプションを設定
  local layoutOptions = ::flexUI.CreateLayoutOptions()
  local vBoxLayout = ::flexUI.CreateVBoxLayout options:layoutOptions

  -- レイアウトの矩形を設定
  vBoxLayout.SetRect (Box2 0 0 100 100)
)
```

#### StackedLayout

* 登録されたアイテムの内一つのみを表示するレイアウト。

```maxscript
(
  -- 任意でレイアウトオプションを設定
  local layoutOptions = ::flexUI.CreateLayoutOptions()
  local stackedLayout = ::flexUI.CreateStackedLayout options:layoutOptions

  -- レイアウトを追加
  stackedLayout.AddLayout layout

  -- ウィジェットを追加
  stackedLayout.AddWidget widget

  -- レイアウトを追加（挿入先インデックスを指定）
  stackedLayout.AddLayout layout index:2

  -- ウィジェットを追加（挿入先インデックスを指定）
  stackedLayout.AddWidget widget index:2

  -- 現在表示されているアイテムのインデックスを設定
  stackedLayout.SetCurrentIndex 2

  -- ロールアウトコントロールの選択と現在のインデックスを同期させる
  DdlPage.Selection = stackedLayout.GetCurrentIndex()

  -- レイアウトの矩形を設定
  stackedLayout.SetRect (Box2 0 0 100 100)
)
```

## 制限

* `RolloutFloater`および`SubRollout`には非対応。
  `Resized`イベントの発生するダイアログでのみ使用可能。

* `FlexComboBoxControlWidgetStruct`は`dropDownList`にのみ対応。
  現状では`dropDownList`との判別ができないため使用頻度の低そうな`comboBox`を非対応とした。

* `curveControl`のサイズ変更には非対応。

* `slider`の`orient`パラメータは`#Horizontal`にのみ対応。

## 追加情報

### グローバル変数

* 通常はグローバル変数`::flexUI`を通して操作する。

* 詳細は[`mxsdoc.FlexUI.ms`](https://imaoki.github.io/kb/mxsdoc/flexui-flexui.html)を参照。

### ウィジェットの種類

| ウィジェット                                                                                                                          | ロールアウトコントロール | 幅   | 高さ | イメージ                                                                                                     |
| ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ | ---- | ---- | ------------------------------------------------------------------------------------------------------------ |
| [`FlexAngleControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexanglecontrolwidget.html)               | `angle`                  | 可変 | 可変 | ![FlexAngleControlWidget](Resource/FlexAngleControlWidget.png "FlexAngleControlWidget")                      |
| [`FlexBitmapControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexbitmapcontrolwidget.html)             | `bitmap`                 | 可変 | 可変 | ![FlexBitmapControlWidget](Resource/FlexBitmapControlWidget.png "FlexBitmapControlWidget")                   |
| [`FlexButtonControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexbuttoncontrolwidget.html)             | `button`                 | 可変 | 可変 | ![FlexButtonControlWidget](Resource/FlexButtonControlWidget.png "FlexButtonControlWidget")                   |
| [`FlexCheckBoxControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexcheckboxcontrolwidget.html)         | `checkBox`               | 固定 | 固定 | ![FlexCheckBoxControlWidget](Resource/FlexCheckBoxControlWidget.png "FlexCheckBoxControlWidget")             |
| [`FlexCheckButtonControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexcheckbuttoncontrolwidget.html)   | `checkButton`            | 可変 | 可変 | ![FlexCheckButtonControlWidget](Resource/FlexCheckButtonControlWidget.png "FlexCheckButtonControlWidget")    |
| [`FlexColorPickerControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexcolorpickercontrolwidget.html)   | `colorPicker`            | 可変 | 可変 | ![FlexColorPickerControlWidget](Resource/FlexColorPickerControlWidget.png "FlexColorPickerControlWidget")    |
| [`FlexComboBoxControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexcomboboxcontrolwidget.html)         | `dropDownList`           | 可変 | 固定 | ![FlexComboBoxControlWidget](Resource/FlexComboBoxControlWidget.png "FlexComboBoxControlWidget")             |
| [`FlexDotNetControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexdotnetcontrolwidget.html)             | `dotNetControl`          | 可変 | 可変 | ![FlexDotNetControlWidget](Resource/FlexDotNetControlWidget.png "FlexDotNetControlWidget")                   |
| [`FlexEditTextControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexedittextcontrolwidget.html)         | `editText`               | 可変 | 可変 | ![FlexEditTextControlWidget](Resource/FlexEditTextControlWidget.png "FlexEditTextControlWidget")             |
| [`FlexGroupBoxControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexgroupboxcontrolwidget.html)         | `groupBox`               | 可変 | 可変 | ![FlexGroupBoxControlWidget](Resource/FlexGroupBoxControlWidget.png "FlexGroupBoxControlWidget")             |
| [`FlexImgTagWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-fleximgtagwidget.html)                           | `imgTag`                 | 可変 | 可変 | ![FlexImgTagWidget](Resource/FlexImgTagWidget.png "FlexImgTagWidget")                                        |
| [`FlexLabelControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexlabelcontrolwidget.html)               | `label`                  | 固定 | 固定 | ![FlexLabelControlWidget](Resource/FlexLabelControlWidget.png "FlexLabelControlWidget")                      |
| [`FlexLinkControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexlinkcontrolwidget.html)                 | `hyperLink`              | 固定 | 固定 | ![FlexLinkControlWidget](Resource/FlexLinkControlWidget.png "FlexLinkControlWidget")                         |
| [`FlexListBoxControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexlistboxcontrolwidget.html)           | `listBox`                | 可変 | 可変 | ![FlexListBoxControlWidget](Resource/FlexListBoxControlWidget.png "FlexListBoxControlWidget")                |
| [`FlexMapButtonControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexmapbuttoncontrolwidget.html)       | `mapButton`              | 可変 | 可変 | ![FlexMapButtonControlWidget](Resource/FlexMapButtonControlWidget.png "FlexMapButtonControlWidget")          |
| [`FlexMaxCurveCtlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexmaxcurvectlwidget.html)                 | `curveControl`           | 固定 | 固定 | ![FlexMaxCurveCtlWidget](Resource/FlexMaxCurveCtlWidget.png "FlexMaxCurveCtlWidget")                         |
| [`FlexMtlButtonControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexmtlbuttoncontrolwidget.html)       | `materialButton`         | 可変 | 可変 | ![FlexMtlButtonControlWidget](Resource/FlexMtlButtonControlWidget.png "FlexMtlButtonControlWidget")          |
| [`FlexMultiListBoxControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexmultilistboxcontrolwidget.html) | `multiListBox`           | 可変 | 可変 | ![FlexMultiListBoxControlWidget](Resource/FlexMultiListBoxControlWidget.png "FlexMultiListBoxControlWidget") |
| [`FlexPickerControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexpickercontrolwidget.html)             | `pickButton`             | 可変 | 可変 | ![FlexPickerControlWidget](Resource/FlexPickerControlWidget.png "FlexPickerControlWidget")                   |
| [`FlexProgressBarWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexprogressbarwidget.html)                 | `progressBar`            | 可変 | 可変 | ![FlexProgressBarWidget](Resource/FlexProgressBarWidget.png "FlexProgressBarWidget")                         |
| [`FlexRadioControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexradiocontrolwidget.html)               | `radioButtons`           | 可変 | 可変 | ![FlexRadioControlWidget](Resource/FlexRadioControlWidget.png "FlexRadioControlWidget")                      |
| [`FlexSliderControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexslidercontrolwidget.html)             | `slider`                 | 可変 | 固定 | ![FlexSliderControlWidget](Resource/FlexSliderControlWidget.png "FlexSliderControlWidget")                   |
| [`FlexSpinnerControlWidgetStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexspinnercontrolwidget.html)           | `spinner`                | 可変 | 固定 | ![FlexSpinnerControlWidget](Resource/FlexSpinnerControlWidget.png "FlexSpinnerControlWidget")                |

### レイアウトの種類

| レイアウト                                                                                                    | 説明                                     | イメージ                                                                 |
| ------------------------------------------------------------------------------------------------------------- | ---------------------------------------- | ------------------------------------------------------------------------ |
| [`FlexGridLayoutStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-layout-flexgridlayout.html)       | グリッドにアイテムを配置する             | ![FlexGridLayout](Resource/FlexGridLayout.png "FlexGridLayout")          |
| [`FlexGroupLayoutStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-layout-flexgrouplayout.html)     | `GroupBoxControl`用のレイアウト          | ![FlexGroupLayout](Resource/FlexGroupLayout.png "FlexGroupLayout")       |
| [`FlexHBoxLayoutStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-layout-flexhboxlayout.html)       | 水平方向にアイテムを配置する             | ![FlexHBoxLayout](Resource/FlexHBoxLayout.png "FlexHBoxLayout")          |
| [`FlexVBoxLayoutStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-layout-flexvboxlayout.html)       | 垂直方向にアイテムを配置する             | ![FlexVBoxLayout](Resource/FlexVBoxLayout.png "FlexVBoxLayout")          |
| [`FlexStackedLayoutStruct`](https://imaoki.github.io/kb/mxsdoc/flexui-model-layout-flexstackedlayout.html) | 登録されたアイテムの内一つのみを表示する | ![FlexStackedLayout](Resource/FlexStackedLayout.png "FlexStackedLayout") |

### レイアウトオプション

* レイアウト各部の余白を設定する。

* 詳細は[`mxsdoc.FlexLayoutOptions.ms`](https://imaoki.github.io/kb/mxsdoc/flexui-model-layout-flexlayoutoptions.html)を参照。

```maxscript
(
  local layoutOptions = ::flexUI.CreateLayoutOptions()

  -- セル間の水平方向の余白を設定
  layoutOptions.SetMarginH 0

  -- セル間の垂直方向の余白を設定
  layoutOptions.SetMarginV 0

  -- レイアウト外周の下側の余白を設定
  layoutOptions.SetPaddingB 0

  -- レイアウト外周の左側の余白を設定
  layoutOptions.SetPaddingL 0

  -- レイアウト外周の右側の余白を設定
  layoutOptions.SetPaddingR 0

  -- レイアウト外周の上側の余白を設定
  layoutOptions.SetPaddingT 0

  -- セル間の余白を一括設定（水平方向の余白、垂直方向の余白）
  layoutOptions.SetMargin 0 0

  -- レイアウト外周の余白を一括設定（上側の余白、右側の余白、下側の余白、左側の余白）
  layoutOptions.SetPadding 0 0 0 0
)
```

### 通知

#### Widget

全てのウィジェットで共通。

* [Widget](https://imaoki.github.io/kb/mxsdoc/flexui-model-widget-flexanglecontrolwidget.html#flexanglecontrolwidgetstruct)

#### Layout

* [FlexGridLayoutStruct](https://imaoki.github.io/kb/mxsdoc/flexui-model-layout-flexgridlayout.html#flexgridlayoutstruct)

* [FlexGroupLayoutStruct](https://imaoki.github.io/kb/mxsdoc/flexui-model-layout-flexgrouplayout.html#flexgrouplayoutstruct)

* [FlexHBoxLayoutStruct](https://imaoki.github.io/kb/mxsdoc/flexui-model-layout-flexhboxlayout.html#flexhboxlayoutstruct)

* [FlexVBoxLayoutStruct](https://imaoki.github.io/kb/mxsdoc/flexui-model-layout-flexvboxlayout.html#flexvboxlayoutstruct)

* [FlexStackedLayoutStruct](https://imaoki.github.io/kb/mxsdoc/flexui-model-layout-flexstackedlayout.html#flexstackedlayoutstruct)

#### Layout Options

* [FlexLayoutOptionsStruct](https://imaoki.github.io/kb/mxsdoc/flexui-model-layout-flexlayoutoptions.html#flexlayoutoptionsstruct)
