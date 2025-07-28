# PowerShell script to fix withOpacity deprecation warnings in Flutter project
# This script replaces .withOpacity() calls with .withValues(alpha: ) for Material 3 compliance

Write-Host "🔧 Starting Flutter withOpacity deprecation fix..." -ForegroundColor Cyan

# Get all Dart files in the project
$dartFiles = Get-ChildItem -Path "." -Filter "*.dart" -Recurse | Where-Object { 
    $_.FullName -notlike "*\.dart_tool*" -and 
    $_.FullName -notlike "*\build\*" -and
    $_.FullName -notlike "*\.pub-cache*"
}

Write-Host "📁 Found $($dartFiles.Count) Dart files to process" -ForegroundColor Yellow

$totalReplacements = 0
$processedFiles = 0

foreach ($file in $dartFiles) {
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        
        # Replace .withOpacity(value) with .withValues(alpha: value)
        # Handle various formatting scenarios
        $patterns = @(
            # Standard pattern: .withOpacity(0.5)
            '\.withOpacity\(([^)]+)\)',
            # Pattern with spaces: .withOpacity( 0.5 )
            '\.withOpacity\(\s*([^)]+)\s*\)'
        )
        
        $fileReplacements = 0
        foreach ($pattern in $patterns) {
            $regexMatches = [regex]::Matches($content, $pattern)
            if ($regexMatches.Count -gt 0) {
                $content = [regex]::Replace($content, $pattern, '.withValues(alpha: $1)')
                $fileReplacements += $regexMatches.Count
            }
        }
        
        # Additional pattern for complex expressions
        # Handle cases like: Colors.black.withOpacity(0.2)
        $complexPattern = '(\w+(?:\.\w+)*?)\.withOpacity\(([^)]+)\)'
        $complexRegexMatches = [regex]::Matches($content, $complexPattern)
        if ($complexRegexMatches.Count -gt 0) {
            $content = [regex]::Replace($content, $complexPattern, '$1.withValues(alpha: $2)')
            $fileReplacements += $complexRegexMatches.Count
        }
        
        # Only write file if changes were made
        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
            Write-Host "✅ Fixed $fileReplacements replacements in: $($file.Name)" -ForegroundColor Green
            $totalReplacements += $fileReplacements
        }
        
        $processedFiles++
        
        # Progress indicator
        if ($processedFiles % 10 -eq 0) {
            Write-Host "⏳ Processed $processedFiles/$($dartFiles.Count) files..." -ForegroundColor Blue
        }
        
    } catch {
        Write-Host "❌ Error processing $($file.FullName): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n🎉 Deprecation fix complete!" -ForegroundColor Green
Write-Host "📊 Summary:" -ForegroundColor Cyan
Write-Host "   • Files processed: $processedFiles" -ForegroundColor White
Write-Host "   • Total replacements: $totalReplacements" -ForegroundColor White
Write-Host "   • withOpacity → withValues(alpha:) conversions completed" -ForegroundColor White

if ($totalReplacements -gt 0) {
    Write-Host "`n🔄 Recommendation: Run 'flutter analyze' to verify all deprecation warnings are resolved" -ForegroundColor Yellow
    Write-Host "🧪 Then run 'flutter test' to ensure no functionality was broken" -ForegroundColor Yellow
} else {
    Write-Host "`n✨ No withOpacity deprecations found - your code is already Material 3 compliant!" -ForegroundColor Green
}

Write-Host "`n🚀 Ready to continue with your Invisible Habit Builder app development!" -ForegroundColor Magenta
