# @Consolable

> *(macro)*  
> con·sol·a·ble — 1) able to be comforted; 2) able to log to the Console 😉

`Consolable` is a tiny [Swift Macro](https://developer.apple.com/documentation/swift/applying-macros) that injects a `Logger` and convenience log functions backed by [OSLog](https://developer.apple.com/documentation/oslog).

## Features
- Per-type Logger with type-aware subsystem and category
- Optional prefix prepended to every message for that type
- Two helpers: `log(_: isError:)` for instance and static contexts
- Defaults to .info, uses .error when isError = true
- No file/line/function noise (`OSLog` includes that automatically)

### Compatibility
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsuperturboryan%2FConsolable%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/superturboryan/Consolable) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsuperturboryan%2FConsolable%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/superturboryan/Consolable)  
Compatible with all Apple platforms.

## Installation

Add `Consolable` via the [Swift Package Manager](https://developer.apple.com/documentation/xcode/swift-packages) 📦
- Xcode → File → Add Package Dependencies
- Enter: https://github.com/superturboryan/Consolable
- Add the Consolable library to your project target

Find out more about `Consolable` on the [Swift Package Index](https://swiftpackageindex.com/superturboryan/Consolable) 📋

## How to use

Annotate your types with `@Consolable` and call `log(_:, isError:)`

```swift
import Consolable

let prefix = "💆"

@Consolable(prefix) // Optional: set a per-type prefix
struct ThingThatNeedsLogging {

    func instanceMethod() {
        log("Something to log")
        // -> "💆 Something to log" at .info

        log("Something went wrong", isError: true)
        // -> "💆 Something went wrong" at .error
    }

    static func staticMethod() {
        log("Something else to log")
        // -> "💆 Something else to log" at .info
    }
}
```

Custom subsystem & category

```swift
@Consolable("[Network]", subsystem: "com.your.app", category: "Helpers.Network")
final class NetworkHelper {
    func fetch() {
        log("Starting request")
        log("Request failed", isError: true)
    }
}
```
