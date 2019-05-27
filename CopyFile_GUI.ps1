

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '640,584'
$Form.text                       = "Copy File"
$Form.TopMost                    = $false

$Groupbox_Browse                = New-Object system.Windows.Forms.Groupbox
$Groupbox_Browse.height         = 120
$Groupbox_Browse.width          = 330
$Groupbox_Browse.text           = "Browse"
$Groupbox_Browse.location       = New-Object System.Drawing.Point(8,5)

$Groupbox_Computers              = New-Object system.Windows.Forms.Groupbox
$Groupbox_Computers.height       = 248
$Groupbox_Computers.width        = 330
$Groupbox_Computers.text         = "Computers to copy to"
$Groupbox_Computers.location     = New-Object System.Drawing.Point(8,124)

$Groupbox_Destination            = New-Object system.Windows.Forms.Groupbox
$Groupbox_Destination.height     = 76
$Groupbox_Destination.width      = 330
$Groupbox_Destination.text       = "Destination"
$Groupbox_Destination.location   = New-Object System.Drawing.Point(8,383)

$Groupbox_StartCopy              = New-Object system.Windows.Forms.Groupbox
$Groupbox_StartCopy.height       = 374
$Groupbox_StartCopy.width        = 269
$Groupbox_StartCopy.text         = "Copy"
$Groupbox_StartCopy.location     = New-Object System.Drawing.Point(340,29)

$Button1_Browse                  = New-Object system.Windows.Forms.Button
$Button1_Browse.text             = "Browse"
$Button1_Browse.width            = 90
$Button1_Browse.height           = 34
$Button1_Browse.location         = New-Object System.Drawing.Point(105,47)
$Button1_Browse.Font             = 'Microsoft Sans Serif,10'

$TextBox1_Computers              = New-Object system.Windows.Forms.TextBox
$TextBox1_Computers.multiline    = $true
$TextBox1_Computers.width        = 224
$TextBox1_Computers.height       = 150
$TextBox1_Computers.location     = New-Object System.Drawing.Point(44,70)
$TextBox1_Computers.Font         = 'Microsoft Sans Serif,10'

$TextBox2_Result                 = New-Object system.Windows.Forms.TextBox
$TextBox2_Result.multiline       = $true
$TextBox2_Result.width           = 224
$TextBox2_Result.height          = 288
$TextBox2_Result.location        = New-Object System.Drawing.Point(20,50)
$TextBox2_Result.Font            = 'Microsoft Sans Serif,10'

$Button2_StartCopy               = New-Object system.Windows.Forms.Button
$Button2_StartCopy.text          = "Start Copy"
$Button2_StartCopy.width         = 90
$Button2_StartCopy.height        = 34
$Button2_StartCopy.location      = New-Object System.Drawing.Point(80,10)
$Button2_StartCopy.Font          = 'Microsoft Sans Serif,10'

$TextBox3_Destination            = New-Object system.Windows.Forms.TextBox
$TextBox3_Destination.multiline  = $false
$TextBox3_Destination.width      = 224
$TextBox3_Destination.height     = 20
$TextBox3_Destination.location   = New-Object System.Drawing.Point(44,43)
$TextBox3_Destination.Font       = 'Microsoft Sans Serif,10'

$TextBox4_File                   = New-Object system.Windows.Forms.TextBox
$TextBox4_File.multiline         = $false
$TextBox4_File.width             = 224
$TextBox4_File.height            = 20
$TextBox4_File.location          = New-Object System.Drawing.Point(44,90)
$TextBox4_File.Font              = 'Microsoft Sans Serif,10'

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Browse to the file you want to copy."
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(55,25)
$Label1.Font                     = 'Microsoft Sans Serif,10'

$Label2                          = New-Object system.Windows.Forms.Label
$Label2.text                     = "Type in the name of computers you want to copy to.
        Separate computers with a comma (,)"
$Label2.AutoSize                 = $true
$Label2.width                    = 25
$Label2.height                   = 10
$Label2.location                 = New-Object System.Drawing.Point(5,20)
$Label2.Font                     = 'Microsoft Sans Serif,10'

$Label3                          = New-Object system.Windows.Forms.Label
$Label3.text                     = "Enter the path you want to copy the file to."
$Label3.AutoSize                 = $true
$Label3.width                    = 25
$Label3.height                   = 10
$Label3.location                 = New-Object System.Drawing.Point(40,18)
$Label3.Font                     = 'Microsoft Sans Serif,10'


$Form.controls.AddRange(@($Groupbox_Browse,$Groupbox_Computers,$Groupbox_Destination,$Groupbox_StartCopy,$ListBox_Computers))

$Groupbox_Browse.controls.AddRange(@($Button1_Browse,$Label1,$TextBox4_File))
$Groupbox_Computers.controls.AddRange(@($TextBox1_Computers,$Label2))
$Groupbox_Destination.controls.AddRange(@($TextBox3_Destination,$Label3))
$Groupbox_StartCopy.controls.AddRange(@($Button2_StartCopy,$TextBox2_Result))



$Button1_Browse.Add_Click({ browse })
$Button2_StartCopy.Add_Click({ StartCopy })
$TextBox1_Computers.Add_TextChanged({  })



function browse {
$openFileDialog = New-Object windows.forms.openfiledialog   
    $openFileDialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()   
    $openFileDialog.title = "Select the file you want to copy"   
    $openFileDialog.Multiselect = $True
    $openFileDialog.ShowHelp = $True   

    $result = $openFileDialog.ShowDialog()    
    Write-host $OpenFileDialog.filename " Selected." 
    $Global:File = $OpenFileDialog.filename
    $textbox4_File.AppendText($openFileDialog.FileName)
 }


function StartCopy {
#$Password = Read-Host -Prompt 'Input password for \Administrator Account'

[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

$title = 'Admin Password'
$msg   = 'Enter the \Administrator password:'

$Password = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)
$Computers += @($TextBox1_Computers.text.split(","))
$Destination = $TextBox3_Destination.Text

foreach ($Computer in $Computers)
    {
        net use \\$Computer\C$ $Password /USER:Administrator
        Copy-Item $File -Destination "\\$Computer\$Destination" -force -recurse
            if(-not $?) {
                $textbox2_Result.AppendText("`n$Computer - Copy Failed")} #-foregroundcolor Red
            else {$textbox2_Result.AppendText("`n$Computer - Successful")} #-foregroundcolor Green
    }
 {#Test for color           
#            if(-not $?) {
#                $Textbox2_result.forecolor = "Red"
#                $textbox2_Result.AppendText("`n$Computer - Copy Failed")} #-foregroundcolor Red
#            else {
#                $TextBox2_result.forecolor = "Green"
#            $textbox2_Result.AppendText("`n$Computer - Successful")} #-foregroundcolor Green
#    }
 }
 
 }
 
[void]$Form.ShowDialog()