/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  ::flexUI = (fileIn "FlexUI.ms")()
  format "[define]::flexUI\n"

  if isProperty ::startupScriptLoader "RegisterScript" do (
    ::startupScriptLoader.RegisterScript (getSourceFileName())
    ::startupScriptLoader.Save()
  )
  ok
)
