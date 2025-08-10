import Foundation

#if canImport(OSLog)
@_exported import OSLog
#endif

/// A type macro that injects a per‑type `Logger` and convenience logging functions.
///
/// Apply `@Consolable("👉")` to any class, struct, enum, or actor in your app to get a
/// private per‑type `Logger` plus two helpers:
///
/// - `private func log(_ message: String, isError: Bool = false)`
/// - `private static func log(_ message: String, isError: Bool = false)`
///
/// The macro prefixes every message with the optional `prefix` you supply and routes logs
/// to `.info` by default, or `.error` when `isError` is `true`. OSLog automatically includes
/// file, function, and line metadata—no need to duplicate it in your messages.
///
/// ### Defaults
/// - **`subsystem`**: The app's bundle identifier or `"app"` if unavailable
/// - **`category`**: the fully qualified name of the annotated type (e.g. `MyModule.MyView`)
///
/// ### Examples
/// ```swift
/// import Consolable
/// import SwiftUI
///
/// @Consolable("👇")
/// struct MainView: View {
///     var body: some View {
///         Text("Hello").task { log("appeared") }        // "👇 appeared" (.info)
///     }
/// }
///
/// @Consolable("[Network]", subsystem: "com.example.app", category: "Helpers.Network")
/// final class NetworkHelper {
///     func fetch() {
///         log("Starting request")                        // .info
///         log("Request failed", isError: true)            // .error
///     }
/// }
/// ```
///
/// ### Notes
/// - The injected members are `private` to the annotated type.
/// - The `Logger` is created as a computed static property and is inexpensive to access.
/// - You can still use `Logger` APIs elsewhere if you need advanced formatting or levels.
///
/// - Parameters:
///   - prefix: Optional string prepended to every message from this type (e.g. "👇" or "[Auth]").
///   - subsystem: Optional OSLog subsystem (defaults to the app’s bundle identifier or `"app"`).
///   - category: Optional OSLog category (defaults to the fully qualified type name).
@attached(
    member,
    names: named(log),
    named(__logger),
    named(__logCategory),
    named(__prefix),
    named(__prefixed)
)
public macro Consolable(
    _ prefix: String? = nil,
    subsystem: String? = nil,
    category: String? = nil
) = #externalMacro(
    module: "Macros",
    type: "ConsolableMacro"
)
