import Foundation

public protocol StatementVisitor {
    associatedtype R
    func visitInstruction(_ expr: InstructionStatement) -> R
}

public protocol Statement {
    func accept<R, V>(visitor: V) -> R where V: StatementVisitor, V.R == R
}

public class InstructionStatement: Statement {
    let label: String?
    let instruction: any Instruction
    let comment: String?

    init(
        label: String?,
        instruction: any Instruction,
        comment: String?
    ) {
        self.label = label
        self.instruction = instruction
        self.comment = comment
    }

    public func accept<R, V>(visitor: V) -> R where V: StatementVisitor, V.R == R {
        visitor.visitInstruction(self)
    }
}

extension InstructionStatement: CustomDebugStringConvertible {
    public var debugDescription: String {
        var result = ""
        result += instruction.encode().map { String(format: "%04X", $0) }.joined()
        if let label {
            result += " \(label): "
        }
        result = result.byAddingRightPadding(15)
        result += "\(instruction)".byAddingRightPadding(40)
        if let comment {
            result += " \(comment)"
        }
        return result
    }
}
