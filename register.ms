/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  fileIn "FlexUI.ms"

  if isProperty ::startupLoader "RegisterScript" do (
    ::startupLoader.RegisterScript (getSourceFileName())
  )
  ok
)
