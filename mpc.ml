open Core

module LazyList = Lazy_list

type 'a parser = char list -> ('a * (char list)) LazyList.t

let run_parser p text =
  (* Printf.printf @@ p (String.to_list text); *)
  LazyList.map ~f:(fun (a, b) -> (a, String.of_char_list b))
    @@ p (String.to_list text)

let return v =
  (fun inp ->
     LazyList.of_list [(v, inp)])

let zero =
  (fun _inp ->
     LazyList.Nil)

let item =
  fun inp ->
  LazyList.of_list @@
     match inp with
     | [] -> []
     | x::xs -> [(x, xs)]

let bind p ~f =
  fun inp ->
  LazyList.concat @@
  LazyList.map ~f:(fun (v, inp2) -> f v inp2)
    (p inp)
let (>>=) p f = bind p ~f

let (<|>) p q =
  fun inp ->
  LazyList.append_lazy (p inp) (lazy (q inp))

let seq p q =
  p >>= fun x ->
  q >>= fun y ->
  return (x, y)

let sat p =
  item >>= fun x ->
  if p x then return x else zero

let char c = sat (Char.equal c)

let range a b =
  let f = Char.(fun x -> a <= x && x <= b) in
  sat f

module Let_syntax = struct
  let bind = bind
end

let digit = range '0' '9'
let lower = range 'a' 'z'
let upper = range 'A' 'Z'
let letter = lower <|> upper

let rec exactly_clist = function
  | [] -> return []
  | x::xs ->
    let%bind _ = char x in
    let%bind _ = exactly_clist xs in
    return (x::xs)

let fix f =
  let rec p = lazy (f r)
  and r = (fun clist -> (Lazy.force p) clist)
  in
  r

let (>>|) p f = p >>= fun x -> return (f x)

let (<$>) f p = p >>| f
let (<*>) fp p = fp >>= fun f -> p >>| f

let ( *>) p q = p >>= const q
let (<* ) p q = p >>= fun x -> q >>= const @@ return x

let many p =
  fix (fun m ->
      ((fun x y -> x::y) <$> p <*> m) <|> return [])

let many1 p =
  let%bind x = p in
  let%bind xs = many p in
  return @@ x::xs

let posnum =
  let%bind ds = many digit in
  let digits = List.map ~f:(Fn.compose Int.of_string String.of_char) ds in
  if List.length digits = 0
  then zero (* zero digits is not a number *)
  else
    let (_, n) = List.fold_right digits ~init:(1, 0)
        ~f:(fun el (power, sum) -> (power*10, power*el + sum)) in
    return n

let num =
  begin (* negative number *)
    let%bind _ = char '-' in
    let%bind n = posnum in
    return (-n)
  end <|> posnum

let exactly str = String.of_char_list <$> exactly_clist (String.to_list str)
let whitechar = char ' ' <|> char '\t' <|> char '\n'
let whitespace = String.of_char_list <$> many whitechar
