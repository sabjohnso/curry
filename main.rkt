#lang racket

(provide
 lambda-curried define-curried lambda-curried/contract
 define-curried/contract
 curried/c
 (contract-out
  [curried-procedure? predicate/c]))

(require
 (for-syntax racket racket/syntax syntax/parse syntax/location))

(struct curried-procedure
  (proc arity args)
  #:property prop:procedure
  (λ (this . more-args)
    (let* ([arity (curried-procedure-arity this)]
           [args (append (curried-procedure-args this) more-args)]
           [n (length args)])
      (cond [(= arity n) (apply (curried-procedure-proc this) args)]
            [(< arity n) (apply (apply (curried-procedure-proc this)
                                       (take args arity))
                                (drop args arity))]
            [else (struct-copy curried-procedure this
                    [args args])]))))

(define-syntax lambda-curried
  (syntax-parser
   [(_ (~describe #:role "curried lambda expression" "formals" (xs:id ...))
       (~describe #:role "curried lambda expression" "body" (~seq es ...+)))
    (with-syntax ([arity (length (syntax-e #'(xs ...)))])
      #'(curried-procedure
         (lambda (xs ...) es ...)
         arity
         '()))]))

(define-syntax (lambda-curried/contract stx)
  (syntax-parse stx
   [(_ (~describe #:role "curried lambda expression" "formals" (xs:id ...))
       (~describe #:role "curried lambda expression" "contract" ctc:expr)
       (~describe #:role "curried lambda expression" "body" (~seq es ...+)))
    (with-syntax ([arity (length (syntax-e #'(xs ...)))]
                  [srcloc (srcloc (syntax-source stx)
                                  (syntax-line stx)
                                  (syntax-column stx)
                                  (syntax-position stx)
                                  (syntax-span stx))])
      #'(curried-procedure
         (contract ctc (lambda (xs ...) es ...)
                   'curry 'neg #f srcloc)
         arity
         '()))]))

(define-syntax define-curried
  (syntax-parser
   [(_ ((~describe #:role "curried procedure definition" "procedure name"
                   f:id)
        (~describe #:role "curried procedure definition" "formals"
                   (~seq xs:id ...)))
       (~describe #:role "curried procedure definition" "body"
                     (~seq es:expr ...+)))
    #'(define f (lambda-curried (xs ...) es ...))]))

(define-syntax define-curried/contract
  (syntax-parser
   [(_ ((~describe #:role "curried procedure definition" "procedure name"
                      f:id)
        (~describe #:role "curried procedure definition" "formals"
                      (~seq xs:id ...)))
       (~describe #:role "curried procedure definition" "contract"
                     ctc:expr)
       (~describe #:role "curried procedure definition" "body"
                     (~seq es:expr ...+)))
    #'(define f (lambda-curried/contract  (xs ...) ctc es ...))]))

(define-syntax curried/c
  (syntax-parser
   [(_  ctc)
    #'(struct/c curried-procedure ctc natural-number/c '())]))

(module+ test
  (require rackunit)

  (let ()
    (define-curried (f) (+ 3 4))
    (check-equal? (f) 7))

  (let ()
    (define-curried (add x y) (+ x y))
    (define-curried (id x) x)
    (check-equal? (add 3 4) 7)
    (check-equal? ((add 3) 4) 7)
    (check-equal? (id 3) 3)
    (check-equal? (id add 3 4) 7))

  (let ([f (lambda-curried/contract (x)
             (-> number? number?)
             (* x x))])
    (check-equal? (f 3) 9)
    (check-equal? ((f) 3) 9)
    (check-exn exn:fail:contract?
      (thunk (f 'x))))

  (check-exn exn:fail:syntax?
    (thunk (expand #'(lambda-curried/contract (x . xs)
                         (cons x xs))))))
