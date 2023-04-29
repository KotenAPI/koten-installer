# Definitions
!define APPNAME "Koten"
!define COMPANYNAME "Koten"
!define DESCRIPTION "Automatiseret viden, LCA og Beskrivelses-vaerktoejer"
!define VERSIONMAJOR 1
!define VERSIONMINOR 23

## These will be displayed by the "Click here for support information" link in "Add/Remove Programs"
## It is possible to use "mailto:" links in here to open the email client
!define HELPURL "https://koten.dk/support"
!define UPDATEURL "https://github.com/KotenAPI/koten-installer"
!define ABOUTURL "https://koten.dk"
!define UNINSTALLER_NAME "uninstall-koten.exe"

## Install size (in kilobytes), use installer estimate here
!define INSTALLSIZE 210000

# Metadata for installer
LicenseData "license.rtf"
Name "${COMPANYNAME} - ${APPNAME}"

!include LogicLib.nsh

# The pages of the installer
page license
page directory
Page instfiles

!macro VerifyUserIsAdmin
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
        messageBox mb_iconstop "Administrator rights required!"
        setErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
        quit
${EndIf}
!macroend

# What the installer actually does
OutFile "koten-installer.exe"
InstallDir "$AppData\Autodesk\Revit\Addins"

function .onInit
	setShellVarContext all
	!insertmacro VerifyUserIsAdmin
functionEnd

Section "install"
    # First, copy 2020
    SetOutPath "$INSTDIR\2020\"
    File "2020\"

    # Then 2021, 2022, 2023
    SetOutPath "$INSTDIR\2021\"
    File "2021\"
    SetOutPath "$INSTDIR\2022\"
    File "2021\"
    SetOutPath "$INSTDIR\2023\"
    File "2021\"

    # Write an uninstaller (and Windows registry to register the uninstaller)
    writeUninstaller "$INSTDIR\${UNINSTALLER_NAME}"
    	# Registry information for add/remove programs
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayName" "${APPNAME} - ${DESCRIPTION}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "UninstallString" "$\"$INSTDIR\${UNINSTALLER_NAME}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\${UNINSTALLER_NAME}$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
	# No logo yet
    #WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayIcon" "$\"$INSTDIR\logo.ico$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "Publisher" "$\"${COMPANYNAME}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "HelpLink" "$\"${HELPURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "URLUpdateInfo" "$\"${UPDATEURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "URLInfoAbout" "$\"${ABOUTURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayVersion" "$\"${VERSIONMAJOR}.${VERSIONMINOR}$\""
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "VersionMinor" ${VERSIONMINOR}
	# There is no option for modifying or repairing the install
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoRepair" 1
	# Set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "EstimatedSize" ${INSTALLSIZE}
SectionEnd

# Uninstaller
function un.onInit
	SetShellVarContext all
 
	#Verify the uninstaller - last chance to back out
	MessageBox MB_OKCANCEL "Permanantly remove ${APPNAME}?" IDOK next
		Abort
	next:
	!insertmacro VerifyUserIsAdmin
functionEnd
 
section "uninstall" 
	# Remove files (done crudely at this point, would potentially wipe other addins
	RMDir /r "$INSTDIR\2020\"
	RMDir /r "$INSTDIR\2021\"
	RMDir /r "$INSTDIR\2022\"
	RMDir /r "$INSTDIR\2023\"
 
	# Always delete uninstaller as the last action
	delete $INSTDIR\${UNINSTALLER_NAME}
 
	# Remove uninstaller information from the registry
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}"
sectionEnd