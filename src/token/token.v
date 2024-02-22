module token

// From the source code we want to generate tokens
// Example: "let x = 5 + 5;"
//        -> LET, IDENTIFIER("x"), EQUAL_SIGN, INTEGER(5), PLUS_SIGN,
//           INTEGER(5), SEMICOLON

type TokenType = string

pub struct Token {
	typ     TokenType
	literal string
}
