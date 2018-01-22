---
navhome: /docs/
title: Scheme
sort: 8
next: true
---

# Scheme 

From [Kohányi Róbert](https://github.com/kohanyirobert/snock/blob/master/snock.ss):

```
(import (rnrs (6)))

(define (i a) a)

(define (n a r)
  (cond
    ((list? a)
     (let ((l (length a)))
       (cond
         ((equal? l 0) (raise 1))
         ((equal? l 1) (r (car a)))
         (else
           (let ((t (cond
                      ((equal? l 2) (cadr a))
                      (else (cdr a)))))
             (n (car a)
                (lambda (p) (n t
                               (lambda (q) (r (cons p q)))))))))))
    ((fixnum? a) (r a))
    (else (raise 2))))

(define (wut a)
  (cond
    ((fixnum? a) 1)
    (else 0)))

(define (lus a)
  (cond
    ((equal? (wut a) 0) (raise 3))
    (else (+ 1 a))))

(define (tis a)
  (cond
    ((equal? (wut a) 1) (raise 4))
    ((equal? (car a) (cdr a)) 0)
    (else 1)))

(define (fas a r)
  (cond
    ((equal? (wut a) 1) (raise 5))
    (else
      (let ((h (car a))
          (t (cdr a)))
      (cond
        ((not (fixnum? h)) (raise 6))
        ((equal? h 0) (raise 7))
        ((equal? h 1) (r t))
        ((fixnum? t) (raise 8))
        ((equal? h 2) (r (car t)))
        ((equal? h 3) (r (cdr t)))
        (else
            (fas (cons (div h 2) t)
                 (lambda (p) (fas (cons (+ 2 (mod h 2)) p)
                                  (lambda (q) (r q)))))))))))

(define (tar a r)
  (cond
    ((equal? (wut a) 1) (raise 9))
    (else
      (let ((s (car a))
            (f (cdr a)))
        (cond
          ((equal? (wut f) 1) (raise 10))
          (else
            (let ((o (car f))
                  (v (cdr f)))
              (cond
                ((equal? (wut o) 0) (tar (cons s o)
                                         (lambda (p) (tar (cons s v)
                                                          (lambda (q) (r (cons p q)))))))
                ((equal? o 0) (r (fas (cons v s) i)))
                ((equal? o 1) (r v))
                ((equal? o 3) (tar (cons s v)
                                   (lambda (p) (r (wut p)))))
                ((equal? o 4) (tar (cons s v)
                                   (lambda (p) (r (lus p)))))
                ((equal? o 5) (tar (cons s v)
                                   (lambda (p) (r (tis p)))))
                ((equal? (wut v) 1) (raise 11))
                (else
                  (let ((x (car v))
                        (y (cdr v)))
                    (cond
                      ((equal? o 2) (tar (cons s x)
                                         (lambda (p) (tar (cons s y)
                                                          (lambda (q) (tar (cons p q)
                                                                           (lambda (u) (r u))))))))
                      ((equal? o 7) (tar (n (list (list s) 2 (list x) 1 (list y)) i)
                                         (lambda (p) (r p))))
                      ((equal? o 8) (tar (n (list (list s) 7 (list (list 7 (list 0 1) (list x)) 0 1) (list y)) i)
                                         (lambda (p) (r p))))
                      ((equal? o 9) (tar (n (list (list s) 7 (list y) 2 (list 0 1) 0 (list x)) i)
                                         (lambda (p) (r p))))
                      ((equal? o 10) (cond
                                       ((equal? (wut x) 1) (tar (cons s y)
                                                                (lambda (p) (r p))))
                                       (else (tar (n (list (list s) 8 (list (cdr x)) 7 (list 0 3) (list y)) i)
                                                  (lambda (p) (r p))))))
                      ((equal? (wut y) 1) (raise 12))
                      ((equal? o 6) (tar (n (list
                                              (list s)
                                              2
                                              (list 0 1)
                                              2
                                              (list 1 (list (car y)) (list (cdr y)))
                                              (list 1 0)
                                              2
                                              (list 1 2 3)
                                              (list 1 0)
                                              4
                                              4
                                              (list x))
                                            i)
                                         (lambda (p) (r p))))
                      (else (raise 13)))))))))))))
```
