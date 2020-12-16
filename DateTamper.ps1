
<#
.Synopsis
   A PowerShell Implimentation of BulkFileChanger
.DESCRIPTION
   A PowerShell Implimentation of BulkFileChanger
   Created by Achref BEN SAAD
   Inspired from : https://www.nirsoft.net/utils/bulk_file_changer.html
.EXAMPLE
   .\DateTamper -date "1-1-2023 6:00" -ALL
   Will Change the LastWriteTime, CreationTime and LastAccesTime of all files and directories in the current position, please note that this function is not recursive
   #>


param(
    $fileName,
    $filesList,
    $date = [DateTime]::Today,
    [switch]$CreationTime,
    [switch]$LastAccessTime,
    [switch]$LastWriteTime,
    [switch]$ALL
)

function Modify {
    param (
        [String]$file,
        $date,
        $CreationTime,
        $LastAccessTime,
        $LastWriteTime,
        $ALL
    )
    $target = Get-Item $file
    if ($ALL) {
        $target.CreationTime = $date
        $target.LastAccessTime = $date
        $target.LastWriteTime = $date    
    }

    if($CreationTime){
        $target.CreationTime = $date
    }
    if ($LastAccessTime) {
        $target.LastAccessTime = $date
    }
    if ($LastWriteTime) {
        $target.LastWriteTime = $date
    }
}


if ($date.GetType() -ne [DateTime]) {
    try {
        $date = Get-Date -date $date
    }
    catch {
        Write-Error -Message "Please enter a valid date format" 
        exit 1
    }
}
if($filesList){
    Get-Content $filesList | ForEach-Object  { Modify -file $_ -date $date -CreationTime $CreationTime -LastAccessTime $LastAccessTime -LastWriteTime $LastWriteTime -ALL $ALL}
}
elseif ($fileName) {
    Modify -file $fileName -date $date -CreationTime $CreationTime -LastAccessTime $LastAccessTime -LastWriteTime $LastWriteTime -ALL $ALL    
}
else{
    Get-ChildItem .  | ForEach-Object  { Modify -file $_ -date $date -CreationTime $CreationTime -LastAccessTime $LastAccessTime -LastWriteTime $LastWriteTime -ALL $ALL}
}
