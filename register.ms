/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  fileIn "FlexUI.ms"

  if isProperty ::startupLoader "RegisterFile" do (
    ::startupLoader.RegisterFile (getSourceFileName())
  )
  ok
)
