/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  local hr = (DotNetObject "System.String" "\n").PadLeft 80 "-"
  local directoryClass = DotNetClass "System.IO.Directory"
  local pathClass = DotNetClass "System.IO.Path"
  local currentFile = getSourceFileName()
  local currentDir = pathClass.GetDirectoryName currentFile
  local testFiles = directoryClass.GetFiles currentDir "*"
  sort testFiles
  for path in testFiles where stricmp path currentFile != 0 do (
    if matchPattern path pattern:@"*\Test\test*.ms" ignoreCase:true do (
      format "%" hr
      fileIn path
    )
  )
  ok
)
