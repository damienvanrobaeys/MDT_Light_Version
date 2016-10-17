#========================================================================
#
# Tool Name	: Windows 10 Profile Generator
# Version:	: 1.0	
# Author 	: Damien VAN ROBAEYS
# Date 		: 14/06/2016
#
#========================================================================

# Param
    # (
		# [Parameter(Mandatory=$true)]
		# [AllowEmptyString()]						
		# [String]$deploymentshare # Import the deployment share from the first GUI		        
    # )

# [System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
# [System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')       				| out-null
# [System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') 	| out-null

# Add-Type -AssemblyName "System.Windows.Forms"
# Add-Type -AssemblyName "System.Drawing"



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



$Update_BTN = $Form.findname("Update_BTN") 
$Add_item_BTN = $Form.findname("Add_item_BTN") 
$Modify_item_BTN = $Form.findname("Modify_item_BTN") 
$Remove_item_BTN = $Form.findname("Remove_item_BTN") 
$Refresh_btn = $Form.findname("Refresh_btn") 



########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
# 																		VARIABLES INITIALIZATION 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################

$object = New-Object -comObject Shell.Application  
$Global:Current_Folder =(get-location).path 
$Date = get-date -format "dd-MM-yy_HHmm"




########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
# 																		FUNCTIONS INITIALIZATION 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################


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
	
	

# Function Populate_Datagrid_Applis # Function to list your applications in the datagrid
	# {	
		# $Global:list_applis = ""
		# $Input_Applications = ""
		
		# $Global:list_applis = "$deploymentshare\Control\Applications.xml"						
		# $Input_Applications = [xml] (Get-Content $list_applis)			
		# foreach ($data in $Input_Applications.selectNodes("applications/application"))
			# {
				# $Applis_values = New-Object PSObject
				# $Applis_values = $Applis_values | Add-Member NoteProperty Name $data.Name
				# $Applis_values = $Applis_values | Add-Member NoteProperty ShortName $data.ShortName
				# $Applis_values = $Applis_values | Add-Member NoteProperty Version $data.Version
				# $Applis_values = $Applis_values | Add-Member NoteProperty Publisher $data.Publisher
				# $Applis_values = $Applis_values | Add-Member NoteProperty Language $data.Language
				# $Applis_values = $Applis_values | Add-Member NoteProperty Source $data.Source
				# $Applis_values = $Applis_values | Add-Member NoteProperty CommandLine $data.CommandLine 	
				# $Applis_values = $Applis_values | Add-Member NoteProperty Comments $data.Comments 		
				# $Applis_values = $Applis_values | Add-Member NoteProperty Reboot $data.Reboot 		
				# $Applis_values = $Applis_values | Add-Member NoteProperty Enable $data.Enable 		
				# $Applis_values = $Applis_values | Add-Member NoteProperty Hide $data.Hide 																	
				# $DataGrid_Applications.Items.Add($Applis_values) #> $null
			# }		
				# write-host $Applis_values
			
	# }
	
	
# Function Populate_Datagrid_Packages # Function to list your applications in the datagrid
	# {	
		# $Global:list_Packages = ""
		# $Input_Packages = ""			

		# $Global:list_Packages = "$deploymentshare\Control\Packages.xml"						
		# $Input_Packages = [xml] (Get-Content $list_Packages)		
		# $OnDemand_packages = $Input_Packages.packages.package | Where {$_.PackageType -match "OnDemandPack"}
		# foreach ($data in $OnDemand_packages) 
			# {
				# $Packages_values = New-Object PSObject
				# $Packages_values = $Packages_values | Add-Member NoteProperty Name $data.Name –passthru
				# $Packages_values = $Packages_values | Add-Member NoteProperty PackageType $data.PackageType –passthru
				# $Packages_values = $Packages_values | Add-Member NoteProperty Language $data.Language –passthru
				# $Packages_values = $Packages_values | Add-Member NoteProperty Version $data.Version –passthru
				# $Packages_values = $Packages_values | Add-Member NoteProperty ProductName $data.ProductName –passthru
				# $Packages_values = $Packages_values | Add-Member NoteProperty Architecture $data.Architecture –passthru
				# $Packages_values = $Packages_values | Add-Member NoteProperty Source $data.Source –passthru	
				# $Packages_values = $Packages_values | Add-Member NoteProperty SupportInformation $data.SupportInformation –passthru		
				# $Packages_values = $Packages_values | Add-Member NoteProperty Comments $data.Comments –passthru						
				# $Packages_values = $Packages_values | Add-Member NoteProperty Reboot $data.Reboot –passthru		
				# $Packages_values = $Packages_values | Add-Member NoteProperty Enable $data.Enable –passthru		
				# $Packages_values = $Packages_values | Add-Member NoteProperty Hide $data.Hide –passthru																	
				# $Datagrid_LPS.Items.Add($Packages_values) > $null
			# }								
	# }	

	

# Function Populate_Datagrid_OS  # Function to list your applications in the datagrid
	# {	
		# $Global:list_OS = ""
		# $Input_OS = ""			

		# $Global:list_OS = "$deploymentshare\Control\OperatingSystems.xml"						
		# $Input_OS = [xml] (Get-Content $list_OS)		
		# foreach ($data in $Input_OS.selectNodes("applications/application"))
			# {
				# $OS_values = New-Object PSObject
				# $OS_values = $OS_values | Add-Member NoteProperty Name $data.Name –passthru
				# $OS_values = $OS_values | Add-Member NoteProperty PackageType $data.PackageType –passthru
				# $OS_values = $OS_values | Add-Member NoteProperty Language $data.Language –passthru
				# $OS_values = $OS_values | Add-Member NoteProperty Version $data.Version –passthru
				# $OS_values = $OS_values | Add-Member NoteProperty ProductName $data.ProductName –passthru
				# $OS_values = $OS_values | Add-Member NoteProperty Architecture $data.Architecture –passthru
				# $OS_values = $OS_values | Add-Member NoteProperty Source $data.Source –passthru	
				# $OS_values = $OS_values | Add-Member NoteProperty SupportInformation $data.SupportInformation –passthru		
				# $OS_values = $OS_values | Add-Member NoteProperty Comments $data.Comments –passthru						
				# $OS_values = $OS_values | Add-Member NoteProperty Reboot $data.Reboot –passthru		
				# $OS_values = $OS_values | Add-Member NoteProperty Enable $data.Enable –passthru		
				# $OS_values = $OS_values | Add-Member NoteProperty Hide $data.Hide –passthru																	
				# $DataGrid_Packages.Items.Add($OS_values) > $null
			# }								
	# }		



# Function Populate_Datagrid_Drivers # Function to list your applications in the datagrid
	# {	
		# $Global:list_Drivers = ""
		# $Input_Drivers = ""			

		# $Global:list_Drivers = "$deploymentshare\Control\Packages.xml"						
		# $Input_Drivers = [xml] (Get-Content $list_Drivers)		
		# foreach ($data in $Input_Drivers.selectNodes("applications/application"))
			# {
				# $Drivers_values = New-Object PSObject
				# $Drivers_values = $Drivers_values | Add-Member NoteProperty Name $data.Name –passthru
				# $Drivers_values = $Drivers_values | Add-Member NoteProperty PackageType $data.PackageType –passthru
				# $Drivers_values = $Drivers_values | Add-Member NoteProperty Language $data.Language –passthru
				# $Drivers_values = $Drivers_values | Add-Member NoteProperty Version $data.Version –passthru
				# $Drivers_values = $Drivers_values | Add-Member NoteProperty ProductName $data.ProductName –passthru
				# $Drivers_values = $Drivers_values | Add-Member NoteProperty Architecture $data.Architecture –passthru
				# $Drivers_values = $Drivers_values | Add-Member NoteProperty Source $data.Source –passthru	
				# $Drivers_values = $Drivers_values | Add-Member NoteProperty SupportInformation $data.SupportInformation –passthru		
				# $Drivers_values = $Drivers_values | Add-Member NoteProperty Comments $data.Comments –passthru						
				# $Drivers_values = $Drivers_values | Add-Member NoteProperty Reboot $data.Reboot –passthru		
				# $Drivers_values = $Drivers_values | Add-Member NoteProperty Enable $data.Enable –passthru		
				# $Drivers_values = $Drivers_values | Add-Member NoteProperty Hide $data.Hide –passthru																	
				# $Datagrid_Drivers.Items.Add($Drivers_values) > $null
			# }								
	# }			
			

		
# Function Populate_Datagrid_Media  # Function to list your applications in the datagrid
	# {	
		# $Global:list_Medias = ""
		# $Input_Media = ""			

		# $Global:list_Medias = "$deploymentshare\Control\Medias.xml"						
		# $Input_Media = [xml] (Get-Content $list_Medias)		
		# foreach ($data in $Input_Media.selectNodes("applications/application"))
			# {
				# $Medias_values = New-Object PSObject
				# $Medias_values = $Medias_values | Add-Member NoteProperty Name $data.Name –passthru
				# $Medias_values = $Medias_values | Add-Member NoteProperty PackageType $data.PackageType –passthru
				# $Medias_values = $Medias_values | Add-Member NoteProperty Language $data.Language –passthru
				# $Medias_values = $Medias_values | Add-Member NoteProperty Version $data.Version –passthru
				# $Medias_values = $Medias_values | Add-Member NoteProperty ProductName $data.ProductName –passthru
				# $Medias_values = $Medias_values | Add-Member NoteProperty Architecture $data.Architecture –passthru
				# $Medias_values = $Medias_values | Add-Member NoteProperty Source $data.Source –passthru	
				# $Medias_values = $Medias_values | Add-Member NoteProperty SupportInformation $data.SupportInformation –passthru		
				# $Medias_values = $Medias_values | Add-Member NoteProperty Comments $data.Comments –passthru						
				# $Medias_values = $Medias_values | Add-Member NoteProperty Reboot $data.Reboot –passthru		
				# $Medias_values = $Medias_values | Add-Member NoteProperty Enable $data.Enable –passthru		
				# $Medias_values = $Medias_values | Add-Member NoteProperty Hide $data.Hide –passthru																	
				# $DataGrid_Packages.Items.Add($Medias_values) > $null
			# }								
	# }					
	
	
		
Function Add_Application_Part 
	{
		powershell -sta ".\Add_Appli.ps1" #-deploymentshare "'$global:deploymentshare'" -module $MDT_Module		
	}
	
Function Add_MUI_Part 
	{
		powershell -sta ".\Add_MUI.ps1" #-deploymentshare "'$global:deploymentshare'" -module $MDT_Module		
	}

Function Add_Package_Part 
	{
		powershell -sta ".\Add_Package.ps1" #-deploymentshare "'$global:deploymentshare'" -module $MDT_Module		
	}	
	
Function Add_Drivers_Part 
	{
		powershell -sta ".\Add_Drivers.ps1" #-deploymentshare "'$global:deploymentshare'" -module $MDT_Module		
	}	
	
Function Add_OS_Part 
	{
		powershell -sta ".\Add_OS.ps1" #-deploymentshare "'$global:deploymentshare'" -module $MDT_Module		
	}	
	
Function Add_Medias_Part 
	{
		powershell -sta ".\Add_Medias.ps1" #-deploymentshare "'$global:deploymentshare'" -module $MDT_Module		
	}	

	
	
	
	

########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
#																						 BUTTONS ACTIONS 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################

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
			$Modify_item_BTN.ToolTip = "Modify an OS"	
			$Remove_item_BTN.ToolTip = "Remove an OS"				
		}			
	ElseIf ($Tab_Control.SelectedItem.Header -eq "Language packs")
		{
			$Global:Launch_mode = "MUIs"		
			$Modify_item_BTN.IsEnabled = $false		
			$Add_item_BTN.ToolTip = "Add a language pack"								
			$Remove_item_BTN.ToolTip = "Remove an language pack"			
		}		
	ElseIf ($Tab_Control.SelectedItem.Header -eq "Packages")
		{
			$Global:Launch_mode = "Packages"		
			$Modify_item_BTN.IsEnabled = $false		
			$Add_item_BTN.ToolTip = "Add a package"								
			$Remove_item_BTN.ToolTip = "Remove a package"			
		}		
	ElseIf ($Tab_Control.SelectedItem.Header -eq "Drivers")
		{
			$Global:Launch_mode = "Drivers"		
			$Modify_item_BTN.IsEnabled = $true		
			$Add_item_BTN.ToolTip = "Add a driver"								
			$Remove_item_BTN.ToolTip = "Remove a driver"			
		}				
	ElseIf ($Tab_Control.SelectedItem.Header -eq "Medias")
		{
			$Global:Launch_mode = "Medias"		
			$Modify_item_BTN.IsEnabled = $true		
			$Add_item_BTN.ToolTip = "Add a Media"								
			$Modify_item_BTN.ToolTip = "Modify a Media"	
			$Remove_item_BTN.ToolTip = "Remove a Media"				
		}				
})					
			
				

				
 $Update_BTN.Add_Click({	
	# powershell -sta ".\Update_DeploymentShare.ps1" #-deploymentshare "'$global:deploymentshare'" -module $MDT_Module	


    $folder = $object.BrowseForFolder(0, $message, 0, 0) 
    If ($folder -ne $null) 
		{ 		
			$global:deploymentshare = $folder.self.Path 
			$global:deploy = "$deploymentshare\Deploy"			
			Populate_Datagrid_MUIs		

		}	

})			





			
########################################################################################################################################################################################################
#                        															ADD BUTTON                                   
########################################################################################################################################################################################################
 $Add_item_BTN.Add_Click({	
	If ($Launch_mode -eq "Applis")
		{
			Add_Application_Part
			# $Applis_Row_List.Clear()			
			# Populate_Datagrid_Applis			
		}
	ElseIf ($Launch_mode -eq "MUIs")
		{
			Add_MUI_Part
			# $MUIs_Row_List.Clear()			
			# Populate_Datagrid_MUIs
		}		
	ElseIf ($Launch_mode -eq "Packages")
		{
			Add_Package_Part
			# $Packages_Row_List.Clear()			
			# Populate_Datagrid_Packages
		}	
	ElseIf ($Launch_mode -eq "Drivers")
		{
			Add_Drivers_Part
			$Packages_Row_List.Clear()			
			Populate_Datagrid_Drivers
		}	
	ElseIf ($Launch_mode -eq "Medias")
		{
			Add_Medias_Part
			$Packages_Row_List.Clear()			
			Populate_Datagrid_Medias
		}	
	ElseIf ($Launch_mode -eq "OS")
		{
			Add_OS_Part
			# $Packages_Row_List.Clear()			
			# Populate_Datagrid_OS
		}			
})			








	

# Show FORM
$Form.ShowDialog() | Out-Null	