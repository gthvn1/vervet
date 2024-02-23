module token

// From the source code we want to generate tokens
// Example: "let x = 5 + 5;"
//        -> LET, IDENTIFIER("x"), EQUAL_SIGN, INTEGER(5), PLUS_SIGN,
//           INTEGER(5), SEMICOLON

type TokenType = string

pub const illegal = 'ILLEGAL'
pub const eof = 'EOF'
pub const ident = 'IDENT'
pub const integer = 'INT'
pub const assign = '='
pub const plus = '+'
pub const comma = ','
pub const semicolon = ';'
pub const lparen = '('
pub const rparen = ')'
pub const lbrace = '{'
pub const rbrace = '}'
pub const function = 'FUNCTION'
pub const let = 'LET'

pub struct Token {
	pub:
	typ     TokenType
	literal string
}
