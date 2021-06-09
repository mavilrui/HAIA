(define (domain EMERGENCIAS)

  (:requirements :strips :typing :durative-actions :fluents)

  (:types loc
          edi hos est - loc
          mov
          pol bom amb - mov
          vic
  )

  (:predicates (en ?e - (either pol bom amb vic) ?l - loc)
               (atrapado ?v - vic) 
               (rescatado ?v - vic)
               (cargado ?v - vic ?a - amb)
               (incendio ?l - loc)(apagado ?l - loc) ;; El predicado apagado no sería necesario una vez se impide rescatar
               ; a personas de edificios en llamas. Se usa únicamente para comprobar que el fuego si que se apaga.
               (disponible ?a - amb)
               (bloqueado ?l1 - loc ?l2 - loc) (libre ?l1 - loc ?l2 - loc)
               (carretera ?l1 - loc ?l2 - loc) ;; Estatico
  )

  (:functions (velocidad ?m - mov)
              (distancia ?l1 - loc ?l2 - loc)
              (coste-apagado)
              (agua ?b - bom)
              (capacidad-agua)
              (victim-time)
              (remove-debris-time)
              (fire-extinguish-time)
              (total-duration)
   )
  
  (:durative-action mover ;; BIEN
           :parameters (?m - mov ?l1 - loc ?l2 - loc)
           :duration (= ?duration (/ (distancia ?l1 ?l2) (velocidad ?m)) )
           :condition (and (at start (en ?m ?l1)) 
                      (over all (carretera ?l1 ?l2))
                      (over all (libre ?l1 ?l2))) 
                      ;(over all (not (bloqueado ?l1 ?l2))))                      
           :effect (and (at start (not (en ?m ?l1) )) (at end (en ?m ?l2))
                        (at end (increase (total-duration) ?duration)))
  )

  (:durative-action recargar
            :parameters (?b - bom ?e - est)
            :duration (= ?duration (/ (- (capacidad-agua) (agua ?b)) 10) )
            :condition (over all (en ?b ?e))
            :effect (and (at end (assign (agua ?b) (capacidad-agua)))
                      (at end (increase (total-duration) ?duration)))
  )
  
  (:durative-action rescatar ;; BIEN
            :parameters (?a - amb ?v - vic ?e - edi)
            :duration (= ?duration 10)
            :condition (and (over all (en ?a ?e)) 
                       (over all (en ?v ?e))
                       (at start (atrapado ?v)))
            :effect (and (at end (not (atrapado ?v))) (at end (rescatado ?v))
                        (at end (increase (total-duration) ?duration)))
  )
  
  (:durative-action cargar ;; BIEN
            :parameters (?a - amb ?v - vic ?e - edi)
            :duration (= ?duration 10)
            :condition (and (over all (en ?a ?e)) 
                       (at start (disponible ?a))                       
                       (at start (en ?v ?e))
                       (at start (rescatado ?v))) ;; podria ser (over all)
            :effect (and 
                      (at end (not (en ?v ?e))) 
                      (at end (cargado ?v ?a)) 
                      (at end (not (disponible ?a)))
                        (at end (increase (total-duration) ?duration)))
  )
  
  (:durative-action descargar ;; BIEN
            :parameters (?a - amb ?v - vic ?h - hos)
            :duration (= ?duration 10)
            :condition (and (over all (en ?a ?h))
                       (at start (cargado ?v ?a)))
            :effect (and (at end (en ?v ?h)) (at end (not (cargado ?v ?a))) (at end (disponible ?a))
                      (at end (assign (victim-time) (total-duration)))  
			(at end (increase (total-duration) ?duration)))
  )  

  (:durative-action desbloquear ;; BIEN
            :parameters (?p - pol ?e1 - loc ?e2 - loc)
            :duration (= ?duration 10)
            :condition (and 
                       (over all (en ?p ?e1))
                       (at start (bloqueado ?e1 ?e2)))
            :effect (and 
                       (at end (not (bloqueado ?e1 ?e2))) 
                       (at end (not (bloqueado ?e2 ?e1)))
                       (at end (libre ?e1 ?e2))
                       (at end (libre ?e2 ?e1))
                       (at end (assign (remove-debris-time) (total-duration)))
                        (at end (increase (total-duration) ?duration)))
  )
  
  (:durative-action extinguir ;; BIEN
            :parameters (?b - bom ?e - loc)
            :duration (= ?duration 10)
            :condition (and (over all (en ?b ?e))
                       (at start (incendio ?e))
                       (at start (> (agua ?b) (coste-apagado))))
            :effect (and 
                      (at end (not (incendio ?e)))
                      (at end (apagado ?e)) 
                      (at end (decrease (agua ?b) (coste-apagado)))
                        (at end (increase (total-duration) ?duration))
                      (at end (assign (fire-extinguish-time) (total-duration))))
  )
)