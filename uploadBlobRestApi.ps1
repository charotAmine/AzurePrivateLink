$StorageAccountName = "<your-account-name>"
$StorageContainerName = "<your-container-name>"
$storageAccessKey = '<your-access-key>'
$filePath = "<your-file-path>"
$fileName = Split-Path $filePath -leaf
$Url = "https://$StorageAccountName.blob.core.windows.net/$StorageContainerName/$fileName"
$contentLength = (Get-Item $filePath).length 
$date = (get-date -format r).ToString()

$headers = @{"x-ms-version"="$headerDate"}
$headers.Add("x-ms-date",$date)
$headers.Add("Content-Length","$contentLength")
$headers.Add("x-ms-blob-type","BlockBlob")

$signatureString = "PUT`n`n`n$contentLength`n`n`n`n`n`n`n`n`n"
$signatureString += "x-ms-blob-type:" + $headers["x-ms-blob-type"] + "`n"
$signatureString += "x-ms-date:" + $headers["x-ms-date"] + "`n"
$signatureString += "x-ms-version:" + $headers["x-ms-version"] + "`n"

$signatureString += "/" + $StorageAccountName + "/$StorageContainerName/$fileName"

$dataToMac = [System.Text.Encoding]::UTF8.GetBytes($signatureString)
$accountKeyBytes = [System.Convert]::FromBase64String($storageAccessKey)
$hmac = new-object System.Security.Cryptography.HMACSHA256((,$accountKeyBytes))
$signature = [System.Convert]::ToBase64String($hmac.ComputeHash($dataToMac))

$headers.Add("Authorization", "SharedKey " + $StorageAccountName + ":" + $signature);

Invoke-RestMethod -Uri $Url -Method PUT -headers $headers -InFile $filePath
