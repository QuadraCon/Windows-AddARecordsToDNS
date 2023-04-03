$DNSZone = Read-Host -Prompt 'Input the DNS Zone'
$DNSSever = Read-Host -Prompt 'Input the server hostname'

Function Get-FileName($initialDirectory)
{   
 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
 Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = $initialDirectory
 $OpenFileDialog.filter = "All files (*.*)| *.*"
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
} #end function Get-FileName
$InputFilePath = Get-FileName
$FileContents=get-content -Path "$InputFilePath" 

try{
     for($i=0;$i -lt $FileContents.count;$i++){
        $textrow = ($FileContents[$i]).split(",")
        Add-DnsServerResourceRecordA -Name $textrow[0].replace("`"","") -IPv4Address $textrow[1].replace("`"","") -ZoneName $DNSZone -ComputerName $DNSSever
        write-host "$textrow[0]/$textrow[1] added to $DNSZone" -Foregroundcolor GREEN
        }
}
catch{
    write-host "An Error Occured $PSItem.Exception.Message" -ForegroundColor RED
}
finally{
    write-host "Script ended"
    pause
}