#lang scribble/manual
@require[@for-label["../main.rkt"
                    racket/base]]

@title{curry}
@author{@author+email["Samuel B. Johnson" "sabjohnso@yahoo.com"]}

@defmodule[curry]

Curry is a library for defining named and unnamed curried functions.

@defform[
  #:id lambda-curried
  (lambda-curried formals body ...)
  #:grammar
  [(formals (id ...))
   (body [expr ...])]]{
  Returns a curried function.
}

@defproc[(curried-procedure? [v any/c]) boolean?]{
Returns @racket[#t] if @racket[v] is a @racket{curried-procedure?}. Otherwise,
returns @racket[#f]
}






