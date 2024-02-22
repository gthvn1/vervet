module lexer

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
