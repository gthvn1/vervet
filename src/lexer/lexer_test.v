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

fn test_next_token() {
	stmt := 'let a = 5;'

	mut l := lexer.new(stmt)

	t := l.next_token()
	assert t == token.Token{'type', 'literal'}
}
