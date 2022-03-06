/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
`CheckBoxControl`の位置とサイズを制御する。
@remarks サイズは次の順序で算出される。

01. 矩形サイズを適用

02. `defaultH`および`defaultW`がそれぞれ`0`以上の場合は適用

03. `explicitH`および`explicitW`がそれぞれ`0`以上の場合は適用

04. `minH`および`minW`を適用
*/
struct FlexCheckBoxControlWidgetStruct (
  /*- @prop <CheckBoxControl> 作成パラメータ1。ロールアウトコントロール。既定値は`undefined`。 */
  public _CP1_,

  /*-
  @prop <Name> 全体の水平方向の位置合わせ。既定値は`#Center`。

  | 値        | 位置                             |
  | --------- | -------------------------------- |
  | `#Left`   | 全体の左端を矩形の左端に合わせる |
  | `#Center` | 全体の中心を矩形の中心に合わせる |
  | `#Right`  | 全体の右端を矩形の右端に合わせる |
  */
  private alignmentH = #Center,
  /*-
  @prop <Name> 全体の垂直方向の位置合わせ。既定値は`#Center`。

  | 値        | 位置                             |
  | --------- | -------------------------------- |
  | `#Top`    | 全体の上端を矩形の上端に合わせる |
  | `#Center` | 全体の中心を矩形の中心に合わせる |
  | `#Bottom` | 全体の下端を矩形の下端に合わせる |
  */
  private alignmentV = #Center,
  /*- @prop <Integer> キャプションと本体との余白ピクセル。既定値は`3`。 */
  private captionMargin = 3,
  /*-
  @prop <Name> キャプションの表示位置。既定値は`#Left`。

  | 値      | 位置                                                       |
  | ------- | ---------------------------------------------------------- |
  | `#Left` | コントロールの左側。垂直方向はコントロールの中心に揃える。 |
  | `#Top`  | コントロールの上側。水平方向はコントロールの左端に揃える。 |
  */
  private captionPosition = #Left,
  /*- @prop <CheckBoxControl> ロールアウトコントロール。既定値は`undefined`。 */
  private control,
  /*- @prop <Integer|UndefinedClass> キャプションを含まない明示的な高さ。既定値は`undefined`。 */
  private explicitH,
  /*- @prop <Integer|UndefinedClass> キャプションを含まない明示的な幅。既定値は`undefined`。 */
  private explicitW,

  /*- @prop <Integer> キャプションを含まない既定の高さ。既定値は`-1`。 */
  private defaultH = -1,
  /*- @prop <Integer> キャプションを含まない既定の幅。既定値は`-1`。 */
  private defaultW = -1,
  /*- @prop <Integer> キャプションを含まない最小の高さ。既定値は`15`。 */
  private minH = 15,
  /*- @prop <Integer> キャプションを含まない最小の幅。既定値は`24`。 */
  private minW = 24,
  /*- @prop <BooleanClass> 高さが変更可能かどうか。既定値は`false`。 */
  private resizableH = false,
  /*- @prop <BooleanClass> 幅が変更可能かどうか。既定値は`false`。 */
  private resizableW = false,

  /*
  public fn GetAlignmentH = (),
  public fn GetAlignmentV = (),
  public fn GetCaptionMargin = (),
  public fn GetCaptionPosition = (),
  public fn GetControl = (),
  public fn GetDefaultH = (),
  public fn GetDefaultW = (),
  public fn GetExplicitH = (),
  public fn GetExplicitW = (),
  public fn GetMinH = (),
  public fn GetMinW = (),
  public fn GetRect = (),
  public fn GetResizableH = (),
  public fn GetResizableW = (),
  public fn SetAlignmentH input = (),
  public fn SetAlignmentV input = (),
  public fn SetCaptionMargin input = (),
  public fn SetCaptionPosition input = (),
  public fn SetControl obj = (),
  public fn SetExplicitH input = (),
  public fn SetExplicitW input = (),
  public fn SetRect rect = (),

  private fn getClientRect hwnd = (),
  private fn isFixedH = (),
  private fn isFixedW = (),
  private fn isValidControl obj = (),
  private fn isValidExplicitH = (),
  private fn isValidExplicitW = (),
  */

  /*-
  全体の水平方向の位置合わせを取得する。
  @returns <Name>
  */
  public fn GetAlignmentH = (
    this.alignmentH
  ),

  /*-
  全体の垂直方向の位置合わせを取得する。
  @returns <Name>
  */
  public fn GetAlignmentV = (
    this.alignmentV
  ),

  /*-
  キャプションと本体との余白ピクセルを取得する。
  @returns <Integer>
  */
  public fn GetCaptionMargin = (
    this.captionMargin
  ),

  /*-
  キャプションの表示位置を取得する。
  @returns <Name>
  */
  public fn GetCaptionPosition = (
    this.captionPosition
  ),

  /*-
  ロールアウトコントロールを取得する。
  @returns <CheckBoxControl|UndefinedClass>
  */
  public fn GetControl = (
    this.control
  ),

  /*-
  キャプションを含まない既定の高さを取得する。
  @returns <Integer>
  */
  public fn GetDefaultH = (
    this.defaultH
  ),

  /*-
  キャプションを含まない既定の幅を取得する。
  @returns <Integer>
  */
  public fn GetDefaultW = (
    this.defaultW
  ),

  /*-
  キャプションを含まない明示的な高さを取得する。
  @returns <Integer|UndefinedClass>
  */
  public fn GetExplicitH = (
    this.explicitH
  ),

  /*-
  キャプションを含まない明示的な幅を取得する。
  @returns <Integer|UndefinedClass>
  */
  public fn GetExplicitW = (
    this.explicitW
  ),

  /*-
  キャプションを含まない最小の高さを取得する。
  @returns <Integer>
  */
  public fn GetMinH = (
    this.minH
  ),

  /*-
  キャプションを含まない最小の幅を取得する。
  @returns <Integer>
  */
  public fn GetMinW = (
    this.minW
  ),

  /*-
  ロールアウトコントロールの矩形を取得する。
  @returns <Box2|UndefinedClass>
  @remarks 値を取得できない場合は`undefined`を返す。
  */
  public fn GetRect = (
    local rect = undefined
    if this.isValidControl this.control do (
      local rectL = undefined
      local rectT = undefined
      local rectR = undefined
      local rectB = undefined
      for hwnd in this.control.Hwnd do (
        local hwndRect = this.getClientRect hwnd
        local hwndL = hwndRect.X
        local hwndT = hwndRect.Y
        local hwndR = hwndL + hwndRect.W
        local hwndB = hwndT + hwndRect.H
        if classOf rectL != Integer do rectL = hwndL
        if classOf rectT != Integer do rectT = hwndT
        if classOf rectR != Integer do rectR = hwndR
        if classOf rectB != Integer do rectB = hwndB
        if rectL > hwndL do rectL = hwndL
        if rectT > hwndT do rectT = hwndT
        if rectR < hwndR do rectR = hwndR
        if rectB < hwndB do rectB = hwndB
      )
      if classOf rectL == Integer and classOf rectT == Integer \
          and classOf rectR == Integer and classOf rectB == Integer do (
        local x = rectL
        local y = rectT
        local w = rectR - rectL
        local h = rectB - rectT
        rect = Box2 x y w h
      )
    )
    rect
  ),

  /*-
  高さが変更可能かどうかを取得する。
  @returns <Integer>
  */
  public fn GetResizableH = (
    this.resizableH
  ),

  /*-
  幅が変更可能かどうかを取得する。
  @returns <Integer>
  */
  public fn GetResizableW = (
    this.resizableW
  ),

  /*-
  全体の水平方向の位置合わせを設定する。
  @param input <Name>
  | 値        | 位置                             |
  | --------- | -------------------------------- |
  | `#Left`   | 全体の左端を矩形の左端に合わせる |
  | `#Center` | 全体の中心を矩形の中心に合わせる |
  | `#Right`  | 全体の右端を矩形の右端に合わせる |
  @returns <Name>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetAlignmentH input = (
    local validValues = #(#Left, #Center, #Right)
    if findItem validValues input > 0 do (
      this.alignmentH = input
      this.notify #(#AlignmentH)
    )
    this.GetAlignmentH()
  ),

  /*-
  全体の垂直方向の位置合わせを設定する。
  @param input <Name>
  | 値        | 位置                             |
  | --------- | -------------------------------- |
  | `#Top`    | 全体の上端を矩形の上端に合わせる |
  | `#Center` | 全体の中心を矩形の中心に合わせる |
  | `#Bottom` | 全体の下端を矩形の下端に合わせる |
  @returns <Name>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetAlignmentV input = (
    local validValues = #(#Top, #Center, #Bottom)
    if findItem validValues input > 0 do (
      this.alignmentV = input
      this.notify #(#AlignmentV)
    )
    this.GetAlignmentV()
  ),

  /*-
  キャプションと本体との余白ピクセルを設定する。
  @param input <Integer> `0`以上の整数。
  @returns <Integer>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetCaptionMargin input = (
    if superClassOf input == Number do (
      input = input as Integer
      if input < 0 do input = 0
      this.captionMargin = input
      this.notify #(#CaptionMargin)
    )
    this.GetCaptionMargin()
  ),

  /*-
  キャプションの表示位置を設定する。
  @param input <Name>
  | 値      | 位置                                                       |
  | ------- | ---------------------------------------------------------- |
  | `#Left` | コントロールの左側。垂直方向はコントロールの中心に揃える。 |
  | `#Top`  | コントロールの上側。水平方向はコントロールの左端に揃える。 |
  @returns <Name>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetCaptionPosition input = (
    local validValues = #(#Left, #Top)
    if findItem validValues input > 0 do (
      this.captionPosition = input
      this.notify #(#CaptionPosition)
    )
    this.GetCaptionPosition()
  ),

  /*-
  ロールアウトコントロールを設定する。
  @param obj <CheckBoxControl>
  @returns <CheckBoxControl|UndefinedClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetControl obj = (
    if this.isValidControl obj do (
      this.control = obj
      this.notify #(#Control)
    )
    this.GetControl()
  ),

  /*-
  キャプションを含まない明示的な高さを設定する。
  @param input <Integer|UndefinedClass> `0`以上の整数、または`undefined`。
  @returns <Integer|UndefinedClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetExplicitH input = (
    if classOf input == UndefinedClass then (
      this.explicitH = input
      this.notify #(#ExplicitH)
    )
    else (
      if superClassOf input == Number do (
        input = input as Integer
        if input < 0 do input = 0
        this.explicitH = input
        this.notify #(#ExplicitH)
      )
    )
    this.GetExplicitH()
  ),

  /*-
  キャプションを含まない明示的な幅を設定する。
  @param input <Integer|UndefinedClass> `0`以上の整数、または`undefined`。
  @returns <Integer|UndefinedClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetExplicitW input = (
    if classOf input == UndefinedClass then (
      this.explicitW = input
      this.notify #(#ExplicitW)
    )
    else (
      if superClassOf input == Number do (
        input = input as Integer
        if input < 0 do input = 0
        this.explicitW = input
        this.notify #(#ExplicitW)
      )
    )
    this.GetExplicitW()
  ),

  /*-
  ロールアウトコントロールの矩形を設定する。
  @param rect <Box2>
  @returns <Box2|UndefinedClass>
  */
  public fn SetRect rect = (
    local rectX = rect.X as Integer
    local rectY = rect.Y as Integer
    local rectW = rect.W as Integer
    local rectH = rect.H as Integer
    if classOf rect == Box2 and this.isValidControl this.control do (
      if this.control.Hwnd.Count == 1 do (
        local hwnd1 = this.control.Hwnd[1]
        -- 矩形を適用
        local x = copy rectX
        local y = copy rectY
        local w = copy rectW
        local h = copy rectH
        -- 既定サイズを適用
        if this.defaultW >= 0 do w = copy this.defaultW
        if this.defaultH >= 0 do h = copy this.defaultH
        -- 明示的サイズを適用
        if this.isValidExplicitW() do w = copy this.explicitW
        if this.isValidExplicitH() do h = copy this.explicitH
        -- 固定サイズの場合は現在のサイズを継承
        local hwnd1Rect = this.getClientRect hwnd1
        if not this.resizableW do w = hwnd1Rect.W
        if not this.resizableH do h = hwnd1Rect.H
        -- 最小サイズを適用
        if w < this.minW do w = copy this.minW
        if h < this.minH do h = copy this.minH
        if w < 0 do w = 0
        if h < 0 do h = 0
        -- 水平方向の位置揃え
        if rectW > w and this.isFixedW() do (
          case this.alignmentH of (
            (#Left): ()
            (#Center): x += (rectW / 2) as Integer - (w / 2) as Integer
            (#Right): x += rectW - w
            default: ()
          )
        )
        -- 垂直方向の位置揃え
        if rectH > h and this.isFixedH() do (
          case this.alignmentV of (
            (#Top): ()
            (#Center): y += (rectH / 2) as Integer - (h / 2) as Integer
            (#Bottom): y += rectH - h
            default: ()
          )
        )
        -- コントロールの矩形を設定
        Windows.SetWindowPos hwnd1 x y w h true
        this.notify #(#RectUpdated)
      )
    )
    this.GetRect()
  ),

  /*-
  指定されたウィンドウのクライアント領域の矩形を取得する。
  @param hwnd <Integer>
  @returns <Box2>
  */
  private fn getClientRect hwnd = (
    local parentHwnd = (Windows.GetHwndData hwnd)[2]
    local rect = Windows.GetWindowPos hwnd
    local pos = Windows.ScreenToClient parentHwnd rect.X rect.Y
    Box2 (pos.X as Integer) (pos.Y as Integer) rect.W rect.H
  ),

  /*-
  @returns <BooleanClass>
  */
  private fn isFixedH = (
    this.defaultH >= 0 \
        or this.isValidExplicitH() \
        or not this.resizableH
  ),

  /*-
  @returns <BooleanClass>
  */
  private fn isFixedW = (
    this.defaultW >= 0 \
        or this.isValidExplicitW() \
        or not this.resizableW
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isValidControl obj = (
    classOf obj == CheckBoxControl
  ),

  /*-
  @returns <BooleanClass>
  */
  private fn isValidExplicitH = (
    classOf this.explicitH == Integer and this.explicitH >= 0
  ),

  /*-
  @returns <BooleanClass>
  */
  private fn isValidExplicitW = (
    classOf this.explicitW == Integer and this.explicitW >= 0
  ),

  /*- @returns <Name> */
  public fn StructName = #FlexCheckBoxControlWidgetStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%FlexCheckBoxControlWidgetStruct\n" indent to:out
    format "%  alignmentH:%\n" indent this.alignmentH to:out
    format "%  alignmentV:%\n" indent this.alignmentV to:out
    format "%  captionMargin:%\n" indent this.captionMargin to:out
    format "%  captionPosition:%\n" indent this.captionPosition to:out
    format "%  control:%\n" indent this.control to:out
    format "%  defaultH:%\n" indent this.defaultH to:out
    format "%  defaultW:%\n" indent this.defaultW to:out
    format "%  explicitH:%\n" indent this.explicitH to:out
    format "%  explicitW:%\n" indent this.explicitW to:out
    format "%  minH:%\n" indent this.minH to:out
    format "%  minW:%\n" indent this.minW to:out
    format "%  resizableH:%\n" indent this.resizableH to:out
    format "%  resizableW:%\n" indent this.resizableW to:out
    ok
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  @remarks 大文字と小文字を区別する。
  */
  public fn Equals obj = (
    local isEqualStructName = isStruct obj \
        and isProperty obj #StructName \
        and classOf obj.StructName == MAXScriptFunction \
        and obj.StructName() == this.StructName()

    local isEqualProperties = isProperty obj #GetAlignmentH \
        and classOf obj.GetAlignmentH == MAXScriptFunction \
        and obj.GetAlignmentH() == this.GetAlignmentH() \
        and isProperty obj #GetAlignmentV \
        and classOf obj.GetAlignmentV == MAXScriptFunction \
        and obj.GetAlignmentV() == this.GetAlignmentV() \
        and isProperty obj #GetCaptionMargin \
        and classOf obj.GetCaptionMargin == MAXScriptFunction \
        and obj.GetCaptionMargin() == this.GetCaptionMargin() \
        and isProperty obj #GetCaptionPosition \
        and classOf obj.GetCaptionPosition == MAXScriptFunction \
        and obj.GetCaptionPosition() == this.GetCaptionPosition() \
        and isProperty obj #GetControl \
        and classOf obj.GetControl == MAXScriptFunction \
        and obj.GetControl() == this.GetControl() \
        and isProperty obj #GetDefaultH \
        and classOf obj.GetDefaultH == MAXScriptFunction \
        and obj.GetDefaultH() == this.GetDefaultH() \
        and isProperty obj #GetDefaultW \
        and classOf obj.GetDefaultW == MAXScriptFunction \
        and obj.GetDefaultW() == this.GetDefaultW() \
        and isProperty obj #GetExplicitH \
        and classOf obj.GetExplicitH == MAXScriptFunction \
        and obj.GetExplicitH() == this.GetExplicitH() \
        and isProperty obj #GetExplicitW \
        and classOf obj.GetExplicitW == MAXScriptFunction \
        and obj.GetExplicitW() == this.GetExplicitW() \
        and isProperty obj #GetMinH \
        and classOf obj.GetMinH == MAXScriptFunction \
        and obj.GetMinH() == this.GetMinH() \
        and isProperty obj #GetMinW \
        and classOf obj.GetMinW == MAXScriptFunction \
        and obj.GetMinW() == this.GetMinW() \
        and isProperty obj #GetResizableH \
        and classOf obj.GetResizableH == MAXScriptFunction \
        and obj.GetResizableH() == this.GetResizableH() \
        and isProperty obj #GetResizableW \
        and classOf obj.GetResizableW == MAXScriptFunction \
        and obj.GetResizableW() == this.GetResizableW()

    isEqualStructName and isEqualProperties
  ),

  /*- @prop <Array[<Struct:ObserverStruct>]> */
  private observers = #(),

  /*-
  @param observer <Struct:ObserverStruct>
  @returns <BooleanClass> 成功した場合は`true`、失敗した場合は`false`。
  */
  public fn AddObserver observer = (
    if this.findObserver observer == 0 do (
      append this.observers observer
    )
    this.findObserver observer > 0
  ),

  /*-
  @param observer <Struct:ObserverStruct>
  @returns <BooleanClass> 成功した場合は`true`、失敗した場合は`false`。
  */
  public fn RemoveObserver observer = (
    local index = this.findObserver observer
    if index > 0 do (
      deleteItem this.observers index
    )
    this.findObserver observer == 0
  ),

  /*-
  @param observer <Struct:ObserverStruct>
  @returns <Integer>
  */
  private fn findObserver observer = (
    local index = 0
    for i = 1 to this.observers.Count while index == 0 do (
      if this.observers[i].Equals observer do (
        index = i
      )
    )
    index
  ),

  /*-
  @param params <Array[<Name>]|Any>
  @param type: <Name>
  @returns <OkClass>
  */
  private fn notify params type: = (
    for observer in this.observers do (
      observer.Callback observer.Context params type:type
    )
    ok
  ),

  on Create do (
    this.SetControl this._CP1_
  )
)
