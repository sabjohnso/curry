#lang scribble/manual
@require[@for-label["../main.rkt"
                    racket/base]]

@title{Curry}
@author{@author+email["Samuel B. Johnson" "sabjohnso@yahoo.com"]}

@defmodule[curry]

Curry is a library for defining named and unnamed curried functions.

@defform/subs[
  #:id lambda-curried
  (lambda-curried formals body ...+)
  ([formals (id ...)])]{
  Returns a curried function.
}

@defform/subs[
  #:id lambda-curried/contract
  (lambda-curried/contract formals ctc body ...+)
  ([formals (id ...)]
   [ctc contract?])]{
  Returns a curried function with a contract.
}

@defform/subs[
  #:id define-curried
  (define-curried signature body ...)
  ([signature (function-name formals)]
   [function-name id]
   [formals (code:line id ...)])
]{
  Defines a curried function and binds it to the specified name.
}

@defform/subs[
  #:id define-curried/contract
  (define-curried/contract signature ctc body ...)
  ([signature (function-name formals)]
   [function-name id]
   [formals (code:line id ...)]
   [ctc contract?])
]{
}

@defproc[(curried-procedure? [v any/c]) boolean?]{
  Returns @racket[#t] if @racket[v] is a @racket[curried-procedure?]. Otherwise,
  returns @racket[#f].
}






