Simple monadic parser combinators in OCaml based on <http://www.cs.nott.ac.uk/~pszgmh/monparsing.pdf1>.

Used for my own devices.


# Dependencies

-   opam
    -   core
    -   ppx\_let
-   dune


# Installation

First install all the dependencies, then do the following:

```sh
git clone https://gitlab.com/kyepskee/mpc
cd mpc
eval $(opam env) # evaluate opam context (if not already evaluated)
dune install
```
