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
            :condition (and (at start (< (agua ?b) (/ (capacidad-agua) 2))) (over all (at ?b ?e)))
            :effect (and (at end (assign (agua ?b) (capacidad-agua))))
  )
  
  (:durative-action rescatar
  )
  
  (:durative-action cargar
  )
  
  (:durative-action descargar
  )
  
  (:durative-action desbloquear
  )
  
  (:durative-action extinguir
  )
  
)