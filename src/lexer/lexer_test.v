import lexer

fn test_lexer() {
	l := lexer.new('let a = 5;')
	assert l.input == 'let a = 5;'
	assert 1 == 1
}
