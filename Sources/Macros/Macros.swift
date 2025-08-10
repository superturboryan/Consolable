import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import OSLog
import Foundation

public struct ConsolableMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf decl: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        // Defaults
        var prefixExpr = ""
        var subsystemExpr = "Foundation.Bundle.main.bundleIdentifier ?? \"app\""
        var categoryExpr  = "String(reflecting: Self.self)"
        
        // Parse: first unlabeled = prefix; labeled subsystem:/category:
        if let args = node.arguments?.as(LabeledExprListSyntax.self) {
            for (idx, arg) in args.enumerated() {
                if let label = arg.label?.text {
                    switch label {
                    case "subsystem": subsystemExpr = arg.expression.description
                    case "category":  categoryExpr  = arg.expression.description
                    default: break
                    }
                } else if idx == 0 {
                    prefixExpr = arg.expression.description
                }
            }
        }
        
        let prefixDecl: DeclSyntax = """
        private static let __prefix: String? = \(raw: prefixExpr)
        """
        
        let categoryDecl: DeclSyntax = """
        private static var __logCategory: String { \(raw: categoryExpr) }
        """
        
        let loggerDecl: DeclSyntax = """
        private static var __logger: Logger {
          Logger(
            subsystem: \(raw: subsystemExpr),
            category: __logCategory
          )
        }
        """
        
        let prefixedFn: DeclSyntax = """
        private static func __prefixed(_ message: String) -> String {
          if let p = __prefix, !p.isEmpty { return "\\(p) \\(message)" }
          return message
        }
        """
        
        let instanceLog: DeclSyntax = """
        private func log(_ message: String, isError: Bool = false) {
          let full = Self.__prefixed(message)
          if isError {
            Self.__logger.error("\\(full, privacy: .public)")
          } else {
            Self.__logger.info("\\(full, privacy: .public)")
          }
        }
        """

        let staticLog: DeclSyntax = """
        private static func log(_ message: String, isError: Bool = false) {
          let full = __prefixed(message)
          if isError {
            __logger.error("\\(full, privacy: .public)")
          } else {
            __logger.info("\\(full, privacy: .public)")
          }
        }
        """
        
        return [prefixDecl, categoryDecl, loggerDecl, prefixedFn, instanceLog, staticLog]
    }
}

@main
struct ConsolablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [ConsolableMacro.self]
}
