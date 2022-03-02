/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  if isProperty ::startupLoader "UnregisterScript" do (
    local registerFile = substituteString (getSourceFileName()) "unregister.ms" "register.ms"
    ::startupLoader.UnregisterScript registerFile
    ::startupLoader.Save()
  )
  ok
)
