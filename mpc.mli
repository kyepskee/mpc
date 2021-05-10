type 'a parser

module LazyList = Lazy_list

val run_parser : 'a parser -> string -> ('a * string) LazyList.t

val return : 'a -> 'a parser

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

val whitechar : char parser
val whitespace : string parser

val posnum : int parser
val num : int parser

val exactly : string -> string parser

val many : 'a parser -> 'a list parser
val many1 : 'a parser -> 'a list parser

module Let_syntax : sig
  val bind : 'a parser -> f:('a -> 'b parser) -> 'b parser
end

val (>>|) : 'a parser -> ('a -> 'b) -> 'b parser

val (<$>) : ('a -> 'b) -> 'a parser -> 'b parser
val (<*>) : ('a -> 'b) parser -> 'a parser  -> 'b parser

val ( *>) : _ parser -> 'a parser  -> 'a parser
val (<* ) : 'a parser -> _ parser  -> 'a parser

val fix : ('a parser -> 'a parser) -> 'a parser
