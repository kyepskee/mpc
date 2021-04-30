open Core

type 'a parser = char list -> ('a * (char list)) list

let run_parser p text =
  (* Printf.printf @@ p (String.to_list text); *)
  List.map ~f:(fun (a, b) -> (a, String.of_char_list b))
    @@ p (String.to_list text)

let result v =
  (fun inp ->
     [(v, inp)])

let zero =
  (fun _inp ->
     [])

let item =
  fun inp ->
     match inp with
     | [] -> []
     | x::xs -> [(x, xs)]

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
let lower = range 'a' 'z'
let upper = range 'A' 'Z'
let letter = lower <|> upper

let rec exactly = function
  | [] -> result []
  | x::xs ->
    let%bind _ = char x in
    let%bind _ = exactly xs in
    result (x::xs)

let rec many p =
  begin
    let%bind x = p in
    let%bind xs = many p in
    result (x::xs)
  end <|> result []
