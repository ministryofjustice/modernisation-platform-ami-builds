$connectionXMLDirectory = "C:\Users\$($ENV:USERNAME)\AppData\Roaming\SQL Developer\system4.1.3.20.78\o.jdeveloper.db.connection.12.2.1.0.42.151001.541"
New-Item -ItemType Directory -Path $connectionXMLDirectory -Force
$connectionXMLLocation = "${connectionXMLDirectory}\connections.xml"
$connectionXMLContents = Get-Content -Path "C:\scripts\connections.xml"
$connectionXMLContents | Out-File -FilePath $connectionXMLLocation
