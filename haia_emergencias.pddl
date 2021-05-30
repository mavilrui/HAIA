(define (domain AEROPUERTO)
  (:requirements :strips :typing :durative-actions :fluents
  )
  (:types loc
          edi hos est - loc
          mov
          pol bom amb - mov
          vic
  )

  (:predicates (en ?e - (either pol bom amb vic) ?l - loc)
               (atrapado ?v - vic ?e - edi)
               (cargado ?v - vic ?a - amb)
               (incendio ?l - loc)
               (bloqueado ?l1 - loc ?l2 - loc)
               (carretera ?l1 - loc ?l2 - loc)
  )

  (:functions (velocidad ?m - mov)
              (distancia ?l1 - loc ?l2 - loc)
              (capacidadAmb)
              (agua ?b - bom)
              (capacidad-agua)
              (agua-total)
   )
  
  (:durative-action mover
           :parameters (?m - mov ?l1 - loc ?l2 - loc)
           :duration (= ?duration (/ (distancia ?l1 ?l2) (velocidad ?m)) )
           :condition (and (at start (at ?m ?l1)) 
                      (over all (connect ?l1 ?l2)) 
                      (over all (not (bloqueado ?l1 ?l2))) 
                      (at start (> (fuel ?m) (* (consumo ?m) (distancia ?l1 ?l2)))))
           :effect (and (at start (not (at ?m ?l1) )) (at end (at ?m ?l2)))
  )

  (:durative-action recargar
            :parameters (?b - bom ?e - est)
            :duration (= ?duration (/ (- (capacidad-agua) (agua ?b)) 10) )
            :condition (and (at start (< (agua ?b)
                       (/ (capacidad-agua) 2))) 
                       (over all (at ?b ?e)))
            :effect (and (at end (assign (agua ?b) (capacidad-agua))))
  )
  
  (:durative-action rescatar
            :parameters (?a -amb ?v - vic ?e - edi)
            :duration (= ?duration 10)
            :condition (and (over all (en ?a ?e)) 
                       (over all (en ?v ?e)) 
                       (at start (atrapado ?v ?e)))
            :effect (at end (not (atrapado ?v ?e))
  )
  
  (:durative-action cargar
            :parameters (?a -amb ?v - vic ?e - edi)
            :duration (= ?duration 10)
            :condition (and (over all (en ?a ?e)) 
                       (at start (en ?v ?e)))
            :effect (and (at end (not (en ?v ?e))) (at end (cargado ?v ?a)))
  )
  
  (:durative-action descargar
            :parameters (?a -amb ?v - vic ?h - hos)
            :duration (= ?duration 10)
            :condition (and (over all (en ?a ?h)) 
                       (at start (cargado ?v ?a)))
            :effect (and (at end (en ?v ?h)) (at end (not (cargado ?v ?a))))
  )
  
  (:durative-action desbloquear
            :parameters (?p -pol ?e1 - edi ?e2 - edi)
            :duration (= ?duration 10)
            :condition (and (or (over all (en ?p ?e1)) (over all (en ?p ?e2))) 
                       (at start (bloqueado ?e2 ?e1))
                       (at start (bloqueado ?e1 ?e2)))
            :effect (at end (not (bloqueado ?e1 ?e2) (not (bloqueado ?e2 ?e1)))
  )
  
  (:durative-action extinguir
  )
  
)
