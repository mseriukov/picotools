import Foundation

protocol ExpressionVisitor {
    associatedtype R
    func visitBinary(_ expr: Binary) -> R
    func visitUnary(_ expr: Unary) -> R
    func visitGrouping(_ expr: Grouping) -> R
    func visitStringLiteral(_ expr: StringLiteral) -> R
    func visitNumberLiteral(_ expr: NumberLiteral) -> R
}


protocol Expression {
    func accept<R, V>(visitor: V) -> R where V: ExpressionVisitor, V.R == R
}

class Binary: Expression {
    let lhs: Expression
    let op: Token
    let rhs: Expression

    init(lhs: Expression, op: Token, rhs: Expression) {
        self.lhs = lhs
        self.op = op
        self.rhs = rhs
    }

    func accept<R, V>(visitor: V) -> R where V: ExpressionVisitor, V.R == R {
        visitor.visitBinary(self)
    }
}

class Grouping: Expression {
    let expr: any Expression

    init(expr: any Expression) {
        self.expr = expr
    }

    func accept<R, V>(visitor: V) -> R where V: ExpressionVisitor, V.R == R {
        visitor.visitGrouping(self)
    }
}

class Unary: Expression {
    let expr: any Expression
    let op: Token

    init(expr: any Expression, op: Token) {
        self.expr = expr
        self.op = op
    }

    func accept<R, V>(visitor: V) -> R where V: ExpressionVisitor, V.R == R {
        visitor.visitUnary(self)
    }
}

class NumberLiteral: Expression {
    let literal: Double
    init(literal: Double) {
        self.literal = literal
    }

    func accept<R, V>(visitor: V) -> R where V: ExpressionVisitor, V.R == R {
        visitor.visitNumberLiteral(self)
    }
}

class StringLiteral: Expression {
    let literal: String
    init(literal: String) {
        self.literal = literal
    }

    func accept<R, V>(visitor: V) -> R where V: ExpressionVisitor, V.R == R {
        visitor.visitStringLiteral(self)
    }
}
