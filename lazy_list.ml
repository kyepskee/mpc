type 'a t = Cons of 'a * 'a t Lazy.t
          | Nil
[@@deriving show]

let head = function
  | Cons (hd, _) -> Some hd
  | Nil -> None

let rest = function
  | Cons (_, rst) -> Lazy.force rst
  | Nil -> Nil

let empty l =
  match l with
  | Cons _ -> false
  | Nil -> true

let rec of_list l =
  match l with
  | [] -> Nil
  | x::xs -> Cons (x, lazy (of_list xs))

let rec to_list l =
  match l with
  | Cons (x, rest) -> x::(to_list @@ Lazy.force rest)
  | Nil -> []

let rec append l1 l2 =
  match l1 with
  | Cons (hd, rest) ->
    let nrest = lazy (append (Lazy.force rest) l2) in
    Cons (hd, nrest)
  | Nil -> l2

let rec append_lazy l1 l2 =
  match l1 with
  | Cons (hd, rest) ->
    let nrest = lazy (append_lazy (Lazy.force rest) l2) in
    Cons (hd, nrest)
  | Nil -> (Lazy.force l2)

let rec map l ~f =
  match l with
  | Cons (hd, rest) ->
    Cons (f hd, lazy (map (Lazy.force rest) ~f))
  | Nil -> Nil

let rec concat l =
  match l with
  | Nil -> Nil
  | Cons (hd, rest) ->
    append_lazy hd (lazy (concat @@ Lazy.force rest))
