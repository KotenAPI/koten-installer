# Plugins
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "WinVer.nsh"
!include "x64.nsh"
!include "replacebetween.nsh"
Unicode true

# Definitions
!define COMPANY_NAME "Koten"
!define PRODUCT_NAME "Koten"
!define PRODUCT_DESCRIPTION "Automatiseret viden, LCA og Beskrivelses-værktøjer"
!define COPYRIGHT "Copyright © 2023 Koten"
!define PRODUCT_VERSION "0.1.23.0"
!define SETUP_VERSION 0.1.23.0

!define ADDIN_DIR "$AppData\Autodesk\Revit\Addins"
Name "Koten"
OutFile "koten-installer.exe"
InstallDir "$PROGRAMFILES\Koten"
InstallDirRegKey HKCU "Software\Koten\Koten" ""
RequestExecutionLevel admin ; user|highest|admin

# Version Info
VIProductVersion "${PRODUCT_VERSION}"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "ProductVersion" "${PRODUCT_VERSION}"
VIAddVersionKey "FileDescription" "${PRODUCT_DESCRIPTION}"
VIAddVersionKey "LegalCopyright" "${COPYRIGHT}"
VIAddVersionKey "FileVersion" "${SETUP_VERSION}"

## These will be displayed by the "Click here for support information" link in "Add/Remove Programs"
## It is possible to use "mailto:" links in here to open the email client
!define HELPURL "https://koten.dk/support"
!define UPDATEURL "https://github.com/KotenAPI/koten-installer"
!define ABOUTURL "https://koten.dk"
!define UNINSTALLER_NAME "uninstall-koten.exe"

## Install size (in kilobytes), use installer estimate here
!define INSTALLSIZE 210000

# Welcome page
!define MUI_WELCOMEPAGE_TITLE "Velkommen til koten!"
!define MUI_WELCOMEPAGE_TEXT "Koten understøtter flere forskellige versioner af Autodesk. Vælg hvilke(n) version(er) Koten skal installeres for på en af de følgende sider."

### CODING FOLLOWS! DO NOT CHANGE UNLESS YOU KNOW WHAT YOU ARE DOING ###
!define MUI_COMPONENTSPAGE_NODESC true

# The pages of the installer
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "License.rtf"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

# Languages
!insertmacro MUI_LANGUAGE "Danish"
!insertmacro MUI_LANGUAGE "English"

# What the installer actually does
Section "Autodesk 2020"
	SetOutPath "${ADDIN_DIR}\2020\"
	File "2020\Koten.addin"
	${ReplaceBetween} "<Assembly>" "</Assembly>" "$INSTDIR\2020\Koten.dll" "${ADDIN_DIR}\2020\Koten.addin"

	SetOutPath "$INSTDIR\2020\"
    File "2020\"
SectionEnd

Section "Autodesk 2021"
	SetOutPath "${ADDIN_DIR}\2021\"
	File "2021\Koten.addin"
	${ReplaceBetween} "<Assembly>" "</Assembly>" "$INSTDIR\2021\Koten.dll" "${ADDIN_DIR}\2021\Koten.addin"

	SetOutPath "$INSTDIR\2021\"
    File "2021\"
SectionEnd

Section "Autodesk 2022"
	SetOutPath "${ADDIN_DIR}\2022\"
	File "2021\Koten.addin"
	${ReplaceBetween} "<Assembly>" "</Assembly>" "$INSTDIR\2022\Koten.dll" "${ADDIN_DIR}\2022\Koten.addin"

    SetOutPath "$INSTDIR\2022\"
    File "2021\"
SectionEnd

Section "Autodesk 2023"
	SetOutPath "${ADDIN_DIR}\2023\"
	File "2021\Koten.addin"
	${ReplaceBetween} "<Assembly>" "</Assembly>" "$INSTDIR\2023\Koten.dll" "${ADDIN_DIR}\2023\Koten.addin"

    SetOutPath "$INSTDIR\2023\"
    File "2021\"
SectionEnd

Section "-hidden section"
	# Write an uninstaller (and Windows registry to register the uninstaller)
    writeUninstaller "$INSTDIR\${UNINSTALLER_NAME}"
    
    # Registry information for add/remove programs
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANY_NAME} ${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME} - ${PRODUCT_DESCRIPTION}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANY_NAME} ${PRODUCT_NAME}" "UninstallString" "$\"$INSTDIR\${UNINSTALLER_NAME}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANY_NAME} ${PRODUCT_NAME}" "QuietUninstallString" "$\"$INSTDIR\${UNINSTALLER_NAME}$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANY_NAME} ${PRODUCT_NAME}" "InstallLocation" "$\"$INSTDIR$\""
	# No logo yet
    #WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANY_NAME} ${PRODUCT_NAME}" "DisplayIcon" "$\"$INSTDIR\logo.ico$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANY_NAME} ${PRODUCT_NAME}" "Publisher" "$\"${COMPANY_NAME}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANY_NAME} ${PRODUCT_NAME}" "HelpLink" "$\"${HELPURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANY_NAME} ${PRODUCT_NAME}" "URLUpdateInfo" "$\"${UPDATEURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANY_NAME} ${PRODUCT_NAME}" "URLInfoAbout" "$\"${ABOUTURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANY_NAME} ${PRODUCT_NAME}" "DisplayVersion" "$\"${PRODUCT_VERSION}$\""
	# There is no option for modifying or repairing the install
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANY_NAME} ${PRODUCT_NAME}" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANY_NAME} ${PRODUCT_NAME}" "NoRepair" 1
	# Set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANY_NAME} ${PRODUCT_NAME}" "EstimatedSize" ${INSTALLSIZE}
SectionEnd

# Uninstaller

section "Uninstall"
	# Remove addin file from autodesk folder
	delete "${ADDIN_DIR}\2020\Koten.addin"
	delete "${ADDIN_DIR}\2021\Koten.addin"
	delete "${ADDIN_DIR}\2022\Koten.addin"
	delete "${ADDIN_DIR}\2023\Koten.addin"

	# Remove our local files (usually in the program files folder)
	RMDir /r "$INSTDIR\2020\"
	RMDir /r "$INSTDIR\2021\"
	RMDir /r "$INSTDIR\2022\"
	RMDir /r "$INSTDIR\2023\"
 
	# Always delete uninstaller as the last action
	delete "$INSTDIR\${UNINSTALLER_NAME}"

    RMDir "$INSTDIR"
 
	# Remove uninstaller information from the registry
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANY_NAME} ${PRODUCT_NAME}"
sectionEnd