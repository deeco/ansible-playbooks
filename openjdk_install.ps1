#REM Deploy .NET Framework 3.5 by using Deployment Image Servicing and Management (DISM)
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All

# Installing OpenJDK8
echo "installing OpenJDK8"
$path = "C:\OpenJDK"
If(!(test-path $path))
{
    New-Item -ItemType Directory -Path $path
}

$url = "https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u202-b08/OpenJDK8U-jdk_x64_windows_hotspot_8u202b08.zip"
$file = "C:\OpenJDK\OpenJDK8U-jdk_x64_windows_hotspot_8u202b08.zip"
$url2 = "http://icedtea.wildebeest.org/download/icedtea-web-binaries/1.7.1/windows/itw-installer.msi"
$file2 = "C:\OpenJDK\itw-installer.msi"
$jdkDir="jdk8u202-b08"
$jdkFullDir="C:\OpenJDK\jdk8u202-b08"

[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$webClient = new-object System.Net.WebClient
$webClient.DownloadFile( $url, $file )
$webClient.DownloadFile( $url2, $file2 )


Add-Type -AssemblyName System.IO.Compression.FileSystem
function unzip {
    param( [string]$ziparchive, [string]$extractpath )
    [System.IO.Compression.ZipFile]::ExtractToDirectory( $ziparchive, $extractpath )
}
unzip $file $path

setx -m JAVA_HOME $jdkFullDir

$oldSysPath = (Get-Itemproperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path).Path
$newSysPath = $oldSysPath + ";C:\OpenJDK\jdk8u202-b08\bin"

Set-ItemProperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path -Value $newSysPath

msiexec /i $file2
######################
### Add Firewall Rules
######################
# This script install all we need to set up a machine to deploy AA


echo "update gitinstall/config"
git config --global core.editor "'C:/Program Files/Notepad++/notepad++.exe' -multiInst -notabbar -nosession -noPlugin"
git config --global core.autocrlf true
git config --system --unset credential.helper
git config --global core.askpass


#Open port on firewall
New-NetFirewallRule -DisplayName 'iis ACA AGIS' -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('80', '443')
New-NetFirewallRule -DisplayName 'biz' -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('3080', '3443')
New-NetFirewallRule -DisplayName 'cmfx' -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('4080', '4443')
New-NetFirewallRule -DisplayName 'web' -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('5080', '5443')
New-NetFirewallRule -DisplayName 'keystone api' -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('7080', '7443')
New-NetFirewallRule -DisplayName 'index' -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('6099', '6990', '6080')
New-NetFirewallRule -DisplayName 'jenkins' -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('42424')
