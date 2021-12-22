#lang info
(define collection "curry")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/curry.scrbl" ())))
(define pkg-desc "Curried functions with partial and extended application")
(define version "0.1")
