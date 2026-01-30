include irvine32.inc
includelib winmm.lib

.data
    
    ; game objects
        building byte 178, 0
        car byte 254, 0
        tree byte 234, 0
        passenger byte 'P'
        destination byte 'D'
        grid byte 400 dup ('.')
    
    ;game variables (state)
        carPosition dd 0
        hasPassenger db 0
        destinationPos dd -1
        destinationActive db 0
        score dd 0
        passengerNo dd 0
        gotout dd 0                             ; 0 for not out 1 for out
        isPause dd 0

    ;input/output
        playerName byte 50 dup(0)
        taxiColor db 0

    ; penalties deepending on levels
        redObstacleP dd 0
        yellowObstacleP dd 0
        redCarP dd 0
        yellowCarP dd 0

    ;modes
    ; 1 for yes, 0 for no
        isCareer byte 0                 
        istime byte 0
        isEndless byte 0

        careerTarget dd 5                   ; win after delivering 5 passengers
        wonGame byte 0                      ; 1 if player won
        negScore byte 0                     ; 1 if player scored negative

    ; Time mode variables
        timeLimit dd 120                    ; 120 seconds (2 minutes) time limit
        timeRemaining dd 0                  ; Countdown
        startTime dd 0
        showTimeRemaining byte "Time: ", 0
        timeRanOut byte 0                   ; 1 true

        pauseStartTime dd 0           ; When pause started
        totalPausedTime dd 0          ; Total time spent paused

    ; FileHandling - Leader board
        filename byte "highscores.txt", 0
        fileHandle dd ?
        leaderboardNames byte 10 dup(30 dup(0))
        leaderboardScores dd 10 dup(0)                  ; 10 scores corresponding to names
        buffer byte 500 dup(0)                          ; Buffer for file reading


    ; Display
        titleLine1 byte "  ____  _   _ ____  _   _    _   _  ___  _   _ ____  ", 13, 10, 0
        titleLine2 byte " |  _ \| | | / ___|| | | |  | | | |/ _ \| | | |  _ \ ", 13, 10, 0
        titleLine3 byte " | |_) | | | \___ \| |_| |  | |_| | | | | | | | |_) |", 13, 10, 0
        titleLine4 byte " |  _ <| |_| |___) |  _  |  |  _  | |_| | |_| |  _ < ", 13, 10, 0
        titleLine5 byte " |_| \_\\___/|____/|_| |_|  |_| |_|\___/ \___/|_| \_\", 13, 10, 0

        showMenu byte 13, 10
                 byte "    ------------------------------------", 13, 10
                 byte "                MAIN MENU               ", 13, 10
                 byte "    ------------------------------------",13, 10
                 byte "            1. Start New Game", 13, 10
                 byte "            2. Continue Game", 13, 10
                 byte "            3. View Leaderboard", 13, 10
                 byte "            4. Show Instructions", 13, 10
                 byte "            5. Exit", 13, 10, 13, 10
                 byte 13, 10
                 byte "Enter your choice: ", 0

        showLevels byte 13, 10
                   byte "  --------------------------------------", 13, 10
                   byte "                 LEVELS                 ", 13, 10
                   byte "  --------------------------------------", 13, 10
                   byte "               E - EASY                 ", 13, 10
                   byte "               M - MEDIUM ", 13 ,10
                   byte "               H - HARD   ",13, 10
                   byte 13, 10
                   byte "Enter your choice: ", 0

        showModes byte 13, 10
                  byte "  ----------------------------------------", 13, 10
                  byte "                    MODES                 ", 13, 10
                  byte "  ----------------------------------------", 13, 10
                  byte "             a - Career", 13, 10
                  byte "             b - Time", 13, 10
                  byte "             c - Endless ", 13, 10
                  byte 13, 10
                  byte "Enter your choice: ", 0

        ;Taxi Selection message
        taxiSelectionMsg byte 13, 10
                         byte "    ------------------------------------", 13, 10
                         byte "              SELECT YOUR TAXI          ", 13, 10
                         byte "    ------------------------------------", 13, 10
                         byte "             1. Yellow Taxi           ", 13, 10
                         byte "             2. Red Taxi              ", 13, 10
                         byte 13, 10, 13, 10
                         byte "Enter choice: ", 0

    ;Player Name prompt
        namePrompt byte "ENTER YOUR NAME: ", 0

   ; Instructions Screen
        instructionsMsg byte 13, 10
                        byte "    ------------------------------------------------------------", 13, 10
                        byte "                            INSTRUCTIONS                      ",13, 10
                        byte "    ------------------------------------------------------------",13, 10
                        byte "     CONTROLS:", 13, 10
                        byte "              W - Move Up", 13, 10
                        byte "              S - Move Down", 13, 10
                        byte "              A - Move Left", 13, 10
                        byte "              D - Move Right", 13, 10
                        byte "              SPACEBAR - Pick/Drop Passenger", 13, 10
                        byte "              P - Pause Game", 13, 10, 13, 10
                        byte "      OBJECTIVE:", 13, 10
                        byte "          Pick up passengers(P) and drop them", 13, 10
                        byte "          at their destinations (Green)", 13, 10, 13, 10
                        byte "      SCORING:", 13, 10
                        byte "          +10 points      = Drop passenger successfully", 13, 10
                        byte "          SCORED NEGATIVE = INSTANT GAME OVER!", 13, 10
                        byte "          HIT BUILDING    = INSTANT GAME OVER!", 13, 10
                        byte "          HIT CARS/TREES  = Penalties ", 13, 10
                        byte "          Hit obstacles(X)= Score penalty", 13, 10, 13, 10
                        byte "Press any key to return back to menu...", 0

    ; Leaderboard Display
        leaderboardTitle1 byte "  -------------------------------------", 0
        leaderboardTitle2 byte "               LEADERBOARD", 0
        leaderboardTitle3 byte "  -------------------------------------",13, 10, 0
        leaderboardEmpty byte "No scores yet! Be the first ONE to play!", 13, 10, 13, 10, 0

        showScore byte "Score: ", 0
        passengers_in_taxi byte "Passenger in taxi: ", 0
        showDelivered byte "Delivered: ", 0
        showTaxiType byte "Taxi: ", 0
        yellowText byte "Yellow", 0
        redText byte "Red", 0

        pausemsg byte "Game Paused! Press 'P' to Unpause",0
        Unpausemsg byte "Unpaused! Now You Can Move", 0

    ; Game Over Messages
        gameOverMsg byte 13, 10
                    byte "    ----------------------------------", 13, 10
                    byte "              GAME OVER!", 13, 10
                    byte "    ----------------------------------", 13, 10, 0

        gameWonMsg byte 13, 10
                   byte "    ----------------------------------", 13, 10
                   byte "                YOU WON!", 13, 10
                   byte "    ----------------------------------", 13, 10, 0

        timeUpMsg byte "    ------------------------------------", 13 ,10
                  byte "     Time's Up! Better luck next time!", 13, 10
                  byte "    ------------------------------------", 13, 10, 0

        negativeScoreMsg byte "  -------------------------------------", 13, 10
                         byte "     Oops! Your Score Went Negative", 13, 10
                         byte "  -------------------------------------", 13, 10, 0

        finalScoreMsg byte "    Final Score: ", 0
        deliveredMsg byte "    Passengers Delivered: ", 0

        ;Generic Messages
        pressKey byte 13, 10, "Press any key to continue...", 0

        ;music
        menuMusic byte "menu.wav", 0
        gameMusic byte "game.wav", 0
        gameOverSound byte "gameover.wav", 0
        collisionSound byte "collision.wav", 0

.code
main PROC
        call Randomize
        call LoadLeaderboard
    
MainLoop:
    call clrscr
    call DisplayTitle
    call Menu
    cmp al, '5'
    jne MainLoop
   
    call SaveLeaderboard
    exit
main ENDP

DisplayTitle PROC
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    mov dl, 15
    mov dh, 2
    call Gotoxy
    mov edx, offset titleLine1
    call WriteString
    
    mov dl, 15
    mov dh, 3
    call Gotoxy
    mov edx, offset titleLine2
    call WriteString
    
    mov dl, 15
    mov dh, 4
    call Gotoxy
    mov edx, offset titleLine3
    call WriteString
    
    mov dl, 15
    mov dh, 5
    call Gotoxy
    mov edx, offset titleLine4
    call WriteString
    
    mov dl, 15
    mov dh, 6
    call Gotoxy
    mov edx, offset titleLine5
    call WriteString
    
    ; Reset color to white on black
    mov eax, white + (black * 16)
    call SetTextColor
    ret
DisplayTitle ENDP

Menu PROC
    mov dl, 20
    mov dh, 8
    call Gotoxy
    mov edx, offset showMenu
    call WriteString
    
    call ReadChar
    call WriteChar
    
    cmp al, '1'
    je NewGame
    
CheckContinue:
    cmp al, '2'
    je Continue
    
CheckLeaderboard:
    cmp al, '3'
    je LeaderBoard
    
CheckInstructions:
    cmp al, '4'
    je ShowInstructions
    
CheckQuit:
    cmp al, '5'
    je QuitGame
    jmp Menu

NewGame:
    
    call clrscr
    call SelectTaxi
    call GetPlayerName

    call InitializeGame
    call GetLevel
    call GetMode
    call clrscr
    call DisplayGrid

GameLoop:
    ;CHECK FOR GAME OVER CONDITION
    mov eax, score
    cmp eax, 0
    jge nextC
    mov negScore, 1
    jmp GameOver

    nextC:                                      ;next condition
    mov eax, gotout
    cmp eax, 0
    jne GameOver

    cmp isCareer, 1
    jne CheckTimeMode
    mov eax, passengerNo
    cmp eax, careerTarget                       ;5
    jge GameWon
    
CheckTimeMode:
    cmp istime, 1
    jne ContinueGame
    
    call UpdateTimeRemaining
    cmp passengerNo, 5                          ; max passengers
    je GameWon

ContinueGame:  
    mov eax, white + (black * 16)
    call SetTextColor
    
    ; current score
    mov dl, 2
    mov dh, 2
    call Gotoxy
    mov edx, offset showScore
    call WriteString
    mov eax, score
    call WriteDec
    
    ; passenger status (0 or 1)
    mov dl, 2
    mov dh, 3
    call Gotoxy
    mov edx, offset passengers_in_taxi
    call WriteString
    movzx eax, hasPassenger
    call WriteDec
    
    ; total passengers delivered
    mov dl, 2
    mov dh, 4
    call Gotoxy
    mov edx, offset showDelivered
    call WriteString
    mov eax, passengerNo
    call WriteDec
    
    ; Display time remaining (for TIME MODE only)
    cmp istime, 1
    jne SkipTimeDisplay

    mov dl, 2
    mov dh, 6
    call Gotoxy
    mov edx, offset showTimeRemaining
    call WriteString
    mov eax, timeRemaining
    call WriteDec
    mov al, 's'
    call WriteChar

SkipTimeDisplay:
    mov dl, 2
    mov dh, 5
    call Gotoxy
    mov edx, offset showTaxiType
    call WriteString
    cmp taxiColor, 0
    je ShowYellow
    cmp taxiColor, 1
    je showRed
    mov eax, Magenta + (black*16)
    jmp next

showRed:
    ; Red taxi
    mov edx, offset redText
    mov eax, red + (black * 16)
    jmp ShowTaxiColor
    
ShowYellow:                                 ; Yellow taxi
    mov edx, offset yellowText
    mov eax, yellow + (black * 16)
    
ShowTaxiColor:
    call SetTextColor
    call WriteString
next:    
    ; Handling player's input (WASD/Space)
    call HandleInput
    jmp GameLoop                             ;continue game loop (at starting it checks if player gets out/not)

GameOver:
    call UpdateLeaderboard
    call SaveLeaderboard
    call clrscr
    call DisplayGameOver
    
    ret                           ;Return to main menu

Continue:
    ret                             ; not implemented

LeaderBoard:
    call clrscr
    call DisplayLeaderboard
    call ReadChar
    ret

ShowInstructions:
    call clrscr
    mov dl, 10
    mov dh, 3
    call Gotoxy
    mov edx, offset instructionsMsg
    call WriteString
    call ReadChar
    ret

QuitGame:
    ret

GameWon:
    mov wonGame, 1
    call UpdateLeaderboard
    call SaveLeaderboard
    call clrscr
     
    call DisplayGameWon

    ret

Menu ENDP

SelectTaxi PROC
    push eax
    
    mov dl, 15
    mov dh, 10
    call Gotoxy
    mov edx, offset taxiSelectionMsg
    call WriteString
    
TaxiInputLoop:
    call ReadChar
    call WriteChar
    cmp al, '1'
    je SelectedYellow
   
    jmp SelectedRed
   
SelectedYellow:
    mov taxiColor, 0              ;0 = Yellow taxi
    jmp TaxiDone
    
SelectedRed:
    mov taxiColor, 1              ;1 = Red taxi
    
TaxiDone:
    pop eax
    ret
SelectTaxi ENDP

GetPlayerName PROC
    push eax
    push ecx
    push edx
    
    call crlf
    mov edx, offset namePrompt
    call WriteString
    mov edx, offset playerName
    mov ecx, 49
    call ReadString
    
    pop edx
    pop ecx
    pop eax
    ret
GetPlayerName ENDP

GetLevel PROC
    mov edx, offset showLevels
    call WriteString
    call ReadChar
    call WriteChar

    cmp al, 'E'
    je original

    cmp al, 'M'
    je double
    
    cmp al, 'H'
    jne original                ; easy by default
  
    ;quardouple the penalties
    mov redObstacleP, 8
    mov redCarP, 12
        ;yellow
    mov yellowObstacleP, 16
    mov yellowCarP, 8
    ret 

double:
    ;double the penalties
    ;red
    mov redObstacleP, 4
    mov redCarP, 6
    ;yellow
    mov yellowObstacleP, 8
    mov yellowCarP, 4
    ret

original: 
    mov redObstacleP, 2
    mov redCarP, 3
    mov yellowObstacleP, 4
    mov yellowCarP, 2
    ret
GetLevel Endp

GetMode PROC
    mov edx, offset showModes
    call WriteString
    call ReadChar
    call Writechar

    cmp al, 'a'
    je CareerM
    cmp al, 'b'
    je timeM
    ; ENDLESS mode keep on passengers genaeration
    mov isEndless, 1                                ; by default endless mode
    ret

timeM:
    mov istime,1

    ;timer for time mode
        call GetMSeconds              ;current time in milliseconds(returns in eax)
        mov startTime, eax
        mov timeRemaining, 120        ;2 minutes
        ret

CareerM:
    mov isCareer, 1
    ret
GetMode Endp

UpdateTimeRemaining PROC
    push eax
    push ebx
    push edx

    cmp isPause, 1
    je TimeUpdateDone             ;if paused, dont update time      
    
    call GetMSeconds              ;Current time
    mov ebx, startTime
    sub eax, ebx                  ;elapsed=current-start

    sub eax, totalPausedTime 
    
    ;converts milliseconds to seconds
    mov ebx, 1000
    mov edx, 0                     ; edx : remain         
    div ebx                        ; quotient in eax 
    
    mov ebx, timeLimit
    sub ebx, eax                  ; EBX= remaining time = eax
    mov timeRemaining, ebx
    
    ; Check if time is up
    cmp ebx, 0
    jg TimeUpdateDone
    mov gotout, 1                 ; Trigger game over when time runs-out
    mov timeRanOut, 1

TimeUpdateDone:
    pop edx
    pop ebx
    pop eax
    ret
UpdateTimeRemaining ENDP

InitializeGame PROC
    mov score, 0
    mov gotout, 0
    mov passengerNo, 0
    mov hasPassenger, 0
    mov destinationActive, 0
    mov destinationPos, -1
    mov isPause, 0

    mov isCareer, 0
    mov istime, 0
    mov isEndless, 0

    mov timeRemaining, 0
    mov startTime, 0
    mov timeRanOut, 0
    mov negScore, 0

    call FillGrid
    ret
InitializeGame ENDP

LoadLeaderboard PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov edi, 0
ClearScores:
    cmp edi, 10
    jge StartLoad
    mov ebx, edi
    shl ebx, 2
    mov leaderboardScores[ebx], 0
    
    mov eax, edi
    mov ebx, 30
    mul ebx
    mov ebx, OFFSET leaderboardNames
    add ebx, eax
    mov ecx, 30               ; Clear ALL 30 bytes
ClearNameBytes:
    mov byte ptr [ebx], 0
    inc ebx
    loop ClearNameBytes
    
    inc edi
    jmp ClearScores

StartLoad:
    mov edx, OFFSET filename
    call OpenInputFile
    mov fileHandle, eax

    cmp eax, INVALID_HANDLE_VALUE
    je LoadDone

    mov eax, fileHandle
    mov edx, OFFSET buffer
    mov ecx, 500
    call ReadFromFile
    push eax                    ; Save bytes read

    mov eax, fileHandle
    call CloseFile

    pop ecx                     ; ECX = bytes read = eax

    cmp ecx, 0
    je LoadDone

    mov buffer[ecx], 0

    mov esi, OFFSET buffer
    mov edi, 0

ParseNextEntry:
    cmp edi, 10
    jge LoadDone

    mov al, [esi]
    cmp al, 0
    je LoadDone

    cmp al, 13
    je SkipEmptyLine
    cmp al, 10
    je SkipEmptyLine

    ; leaderboardNames + (edi*30)       - every naem 30 character
    push eax
    mov eax, edi
    mov ebx, 30
    mul ebx
    mov ebx, OFFSET leaderboardNames
    add ebx, eax
    pop eax                             ;EBX the destination for name

CopyNameChar:
    mov al, [esi]
    cmp al, ','
    je NameDone
    cmp al, 0
    je ParseError
    cmp al, 13
    je ParseError
    cmp al, 10
    je ParseError
    
    mov [ebx], al
    inc esi
    inc ebx
    jmp CopyNameChar

NameDone:
    mov byte ptr [ebx], 0
    inc esi

    mov eax, 0                ; Score = 0
ParseScoreDigit:
    mov bl, [esi]
    cmp bl, '0'
    jb ScoreDone
    cmp bl, '9'
    ja ScoreDone

    ;score * 10 + digit
    push edx
    mov ecx, 10
    mul ecx
    sub bl, '0'
    movzx ecx, bl
    add eax, ecx
    pop edx
    inc esi
    jmp ParseScoreDigit

ScoreDone:
    push ebx
    mov ebx, edi
    shl ebx, 2
    mov leaderboardScores[ebx], eax
    pop ebx

SkipToNextLine:
    mov al, [esi]
    cmp al, 0
    je NextEntry
    cmp al, 13
    je FoundCR
    cmp al, 10
    je FoundLF
    inc esi
    jmp SkipToNextLine

FoundCR:
    inc esi
    mov al, [esi]
    cmp al, 10
    jne NextEntry
    inc esi
    jmp NextEntry

FoundLF:
    inc esi
    jmp NextEntry

SkipEmptyLine:
    inc esi
    jmp ParseNextEntry

ParseError:
    jmp SkipToNextLine

NextEntry:
    inc edi
    jmp ParseNextEntry

LoadDone:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
LoadLeaderboard ENDP

SaveLeaderboard PROC
    push eax
    push edx
    push ecx
    push esi
    push edi
    push ebx

    mov edx, OFFSET filename
    call CreateOutputFile
    mov fileHandle, eax
    cmp eax, INVALID_HANDLE_VALUE
    je SaveDone

    mov esi, 0                  ;index
    mov edi, OFFSET buffer

WriteEntryLoop:
    cmp esi, 10
    jge DoneFormatting

    ; Check if score exists
    mov ebx, esi
    shl ebx, 2
    mov eax, leaderboardScores[ebx]
    cmp eax, 0
    je NextEntry

    push eax                    ; Save score

    ;Copy name to buffer
    push eax
    mov eax, esi
    mov ebx, 30
    mul ebx
    mov ebx, OFFSET leaderboardNames
    add ebx, eax
    pop eax                                     ; EBX = source name

CopyName:
    mov al, [ebx]
    cmp al, 0
    je NameCopied
    mov [edi], al
    inc ebx
    inc edi
    jmp CopyName

NameCopied:
    mov byte ptr [edi], ','                     ; Adding comma
    inc edi

    pop eax                                     ; Restore score

    push esi
    
    cmp eax, 0                                  ; Handles zero score
    jne CountDigits
    mov byte ptr [edi], '0'
    inc edi
    jmp AddNewline

CountDigits:
    mov ebx, 10
    mov esi, 0      ; Digit counter
    push eax        ; original score

CountLoop:
    xor edx, edx
    div ebx
    inc esi
    cmp eax, 0
    jne CountLoop

    pop eax                         ; Restore score
    mov ecx, esi                    ; ECX = digit count

ConvertLoop:
    xor edx, edx
    div ebx
    push edx                         ;Saving remainder (digit)
    dec ecx
    cmp ecx, 0
    jne ConvertLoop

    mov ecx, esi
WriteDigits:
    pop eax
    add al, '0'
    mov [edi], al
    inc edi
    dec ecx
    cmp ecx, 0
    jne WriteDigits

AddNewline:
    pop esi

    ;newline (CR LF)
    mov byte ptr [edi], 13
    inc edi
    mov byte ptr [edi], 10
    inc edi

NextEntry:
    inc esi
    jmp WriteEntryLoop

DoneFormatting:
    mov ecx, edi
    sub ecx, OFFSET buffer
    cmp ecx, 0
    je CloseFileOnly

    mov eax, fileHandle
    mov edx, OFFSET buffer
    call WriteToFile

CloseFileOnly:
    mov eax, fileHandle
    call CloseFile

SaveDone:
    pop ebx
    pop edi
    pop esi
    pop ecx
    pop edx
    pop eax
    ret
SaveLeaderboard ENDP

UpdateLeaderboard PROC
    push eax
    push ebx
    push ecx
    push esi
    push edi
    
    ;Finding insert pos
    mov esi, 0
    
FindPositionLoop:
    cmp esi, 10
    jge UpdateDone
    
    mov ebx, esi
    shl ebx, 2
    mov eax, leaderboardScores[ebx]
    
    mov ecx, score
    cmp ecx, eax
    jg InsertAtPosition
    
    inc esi
    jmp FindPositionLoop
    
InsertAtPosition:
    mov edi, 9
    
ShiftLoop:
    cmp edi, esi
    jle ShiftDone
    
    mov ebx, edi
    dec ebx
    shl ebx, 2                                      ; multiplying by 4
    mov eax, leaderboardScores[ebx]
    
    mov ebx, edi
    shl ebx, 2
    mov leaderboardScores[ebx], eax
    
    push esi
    push edi
    push ecx
    
                ; Calculating source: (edi-1) * 30
    mov eax, edi
    dec eax
    mov ebx, 30
    mul ebx
    mov ebx, OFFSET leaderboardNames
    add ebx, eax
    mov esi, ebx
    
            ;------  Calculating position: edi * 30
    mov eax, edi        
    mov ebx, 30
    mul ebx
    mov ebx, OFFSET leaderboardNames
    add ebx, eax
    mov edi, ebx
    
    ; copying name
    mov ecx, 30
CopyLoop:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    cmp ecx, 0
    jne CopyLoop
    
    pop ecx
    pop edi
    pop esi
    
    dec edi
    jmp ShiftLoop
    
ShiftDone:
    ; Inserting new score at position esi
    mov ebx, esi
    shl ebx, 2
    mov eax, score
    mov leaderboardScores[ebx], eax
    
    ; Inserting new name
    mov eax, esi
    mov ebx, 30
    mul ebx
    mov ebx, OFFSET leaderboardNames
    add ebx, eax
    mov edi, ebx
    
    mov esi, OFFSET playerName
    mov ecx, 30
    
CopyNewName:
    mov al, [esi]
    mov [edi], al
    cmp al, 0
    je UpdateDone
    inc esi
    inc edi
    dec ecx
    cmp ecx, 0
    jne CopyNewName
    
UpdateDone:
    pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
UpdateLeaderboard ENDP

DisplayLeaderboard PROC
    push eax
    push edx
    push ecx
    push esi
    push ebx

    mov eax, cyan + (black * 16)
    call SetTextColor
    
    mov dl, 15
    mov dh, 3
    call Gotoxy
    mov edx, offset leaderboardTitle1
    call WriteString

    mov dl, 15
    mov dh, 4
    call Gotoxy
    mov edx, offset leaderboardTitle2
    call WriteString

    mov dl, 15
    mov dh, 5
    call Gotoxy
    mov edx, offset leaderboardTitle3
    call WriteString
    
    ; Check if leaderboard is empty
    mov eax, leaderboardScores[0]
    cmp eax, 0
    jne ShowScores
    
    mov dl, 20
    mov dh, 5
    call Gotoxy
    mov edx, offset leaderboardEmpty
    call WriteString
    jmp LeaderboardDisplayDone
    mov dl, 15
ShowScores:
    mov ecx, 10                   ;Max entries
    mov esi, 0                    ; Current index
    mov dh, 7                     ;Starting Y position
    
DisplayLoop:
    mov ebx, esi
    shl ebx, 2
    mov eax, leaderboardScores[ebx]
    cmp eax, 0                    ; Check if score exists
    je LeaderboardDisplayDone     ; No more scores
    
    push ecx
    
    ; Position cursor
    mov dl, 15
    call Gotoxy
    
    ; rank number
    mov eax, esi
    inc eax
    call WriteDec
    mov al, '.'
    call WriteChar
    mov al, ' '
    call WriteChar
    
    ; player name from leaderboardNames array
    push esi
    mov eax, esi
    mov ebx, 30
    mul ebx                       ; Calculates offset in names array
    mov edx, OFFSET leaderboardNames
    add edx, eax
    call WriteString
    pop esi
    
    ; Display score
    mov al, ' '
    call WriteChar
    mov al, '-'
    call WriteChar
    mov al, ' '
    call WriteChar
    
    mov ebx, esi
    shl ebx, 2
    mov eax, leaderboardScores[ebx]
    call WriteDec
    
    inc dh
    inc esi
    
    pop ecx
    dec ecx
    cmp ecx, 0
    jne DisplayLoop
    
LeaderboardDisplayDone:
    mov dl, 20
    mov dh, 20
    call Gotoxy
    mov edx, offset pressKey
    call WriteString
    
    mov eax, white + (black * 16)
    call SetTextColor
    
    pop ebx
    pop esi
    pop ecx
    pop edx
    pop eax
    ret
DisplayLeaderboard ENDP

DisplayGameWon PROC
    mov eax, green + (black * 16)
    call SetTextColor
    
    mov dl, 20
    mov dh, 8
    call Gotoxy
    mov edx, offset gameWonMsg
    call WriteString
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    mov dl, 20
    mov dh, 14
    call Gotoxy
    mov edx, offset finalScoreMsg
    call WriteString
    mov eax, score
    call WriteDec
    
    mov dl, 20
    mov dh, 15
    call Gotoxy
    mov edx, offset pressKey
    call WriteString
    call ReadChar

    ret
DisplayGameWon Endp

DisplayGameOver PROC
    call clrscr

    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 40
    mov dh, 7
    call Gotoxy
    mov edx, offset gameOverMsg
    call WriteString
    
    cmp negScore, 1
    je NegativeScoreGameOver
    ; Check if game over due to time running out
    cmp istime, 1
    jne NormalGameOver
    cmp timeRanOut, 1
    jne NormalGameOver
    
    ; Time ran out message
    mov dl, 40
    mov dh, 12
    call Gotoxy
    mov edx, offset timeUpMsg
    call WriteString
    jmp ShowScoreDisplay

NegativeScoreGameOver:
    mov dl, 0
    mov dh, 12
    call Gotoxy
    mov edx, offset negativeScoreMsg
    call WriteString
    jmp Bye

NormalGameOver:

    ShowScoreDisplay:                                           ; Score and passengers delivered
        ; Display final score in yellow
        mov eax, yellow + (black * 16)
        call SetTextColor
        mov dl, 20
        mov dh, 14
        call Gotoxy
        mov edx, offset finalScoreMsg
        call WriteString
        mov eax, score
        call WriteInt
    
        ; Display passengers delivered
        mov dl, 20
        mov dh, 15
        call Gotoxy
        mov edx, offset deliveredMsg
        call WriteString
        mov eax, passengerNo
        call WriteDec
Bye:    
    ; Display "press key" message
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 20
    mov dh, 20
    call Gotoxy
    mov edx, offset pressKey
    call WriteString
    
    call ReadChar
    ret

DisplayGameOver ENDP

FillGrid PROC
    mov grid[0], 254       ;car at position 0
    mov carPosition, 0     ;car position variable

    mov ecx, 100            ; 25 perecnt buildings may be reduced
PlaceBuildings:
    call GetRandomRoadPosition
    mov grid[eax], 178
    push eax
    push ebx
    
    ; Check above
    mov ebx, eax
    sub ebx, 20                   ; Position above
    cmp ebx, 0                    ; Don't clear position 0 (car position)
    ;je CheckDown
    jle CheckDown                  ; Out of bounds
    mov grid[ebx], '.'
    
CheckDown:
    ; Check below
    mov ebx, eax
    add ebx, 20
    cmp ebx, 0
    je CheckLeft                  ;Already at left          
    cmp ebx, 399
    jg CheckLeft                  ;Out of bounds
    mov grid[ebx], '.'
    
CheckLeft:
    ; Check left
    mov ebx, eax
    dec ebx
    cmp ebx, 0
    ;je CheckRight
    jle CheckRight
    mov grid[ebx], '.'
    
CheckRight:
    ; Check right
    mov ebx, eax
    inc ebx
    cmp ebx, 0
    je DoneAdjacent
    cmp ebx, 399
    jg DoneAdjacent
    mov grid[ebx], '.'

DoneAdjacent:
    pop ebx
    pop eax
    loop PlaceBuildings
    
    mov ecx, 4
placeCar:
    call GetRandomRoadPosition
    mov grid[eax], 254
    loop placeCar
    
    mov ecx, 5
placePassenger:
    call GetRandomRoadPosition
    mov grid[eax], 'P'
    loop placePassenger

    mov ecx, 7

placeTrees:
    call GetRandomRoadPosition    ; Already avoids 0,1,20
    mov grid[eax], 234            ; Tree character (ASCII 234)
    loop placeTrees

    mov ecx, 7
placeHurdles:
    call GetRandomRoadPosition    ; Already avoids 0,1,20
    mov grid[eax], 'X'
    loop placeHurdles

    push eax
    mov eax, 11
    call RandomRange
    mov ecx, eax
    pop eax

placeBonus:
    call GetRandomRoadPosition
    mov grid[eax], 'B'
    loop placeBonus
    
    push eax
    mov eax, 8
    call RandomRange
    mov ecx, eax
    pop eax

placeNeg:
    call GetRandomRoadPosition
    mov grid[eax],'!'
    loop placeNeg
    ret
FillGrid ENDP

GetRandomRoadPosition PROC
TryAgain:
    mov eax, 399
    call RandomRange
    
    cmp grid[eax], '.'
    jne TryAgain
    
    ;Check RIGHT side (carPosition + 1)
    mov ebx, carPosition
    inc ebx
    mov edx, carPosition
    and edx, 19              ;position % 20
    cmp edx, 19
    je SkipRight                ;boundary
    cmp ebx, eax
    je TryAgain

SkipRight:
    mov ebx, carPosition
    dec ebx
    mov edx, carPosition
    and edx, 19              ;position % 20
    cmp edx, 0           ;leftmost column
    je SkipLeft
    cmp ebx, eax
    je TryAgain

SkipLeft:
    mov ebx, carPosition
    add ebx, 20
    cmp ebx, 399             ;within bounds or not
    ja SkipDown
    cmp ebx, eax
    je TryAgain

SkipDown:
    mov ebx, carPosition
    sub ebx, 20
    cmp ebx, 0
    jl SkipUp
    cmp ebx, eax
    je TryAgain
SkipUp:
    ret
GetRandomRoadPosition ENDP

DisplayGrid PROC
    push eax
    push ecx
    push edx
    
    ; Set border color to green
    mov eax, Green
    call SetTextColor
    
    ; Draw top border (horizontal line)
    mov dl, 29
    mov dh, 5
    mov ecx, 41
L1:
    call Gotoxy
    mov al, '-'
    call WriteChar
    inc dl
    loop L1
    
    ; Draw left border (vertical line)
    mov dl, 29
    mov dh, 6
    mov ecx, 20
L2:
    call Gotoxy
    mov al, '|'
    call WriteChar
    inc dh
    loop L2
    
    ; Draw right border (vertical line)
    mov dl, 69
    mov dh, 6
    mov ecx, 20
L3:
    call Gotoxy
    mov al, '|'
    call WriteChar
    inc dh
    loop L3
    
    ; Draw bottom border (horizontal line)
    mov dl, 29
    mov dh, 26
    mov ecx, 41
L4:
    call Gotoxy
    mov al, '-'
    call WriteChar
    inc dl
    loop L4
    
    ; Draw grid divider lines (Gray vertical lines)
    mov eax, Gray
    call SetTextColor
    
    mov dl, 31                    ; Starting X position
    mov ecx, 19                   ; Number of vertical lines
    
outer:
    push ecx
    mov dh, 6                     ; Starting Y position
    mov ecx, 20                   ; Height of each line
    
inner:
    call Gotoxy
    mov al, '|'
    call WriteChar
    inc dh
    loop inner
    
    add dl, 2                     ; Move to next column
    pop ecx
    loop outer
    
    ; Render game objects (grid contents)
    mov esi, 0                    ; Grid index
    mov dh, 6                     ; Starting Y position
    mov ecx, 20                   ; 20 rows
    
DisplayGridRows:
    push ecx
    mov dl, 30                    ; Starting X position
    mov ecx, 20                   ; 20 columns
    
DisplayGridCols:
    push ecx
    call Gotoxy
    
    ; Load character from grid
    mov al, grid[esi]
    
    ; Determine color based on object type
    cmp al, 178
    je IsBuilding
    cmp al, 234
    je IsTree
    cmp al, 'P'
    je IsPassenger
    cmp al, 'D'
    je IsDestination
    cmp al, 'X'
    je IsHurdle
    cmp al, '!'
    je IsNeg
    cmp al, 254
    je c2
    cmp al, 'B'
    je IsBonus
    c2:
        mov ecx, carPosition
        cmp ecx, esi
        je IsCar
    cmp al, 254
    je IsNPCCar
    
    mov eax, black + (black * 16)
    jmp DisplayChar
    
IsBuilding:
    mov eax, Gray + (black * 16)
    jmp DisplayChar
    
IsTree:
    mov eax, LightGreen + (black * 16)
    jmp DisplayChar
    
IsPassenger:
    mov eax, blue + (black * 16)
    jmp DisplayChar
    
IsDestination:
    mov eax, green + (green * 16)
    jmp DisplayChar
    
IsHurdle:
    mov eax, lightRed + (Black * 16)
    jmp DisplayChar

IsBonus:
    mov eax, LightBlue + (LightBlue * 16)
    jmp DisplayChar

IsNeg:
    mov eax, lightGray  + (lightGray *16)
    jmp DisplayChar

IsNPCCar:
    mov eax, Magenta + (black*16)
    jmp DisplayChar
IsCar:
    ;Use selected taxi color (yellow or red)
    cmp taxiColor, 0
    je YellowCar
    jne RedCar

RedCar:
    mov eax, red + (black * 16)
    jmp DisplayChar
    
YellowCar:
    mov eax, yellow + (black * 16)
    
DisplayChar:
    call SetTextColor
    mov al, grid[esi]
    call WriteChar
    
    pop ecx

    add dl, 2                     ; Move to next column
    inc esi                       ; Next grid position
    dec ecx
    cmp ecx, 0
    jne DisplayGridCols
    
    pop ecx
    inc dh                        ; Move to next row
    dec ecx
    cmp ecx, 0
    jne DisplayGridRows
    
    pop edx
    pop ecx
    pop eax
    ret
DisplayGrid ENDP

HandleInput PROC    
    call ReadKey
    cmp al, 'P'
    je CheckP
    cmp isPause, 0
    je CheckSpace

    ; is paused
    Push edx
    mov dl, 40
    mov dh, 12
    call Gotoxy
    mov edx, Offset pausemsg
    call WriteString
    pop edx
    ret

    ;Check for spacebar (pickup/drop passenger)
CheckSpace:
    cmp al, ' '
    jne CheckW
    call PickupDropPassenger
    ret
CheckW:
    ; Check for 'w' key (move up)
    cmp al, 'w'
    jne CheckS
    call MoveUp
    ret
    
CheckS:
    ; Check for 's' key (move down)
    cmp al, 's'
    jne CheckA
    call MoveDown
    ret
    
CheckA:
    ; Check for 'a' key (move left)
    cmp al, 'a'
    jne CheckD
    call MoveLeft
    ret
    
CheckD:
    ; Check for 'd' key (move right)
    cmp al, 'd'
    jne CheckP
    call MoveRight
    ret

CheckP:
    cmp isTime, 1
    jne NoInput
    cmp al, 'P'
    jne NoInput
    cmp isPause, 0                                  ; unpaused
    je Pause1
    
    call GetMSeconds
    mov ebx, pauseStartTime
    sub eax, ebx                  ; EAX = time spent in this pause
    add totalPausedTime, eax      ; Add to cumulative paused time
    
    mov isPause, 0                ; Set to unpaused

    call clrscr
    call DisplayGrid
    ret
    
    Pause1:
    call GetMSeconds
    mov pauseStartTime, eax 
    mov isPause, 1

NoInput:
    ret
HandleInput ENDP

PickupDropPassenger PROC
    mov eax, carPosition
    movzx ebx, byte ptr grid[eax]
    
    ; Check if taxi has passenger
    cmp hasPassenger, 0
    je DoPickup
    
    call DropPassengerLogic
    jmp PDPDone
    
DoPickup:
    call PickupPassengerLogic
    
PDPDone:
    call DisplayGrid              ; Redraw grid
    ret
PickupDropPassenger ENDP

PickupPassengerLogic PROC
    mov eax, carPosition
    movzx ebx, byte ptr grid[eax]
    
    ;check if passenger is on current tile
    cmp bl, 'P'
    jne CheckAboveP
    mov grid[eax], '.'

    ;penalty for hitting passenger
    mov ebx, score
    sub ebx, 5
    mov score, ebx
    jmp DoPickupSuccess
    
CheckAboveP:
    push eax
    mov eax, carPosition
    sub eax, 20
    
    cmp eax, 0
    jl CheckBelowP
   
   cmp grid[eax], 'P'
    jne CheckBelowP
    
    mov grid[eax], '.'
    pop eax
    jmp DoPickupSuccess
    
CheckBelowP:
    mov eax, carPosition
    add eax, 20
    ;Out of bounds
    cmp eax, 399
    jg CheckLeftP
    
    cmp grid[eax], 'P'
    jne CheckLeftP
    mov grid[eax], '.'
    pop eax
    jmp DoPickupSuccess
    
CheckLeftP:
    mov eax, carPosition
    dec eax
    cmp eax, 0
    jl CheckRightP
    cmp grid[eax], 'P'
    jne CheckRightP
    mov grid[eax], '.'
    pop eax
    jmp DoPickupSuccess
    
CheckRightP:
    mov eax, carPosition
    inc eax
    cmp eax, 399
    jg NoPickupFound
    cmp grid[eax], 'P'
    jne NoPickupFound
    mov grid[eax], '.'
    pop eax
    jmp DoPickupSuccess
    
NoPickupFound:
    pop eax
    ret
    
DoPickupSuccess:
    ; Passenger picked up successfully
    mov hasPassenger, 1           ; Set passenger flag
    
    ; Clear old destination if exists
    cmp destinationActive, 1
    jne SkipClearOld
    push eax
    mov eax, destinationPos
    cmp grid[eax], 'D'
    jne SkipClearOld2
    mov grid[eax], '.'            ; Remove old destination
SkipClearOld2:
    pop eax
    
SkipClearOld:
    ; Generate new destination for this passenger
    call GenerateDestination
    mov destinationActive, 1      ; Mark destination as active
    ret
PickupPassengerLogic ENDP

DropPassengerLogic PROC
    ;Check if destination exists
    cmp destinationActive, 0
    jne CheckDropLoc
    ret
    
CheckDropLoc:
    mov eax, carPosition
    mov ebx, destinationPos
    cmp eax, ebx
    je DoDropSuccess
    
    ; Check adjacent tiles
    push eax
    
    ; Check above
    mov eax, carPosition
    sub eax, 20
    cmp eax, ebx
    je FoundDropSpot
    
    ; Check below
    mov eax, carPosition
    add eax, 20
    cmp eax, ebx
    je FoundDropSpot
    
    ; Check left
    mov eax, carPosition
    dec eax
    cmp eax, ebx
    je FoundDropSpot
    
    ; Check right
    mov eax, carPosition
    inc eax
    cmp eax, ebx
    je FoundDropSpot
    
    ; Not at destination
    pop eax
    ret
    
FoundDropSpot:
    pop eax
    
DoDropSuccess:
    ; Drop passenger successfully
    mov hasPassenger, 0           ; Clear passenger flag
    
    ; Remove destination from grid
    mov eax, destinationPos
    mov grid[eax], '.'
    mov destinationPos, -1
    mov destinationActive, 0
    
    ; Award points
    mov eax, score
    add eax, 10                   ; +10 points for successful delivery
    mov score, eax
    
    ; Increment delivery counter
    mov eax, passengerNo
    inc eax
    mov passengerNo, eax
    
    cmp isEndless, 1
    jne SkipSpawn
    call GetRandomRoadPosition
    mov grid[eax], 'P'
SkipSpawn:
    ret
DropPassengerLogic ENDP

MoveUp PROC

    mov ebx, carPosition
    mov eax, ebx
    sub eax, 20
    cmp eax, 0
    jl E
    
    call CanMoveToPosition
    jnc NoMoveUp
    
    mov carPosition, ebx
    call UpdateCarPosition
    call DisplayGrid
    jmp E
    
NoMoveUp:
    call DisplayGrid
E:
    ret
MoveUp ENDP

MoveDown PROC
    mov ebx, carPosition
    mov eax, ebx
    add eax, 20
    cmp eax, 399
    jg E

    call CanMoveToPosition
    jnc NoMoveDown

    mov carPosition, ebx
    call UpdateCarPosition
    call DisplayGrid
    jmp E
    
NoMoveDown:
    call DisplayGrid
E:
    ret
MoveDown ENDP

MoveLeft PROC
    mov eax, carPosition
    mov ebx, eax
   
;boundary check
    push edx
    mov edx, 0
    push ecx
    mov ecx, 20
    div ecx             ;EAX = row, EDX = column
    cmp edx, 0
    pop ecx
    pop edx
    je E             ; already at left,can't move

    mov eax, ebx
    dec eax
    call CanMoveToPosition
    jnc NoMoveLeft

    mov carPosition, ebx
    call UpdateCarPosition
    call DisplayGrid
    jmp E
    
NoMoveLeft:
    ; Obstacle was hit - penalty already applied in CanMoveToPosition
    call DisplayGrid
    
E:
    ret
MoveLeft ENDP

MoveRight PROC
    mov eax, carPosition
    mov ebx, eax

    push edx
    mov edx, 0
    push ecx
    mov ecx, 20
    div ecx                ;EAX = row, EDX = column
    cmp edx, 19             ;19th column, rightmpst
    pop ecx
    pop edx
    je E
    
    mov eax, ebx
    inc eax
    call CanMoveToPosition
    jnc NoMoveRight

    mov carPosition, ebx
    call UpdateCarPosition
    call DisplayGrid
    jmp E
    
NoMoveRight:
    call DisplayGrid
    
E:
    ret
MoveRight ENDP

GenerateDestination PROC
    push eax
    push ebx
    push esi
    
GenerateLoop:
    mov eax, 400
    call RandomRange
    cmp grid[eax], '.'
    jne GenerateLoop
    
    ; destination can't be carPosition, Passenger position, hurdle 'X',  tree
    
    mov destinationPos, eax
    mov grid[eax], 'D'            ; Place destination marker
    
    pop esi
    pop ebx
    pop eax
    ret
GenerateDestination ENDP

CanMoveToPosition PROC
    push eax
    
    cmp grid[eax], 178            ; Building
    je HitDanger                ; OUT
    
    cmp grid[eax], 254            ;Npc car
    je HitCar

    cmp grid[eax], 234            ; Tree is obstacle
    je HitObstacle
    cmp grid[eax], 'X'
    je HitObstacle

    cmp grid[eax], '!'            ; Nega marking
    je HitNeg

    cmp grid[eax], 'P'
    je HitPassenger

    cmp grid[eax], 'B'
    je Bonus

    cmp grid[eax], 'D'
    je HitDestination
    
    pop eax
    stc                           ;carry flag set (success)
    ret

HitNeg:
    mov eax, 10
    call RandomRange
    sub score, eax

    pop eax
    stc
    ret
Bonus:
    mov eax, 20
    call RandomRange
    add eax, 1
    add score, eax

    pop eax
    stc
    ret

HitDestination:
    pop eax
    stc
    ret

HitDanger:
    mov gotout, 1
    pop eax
    clc
    ret

HitPassenger:
    mov eax, score
    sub eax, 5
    mov score, eax
    pop eax
    clc
    ret

HitObstacle:
    cmp taxiColor, 0              ; 0 = Yellow taxi
    je YellowObstaclePenalty
    
    ;Red taxi penalty
    mov eax, score
    sub eax, redObstacleP
    mov score, eax
    jmp ObstacleDone
    
YellowObstaclePenalty:
    ; Yellow taxi penalty (-4)
    mov eax, score
    sub eax, yellowObstacleP
    mov score, eax
    
ObstacleDone:
    pop eax
    clc
    ret

HitCar:   
    cmp taxiColor, 0              ; 0 = Yellow taxi
    je YellowCarPenalty
    
    ;Red taxi penalty (-3)
    mov eax, score
    sub eax, redCarP
    mov score, eax
    jmp CarDone
    
YellowCarPenalty:
    ; Yellow taxi penalty (-2)
    mov eax, score
    sub eax, yellowCarP
;    movzx eax,eax
    mov score, eax
    
CarDone:
    pop eax
    clc            
    ret

CanMoveToPosition ENDP

UpdateCarPosition PROC
    push eax
    push ebx
    push esi

    mov esi, CarPosition
    
    cmp destinationActive, 0
    je placeRoad

    mov ebx, destinationPos
    cmp esi, ebx
    jne placeRoad
    
    mov grid[esi], 'D'
    jmp PlaceNewCar

placeRoad:
    mov grid[esi], '.'
    
PlaceNewCar:
    mov esi, eax                                        ; new car position in eax
    mov grid[esi], 254
    mov carPosition, esi
    
    pop esi
    pop ebx
    pop eax
    ret
UpdateCarPosition ENDP

END main