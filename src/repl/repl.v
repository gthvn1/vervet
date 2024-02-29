module repl

import lexer
import token
import os

pub fn start() {
	println('
Welcome to Monkey Islang!!!
This is the REPL for Monkey programming language.
Type <ctrl+D> or "q" to quit
')

	for {
		expr := os.input_opt('>> ') or { break }

		if expr in ['q', 'q;'] {
			println('Bye... May your trip be as enjoyable as finding')
			println('extra bananas at the bottom of the bag!')
			break
		}

		mut l := lexer.new(expr)
		for {
			tok := l.next_token()
			if tok.typ == token.TokenType.eof {
				break
			}
			tok.print()
		}
	}
}
