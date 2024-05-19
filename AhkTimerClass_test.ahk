; Script     AhkTimerClass_test.ahk
; License:   MIT License
; Author:    Bence Markiel (bceenaeiklmr)
; Github:    https://github.com/bceenaeiklmr/AhkTimerClass
; Date       19.05.2024
; Version    0.2

#Requires AutoHotkey >=2.0
#Warn All

#Include AhkTimerClass.ahk

; Reset the timer
;Timer.Reset
;Timer.__New()
;Timer()
Timer

Loop 3 {
    Timer.Wait(A_Index*25)
    Timer.Add(A_Index ". test")
}
; Show the results
Timer.Show()

testcases := 10000

Timer
; benchmark case 1
loop 10000
    ret := Func1()
Timer.Add("Func1")

; benchmark case 2
loop 10000
    ret := Func2()
Timer.Add("Func2")

; benchmark case 3
loop 10000
    ret := Func3()
Timer.Add("Func3")

; benchmark case 4
loop 10000
    ret := Func4()
Timer.Add("Func4")

; benchmark case 5
loop 10000
    ret := Func5()
Timer.Add("Func5")

; benchmark case 6
loop 10000
    ret := Func6()
Timer.Add("Func6")

; show results
Timer.Show("Results - classic way")

t2 := Timer.Clone()

; Alternative way to benchmark functions
Timer()
loop 6 {
    iFunc := A_Index
    loop testcases
        ret := Func%iFunc%()
    Timer.Add("  [ " iFunc " ]")
}
Timer.Show("Another way")

t2.Show("You can clone the Timer object")

; Second alternative way
Timer.Reset()
for fn in ["Func1", "Func2", "Func3", "Func4", "Func5", "Func6"] {
    loop testcases
        ret := %fn%()
    Timer.Add(fn)
}
Msgbox "Saved:" "`n`n" res := Timer.Result(), "Another #2"

; test functions

Func1() {
    static x := 0, y := 0, w := 2560, h := 1440
    return x " " y " " w " " h
}

Func2() {
    x := 0, y := 0, w := 2560, h := 1440
    return x " " y " " w " " h
}

Func3() {
    static buff := Buffer(16, 0)
    NumPut("int",    0, buff,  0)
    NumPut("int",    0, buff,  4)
    NumPut("int", 2560, buff,  8)
    NumPut("int", 1440, buff, 12)
    return NumGet(buff, 0, "int") " " NumGet(buff, 4, "int") " " NumGet(buff, 8, "int") " " NumGet(buff, 12, "int")
}

Func4() {
    static buff := Buffer(16, 0)
    NumPut("int",    0, buff,  0), NumPut("int",    0, buff,  4), NumPut("int", 2560, buff,  8), NumPut("int", 1440, buff, 12)
    return NumGet(buff, 0, "int") " " NumGet(buff, 4, "int") " " NumGet(buff, 8, "int") " " NumGet(buff, 12, "int")
}

Func5() {
    buff := Buffer(16)
    NumPut("int",    0, buff,  0)
    NumPut("int",    0, buff,  4)
    NumPut("int", 2560, buff,  8)
    NumPut("int", 1440, buff, 12)
    return NumGet(buff, 0, "int") " " NumGet(buff, 4, "int") " " NumGet(buff, 8, "int") " " NumGet(buff, 12, "int")
}

Func6() {
    buff := Buffer(16),
    NumPut("int",    0, buff,  0),
    NumPut("int",    0, buff,  4),
    NumPut("int", 2560, buff,  8),
    NumPut("int", 1440, buff, 12)
    return NumGet(buff, 0, "int") " " NumGet(buff, 4, "int") " " NumGet(buff, 8, "int") " " NumGet(buff, 12, "int")
}
