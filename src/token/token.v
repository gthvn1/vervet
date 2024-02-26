module token

// From the source code we want to generate tokens
// Example: "let x = 5 + 5;"
//        -> LET, IDENTIFIER("x"), EQUAL_SIGN, INTEGER(5), PLUS_SIGN,
//           INTEGER(5), SEMICOLON

enum TokenType {
	illegal
	eof
	ident
	integer
	assign
	plus
	comma
	semicolon
	lparen
	rparen
	lbrace
	rbrace
	function
	let
}

// Convert the TokenType to a string
pub fn (tt TokenType) to_string() string {
	return match tt {
		.illegal { 'ILLEGAL' }
		.eof { 'EOF' }
		.ident { 'IDENT' }
		.integer { 'INT' }
		.assign { '=' }
		.plus { '+' }
		.comma { ',' }
		.semicolon { ';' }
		.lparen { '(' }
		.rparen { ')' }
		.lbrace { '{' }
		.rbrace { '}' }
		.function { 'FUNCTION' }
		.let { 'LET' }
	}
}

pub struct Token {
pub:
	typ     TokenType
	literal string
}
