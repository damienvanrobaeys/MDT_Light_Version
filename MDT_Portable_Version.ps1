#========================================================================
#
# Tool Name	: Windows 10 Profile Generator
# Version:	: 1.0	
# Author 	: Damien VAN ROBAEYS
# Date 		: 14/06/2016
#
#========================================================================

Param
    (
		[Parameter(Mandatory=$true)]
		[AllowEmptyString()]						
		[String]$deploymentshare, # Import the deployment share from the first GUI	
		[Parameter(Mandatory=$true)]
		[AllowEmptyString()]						
		[String]$MDTModule, # Import the MDT module from the first GUI
		[Parameter(Mandatory=$true)]
		[AllowEmptyString()]						
		[String]$ADKmodule # Import the ADK module from the first GUI		
    )

[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.ComponentModel') 				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Data')           				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')        				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('PresentationCore')      				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')       				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') 	| out-null

Add-Type -AssemblyName "System.Windows.Forms"
Add-Type -AssemblyName "System.Drawing"

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

# Load MainWindow
$XamlMainWindow=LoadXml("MDT_Portable_Version.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
# 																		BUTTONS AND LABELS INITIALIZATION 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################

$Tab_Control = $Form.findname("Tab_Control") 
#************************************************************************** APPLICATIONS TAB ***********************************************************************************************
$Tab_Applis = $Form.findname("Tab_Applis") 
$DataGrid_Applications = $Form.findname("DataGrid_Applications") 
#************************************************************************** OS TAB ***********************************************************************************************
$Tab_OS = $Form.findname("Tab_OS") 
$Datagrid_OS = $Form.findname("Datagrid_OS") 
#************************************************************************** LPS TAB ***********************************************************************************************
$Tab_LPS = $Form.findname("Tab_LPS") 
$DataGrid_MUIs = $Form.findname("DataGrid_MUIs") 
#************************************************************************** PACKAGES TAB ***********************************************************************************************
$Tab_Packages = $Form.findname("Tab_Packages") 
$Datagrid_Packages = $Form.findname("Datagrid_Packages") 
#************************************************************************** DRIVERS TAB ***********************************************************************************************
$Tab_Drivers = $Form.findname("Tab_Drivers") 
$Datagrid_Drivers = $Form.findname("Datagrid_Drivers") 
#************************************************************************** MEDIA TAB ***********************************************************************************************
$Tab_Media = $Form.findname("Tab_Media") 
$Datagrid_Media = $Form.findname("Datagrid_Media") 
#************************************************************************** ACTIONS PART ***********************************************************************************************
$Update_BTN = $Form.findname("Update_BTN") 
$Add_item_BTN = $Form.findname("Add_item_BTN") 
$Modify_item_BTN = $Form.findname("Modify_item_BTN") 
$Remove_item_BTN = $Form.findname("Remove_item_BTN") 
$Refresh_btn = $Form.findname("Refresh_btn") 
#************************************************************************** TITLEBAR bUTTONS ***********************************************************************************************
$Open_Settings = $Form.findname("Open_Settings") 
$FlyOutContent = $Form.findname("FlyOutContent") 
$Open_Checking_part = $Form.findname("Open_Checking_part") 
$FlyOutContent2 = $Form.findname("FlyOutContent2") 
#************************************************************************** MORE SETTINGS PART ***********************************************************************************************
$Browse_other_Deploy = $Form.findname("Browse_other_Deploy") 
$Browse_other_Deploy_textbox = $Form.findname("Browse_other_Deploy_textbox") 

$New_Deploymentshare_Name = $Form.findname("New_Deploymentshare_Name") 
$New_Deploy_Path = $Form.findname("New_Deploy_Path") 
$Create_New_Deploy = $Form.findname("Create_New_Deploy") 
$Open_New_Deploy_CheckBox = $Form.findname("Open_New_Deploy_CheckBox") 

$Browse_Other_MDT_Module = $Form.findname("Browse_Other_MDT_Module") 
$Browse_Other_MDT_Module_textbox = $Form.findname("Browse_Other_MDT_Module_textbox") 

$Browse_Other_ADK_Module = $Form.findname("Browse_Other_ADK_Module") 
$Browse_Other_ADK_Module_textbox = $Form.findname("Browse_Other_ADK_Module_textbox") 

#************************************************************************** CHECKING PART ***********************************************************************************************
$DS_Path_Info = $Form.findname("DS_Path_Info") 
$MDT_Module_path = $Form.findname("MDT_Module_path") 
$ADK_Module_path = $Form.findname("ADK_Module_path") 
$MDT_module_version = $Form.findname("MDT_module_version") 
$MDT_Version = $Form.findname("MDT_Version") 
$MDT_Module_Check = $Form.findname("MDT_Module_Check") 


$Global:Applis_Row_List = $DataGrid_Applications.items
$Global:MUIs_Row_List = $DataGrid_MUIs.items
$Global:Packages_Row_List = $DataGrid_Packages.items
$Global:OS_Row_List = $Datagrid_OS.items
$Global:Medias_Row_List = $Datagrid_Media.items
$Global:Drivers_Row_List = $Datagrid_Drivers.items

########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
# 																		VARIABLES INITIALIZATION 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################

$object = New-Object -comObject Shell.Application  
$Global:Current_Folder =(get-location).path 
$Date = get-date -format "dd-MM-yy_HHmm"
$global:deploy = "$deploymentshare"

$Global:Comp_Name = $env:LOGONSERVER

$Global:version_xml = "$deploymentshare\Control\Version.xml"



$Global:workbench_file = "$MDTModule\Bin\Microsoft.BDD.Workbench.dll"
$Get_Module_Version = (Get-Item $workbench_file).VersionInfo.FileVersion	
$MDT_module_version.Content = $Get_Module_Version
$MDT_module_version.ForeGround = "White"	


$DS_Path_Info.Text = "$deploymentshare"
$MDT_Module_path.Text = "$MDTModule"
$ADK_Module_path.Text = "$ADKmodule"


$Get_Version = [xml] (Get-Content $version_xml)		
$Global:MDT_Version_Check = $Get_Version.version
$MDT_Version.Content = $MDT_Version_Check
$MDT_Version.ForeGround = "White"

If ($Get_Module_Version -ne $MDT_Version_Check)
	{
		$MDT_Module_Check.Text = "MDT module version and Deploymentshare version are diff"	
	}

########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
# 																		FUNCTIONS INITIALIZATION 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################

#*******************************************************************************************************************************************************************************************************
#																						 POPULATES DATAGRIDS FUNCTIONS
#*******************************************************************************************************************************************************************************************************
	
Function Populate_Datagrid_MUIs # Function to list your applications in the datagrid
	{		
		$Global:list_MUIs = ""
		$Input_MUIs = ""		
		
		$Global:list_MUIs = "$deploy\Control\Packages.xml"						
		$Input_MUIs = [xml] (Get-Content $list_MUIs)		
		$MUI_packages = $Input_MUIs.packages.package | Where {$_.PackageType -match "LanguagePack"}
		foreach ($data in $MUI_packages) 
			{
				$MUIs_values = New-Object PSObject
				$MUIs_values = $MUIs_values | Add-Member NoteProperty -Name Language -Value $data.Language 	–passthru			
				$MUIs_values = $MUIs_values | Add-Member NoteProperty Name $data.Name –passthru
				$MUIs_values = $MUIs_values | Add-Member NoteProperty Version $data.Version –passthru
				$DataGrid_MUIs.Items.Add($MUIs_values) > $null
			}		
	}	
	
	
Function Populate_Datagrid_Applis  # Function to list your applications in the datagrid
	{	
		$Global:list_applis = ""
		$Input_Applications = ""			

		$Global:list_applis = "$deploy\Control\Applications.xml"						
		$Input_Applications = [xml] (Get-Content $list_applis)		
		foreach ($data in $Input_Applications.selectNodes("applications/application"))
			{
				$Applis_values = New-Object PSObject
				$Applis_values = $Applis_values | Add-Member NoteProperty Name $data.Name –passthru
				$Applis_values = $Applis_values | Add-Member NoteProperty Version $data.Version –passthru
				$Applis_values = $Applis_values | Add-Member NoteProperty Publisher $data.Publisher –passthru
				$Applis_values = $Applis_values | Add-Member NoteProperty Language $data.Language –passthru																	
				$DataGrid_Applications.Items.Add($Applis_values) > $null
			}								
	}			
	
	
Function Populate_Datagrid_Packages # Function to list your applications in the datagrid
	{	
		$Global:list_Packages = ""
		$Input_Packages = ""			

		$Global:list_Packages = "$deploy\Control\Packages.xml"						
		$Input_Packages = [xml] (Get-Content $list_Packages)		
		$OnDemand_packages = $Input_Packages.packages.package | Where {$_.PackageType -match "OnDemandPack"}
		foreach ($data in $OnDemand_packages) 
			{
				$Packages_values = New-Object PSObject
				$Packages_values = $Packages_values | Add-Member NoteProperty Name $data.Name –passthru
				$Packages_values = $Packages_values | Add-Member NoteProperty PackageType $data.PackageType –passthru
				$Packages_values = $Packages_values | Add-Member NoteProperty Architecture $data.Architecture –passthru				
				$Packages_values = $Packages_values | Add-Member NoteProperty Language $data.Language –passthru
				$Packages_values = $Packages_values | Add-Member NoteProperty Version $data.Version –passthru															
				$Datagrid_Packages.Items.Add($Packages_values) > $null
			}								
	}	

	
Function Populate_Datagrid_OS  # Function to list your applications in the datagrid
	{	
		$Global:list_OS = ""
		$Input_OS = ""			

		$Global:list_OS = "$deploy\Control\OperatingSystems.xml"						
		$Input_OS = [xml] (Get-Content $list_OS)		
		foreach ($data in $Input_OS.selectNodes("oss/os"))
			{
				$OS_values = New-Object PSObject
				$OS_values = $OS_values | Add-Member NoteProperty Name $data.Name –passthru
				$OS_values = $OS_values | Add-Member NoteProperty Description $data.Description –passthru
				$OS_values = $OS_values | Add-Member NoteProperty Platform $data.Platform –passthru
				$OS_values = $OS_values | Add-Member NoteProperty Build $data.Build –passthru
				$OS_values = $OS_values | Add-Member NoteProperty OSType $data.OSType –passthru		
				$OS_values = $OS_values | Add-Member NoteProperty Flags $data.Flags –passthru															
				$OS_values = $OS_values | Add-Member NoteProperty Enable $data.Enable –passthru																			
				$Datagrid_OS.Items.Add($OS_values) > $null
			}								
	}		


Function Populate_Datagrid_Drivers # Function to list your applications in the datagrid
	{	
		$Global:list_Drivers = ""
		$Input_Drivers = ""			

		$Global:list_Drivers = "$deploy\Control\Drivers.xml"						
		$Input_Drivers = [xml] (Get-Content $list_Drivers)		
		foreach ($data in $Input_Drivers.selectNodes("drivers/driver"))
			{
				$Drivers_values = New-Object PSObject
				$Drivers_values = $Drivers_values | Add-Member NoteProperty Name $data.Name –passthru
				$Drivers_values = $Drivers_values | Add-Member NoteProperty Manufacturer $data.Manufacturer –passthru
				$Drivers_values = $Drivers_values | Add-Member NoteProperty Version $data.Version –passthru
				$Drivers_values = $Drivers_values | Add-Member NoteProperty Date $data.Date –passthru
				$Drivers_values = $Drivers_values | Add-Member NoteProperty Platform $data.Platform –passthru
				$Drivers_values = $Drivers_values | Add-Member NoteProperty Class $data.Class –passthru	
				$Drivers_values = $Drivers_values | Add-Member NoteProperty Enable $data.Enable –passthru																				
				$Datagrid_Drivers.Items.Add($Drivers_values) > $null
			}								
	}			
			

		
Function Populate_Datagrid_Media  # Function to list your applications in the datagrid
	{	
		$Global:list_Medias = ""
		$Input_Media = ""			

		$Global:list_Medias = "$deploy\Control\Medias.xml"						
		$Input_Media = [xml] (Get-Content $list_Medias)		
		foreach ($data in $Input_Media.selectNodes("medias/media"))
			{
				$Medias_values = New-Object PSObject
				$Medias_values = $Medias_values | Add-Member NoteProperty Name $data.Name –passthru
				$Medias_values = $Medias_values | Add-Member NoteProperty Root $data.Root –passthru
				$Medias_values = $Medias_values | Add-Member NoteProperty Profile $data.SelectionProfile –passthru	
				$Medias_values = $Medias_values | Add-Member NoteProperty Supportx86 $data.Supportx86 –passthru														
				$Medias_values = $Medias_values | Add-Member NoteProperty Supportx64 $data.Supportx64 –passthru														
				$Medias_values = $Medias_values | Add-Member NoteProperty ISOname $data.ISOname –passthru																
				$Datagrid_Media.Items.Add($Medias_values) > $null
			}								
	}					
	
	
	
	
	
#*******************************************************************************************************************************************************************************************************
#																						 FUNCTION TO CREATE THE ADK & MDT REGISTRY STRUCTURE
#*******************************************************************************************************************************************************************************************************
		
Function MDT_ADK_Registry_Creation
	{
		# In this part we'll use MDT as a portable application
		# 1 / First we need to create a registry Key "HKLM:\SOFTWARE\Microsoft\Deployment 4"
		$MDT_Deployment4_Label = "Deployment 4" 
		$HKLM_Location = "HKLM:\SOFTWARE\Microsoft"
		$Global:MDT_Deployment4 = "HKLM:\SOFTWARE\Microsoft\$MDT_Deployment4_Label"
		New-Item -Path $HKLM_Location -Name $MDT_Deployment4_Label			
		# 2 / Then we need to create a string Install_Dir with value "$Current_Folder\module\" in the "Deployment 4 Key"		
		New-ItemProperty -Path "$MDT_Deployment4" -Name "Install_Dir" -PropertyType String -Value "$MDTModule\"

		# 3 / We need to create a registry Key "HKLM:\SOFTWARE\Microsoft\Windows Kits\Installed Roots"					
		$WinKits_Key_Label = "Windows Kits" 
		$InstalledRoots_Key_Label = "Installed Roots" 
		$InstalledRoots_Key_Creation = "HKLM:\SOFTWARE\Microsoft\Windows Kits\$InstalledRoots_Key_Label"
		$Global:WindowsKits_Location = "HKLM:\SOFTWARE\Microsoft\Windows Kits"
		New-Item -Path $HKLM_Location -Name $WinKits_Key_Label
		New-Item -Path $WindowsKits_Location -Name $InstalledRoots_Key_Label
		
		# 2 / Then we need to create a string "KitsRoot10" with value "$Current_Folder\Windows Kits\" in the "Installed Roots"					
		New-ItemProperty -Path "$InstalledRoots_Key_Creation" -Name "KitsRoot10" -PropertyType String -Value "$ADKmodule\"	
	}


#*******************************************************************************************************************************************************************************************************
#																						 FUNCTION TO DELETE THE ADK & MDT REGISTRY STRUCTURE
#*******************************************************************************************************************************************************************************************************
			
Function MDT_ADK_Registry_Delete
	{
		Remove-Item -Path $MDT_Deployment4 -recurse
		Remove-Item -Path $WindowsKits_Location -recurse	
	}


	
#*******************************************************************************************************************************************************************************************************
#																						 ADD ITEMS FUNCTIONS
#*******************************************************************************************************************************************************************************************************
		
Function Add_Application_Part 
	{
		MDT_ADK_Registry_Creation
		powershell -sta ".\Add_Appli.ps1" -deploymentshare "'$global:deploy'" -module $MDTModule	
		MDT_ADK_Registry_Delete
	}
	
	
Function Add_MUI_Part 
	{
		MDT_ADK_Registry_Creation
		powershell -sta ".\Add_MUI.ps1" -deploymentshare "'$global:deploy'" -module $MDTModule	
		MDT_ADK_Registry_Delete	
	}

Function Add_Package_Part 
	{
		MDT_ADK_Registry_Creation
		powershell -sta ".\Add_Package.ps1" -deploymentshare "'$global:deploy'" -module $MDTModule	
		MDT_ADK_Registry_Delete
	}	
	
Function Add_Drivers_Part 
	{
		MDT_ADK_Registry_Creation
		powershell -sta ".\Add_Drivers.ps1" -deploymentshare "'$global:deploy'" -module $MDTModule	
		MDT_ADK_Registry_Delete		
	}	
	
Function Add_OS_Part 
	{
		MDT_ADK_Registry_Creation
		powershell -sta ".\Add_OS.ps1" -deploymentshare "'$global:deploy'" -module $MDTModule		
		MDT_ADK_Registry_Delete
	}	
	
Function Add_Medias_Part 
	{
		MDT_ADK_Registry_Creation
		powershell -sta ".\Add_Media.ps1" -deploymentshare "'$global:deploy'" -module $MDTModule	
		MDT_ADK_Registry_Delete
	}	


	
	
	
	
#*******************************************************************************************************************************************************************************************************
#																						 MODIFY ITEMS FUNCTIONS
#*******************************************************************************************************************************************************************************************************	
	
Function Modify_Application_Part
	{		
		If ($DataGrid_Applications.SelectedIndex -ne "-1")
			{
				$i = $DataGrid_Applications.SelectedIndex
				$Global:App_Name = $Applis_Row_List[$i].Name
				$Global:App_ShortName = $Applis_Row_List[$i].ShortName									
				$Global:App_Comments = $Applis_Row_List[$i].Comments					
				$Global:App_Publisher = $Applis_Row_List[$i].Publisher	
				$Global:App_Version = $Applis_Row_List[$i].Version
				$Global:App_Source = $Applis_Row_List[$i].Source				
				$Global:App_Language = $Applis_Row_List[$i].Language
				$Global:App_CMD = $Applis_Row_List[$i].CommandLine
				$Global:App_Reboot = $Applis_Row_List[$i].Reboot		
				$Global:App_Enable = $Applis_Row_List[$i].Enable									
				$Global:App_Hide = $Applis_Row_List[$i].Hide									

				If (!$App_Name){$App_Name = "-"}
				If (!$App_ShortName){$App_ShortName = "-"}
				If (!$App_Comments){$App_Comments = "-"}
				If (!$App_Publisher){$App_Publisher = "-"}
				If (!$App_Version){$App_Version = "-"}
				If (!$App_Source){$App_Source = "-"}
				If (!$App_Language){$App_Language = "-"}
				If (!$App_CMD){$App_CMD = "-"}
				If (!$App_Reboot){$App_Reboot = "False"}
				If (!$App_Enable){$App_Enable = "False"}
				If (!$App_Hide){$App_Hide = "False"}
				
				powershell -sta ".\Modify_Appli.ps1" -deploymentshare "'$global:deploy'" -applixml $list_applis -position $i -name "'$App_Name'" -ShortName "'$App_ShortName'" -comments "'$App_Comments'" -publisher "'$App_Publisher'" -version "'$App_Version'" -source "'$App_Source'" -language "'$App_Language'" -command "'$App_CMD'" -reboot $App_Reboot -enable $App_Enable -hide $App_Hide				
			}
		Else
			{
				[System.Windows.Forms.MessageBox]::Show("You have to select an application to modify") 	
			}				
	}		
	

	
#*******************************************************************************************************************************************************************************************************
#																						 REMOVE ITEMS FUNCTIONS
#*******************************************************************************************************************************************************************************************************
	
Function Remove_MUIs_Part
	{	
		If ($DataGrid_MUIs.SelectedIndex -ne "-1")
			{
				$i = $DataGrid_MUIs.SelectedIndex
				$MUI_Name = $MUIs_Row_List[$i].Name		
				
				import-module "$MDTModule\Bin\MicrosoftDeploymentToolkit.psd1"
				
				$PSDrive_Test = get-psdrive
				If ($PSDrive_Test -eq "DSAppManager")
					{
						Remove-PSDrive -Name "DSAppManager"		
						New-PSDrive -Name "DSAppManager" -PSProvider MDTProvider -Root $deploy								
					}
				Else
					{
						New-PSDrive -Name "DSAppManager" -PSProvider MDTProvider -Root $deploy		
					}					
				remove-item -path "DSAppManager:\Packages\$MUI_Name" -force -verbose					
				[System.Windows.Forms.MessageBox]::Show("Your language pack has been correctly removed") 					
			}
		Else
			{
				[System.Windows.Forms.MessageBox]::Show("You have to select an application to remove") 	
			}				
	}
	
	
Function Remove_Package_Part
	{	
		If ($DataGrid_Packages.SelectedIndex -ne "-1")
			{
				$i = $DataGrid_Packages.SelectedIndex
				$Package_Name = $Packages_Row_List[$i].Name		
				
				import-module "$MDTModule\Bin\MicrosoftDeploymentToolkit.psd1"
				
				$PSDrive_Test = get-psdrive
				If ($PSDrive_Test -eq "DSAppManager")
					{
						Remove-PSDrive -Name "DSAppManager"		
						New-PSDrive -Name "DSAppManager" -PSProvider MDTProvider -Root $deploy								
					}
				Else
					{
						New-PSDrive -Name "DSAppManager" -PSProvider MDTProvider -Root $deploy		
					}					
				remove-item -path "DSAppManager:\Packages\$Package_Name" -force -verbose					
				[System.Windows.Forms.MessageBox]::Show("Your package has been correctly removed") 					
			}
		Else
			{
				[System.Windows.Forms.MessageBox]::Show("You have to select an application to remove") 	
			}				
	}	
	
	
Function Remove_Application_Part
	{	
		If ($DataGrid_Applis.SelectedIndex -ne "-1")
			{
				$i = $DataGrid_Applications.SelectedIndex
				$App_Name = $Applis_Row_List[$i].Name		
				
				import-module "$MDTModule\Bin\MicrosoftDeploymentToolkit.psd1"				
				$PSDrive_Test = get-psdrive
				If ($PSDrive_Test -eq "DSAppManager")
					{
						Remove-PSDrive -Name "DSAppManager"		
						New-PSDrive -Name "DSAppManager" -PSProvider MDTProvider -Root $deploymentshare								
					}
				Else
					{
						New-PSDrive -Name "DSAppManager" -PSProvider MDTProvider -Root $deploymentshare		
					}					
				remove-item -path "DSAppManager:\Applications\$App_Name" -force -verbose		
				[System.Windows.Forms.MessageBox]::Show("Your application has been correctly removed") 					
			}
		Else
			{
				[System.Windows.Forms.MessageBox]::Show("You have to select an application to remove") 	
			}				
	}	

	
Function Remove_OS_Part
	{	
		If ($Datagrid_OS.SelectedIndex -ne "-1")
			{
				$i = $Datagrid_OS.SelectedIndex
				$OS_Name = $OS_Row_List[$i].Name		
				
				import-module "$MDTModule\Bin\MicrosoftDeploymentToolkit.psd1"
				$PSDrive_Test = get-psdrive
				If ($PSDrive_Test -eq "OSManager")
					{
						Remove-PSDrive -Name "OSManager"		
						New-PSDrive -Name "OSManager" -PSProvider MDTProvider -Root $deploymentshare								
					}
				Else
					{
						New-PSDrive -Name "OSManager" -PSProvider MDTProvider -Root $deploymentshare		
					}					
				remove-item -path "OSManager:\Operating Systems\$OS_Name" -force -verbose		
				[System.Windows.Forms.MessageBox]::Show("Your Operating System has been correctly removed") 					
			}
		Else
			{
				[System.Windows.Forms.MessageBox]::Show("You have to select an Operating System to remove") 	
			}				
	}		
	
		
Function Remove_Drivers_Part
	{	
		If ($Datagrid_Drivers.SelectedIndex -ne "-1")
			{
				$i = $Datagrid_Drivers.SelectedIndex
				$Driver_Name = $Drivers_Row_List[$i].Name		
				
				import-module "$MDTModule\Bin\MicrosoftDeploymentToolkit.psd1"				
				$PSDrive_Test = get-psdrive
				If ($PSDrive_Test -eq "DriversManager")
					{
						Remove-PSDrive -Name "DriversManager"		
						New-PSDrive -Name "DriversManager" -PSProvider MDTProvider -Root $deploymentshare								
					}
				Else
					{
						New-PSDrive -Name "DriversManager" -PSProvider MDTProvider -Root $deploymentshare		
					}					
				remove-item -path "DriversManager:\Out-of-Box Drivers\$Driver_Name" -force -verbose		
				[System.Windows.Forms.MessageBox]::Show("Your driver has been correctly removed") 					
			}
		Else
			{
				[System.Windows.Forms.MessageBox]::Show("You have to select a driver to remove") 	
			}				
	}			
	
	
Function Remove_Media
	{	
		If ($Datagrid_Media.SelectedIndex -ne "-1")
			{
				$i = $Datagrid_Media.SelectedIndex
				$Media_Name = $Medias_Row_List[$i].Name		
				
				import-module "$MDTModule\Bin\MicrosoftDeploymentToolkit.psd1"				
				$PSDrive_Test = get-psdrive
				If ($PSDrive_Test -eq "MediaManager")
					{
						Remove-PSDrive -Name "MediaManager"		
						New-PSDrive -Name "MediaManager" -PSProvider MDTProvider -Root $deploymentshare								
					}
				Else
					{
						New-PSDrive -Name "MediaManager" -PSProvider MDTProvider -Root $deploymentshare		
					}					
				remove-item -path "MediaManager:\Media\$Media_Name" -force -verbose		
				[System.Windows.Forms.MessageBox]::Show("Your media has been correctly removed") 					
			}
		Else
			{
				[System.Windows.Forms.MessageBox]::Show("You have to select a driver to remove") 	
			}				
	}		
	
	

	
########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
# 																		SCRIPT INITIALIZATION 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################	
	
Populate_Datagrid_Applis	
Populate_Datagrid_MUIs
Populate_Datagrid_Packages		
Populate_Datagrid_Media
Populate_Datagrid_OS
Populate_Datagrid_Drivers
	
	


########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
#																						 BUTTONS ACTIONS 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################


#*******************************************************************************************************************************************************************************************************
#																						 ACTIONS ON BUTTON DEPENDING OF THE TAB
#*******************************************************************************************************************************************************************************************************
	
$Tab_Control.Add_SelectionChanged({
	
	If ($Tab_Control.SelectedItem.Header -eq "Applications")
		{
			$Global:Launch_mode = "Applis"		
			$Modify_item_BTN.IsEnabled = $true	
			$Add_item_BTN.ToolTip = "Add an application"								
			$Modify_item_BTN.ToolTip = "Modify an application"	
			$Remove_item_BTN.ToolTip = "Remove an application"										
		}		
	ElseIf ($Tab_Control.SelectedItem.Header -eq "Operating System")
		{
			$Global:Launch_mode = "OS"			
			$Modify_item_BTN.IsEnabled = $true		
			$Add_item_BTN.ToolTip = "Add an OS"								
			$Modify_item_BTN.ToolTip = "Not applicable yet"	
			$Remove_item_BTN.ToolTip = "Remove an OS"				
		}			
	ElseIf ($Tab_Control.SelectedItem.Header -eq "Language packs")
		{
			$Global:Launch_mode = "MUIs"		
			$Modify_item_BTN.IsEnabled = $false		
			$Add_item_BTN.ToolTip = "Add a language pack"	
			$Modify_item_BTN.ToolTip = "Not applicable"				
			$Remove_item_BTN.ToolTip = "Remove an language pack"			
		}		
	ElseIf ($Tab_Control.SelectedItem.Header -eq "Packages")
		{
			$Global:Launch_mode = "Packages"		
			$Modify_item_BTN.IsEnabled = $false		
			$Add_item_BTN.ToolTip = "Add a package"	
			$Modify_item_BTN.ToolTip = "Not applicable"							
			$Remove_item_BTN.ToolTip = "Remove a package"			
		}		
	ElseIf ($Tab_Control.SelectedItem.Header -eq "Drivers")
		{
			$Global:Launch_mode = "Drivers"		
			$Modify_item_BTN.IsEnabled = $true		
			$Add_item_BTN.ToolTip = "Add a driver"
			$Modify_item_BTN.ToolTip = "Not applicable"							
			$Remove_item_BTN.ToolTip = "Remove a driver"			
		}				
	ElseIf ($Tab_Control.SelectedItem.Header -eq "Medias")
		{
			$Global:Launch_mode = "Medias"		
			$Modify_item_BTN.IsEnabled = $true		
			$Add_item_BTN.ToolTip = "Add a Media"								
			$Modify_item_BTN.ToolTip = "Modify a Media"	
			$Modify_item_BTN.ToolTip = "Not applicable"							
			$Remove_item_BTN.ToolTip = "Remove a Media"				
		}				
})					
			
				

#*******************************************************************************************************************************************************************************************************
#																						 UPDATE BUTTON
#*******************************************************************************************************************************************************************************************************
					
$Update_BTN.Add_Click({	
	powershell -sta ".\Update_DeploymentShare.ps1" -deploymentshare "'$global:deploy'" -module $MDTModule			
})			

$Open_Settings.Add_Click({
    $FlyOutContent.IsOpen = $true    
})

$Open_Checking_part.Add_Click({
    $FlyOutContent2.IsOpen = $true    
})

########################################################################################################################################################################################################
#                        															ADD BUTTON                                   
########################################################################################################################################################################################################
 $Add_item_BTN.Add_Click({	
	If ($Launch_mode -eq "Applis")
		{
			Add_Application_Part
			$Applis_Row_List.Clear()					
			Populate_Datagrid_Applis			
		}
	ElseIf ($Launch_mode -eq "MUIs")
		{
			Add_MUI_Part
			$MUIs_Row_List.Clear()			
			Populate_Datagrid_MUIs
		}		
	ElseIf ($Launch_mode -eq "Packages")
		{
			Add_Package_Part
			$Packages_Row_List.Clear()			
			Populate_Datagrid_Packages
		}	
	ElseIf ($Launch_mode -eq "Drivers")
		{
			Add_Drivers_Part
			$Drivers_Row_List.Clear()			
			Populate_Datagrid_Drivers
		}	
	ElseIf ($Launch_mode -eq "Medias")
		{
			Add_Medias_Part
			$Medias_Row_List.Clear()			
			Populate_Datagrid_Medias
		}	
	ElseIf ($Launch_mode -eq "OS")
		{
			Add_OS_Part
			$OS_Row_List.Clear()			
			Populate_Datagrid_OS
		}			
})			



########################################################################################################################################################################################################
#                        															MODIFY BUTTON                                   
########################################################################################################################################################################################################
 $Modify_item_BTN.Add_Click({	
	If ($Launch_mode -eq "Applis")
		{
			Modify_Application_Part
			$Applis_Row_List.Clear()			
			Populate_Datagrid_Applis			
		}	
})	


########################################################################################################################################################################################################
#                        															REMOVE BUTTON                                   
########################################################################################################################################################################################################

$Remove_item_BTN.Add_Click({	
	If ($Launch_mode -eq "Applis")
		{
			MDT_ADK_Registry_Creation
			Remove_Application_Part
			$Applis_Row_List.Clear()					
			Populate_Datagrid_Applis	
			MDT_ADK_Registry_Delete			
		}
	ElseIf ($Launch_mode -eq "MUIs")
		{
			MDT_ADK_Registry_Creation
			Remove_MUIs_Part
			$MUIs_Row_List.Clear()			
			Populate_Datagrid_MUIs
			MDT_ADK_Registry_Delete
		}		
	ElseIf ($Launch_mode -eq "Packages")
		{
			MDT_ADK_Registry_Creation
			Remove_Package_Part
			$Packages_Row_List.Clear()			
			Populate_Datagrid_Packages
			MDT_ADK_Registry_Delete
		}	
	ElseIf ($Launch_mode -eq "Drivers")
		{
			MDT_ADK_Registry_Creation
			Remove_Drivers_Part
			$Drivers_Row_List.Clear()			
			Populate_Datagrid_Drivers
			MDT_ADK_Registry_Delete
		}	
	ElseIf ($Launch_mode -eq "Medias")
		{
			MDT_ADK_Registry_Creation
			Remove_Medias_Part
			$Medias_Row_List.Clear()			
			Populate_Datagrid_Medias
			MDT_ADK_Registry_Delete
		}	
	ElseIf ($Launch_mode -eq "OS")
		{
			MDT_ADK_Registry_Creation
			Remove_OS_Part
			$OS_Row_List.Clear()			
			Populate_Datagrid_OS
			MDT_ADK_Registry_Delete
		}			
})		




########################################################################################################################################################################################################
#                        															BROWSE ANOTHER DEPLOYMENTSHARE BUTTON                                   
########################################################################################################################################################################################################

$Browse_other_Deploy.Add_Click({	
	$folder = $object.BrowseForFolder(0, $message, 0, 0) 
	If ($folder -ne $null) 
		{ 		
			$global:Other_Deploy = $folder.self.Path 
			$Browse_other_Deploy_textbox.Text =  $Other_Deploy		
			
			$deploy = "$Other_Deploy"
			
			$DS_Path_Info.Text = "$deploy"
					
			$Global:version_xml = "$deploy\Control\Version.xml"			
			[xml]$fileContents = Get-Content -Path $version_xml
			$Global:MDT_Version = $fileContents.version			
					
			$Applis_Row_List.Clear()					
			$MUIs_Row_List.Clear()			
			$Packages_Row_List.Clear()			
			$Drivers_Row_List.Clear()			
			$Medias_Row_List.Clear()			
			$OS_Row_List.Clear()			
	
			Populate_Datagrid_Applis	
			Populate_Datagrid_MUIs
			Populate_Datagrid_Packages		
			Populate_Datagrid_Media
			Populate_Datagrid_OS
			Populate_Datagrid_Drivers
		}
})


########################################################################################################################################################################################################
#                        															BROWSE ANOTHER ADK MODULE BUTTON                                   
########################################################################################################################################################################################################

$Browse_Other_ADK_Module.Add_Click({	
	$folder = $object.BrowseForFolder(0, $message, 0, 0) 
	If ($folder -ne $null) 
		{ 		
			$global:Other_ADK_Module = $folder.self.Path 
			$Browse_Other_ADK_Module_textbox.Text =  $Other_ADK_Module		
			$ADKmodule = $Other_ADK_Module				
			$ADK_Module_path.Text = "$Other_ADK_Module"							
		}
		
})



########################################################################################################################################################################################################
#                        															BROWSE ANOTHER MDT MODULE BUTTON                                   
########################################################################################################################################################################################################

$Browse_Other_MDT_Module.Add_Click({	
	$folder = $object.BrowseForFolder(0, $message, 0, 0) 
	If ($folder -ne $null) 
		{ 		
			$global:Other_MDT_Module = $folder.self.Path 
			$Browse_Other_MDT_Module_textbox.Text =  $Other_MDT_Module	
			$MDTmodule = $Other_MDT_Module
			$MDT_Module_path.Text = "$Other_MDT_Module"		
					
			$Global:workbench_file = "$Other_MDT_Module\Bin\Microsoft.BDD.Workbench.dll"
			$Get_Module_Version = (Get-Item $workbench_file).VersionInfo.FileVersion	
			$MDT_module_version.Content = $Get_Module_Version
			$MDT_module_version.ForeGround = "White"						
		}
})



########################################################################################################################################################################################################
#                        															CREATE A NEW DEPLOYMENTSHARE PATH BUTTON                                   
########################################################################################################################################################################################################

$New_Deploy_Path.Add_Click({	
	$folder = $object.BrowseForFolder(0, $message, 0, 0) 
	If ($folder -ne $null) 
		{ 		
			$global:New_Deploy_Create = $folder.self.Path 
		}	
})

########################################################################################################################################################################################################
#                        															CREATE A NEW DEPLOYMENTSHARE CREATE BUTTON                                   
########################################################################################################################################################################################################

$Create_New_Deploy.Add_Click({	
	$New_DS_Name = $New_Deploymentshare_Name.Text.ToString()	
	MDT_ADK_Registry_Creation
	import-module "$MDTModule\Bin\MicrosoftDeploymentToolkit.psd1"					
	$PSDrive_Test = get-psdrive
	If ($PSDrive_Test -eq "DSManager")
		{
			Remove-PSDrive -Name "DSManager"	
			New-Item -Path "$New_Deploy_Create\$New_DS_Name" -ItemType directory
			New-SmbShare -Name "New_DS_Name$" -Path "$New_Deploy_Create\$New_DS_Name" -FullAccess Administrators					
			New-PSDrive -Name "DSManager" -PSProvider "MDTProvider" -Root "$New_Deploy_Create\$New_DS_Name" -Description "MDT Deployment Share" -NetworkPath "\\$Comp_Name\$New_Deploy_Create$" -Verbose | add-MDTPersistentDrive -Verbose
		}
	Else
		{
			New-PSDrive -Name "DSManager" -PSProvider MDTProvider -Root $New_Deploy_Create -NetworkPath "\\$Comp_Name\$New_Deploy_Create$" -Verbose    
			New-Item -Path "$New_Deploy_Create\$New_DS_Name" -ItemType directory
			New-SmbShare -Name "New_DS_Name$" -Path "$New_Deploy_Create\$New_DS_Name" -FullAccess Administrators				
			New-PSDrive -Name "DSManager" -PSProvider "MDTProvider" -Root "$New_Deploy_Create\$New_DS_Name" -Description "MDT Deployment Share" -NetworkPath "\\$Comp_Name\$New_Deploy_Create$" -Verbose | add-MDTPersistentDrive -Verbose			
		}
	MDT_ADK_Registry_Delete	

	If ($Open_New_Deploy_CheckBox.IsChecked -eq $true)
		{
			$deploy = "$New_Deploy_Create\$New_DS_Name"
													
			$Applis_Row_List.Clear()					
			$MUIs_Row_List.Clear()			
			$Packages_Row_List.Clear()			
			$Drivers_Row_List.Clear()			
			$Medias_Row_List.Clear()			
			$OS_Row_List.Clear()			
	
			Populate_Datagrid_Applis	
			Populate_Datagrid_MUIs
			Populate_Datagrid_Packages		
			Populate_Datagrid_Media
			Populate_Datagrid_OS
			Populate_Datagrid_Drivers			
		}
})


# Show FORM
$Form.ShowDialog() | Out-Null	