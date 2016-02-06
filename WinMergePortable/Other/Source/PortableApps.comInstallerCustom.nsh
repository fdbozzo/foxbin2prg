!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "2.12.4.2" $1
		${If} $1 == 2 ;Upgrading from version before 2.12.4.2
		${AndIf} ${FileExists} "$INSTDIR\Data\settings\WinMerge.reg"
			WriteINIStr "$INSTDIR\Data\settings\WinMerge.reg" "HKEY_CURRENT_USER\Software\Thingamahoochie\WinMerge\Merge7z" '"Enable"' "dword:00000002"
			WriteINIStr "$INSTDIR\Data\settings\WinMerge.reg" "HKEY_CURRENT_USER\Software\Thingamahoochie\WinMerge" '"ContextMenuEnabled"' "dword:00000000"
		${EndIf}
	${EndIf}
!macroend