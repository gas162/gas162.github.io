function Process-QuestionsFile {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FileName
    )

    # Прочитать строки из указанного файла
    $lines = Get-Content -Path $FileName

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
    $outputFile = [System.IO.Path]::ChangeExtension($FileName, "json")
    $data | ConvertTo-Json -Depth 3 | Set-Content -Path $outputFile
    Write-Output "Данные успешно сохранены в файл $outputFile"
}

Process-QuestionsFile -FileName "questions_common.txt"
Process-QuestionsFile -FileName "questions_cosmetology.txt"