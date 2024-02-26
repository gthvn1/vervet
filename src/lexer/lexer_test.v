import lexer
import token

type Tok = token.Token
type TokType = token.TokenType

fn test_read_char() {
	stmt := 'let a = 5;'

	mut l := lexer.new(stmt)
	assert l.input == stmt

	for i in 0 .. stmt.len {
		assert l.position == i
		assert l.read_position == i + 1
		assert l.ch == stmt[i]
		l.read_char()
	}

	// We should be at the end of the stmt
	assert l.ch == 0

	// If we read another char as we are at the end we still read 0
	l.read_char()
	assert l.ch == 0
}

fn test_simple_next_token() {
	stmt := '=+(){},;'

	expected := [
		Tok{TokType.assign, '='},
		Tok{TokType.plus, '+'},
		Tok{TokType.lparen, '('},
		Tok{TokType.rparen, ')'},
		Tok{TokType.lbrace, '{'},
		Tok{TokType.rbrace, '}'},
		Tok{TokType.comma, ','},
		Tok{TokType.semicolon, ';'},
	]

	mut l := lexer.new(stmt)

	for i, t in expected {
		tok := l.next_token()
		if tok.typ != t.typ {
			eprintln('tests[${i}] - tokentype wrong. expected=<${t.typ}> , got=<${tok.typ}>')
			assert false
		}
		if tok.literal != t.literal {
			eprintln('tests[${i}] - literal wrong. expected=<${t.literal}> , got=<${tok.literal}>')
			assert false
		}
	}
}

fn test_extended_next_token() {
	stmt := 'let five = 5;'

	expected := [
		Tok{TokType.let, 'let'},
		Tok{TokType.ident, 'five'},
		Tok{TokType.assign, '='},
		Tok{TokType.integer, '5'},
		Tok{TokType.semicolon, ';'},
	]

	mut l := lexer.new(stmt)

	for i, t in expected {
		tok := l.next_token()
		if tok.typ != t.typ {
			eprintln('tests[${i}] - tokentype wrong. expected=<${t.typ}> , got=<${tok.typ}>')
			assert false
		}
		if tok.literal != t.literal {
			eprintln('tests[${i}] - literal wrong. expected=<${t.literal}> , got=<${tok.literal}>')
			assert false
		}
	}
}
