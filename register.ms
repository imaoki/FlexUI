/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  fileIn "FlexUI.ms"

  if isProperty ::startupScriptLoader "RegisterScript" do (
    ::startupScriptLoader.RegisterScript (getSourceFileName())
    ::startupScriptLoader.Save()
  )
  ok
)
