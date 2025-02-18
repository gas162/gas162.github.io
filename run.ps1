# Прочитать строки из файла
$lines = Get-Content -Path "questions.txt"

# Инициализация переменных
$data = @()
$currentQuestion = $null
$questionNumber = 0

# Обработка строк файла
foreach ($line in $lines) {
    if (-not [string]::IsNullOrWhiteSpace($line)) {
        if ($line -match "^\d+\.(.+)$") {
            if ($currentQuestion -ne $null) {
                $data += $currentQuestion
            }
            $questionNumber++
            $currentQuestion = @{
                n = $questionNumber
                q = $matches[1].Trim()
                a = @()
            }
        } elseif ($currentQuestion -ne $null) {
            $currentQuestion.a += $line.Trim()
        }
    }
}

if ($currentQuestion -ne $null) {
    $data += $currentQuestion
}

# Преобразование данных в формат JSON и сохранение в файл
$data | ConvertTo-Json -Depth 3 | Set-Content -Path "questions.json"
Write-Output "Данные успешно сохранены в файл questions.json"
