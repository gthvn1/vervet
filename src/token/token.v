module token

// From the source code we want to generate tokens
// Example: "let x = 5 + 5;"
//        -> LET, IDENTIFIER("x"), EQUAL_SIGN, INTEGER(5), PLUS_SIGN,
//           INTEGER(5), SEMICOLON

pub enum TokenType {
	illegal
	eof
	// Identifiers + literals
	ident
	integer
	// Operators
	assign
	plus
	minus
	bang
	asterix
	slash
	lt
	gt
	eq
	not_eq
	// Delimiters
	comma
	semicolon
	lparen
	rparen
	lbrace
	rbrace
	// Keywords
	// Note: we prefix keywords because most of them are also keywords in V
	k_function
	k_let
	k_true
	k_false
	k_if
	k_else
	k_return
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
		.minus { '-' }
		.bang { '!' }
		.asterix { '*' }
		.slash { '/' }
		.lt { '<' }
		.gt { '>' }
		.eq { '==' }
		.not_eq { '!=' }
		.comma { ',' }
		.semicolon { ';' }
		.lparen { '(' }
		.rparen { ')' }
		.lbrace { '{' }
		.rbrace { '}' }
		.k_function { 'FUNCTION' }
		.k_let { 'LET' }
		.k_true { 'TRUE' }
		.k_false { 'FALSE' }
		.k_if { 'IF' }
		.k_else { 'ELSE' }
		.k_return { 'RETURN' }
	}
}

pub struct Token {
pub:
	typ     TokenType
	literal string
}

pub fn (t Token) print() {
	typ_str := t.typ.to_string()
	lit_str := t.literal
	println('Type: ${typ_str:-20}  Literal: ${lit_str}')
}
