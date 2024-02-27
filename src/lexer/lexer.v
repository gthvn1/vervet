module lexer

import token

pub struct Lexer {
pub mut:
	input         string
	position      int // current position in input (points to current char)
	read_position int // current reading position in input (after current char)
	ch            u8  // current char under examination
}

// Return a new lexer initialized with string passed as parameter
pub fn new(input string) Lexer {
	mut l := &Lexer{input, 0, 0, 0}
	l.read_char()
	return *l
}

// Give the next character and advance the position
pub fn (mut l Lexer) read_char() {
	if l.read_position >= l.input.len {
		l.ch = 0
	} else {
		l.ch = l.input[l.read_position]
	}

	l.position = l.read_position
	l.read_position += 1
}

// Returns the next character to be read without modifying the lexer.
pub fn (l Lexer) peek_char() u8 {
	return if l.read_position >= l.input.len {
		`\0`
	} else {
		l.input[l.read_position]
	}
}

// Skip space, newline, tabs and carriage return
fn (mut l Lexer) skip_whitespace() {
	for l.ch == ` ` || l.ch == `\t` || l.ch == `\n` || l.ch == `\r` {
		l.read_char()
	}
}

// Return true if c is a letter
fn is_letter(c u8) bool {
	return (`a` <= c && c <= `z`) || (`A` <= c && c <= `Z`)
}

// Return true if c is a digit
fn is_digit(c u8) bool {
	return `0` <= c && c <= `9`
}

// Return the token.TokenenType of the given string
fn lookup_ident(ident string) token.TokenType {
	return match ident {
		'fn' { token.TokenType.k_function }
		'let' { token.TokenType.k_let }
		'true' { token.TokenType.k_true }
		'false' { token.TokenType.k_false }
		'if' { token.TokenType.k_if }
		'else' { token.TokenType.k_else }
		'return' { token.TokenType.k_return }
		else { token.TokenType.ident }
	}
}

// Read the number under current character
fn (mut l Lexer) read_integer() string {
	pos := l.position
	for is_digit(l.ch) {
		l.read_char()
	}
	return l.input[pos..l.position]
}

// Read while current is a character
fn (mut l Lexer) read_identifier() string {
	pos := l.position
	for is_letter(l.ch) {
		l.read_char()
	}
	return l.input[pos..l.position]
}

// Return the next token and update the lexer
pub fn (mut l Lexer) next_token() token.Token {
	l.skip_whitespace()

	t := match l.ch {
		`=` {
			// Can be '=' or '=='
			if l.peek_char() == `=` {
				l.read_char()
				&token.Token{token.TokenType.eq, '=='}
			} else {
				&token.Token{token.TokenType.assign, '='}
			}
		}
		`;` {
			&token.Token{token.TokenType.semicolon, ';'}
		}
		`(` {
			&token.Token{token.TokenType.lparen, '('}
		}
		`)` {
			&token.Token{token.TokenType.rparen, ')'}
		}
		`,` {
			&token.Token{token.TokenType.comma, ','}
		}
		`+` {
			&token.Token{token.TokenType.plus, '+'}
		}
		`-` {
			&token.Token{token.TokenType.minus, '-'}
		}
		`!` {
			// Can be '!=' or '!'
			if l.peek_char() == `=` {
				l.read_char()
				&token.Token{token.TokenType.not_eq, '!='}
			} else {
				&token.Token{token.TokenType.bang, '!'}
			}
		}
		`*` {
			&token.Token{token.TokenType.asterix, '*'}
		}
		`/` {
			&token.Token{token.TokenType.slash, '/'}
		}
		`<` {
			&token.Token{token.TokenType.lt, '<'}
		}
		`>` {
			&token.Token{token.TokenType.gt, '>'}
		}
		`{` {
			&token.Token{token.TokenType.lbrace, '{'}
		}
		`}` {
			&token.Token{token.TokenType.rbrace, '}'}
		}
		`\0` {
			&token.Token{token.TokenType.eof, ''}
		}
		else {
			// If we have a letter or an integer the next caracter will be set when
			// calling read_identifier() or read_integer() so we return without reading
			// next caracter.
			if is_letter(l.ch) {
				ident := l.read_identifier()
				return token.Token{lookup_ident(ident), ident}
			}

			if is_digit(l.ch) {
				return token.Token{token.TokenType.integer, l.read_integer()}
			}

			&token.Token{token.TokenType.illegal, ''}
		}
	}

	l.read_char()

	return *t
}
