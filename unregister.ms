/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  local pathUtility = ::PathUtilityStruct (getSourceFileName())
  local registerFile = pathUtility.GetFullPath @".\register.ms"

  if isProperty ::startupScriptLoader "UnregisterScript" do (
    ::startupScriptLoader.UnregisterScript registerFile
    ::startupScriptLoader.Save()
  )
  ok
)
