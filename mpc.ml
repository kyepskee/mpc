open Core

type 'a parser = string -> ('a * string) list

let result v =
  (fun inp ->
     [(v, inp)])

let zero =
  (fun _inp ->
     [])

let item =
  fun inp ->
     match String.to_list inp with
     | [] -> []
     | x::xs -> [(x, String.of_char_list xs)]

let bind p ~f =
  fun inp ->
  List.concat @@
  List.map ~f:(fun (v, inp2) -> f v inp2)
    (p inp)
let (>>=) p f = bind p ~f

let (<|>) p q =
  fun inp ->
  List.append (p inp) (q inp)

let seq p q =
  p >>= fun x ->
  q >>= fun y ->
  result (x, y)

let sat p =
  item >>= fun x ->
  if p x then result x else zero

let char c = sat (Char.equal c)

let range a b =
  let f = (fun x -> a <= x && x <= b) in
  sat f

module Let_syntax = struct
  let bind = bind
end

let digit = range '0' '9'
let lower = range 'a' 'b'
let upper = range 'A' 'B'
let letter = lower <|> upper

let rec exactly str =
  match String.to_list str with
  | [] -> result ""
  | x::xs ->
    let%bind _ = char x in
    let%bind _ = exactly (String.of_char_list xs) in
    result (String.of_char_list (x::xs))
