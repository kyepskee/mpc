type 'a parser

val result : 'a -> 'a parser

val zero : 'a parser
val item : char parser

val (>>=) : 'a parser -> ('a -> 'b parser) -> 'b parser
val bind : 'a parser -> f:('a -> 'b parser) -> 'b parser
val (<|>) : 'a parser -> 'a parser -> 'a parser

val seq : 'a parser -> 'b parser -> ('a * 'b) parser
val sat : (char -> bool) -> char parser

val char : char -> char parser
val range : char -> char -> char parser

val digit : char parser
val lower : char parser
val upper : char parser
val letter : char parser

val exactly : string -> string parser
