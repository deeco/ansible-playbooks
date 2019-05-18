# This script install all we need to set up a machine to deploy AA

[CmdletBinding()]
param (
      [string] $usern
    , [string] $pass
    , [string] $branch
)

$gitDirectory="C:\ansible\GIT" #set directory for cloning git repository
$aaWorspace="C:\AA_Auto_Build_Deploy" #set directory where put AA-ENV
$gitBranch=$branch #AA_ENV branch to use
$aaenv="https://" + $usern +":" + $pass + "@github.com/Accela-Inc/AA-ENV.git"
$folder="AA-ENV"

#Check/set directory
If(!(test-path $gitDirectory))
{
    New-Item -ItemType Directory -Force -Path $gitDirectory
}
If(!(test-path $aaWorspace))
{
    New-Item -ItemType Directory -Force -Path $aaWorspace
}

#Cloning repository
cd $gitDirectory
rm -r -fo $folder
echo "removing folder .........."
Start-Sleep -Seconds 10
echo "Cloning repository"
git clone $aaenv 
cd $folder
git checkout $gitBranch

#Copy AA-ENV into workspace directory
echo "Moving folder and files"
rm -r -fo $aaWorspace/$folder
Start-Sleep -Seconds 15
Copy-Item -force $gitDirectory/$folder -Destination $aaWorspace/$folder -Recurse
New-Item -ItemType Directory -Force -Path $aaWorspace/index

