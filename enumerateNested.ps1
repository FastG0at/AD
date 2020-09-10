$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$PDC = ($domainObj.PdcRoleOwner).Name
$SearchString = "LDAP://"
$SearchString += $PDC + "/"
$DistinguishedName = "DC=$($domainObj.Name.Replace('.', ',DC='))"
$SearchString += $DistinguishedName
$Searcher = New-Object System.DirectoryServices.DirectorySearcher([ADSI]$SearchString)
$objDomain = New-Object System.DirectoryServices.DirectoryEntry
$Searcher.SearchRoot = $objDomain

$Searcher.filter="(objectClass=Group)"
$Result = $Searcher.FindAll()
Foreach($obj in $Result)
{
$a=$obj.Properties.name
$b=$obj.Properties.member
Write-Host "Group name is $a"
$Mlength=$b.Length
if(!$Mlength)
{
Write-Host "No more members found"
Write-Host "------------------------"
continue
}
$s=$b.split(',')
$memberlength=$s[0].Length
$membername=$s[0].Substring(3,$memberlength-3)
Write-Host "Member name is $membername"

while($memberlength)
{
$Searcher.filter="(name=$membername)"
$subResult = $Searcher.FindAll()
$c=$subResult.Properties.member
$memberlength=$c.Length

if(!$memberlength)
{
Write-Host "No more members found"
break
}
$sloop=$c.split(',')
$looplength=$sloop[0].Length
$membername=$sloop[0].Substring(3,$looplength-3)
Write-Host "Member name is $membername"
}
Write-Host "------------------------"
}
