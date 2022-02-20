# FlexUI

ロールアウトコントロールをフレキシブルに配置するためのフレームワーク。

## 特徴

* Qtライクな使用感。

* 24種類のロールアウトコントロールに対応。
  （`comboBox`と`timer`は非対応）

* `progressBar`や`spinner`等、通常はサイズ変更できないコントロールもサイズ変更可能。

## サンプル

## 要件

* [imaoki/Standard](https://github.com/imaoki/Standard)

## 動作確認

`3ds Max 2022.3 Update`

## スタートアップに登録する

`register.ms`を実行する。

## スタートアップから登録解除する

`unregister.ms`を実行する。

## 使い方

### ウィジェット

```
(
  local widget = ::flexUI.CreateWidget Btn
  widget.SetRect (Box2 0 0 100 100)
)
```

### レイアウト

```
(
  local layout = ::flexUI.CreateLayout #VBox
  layout.SetRect (Box2 0 0 100 100)
)
```

### `VBox`レイアウトの例

```maxscript
(
  rollout RltSample "FlexUI Sample" (
    imgTag Itg1 "ImgTag" bitmap:(BitMap 1 1 Color:(Color 159 31 31))
    imgTag Itg2 "ImgTag" bitmap:(BitMap 1 1 Color:(Color 31 159 31))
    imgTag Itg3 "ImgTag" bitmap:(BitMap 1 1 Color:(Color 31 31 159))

    local layout = undefined

    local padding = 80
    local bgColor = Color 31 95 95
    local rectColor = Color 63 127 127

    fn getRect = (
      local size = getDialogSize RltSample
      if size.X < 1 do size.X = 1
      if size.Y < 1 do size.Y = 1
      local x = padding
      local y = padding
      local w = size.X as Integer - padding * 2
      local h = size.Y as Integer - padding * 2
      -- Box2値のサイズは`1`以上必要
      if w < 1 do w = 1
      if h < 1 do h = 1
      Box2 x y w h
    )

    fn updateBackgroundImage = (
      local size = getDialogSize RltSample
      if size.X < 1 do size.X = 1
      if size.Y < 1 do size.Y = 1
      local imageW = size.X as Integer
      local imageH = size.Y as Integer
      local bgImage = Bitmap imageW imageH Color:bgColor Gamma:(1.0 / 2.2)
      local rect = getRect()
      local rectImage = Bitmap rect.W rect.H Color:rectColor
      pasteBitmap rectImage bgImage [0, 0] [rect.X, rect.Y] type:#Paste
      setDialogBitmap RltSample bgImage
      ok
    )

    fn updateControl = (
      updateBackgroundImage()
      local rects = layout.SetRect (getRect())
      ok
    )

    on RltSample Open do (
      -- ウィジェットを作成
      local widget1 = ::flexUI.CreateWidget Itg1
      local widget2 = ::flexUI.CreateWidget Itg2
      local widget3 = ::flexUI.CreateWidget Itg3

      -- レイアウトを作成
      layout = ::flexUI.CreateLayout #VBox

      -- レイアウトオプションを設定
      layout.Options.SetMargin 5 5
      layout.Options.SetPadding 5 5 5 5

      -- ウィジェットを追加
      layout.AddWidget widget1

      -- スペースを追加
      layout.AddSpace 10

      -- ウィジェットをストレッチ係数`2`で追加
      layout.AddWidget widget2 stretch:2

      -- ストレッチをストレッチ係数`2`で追加
      layout.AddStretch stretch:2

      -- ウィジェットを最小高`10`で追加
      layout.AddWidget widget3 minimum:10

      -- コントロールを更新
      updateControl()
    )
    on RltSample Resized v do updateControl()
  )
  createDialog RltSample 320 320 \
      bmpStyle:#Bmp_Tile \
      style:#(#Style_Resizing, #Style_Sysmenu, #Style_ToolWindow)
  ok
)
```

## `::flexUI`

通常はこのグローバル変数を通して操作する。
プロパティやメソッドの詳細は[`mxsdoc.FlexUI.ms`](https://imaoki.github.io/mxskb/mxsdoc/flexui-flexui.html)を参照。

## ウィジェット

ウィジェットは全て共通のプロパティを持ち、コントロール毎に定義する。
プロパティやメソッドの詳細は各ウィジェットのドキュメントを参照。

### 設定可能なプロパティ

| プロパティ        | 説明                               |
| ----------------- | ---------------------------------- |
| `alignmentH`      | 全体の水平方向の位置合わせ         |
| `alignmentV`      | 全体の垂直方向の位置合わせ         |
| `captionMargin`   | キャプションと本体との余白ピクセル |
| `captionPosition` | キャプションの表示位置             |
| `explicitH`       | キャプションを含まない明示的な高さ |
| `explicitW`       | キャプションを含まない明示的な幅   |

### 定数プロパティ

| プロパティ   | 説明                             |
| ------------ | -------------------------------- |
| `defaultH`   | キャプションを含まない既定の高さ |
| `defaultW`   | キャプションを含まない既定の幅   |
| `minH`       | キャプションを含まない最小の高さ |
| `minW`       | キャプションを含まない最小の幅   |
| `resizableH` | 高さが変更可能かどうか           |
| `resizableW` | 幅が変更可能かどうか             |

### ウィジェットの種類

| ウィジェット                                                                                                                    | コントロール     | 幅   | 高さ | 画像                                                                                                         |
| ------------------------------------------------------------------------------------------------------------------------------- | ---------------- | ---- | ---- | ------------------------------------------------------------------------------------------------------------ |
| [`FlexAngleControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexanglecontrolwidget.html)               | `angle`          | 可変 | 可変 | ![FlexAngleControlWidget](Resource/FlexAngleControlWidget.png "FlexAngleControlWidget")                      |
| [`FlexBitmapControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexbitmapcontrolwidget.html)             | `bitmap`         | 可変 | 可変 | ![FlexBitmapControlWidget](Resource/FlexBitmapControlWidget.png "FlexBitmapControlWidget")                   |
| [`FlexButtonControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexbuttoncontrolwidget.html)             | `button`         | 可変 | 可変 | ![FlexButtonControlWidget](Resource/FlexButtonControlWidget.png "FlexButtonControlWidget")                   |
| [`FlexCheckBoxControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexcheckboxcontrolwidget.html)         | `checkBox`       | 固定 | 固定 | ![FlexCheckBoxControlWidget](Resource/FlexCheckBoxControlWidget.png "FlexCheckBoxControlWidget")             |
| [`FlexCheckButtonControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexcheckbuttoncontrolwidget.html)   | `checkButton`    | 可変 | 可変 | ![FlexCheckButtonControlWidget](Resource/FlexCheckButtonControlWidget.png "FlexCheckButtonControlWidget")    |
| [`FlexColorPickerControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexcolorpickercontrolwidget.html)   | `colorPicker`    | 可変 | 可変 | ![FlexColorPickerControlWidget](Resource/FlexColorPickerControlWidget.png "FlexColorPickerControlWidget")    |
| [`FlexComboBoxControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexcomboboxcontrolwidget.html)         | `dropDownList`   | 可変 | 固定 | ![FlexComboBoxControlWidget](Resource/FlexComboBoxControlWidget.png "FlexComboBoxControlWidget")             |
| [`FlexDotNetControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexdotnetcontrolwidget.html)             | `dotNetControl`  | 可変 | 可変 | ![FlexDotNetControlWidget](Resource/FlexDotNetControlWidget.png "FlexDotNetControlWidget")                   |
| [`FlexEditTextControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexedittextcontrolwidget.html)         | `editText`       | 可変 | 可変 | ![FlexEditTextControlWidget](Resource/FlexEditTextControlWidget.png "FlexEditTextControlWidget")             |
| [`FlexGroupBoxControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexgroupboxcontrolwidget.html)         | `groupBox`       | 可変 | 可変 | ![FlexGroupBoxControlWidget](Resource/FlexGroupBoxControlWidget.png "FlexGroupBoxControlWidget")             |
| [`FlexImgTagWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-fleximgtagwidget.html)                           | `imgTag`         | 可変 | 可変 | ![FlexImgTagWidget](Resource/FlexImgTagWidget.png "FlexImgTagWidget")                                        |
| [`FlexLabelControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexlabelcontrolwidget.html)               | `label`          | 固定 | 固定 | ![FlexLabelControlWidget](Resource/FlexLabelControlWidget.png "FlexLabelControlWidget")                      |
| [`FlexLinkControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexlinkcontrolwidget.html)                 | `hyperLink`      | 固定 | 固定 | ![FlexLinkControlWidget](Resource/FlexLinkControlWidget.png "FlexLinkControlWidget")                         |
| [`FlexListBoxControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexlistboxcontrolwidget.html)           | `listBox`        | 可変 | 可変 | ![FlexListBoxControlWidget](Resource/FlexListBoxControlWidget.png "FlexListBoxControlWidget")                |
| [`FlexMapButtonControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexmapbuttoncontrolwidget.html)       | `mapButton`      | 可変 | 可変 | ![FlexMapButtonControlWidget](Resource/FlexMapButtonControlWidget.png "FlexMapButtonControlWidget")          |
| [`FlexMaxcurveCtlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexmaxcurvectlwidget.html)                 | `curveControl`   | 固定 | 固定 | ![FlexMaxcurveCtlWidget](Resource/FlexMaxcurveCtlWidget.png "FlexMaxcurveCtlWidget")                         |
| [`FlexMtlButtonControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexmtlbuttoncontrolwidget.html)       | `materialButton` | 可変 | 可変 | ![FlexMtlButtonControlWidget](Resource/FlexMtlButtonControlWidget.png "FlexMtlButtonControlWidget")          |
| [`FlexMultiListBoxControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexmultilistboxcontrolwidget.html) | `multiListBox`   | 可変 | 可変 | ![FlexMultiListBoxControlWidget](Resource/FlexMultiListBoxControlWidget.png "FlexMultiListBoxControlWidget") |
| [`FlexPickerControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexpickercontrolwidget.html)             | `pickButton`     | 可変 | 可変 | ![FlexPickerControlWidget](Resource/FlexPickerControlWidget.png "FlexPickerControlWidget")                   |
| [`FlexProgressBarWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexprogressbarwidget.html)                 | `progressBar`    | 可変 | 可変 | ![FlexProgressBarWidget](Resource/FlexProgressBarWidget.png "FlexProgressBarWidget")                         |
| [`FlexRadioControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexradiocontrolwidget.html)               | `radioButtons`   | 可変 | 可変 | ![FlexRadioControlWidget](Resource/FlexRadioControlWidget.png "FlexRadioControlWidget")                      |
| [`FlexSliderControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexslidercontrolwidget.html)             | `slider`         | 可変 | 固定 | ![FlexSliderControlWidget](Resource/FlexSliderControlWidget.png "FlexSliderControlWidget")                   |
| [`FlexSpinnerControlWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexspinnercontrolwidget.html)           | `spinner`        | 可変 | 固定 | ![FlexSpinnerControlWidget](Resource/FlexSpinnerControlWidget.png "FlexSpinnerControlWidget")                |
| [`FlexSubRolloutWidgetStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-widget-flexsubrolloutwidget.html)                   | `subRollout`     | 可変 | 可変 | ![FlexSubRolloutWidget](Resource/FlexSubRolloutWidget.png "FlexSubRolloutWidget")                            |

#### 制限

* `FlexComboBoxControlWidgetStruct`は`dropDownList`にのみ対応する。
  `comboBox`には非対応。

* `curveControl`のサイズ変更には非対応。

* `slider`の`orient`パラメータは`#Horizontal`にのみ対応。

## レイアウト

レイアウトはそれぞれ固有のプロパティを持つ。
プロパティやメソッドの詳細は各レイアウトのドキュメントを参照。

| レイアウト                                                                                        | 説明                         | 画像                                                            |
| ------------------------------------------------------------------------------------------------- | ---------------------------- | --------------------------------------------------------------- |
| [`FlexGridLayoutStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-layout-flexgridlayout.html) | グリッドにアイテムを配置する | ![FlexGridLayout](Resource/FlexGridLayout.png "FlexGridLayout") |
| [`FlexHBoxLayoutStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-layout-flexhboxlayout.html) | 水平方向にアイテムを配置する | ![FlexHBoxLayout](Resource/FlexHBoxLayout.png "FlexHBoxLayout") |
| [`FlexVBoxLayoutStruct`](https://imaoki.github.io/mxskb/mxsdoc/flexui-layout-flexvboxlayout.html) | 垂直方向にアイテムを配置する | ![FlexVBoxLayout](Resource/FlexVBoxLayout.png "FlexVBoxLayout") |

### レイアウトオプション

レイアウト各部の余白を設定する。
プロパティやメソッドの詳細は[`mxsdoc.FlexLayoutOptions.ms`](https://imaoki.github.io/mxskb/mxsdoc/flexui-layout-flexlayoutoptions.html)を参照。

| プロパティ | 説明                       |
| ---------- | -------------------------- |
| `marginH`  | セル間の水平方向の余白     |
| `marginV`  | セル間の垂直方向の余白     |
| `paddingB` | レイアウト外周の下側の余白 |
| `paddingL` | レイアウト外周の左側の余白 |
| `paddingR` | レイアウト外周の右側の余白 |
| `paddingT` | レイアウト外周の上側の余白 |

`::flexUI`の`useGlobalLayoutOptions`プロパティを`true`に設定することでオプションの共有が可能。

## ライセンス

[MIT License](https://github.com/imaoki/DocGenerator/blob/main/LICENSE)
