module lexer

import token

type Tok = token.Token
type TokType = token.TokenType

pub struct Lexer {
pub mut:
	input         string
	position      int // current position in input (points to current char)
	read_position int // current reading position in input (after current char)
	ch            u8  // current char under examination
}

fn new(input string) Lexer {
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

fn is_digit(c u8) bool {
	return `0` <= c && c <= `9`
}

// Return the TokenType of the given string
fn lookup_ident(ident string) TokType {
	return match ident {
		'let' { TokType.let }
		else { TokType.ident }
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

pub fn (mut l Lexer) next_token() Tok {
	l.skip_whitespace()

	t := match l.ch {
		`=` {
			&Tok{TokType.assign, '='}
		}
		`;` {
			&Tok{TokType.semicolon, ';'}
		}
		`(` {
			&Tok{TokType.lparen, '('}
		}
		`)` {
			&Tok{TokType.rparen, ')'}
		}
		`,` {
			&Tok{TokType.comma, ','}
		}
		`+` {
			&Tok{TokType.plus, '+'}
		}
		`{` {
			&Tok{TokType.lbrace, '{'}
		}
		`}` {
			&Tok{TokType.rbrace, '}'}
		}
		`0` {
			&Tok{TokType.eof, ''}
		}
		else {
			// If we have a letter or an integer the next caracter will be set when
			// calling read_identifier() or read_integer() so we return without reading
			// next caracter.
			if is_letter(l.ch) {
				ident := l.read_identifier()
				return Tok{lookup_ident(ident), ident}
			}

			if is_digit(l.ch) {
				return Tok{TokType.integer, l.read_integer()}
			}

			&Tok{TokType.illegal, ''}
		}
	}

	l.read_char()

	return *t
}
