OutFile "koten-installer.exe"
InstallDir "$AppData\Autodesk\Revit\Addins"

Section
    # First, copy 2020
    SetOutPath "$INSTDIR\2020\"
    File "2020\"

    # Then 2021, 2022
    SetOutPath "$INSTDIR\2021\"
    File "2021\"
    SetOutPath "$INSTDIR\2022\"
    File "2021\"
SectionEnd
