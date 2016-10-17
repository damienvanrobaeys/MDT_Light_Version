#========================================================================
#
# Tool Name	: ENTITY TOOL WINDOWS 10
# Author 	: Damien VAN ROBAEYS
#
#========================================================================

param(
	[String]$deploymentshare,
	[String]$applixml,
	[String]$position,
	[String]$name,
	[String]$ShortName,
	[String]$comments,	
	[String]$publisher,
	[String]$version,	
	[String]$language,	
	[String]$command,
	[String]$source,	
	[String]$reboot,	
	[String]$enable,	
	[String]$hide		
	)
	
[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  | out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.ComponentModel') | out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Data')           | out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')        | out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null
[System.Reflection.Assembly]::LoadWithPartialName('PresentationCore')      | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')       | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') | out-null

[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo] "en-US"

Add-Type -AssemblyName "System.Windows.Forms"
Add-Type -AssemblyName "System.Drawing"

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

# Load MainWindow
$XamlMainWindow=LoadXml("Modidy_Appli.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
# 																		BUTTONS AND LABELS INITIALIZATION 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################

#************************************************************************** OPEN DEPLOYMENTSHARE FOLDER  ***********************************************************************************************
$Appli_publisher = $Form.findname("Appli_publisher") 
#************************************************************************** OPEN DEPLOYMENTSHARE FOLDER  ***********************************************************************************************
$Appli_name = $Form.findname("Appli_name") 
#************************************************************************** OPEN DEPLOYMENTSHARE FOLDER  ***********************************************************************************************
$Appli_version = $Form.findname("Appli_version") 
#************************************************************************** OPEN DEPLOYMENTSHARE FOLDER  ***********************************************************************************************
$Appli_language = $Form.findname("Appli_language") 
#************************************************************************** OPEN DEPLOYMENTSHARE FOLDER  ***********************************************************************************************
$New_Appli = $Form.findname("New_Appli") 
#************************************************************************** OPEN DEPLOYMENTSHARE FOLDER  ***********************************************************************************************
$Appli_command = $Form.findname("Appli_command") 
#************************************************************************** OPEN DEPLOYMENTSHARE FOLDER  ***********************************************************************************************
$Appli_comments = $Form.findname("Appli_comments") 
#************************************************************************** OPEN DEPLOYMENTSHARE FOLDER  ***********************************************************************************************
$Appli_Reboot = $Form.findname("Appli_Reboot") 
#************************************************************************** OPEN DEPLOYMENTSHARE FOLDER  ***********************************************************************************************
$Appli_Enable = $Form.findname("Appli_Enable") 
#************************************************************************** OPEN DEPLOYMENTSHARE FOLDER  ***********************************************************************************************
$Appli_Hide = $Form.findname("Appli_Hide") 
#************************************************************************** OPEN DEPLOYMENTSHARE FOLDER  ***********************************************************************************************
$Appli_Folder_Choice_Name = $Form.findname("Appli_Folder_Choice_Name") 
#************************************************************************** OPEN DEPLOYMENTSHARE FOLDER  ***********************************************************************************************
$New_Appli_source_textbox = $Form.findname("New_Appli_source_textbox") 
#************************************************************************** OPEN DEPLOYMENTSHARE FOLDER  ***********************************************************************************************
$Apply_changes_XML = $Form.findname("Apply_changes_XML") 
#************************************************************************** OPEN DEPLOYMENTSHARE FOLDER  ***********************************************************************************************
$Appli_Shortname = $Form.findname("Appli_Shortname") 

		
		
########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
#																		 VARIABLES DEFINITION 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################		
		
$object = New-Object -comObject Shell.Application  
				
$Appli_name.Text = $name
$Appli_comments.Text = $comments
$Appli_publisher.Text = $publisher
$Appli_version.Text = $version
$Appli_language.Text = $language
$New_Appli_source_textbox.Text = $source
$Appli_command.Text = $command
$Appli_Shortname.Text = $ShortName

$New_sources = $false
$New_Appli_source_textbox.IsEnabled = $false

If ($reboot -eq "$true")
	{
		$Appli_Reboot.IsChecked = $true	
	}
Else
	{
		$Appli_Reboot.IsChecked = $false	
	}

	
If ($hide -eq "$true")
	{
		$Appli_Hide.IsChecked = $true	
	}
Else
	{
		$Appli_Hide.IsChecked = $false	
	}	
	
	
If ($enable -eq "$true")
	{
		$Appli_Enable.IsChecked = $true	
	}
Else
	{
		$Appli_Enable.IsChecked = $false	
	}


########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
#																						 BROWSE NEW APPLI BUTTON 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################	
	
$New_Appli.Add_Click({	### action on button
    $folder = $object.BrowseForFolder(0, $message, 0, 0) 
    If ($folder -ne $null) { 
        $global:appli_sources_folder = $folder.self.Path 
		$global:appli_source_name = split-path  $folder.self.Path -leaf -resolve		
		$New_Appli_source_textbox.Text =  $appli_sources_folder	
		$New_sources = $true
	If($New_sources = $true)
		{				
			Remove-item "$deploymentshare\Applications\$name\*" -recurse
			copy-item "$appli_sources_folder\*" "$deploymentshare\Applications\$name"				
		}			
		
    }	 	
})			

########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
#																						 APPLY CHANGES BUTTON  
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################
	
$Apply_changes_XML.Add_Click({			
	If (($XML_Application_name -eq "") -or -($XML_Appli_Source_Folder -eq "") -or ($XML_Folder_Choice_Name -eq ""))
		{
			$Appli_name.BorderBrush = "Red"
			$New_Appli_source_textbox.BorderBrush = "Red"
		}
	Else
		{						
			If ($Appli_Enable.IsChecked	-eq $true)
				{
					$Enable_status = "True"
				}
			Else
				{
					$Enable_status = "False"
				}
				
			If ($Appli_Hide.IsChecked -eq $true)
				{
					$Hide_status = "True"
				}
			Else
				{
					$Hide_status = "False"
				}

			If ($Appli_Reboot.IsChecked	-eq $true)
				{
					$Reboot_status = "True"
				}
			Else
				{
					$Reboot_status = "False"
				}						
																									
			function LoadXml ($filename){
				$appEntityXml = [xml](Get-Content $filename)
				$appEntityXml.applications.application[$position].name   	 	= $Appli_name.Text.ToString()	
				$appEntityXml.applications.application[$position].ShortName     = $Appli_Shortname.Text.ToString()								
				$appEntityXml.applications.application[$position].comments   	= $Appli_comments.Text.ToString()					
				$appEntityXml.applications.application[$position].publisher  	= $Appli_publisher.Text.ToString()	
				$appEntityXml.applications.application[$position].version 	 	= $Appli_version.Text.ToString()	
				$appEntityXml.applications.application[$position].CommandLine   = $Appli_command.Text.ToString()	
				$appEntityXml.applications.application[$position].language   	= $Appli_language.Text.ToString()
				$appEntityXml.applications.application[$position].reboot     	= $Reboot_status							
				$appEntityXml.applications.application[$position].enable     	= $Enable_status					
				$appEntityXml.applications.application[$position].hide     		= $Hide_status	 				
				
				$appEntityXml.Save($filename)
			}	
			LoadXml ($applixml)
		}		
		[System.Windows.Forms.MessageBox]::Show("Application has been correctly modified. You close the window.") 	
})		
		

$Form.ShowDialog() | Out-Null
