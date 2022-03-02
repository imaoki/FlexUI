/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  local hr = ::std.StringUtility.PadLeft "\n" 80 "-"
  local currentFile = getSourceFileName()
  local pathUtility = ::std.PathUtilityStruct currentFile
  local currentDir = pathUtility.GetDirectoryName currentFile
  local testFiles = ::std.FileUtility.GetFiles currentDir @"*\Test\test*.ms"
  for path in testFiles where stricmp path currentFile != 0 do (
    format "%" hr
    fileIn path
  )
  ok
)
