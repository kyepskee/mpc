Simple monadic parser combinators in OCaml based on <http://www.cs.nott.ac.uk/~pszgmh/monparsing.pdf1>.

Used for my own devices.


# Installation

To install do the following:

```sh
git clone https://gitlab.com/kyepskee/mpc
cd mpc
eval $(opam env) # evaluate opam context (if not already evaluated)
dune install
```


# Dependencies

-   opam
    -   core
    -   ppx<sub>let</sub>
-   dune
