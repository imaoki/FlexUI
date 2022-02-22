/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  if isProperty ::startupScriptLoader "UnregisterScript" do (
    local registerFile = substituteString (getSourceFileName()) "unregister.ms" "register.ms"
    ::startupScriptLoader.UnregisterScript registerFile
    ::startupScriptLoader.Save()
  )
  ok
)
