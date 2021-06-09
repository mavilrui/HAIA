(define (domain EMERGENCIAS)

  (:requirements :strips :typing :durative-actions :fluents)

  (:types loc
          edi hos est com - loc
          mov
          pol bom amb - mov
          vic
  )

  (:predicates (en ?e - (either pol bom amb vic) ?l - loc)
               (atrapado ?v - vic) 
               (rescatado ?v - vic)
               (repostar ?m - mov ?l - loc)
               (cargado ?v - vic ?a - amb)
               (bloqueado ?l1 - loc ?l2 - loc)
	       (accidente ?v - vic ?l1 - loc ?l2 - loc) 
	       (libre ?l1 - loc ?l2 - loc)
               (carretera ?l1 - loc ?l2 - loc) 
               (boca-incendios ?l1 - loc)
               (sin-boca-incendios ?l1 - loc)
  )

  (:functions (velocidad ?m - mov)
              (distancia ?l1 - loc ?l2 - loc)
              (nivel-bloqueo ?l1 - loc ?l2 - loc)
              (coste-apagado)
              (consumo ?m - mov)
              (agua ?b - bom)
              (gasolina ?m - mov)
              (capacidad-agua)
              (capacidad-gasolina)
              (incendio ?l - loc)
              (carga-amb ?a - amb)
              (capacidadMax)
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
                      (over all (libre ?l1 ?l2))
                      (at start (> (gasolina ?m) (* (consumo ?m) (distancia ?l1 ?l2)))) ;; Se añade el consumo de gasolina               
                    )  
           :effect (and 
                        (at start (not (en ?m ?l1) )) 
                        (at end (en ?m ?l2)) 
                        (at end (decrease (gasolina ?m) (* (consumo ?m)  (distancia ?l1 ?l2)))) ;; Se añade el consumo de gasolina
                        (at end (increase (total-duration) ?duration))
                    )
  )
  
  (:durative-action repostar
            :parameters (?m - mov ?l - loc)
            :duration (= ?duration (/ (- (capacidad-gasolina) (gasolina ?m)) 5000) )
            :condition (and (over all (en ?m ?l)) (at start (repostar ?m ?l)))
            :effect (and 
                    (at end (assign (gasolina ?m) (capacidad-gasolina)))
                    (at end (increase (total-duration) ?duration))
                    )
  )

  (:durative-action recargar ;; BIEN
            :parameters (?b - bom ?e - est)
            :duration (= ?duration (/ (- (capacidad-agua) (agua ?b)) 10) )
            :condition (over all (en ?b ?e))
            :effect (and 
                      (at end (assign (agua ?b) (capacidad-agua)))
                      (at end (increase (total-duration) ?duration))
                    )
  )
  
  (:durative-action rescatar-accidente ;; BIEN
            :parameters (?p - pol ?v - vic ?l1 - loc ?l2 - loc)
            :duration (= ?duration 10)
            :condition (and (over all (en ?p ?l1))
                       (at start (accidente ?v ?l1 ?l2)))
            :effect (and 
                        (at end (not (accidente ?v ?l1 ?l2)))
                        (at end (not (accidente ?v ?l2 ?l1))) 
                        (at end (libre ?e1 ?e2))
                        (at end (libre ?e2 ?e1))
                        (at end (rescatado ?v)) 
                        (at end (en ?v ?l1))
                        (at end (increase (total-duration) ?duration))
                    )
  )
  
  (:durative-action rescatar ;; BIEN
            :parameters (?a - amb ?v - vic ?e - edi)
            :duration (= ?duration 10)
            :condition (and (over all (en ?a ?e)) 
                       (over all (en ?v ?e))
                       (at start (> 1 (incendio ?e) ))
                       (at start (atrapado ?v)))
            :effect (and 
                        (at end (not (atrapado ?v))) 
                        (at end (rescatado ?v))
                        (at end (increase (total-duration) ?duration))
                    )
  )
  
  (:durative-action rescatar-incendio-amb ;; BIEN
            :parameters (?a - amb ?v - vic ?e - edi)
            :duration (= ?duration 50)
            :condition (and (over all (en ?a ?e)) 
                       (over all (en ?v ?e))
                       (at start (> (incendio ?e) 0))
                       (at start (atrapado ?v)))
            :effect (and 
                      (at end (not (atrapado ?v))) 
                      (at end (rescatado ?v))
                      (at end (increase (total-duration) ?duration))
                    )
  )
  
  (:durative-action rescatar-incendio-bom ;; BIEN
            :parameters (?b - bom ?v - vic ?e - edi)
            :duration (= ?duration 10)
            :condition (and (over all (en ?b ?e)) 
                       (over all (en ?v ?e))
                       (at start (> (incendio ?e) 0))
                       (at start (atrapado ?v)))
            :effect (and 
                      (at end (not (atrapado ?v))) 
                      (at end (rescatado ?v))
                      (at end (increase (total-duration) ?duration))
                    )
  )
  
  (:durative-action cargar ;; BIEN
            :parameters (?a - amb ?v - vic ?e - edi)
            :duration (= ?duration 10)
            :condition (and (over all (en ?a ?e))                       
                       (at start (en ?v ?e))
                       (at start (rescatado ?v)) ;; podria ser (over all)
                       (at start (> (capacidadMax) (carga-amb ?a))) ; '>' porque lpg a veces tiene problemas con el '<'
                      )
            :effect (and 
                      (at end (not (en ?v ?e))) 
                      (at end (cargado ?v ?a)) 
                      (at end (increase (carga-amb ?a) 1))
                      (at end (increase (total-duration) ?duration))
                    )
  )
  
  (:durative-action descargar ;; BIEN
            :parameters (?a - amb ?v - vic ?h - hos)
            :duration (= ?duration 10)
            :condition (and (over all (en ?a ?h))
                       (at start (cargado ?v ?a)))
            :effect (and 
                      (at end (en ?v ?h)) 
                      (at end (not (cargado ?v ?a))) 
                      (at end (decrease (carga-amb ?a) 1))
                      (at end (increase (total-duration) ?duration))
                      (at end (assign (victim-time) (total-duration)))                      
                    )
  )

  (:durative-action desbloquear ;; BIEN
            :parameters (?p - pol ?e1 - loc ?e2 - loc)
            :duration (= ?duration (* (nivel-bloqueo ?e1 ?e2) 100))
            :condition (and 
                       (over all (en ?p ?e1))
                       (at start (bloqueado ?e1 ?e2)))
            :effect (and 
                       (at end (not (bloqueado ?e1 ?e2))) 
                       (at end (not (bloqueado ?e2 ?e1)))
                       (at end (libre ?e1 ?e2))
                       (at end (libre ?e2 ?e1))
                       (at end (increase (total-duration) ?duration))
                       (at end (assign (remove-debris-time) (total-duration)))
                    )
  )

  (:durative-action extinguir-boca ;; BIEN
            :parameters (?b - bom ?e - loc)
            :duration (= ?duration 10)
            :condition (and (over all (en ?b ?e))
                       (at start (> (incendio ?e) 0))
                       (at start (boca-incendios ?e))
                       )
            :effect (and 
                      (at end (decrease (incendio ?e) 1))
                      (at end (increase (total-duration) ?duration))
                      (at end (assign (fire-extinguish-time) (total-duration)))
                    )
            
  )

  (:durative-action extinguir-deposito ;; BIEN
            :parameters (?b - bom ?e - loc)
            :duration (= ?duration 10)
            :condition (and (over all (en ?b ?e))
                       (at start (> (incendio ?e) 0))
                       (at start (sin-boca-incendios ?e))
                       (at start (> (agua ?b) (coste-apagado))))
            :effect (and 
                      (at end (decrease (incendio ?e) 1))
                      (at end (decrease (agua ?b) (coste-apagado)))
                      (at end (increase (total-duration) ?duration))
                      (at end (assign (fire-extinguish-time) (total-duration)))
                    )
  )
)
