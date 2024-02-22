module lexer

import token

struct Lexer {
pub mut:
	input         string
	position      int // current position in input (points to current char)
	read_position int // current reading position in input (after current char)
	ch            u8  // current char under examination
}

fn new(input string) Lexer {
	mut l := &Lexer{input, 0, 0, 0}
	return *l
}

// Give the next character and advance the position
fn read_char(mut l Lexer) {
	if l.read_position >= l.input.len {
		l.ch = 0
	} else {
		l.ch = l.input[l.read_position]
	}

	l.position = l.read_position
	l.read_position += 1
}

fn test_read_char() {
	println('Testing lexer')
}
