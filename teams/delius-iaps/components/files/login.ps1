$connectionXMLDirectory = "C:\Users\$($ENV:USERNAME)\AppData\Roaming\SQL Developer\system4.1.3.20.78\o.jdeveloper.db.connection.12.2.1.0.42.151001.541"
$connectionsXMLFullPath = "${connectionXMLDirectory}\connections.xml"
if (![System.IO.File]::Exists($connectionsXMLFullPath)) {
    New-Item -ItemType Directory -Path $connectionXMLDirectory -Force
    $connectionXMLContents = Get-Content -Path "C:\scripts\connections.xml"
    $connectionXMLContents | Out-File -FilePath $connectionsXMLFullPath -Encoding utf8
}
