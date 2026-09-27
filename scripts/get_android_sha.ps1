# Prints SHA-1 and SHA-256 for Firebase Google Sign-In (debug keystore).
$keystore = "$env:USERPROFILE\.android\debug.keystore"
if (-not (Test-Path $keystore)) {
    Write-Host "Debug keystore not found at: $keystore"
    Write-Host "Run the app once from Android Studio, or create the keystore."
    exit 1
}
Write-Host "`nAdd BOTH fingerprints in Firebase Console:"
Write-Host "Project Settings -> Your apps -> Android (com.example.ybt_chat) -> Add fingerprint`n"
keytool -list -v -keystore $keystore -alias androiddebugkey -storepass android -keypass android
