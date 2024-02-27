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

fn tokens_are_equal(tt1 token.Token, tt2 token.Token) bool {
	mut eq := true

	if tt1.typ != tt2.typ {
		eprintln('types are different: < ${tt1.typ} > VS < ${tt2.typ} >')
		eq = false
	}

	if tt1.literal != tt2.literal {
		eprintln('literals are different: < ${tt1.literal} > VS < ${tt2.literal} >')
		eq = false
	}

	return eq
}

fn test_simple_next_token() {
	stmt := '=+(){},;'

	expected := [
		token.Token{token.TokenType.assign, '='},
		token.Token{token.TokenType.plus, '+'},
		token.Token{token.TokenType.lparen, '('},
		token.Token{token.TokenType.rparen, ')'},
		token.Token{token.TokenType.lbrace, '{'},
		token.Token{token.TokenType.rbrace, '}'},
		token.Token{token.TokenType.comma, ','},
		token.Token{token.TokenType.semicolon, ';'},
	]

	mut l := lexer.new(stmt)

	for token in expected {
		assert tokens_are_equal(token, l.next_token())
	}
}

fn test_extended_next_token() {
	stmt := '
	let five = 5;
	let ten = 10;

	let add = fn(x, y) {
		x + y;
	};

	let result = add(five, ten);
	!-/*5;
  5 < 10 > 5;
  if (5 < 10) {
  return true;
  } else {
  return false;
  }
  10 == 10;
  10 != 9;
	'

	expected := [
		token.Token{token.TokenType.k_let, 'let'},
		token.Token{token.TokenType.ident, 'five'},
		token.Token{token.TokenType.assign, '='},
		token.Token{token.TokenType.integer, '5'},
		token.Token{token.TokenType.semicolon, ';'},
		token.Token{token.TokenType.k_let, 'let'},
		token.Token{token.TokenType.ident, 'ten'},
		token.Token{token.TokenType.assign, '='},
		token.Token{token.TokenType.integer, '10'},
		token.Token{token.TokenType.semicolon, ';'},
		token.Token{token.TokenType.k_let, 'let'},
		token.Token{token.TokenType.ident, 'add'},
		token.Token{token.TokenType.assign, '='},
		token.Token{token.TokenType.k_function, 'fn'},
		token.Token{token.TokenType.lparen, '('},
		token.Token{token.TokenType.ident, 'x'},
		token.Token{token.TokenType.comma, ','},
		token.Token{token.TokenType.ident, 'y'},
		token.Token{token.TokenType.rparen, ')'},
		token.Token{token.TokenType.lbrace, '{'},
		token.Token{token.TokenType.ident, 'x'},
		token.Token{token.TokenType.plus, '+'},
		token.Token{token.TokenType.ident, 'y'},
		token.Token{token.TokenType.semicolon, ';'},
		token.Token{token.TokenType.rbrace, '}'},
		token.Token{token.TokenType.semicolon, ';'},
		token.Token{token.TokenType.k_let, 'let'},
		token.Token{token.TokenType.ident, 'result'},
		token.Token{token.TokenType.assign, '='},
		token.Token{token.TokenType.ident, 'add'},
		token.Token{token.TokenType.lparen, '('},
		token.Token{token.TokenType.ident, 'five'},
		token.Token{token.TokenType.comma, ','},
		token.Token{token.TokenType.ident, 'ten'},
		token.Token{token.TokenType.rparen, ')'},
		token.Token{token.TokenType.semicolon, ';'},
		//!-/*5;
		token.Token{token.TokenType.bang, '!'},
		token.Token{token.TokenType.minus, '-'},
		token.Token{token.TokenType.slash, '/'},
		token.Token{token.TokenType.asterix, '*'},
		token.Token{token.TokenType.integer, '5'},
		token.Token{token.TokenType.semicolon, ';'},
		// 5 < 10 > 5;
		token.Token{token.TokenType.integer, '5'},
		token.Token{token.TokenType.lt, '<'},
		token.Token{token.TokenType.integer, '10'},
		token.Token{token.TokenType.gt, '>'},
		token.Token{token.TokenType.integer, '5'},
		token.Token{token.TokenType.semicolon, ';'},
		// if (5 < 10) {
		token.Token{token.TokenType.k_if, 'if'},
		token.Token{token.TokenType.lparen, '('},
		token.Token{token.TokenType.integer, '5'},
		token.Token{token.TokenType.lt, '<'},
		token.Token{token.TokenType.integer, '10'},
		token.Token{token.TokenType.rparen, ')'},
		token.Token{token.TokenType.lbrace, '{'},
		// return true;
		token.Token{token.TokenType.k_return, 'return'},
		token.Token{token.TokenType.k_true, 'true'},
		token.Token{token.TokenType.semicolon, ';'},
		//} else {
		token.Token{token.TokenType.rbrace, '}'},
		token.Token{token.TokenType.k_else, 'else'},
		token.Token{token.TokenType.lbrace, '{'},
		// return false;
		token.Token{token.TokenType.k_return, 'return'},
		token.Token{token.TokenType.k_false, 'false'},
		token.Token{token.TokenType.semicolon, ';'},
		//}
		token.Token{token.TokenType.rbrace, '}'},
		// 10 == 10;
		token.Token{token.TokenType.integer, '10'},
		token.Token{token.TokenType.eq, '=='},
		token.Token{token.TokenType.integer, '10'},
		token.Token{token.TokenType.semicolon, ';'},
		// 10 != 9;
		token.Token{token.TokenType.integer, '10'},
		token.Token{token.TokenType.not_eq, '!='},
		token.Token{token.TokenType.integer, '9'},
		token.Token{token.TokenType.semicolon, ';'},
		// EOF
		token.Token{token.TokenType.eof, ''},
	]

	mut l := lexer.new(stmt)

	for token in expected {
		assert tokens_are_equal(token, l.next_token())
	}
}
