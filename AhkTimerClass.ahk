; Script     AhkTimerClass.ahk
; License:   MIT License
; Author:    Bence Markiel (bceenaeiklmr)
; Github:    https://github.com/bceenaeiklmr/AhkTimerClass
; Date       19.05.2024
; Version    0.2

#Requires AutoHotkey >=2.0
#SingleInstance Force
#Warn All

/** Timer class for benchmarking.
 *  
 * **Examples:**
 * * Reset the counter: `Timer.reset()`, `Timer()`, `Timer.__New()`
 * * Add a timestamp: `Timer.add()`, `Timer.add('Name')`
 * * Show the result: `Timer.show()`
 * * Precise sleep: `Timer.wait(ms)`
 * * Clone the Timer object: `obj := Timer.Clone(), obj.show()`
 */
class Timer {

    ; Records a QPC timestamp, `name` is optional, and can be used to identify the benchmark.
    static add(name := '') {
        this.counter.Push([this.qpc, name])
    }

    ; Resets the counter.
    static reset() {
        this.counter := [[this.qpc, '']]
    }

    ; Waits for the specified time in milliseconds, enables shorter sleep than `15.6` ms.
    static wait(ms) {
        start := this.qpc / this.freq
        waited := 0
        while waited <= ms
            waited := (this.qpc / this.freq - start) * 1000
        return waited
    }

    ; Displays the result in a message box.
    static show(title := 'Result') {
        MsgBox(this.result(), title)
    }

    ; Returns the ranks.
    static getRanks() {
        ranks := [], str := ''
        for v in this.counter {
            if A_Index !== 1 {
                recent := this.counter[A_Index][1]
                previous := this.counter[A_Index - 1][1]
                elapsed := (recent - previous) / this.freq * 1000
                str .= elapsed '`t' A_Index - 1 '`n'
            }
        }
        loop Parse, Sort(SubStr(str, 1, -1), 'N'), '`n'
            ranks.Push(StrSplit(StrReplace(A_LoopField, Chr(13)), '`t')[2])
        return ranks
    }

    ; Returns the test result as a string.
    static result() {

        this.min := this.counter[2][1] - this.counter[1][1]
        this.max := 0
        this.total := 0
        ranks := this.getRanks()
        n := this.counter.Length - 1        
        str := 'name' '`t' 'ms' '`t' 'fps' '`t' 'rank' '`n'

        for counter in this.counter {
            if A_Index !== 1 {
                recent := this.counter[A_Index][1]
                previous := this.counter[A_Index - 1][1]
                this.total += elapsed := (recent - previous) / this.freq * 1000
                (elapsed < this.min) ? this.min := elapsed : ''
                (elapsed > this.max) ? this.max := elapsed : ''
                name := counter[2] ? counter[2] : A_Index - 1
                str .= name '`t' Format('{:.2f}', elapsed) '`t' Format('{:.2f}', 1000 / elapsed) '`t' ranks[A_Index - 1] '`n'
            }
        }

        return SubStr(
            '∑'   '`t' Format('{:.2f}', this.total)     '`tms' '`n' .
            'avg' '`t' Format('{:.2f}', this.total / n) '`tms' '`n' .
            'min' '`t' Format('{:.2f}', this.min)       '`tms' '`n' .
            'max' '`t' Format('{:.2f}', this.max)       '`tms' '`n' .
            'fps' '`t' Format('{:.2f}', 1000 / this.total)    '`n' .
            'n'   '`t' n '`n`n' str, 1, -1)
    }

    ; Returns the current QPC timestamp.
    static qpc => (DllCall('QueryPerformanceCounter', 'Int64*', &qpc := 0), qpc)

    ; Reinitializes, resets the Timer object.
    __New() => Timer.__New()

    static __New() {
        DllCall('QueryPerformanceFrequency', 'Int64*', &freq := 0)
        this.freq := freq
        this.reset()
    }
}
