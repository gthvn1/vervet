import lexer
import token

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
		token.Token{token.assign, '='},
		token.Token{token.plus, '+'},
		token.Token{token.lparen, '('},
		token.Token{token.rparen, ')'},
		token.Token{token.lbrace, '{'},
		token.Token{token.rbrace, '}'},
		token.Token{token.comma, ','},
		token.Token{token.semicolon, ';'},
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
