# AhkTimerClass

## Overview

The `AhkTimerClass` repository contains a `Timer` class for high-precision benchmarking in AutoHotkey scripts. It uses the `QueryPerformanceCounter` API for more accurate timing than the built-in `A_TickCount` command. The class allows you to add timestamps, reset the counter, display results.

## Youtube

[![AhkTimerClass_GH](https://github.com/bceenaeiklmr/AhkTimerClass/assets/105103590/2c6b0719-5520-40e9-8eee-279b3e2280fa)](https://www.youtube.com/watch?v=SqNZMddZQv8)

## Features

- **High-Precision Timing:** Uses `QueryPerformanceCounter` for accurate timing.
- **Record Timestamps:** Add named or unnamed timestamps.
- **Reset Counter:** Easily reset the timer counter.
- **Display Results:** Show timing results in a formatted message box.

## Installation
- Download the AhkTimerClass.ahk file from the repository.
- Include the AhkTimerClass.ahk script in your AutoHotkey project.
- Run the test file.

## Properties

- **`qpc`**: Returns the current `QueryPerformanceCounter`.
- **`qpf`**: Returns the current `QueryPerformanceFrequency`.

## Methods

- **`add(name := '')`**: Records a QPC timestamp. `name` is optional and can be used to identify the benchmark.
- **`reset()`**: Resets the counter.
- **`wait(ms)`**: Waits for the specified time in milliseconds, enabling shorter sleep than `15.6` ms.
- **`show(title := 'Result')`**: Displays the result in a message box with an optional title.
- **`getRanks()`**: Returns the ranks.
- **`result()`**: Returns the test result as a string.
- **`clone()`**: Clones the timer object.

## Typical output

```ahk
∑	46.40	ms
avg	7.73	ms
min	3.03	ms
max	12.11	ms
fps	21.55
n	6

name	ms	fps	rank
Func1	3.03	329.58	1
Func2	6.95	143.98	4
Func3	6.97	143.45	2
Func4	6.62	151.15	3
Func5	10.73	93.17	5
Func6	12.11	82.61	6
```

## Usage Examples

### Example Script

```ahk
#Requires AutoHotkey >=2.0
#SingleInstance Force
#Warn All

; reset the timer
Timer

; Simple Operation Benchmarking
loop 10000
    result := simpleOperation()
timer.add('SimpleOperation')

; Mathematical Calculation Benchmarking
loop 10000
    result := mathCalculation()
timer.add('MathCalculation')

; String Concatenation Benchmarking
loop 10000
    result := stringConcat()
timer.add('StringConcat')

; Array Manipulation Benchmarking
loop 10000
    result := arrayManipulation()
timer.add('ArrayManipulation')

timer.show()

simpleOperation() {
    return 999 + 338
}

mathCalculation() {
    x := 1337
    y := 4096
    return x * y
}

stringConcat() {
    str1 := 'Hello'
    str2 := 'World'
    return str1 A_Space str2
}

arrayManipulation() {
    arr := [1, 2, 3, 4, 5]
    arr.Push(6)
    arr.RemoveAt(1)
    return arr.Length
}
```
