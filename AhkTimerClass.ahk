; Script     AhkTimerClass.ahk
; License:   MIT License
; Author:    Bence Markiel (bceenaeiklmr)
; Github:    https://github.com/bceenaeiklmr/AhkTimerClass
; Date       20.05.2024
; Version    0.2.1
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
        start := this.qpc / this.qpf
        waited := 0
        while waited <= ms
            waited := (this.qpc / this.qpf - start) * 1000
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
                elapsed := (recent - previous) / this.qpf * 1000
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
                this.total += elapsed := (recent - previous) / this.qpf * 1000
                (elapsed < this.min) ? this.min := elapsed : ''
                (elapsed > this.max) ? this.max := elapsed : ''
                name := counter[2] ? counter[2] : A_Index - 1
                str .= name '`t' Format('{:.2f}', elapsed) '`t' Format('{:.2f}', 1000 / elapsed) '`t' ranks[A_Index - 1] '`n'
            }
        }

        return SubStr(
            '∑'   '`t' Format('{:.2f}', this.total)     '`t' 'ms' '`n' .
            'avg' '`t' Format('{:.2f}', this.total / n) '`t' 'ms' '`n' .
            'min' '`t' Format('{:.2f}', this.min)       '`t' 'ms' '`n' .
            'max' '`t' Format('{:.2f}', this.max)       '`t' 'ms' '`n' .
            'fps' '`t' Format('{:.2f}', 1000 / this.total)        '`n' .
            'n'   '`t' n '`n`n' str, 1, -1)
    }

    ;properties
    static qpc => (DllCall('QueryPerformanceCounter', 'Int64*', &qpc := 0), qpc)
    static qpf => (DllCall('QueryPerformanceFrequency', 'Int64*', &qpf := 0), qpf)

    ; Reinitializes, resets the Timer object.
    __New() => Timer.__New()
    static __New() => this.reset()
}
