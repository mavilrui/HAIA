(define (problem probEmergencia)
(:domain EMERGENCIAS)
(:objects
          Hospital - hos
          EstacionBomberos - est
          E1 E2 E3 E4 E5 E6 - edi
          A - amb
          P - pol
          B - bom
          V1 V2 - vic
)

(:init
          (= (victim-time) 0)
          (= (remove-debris-time) 0)
          (= (total-duration) 0)
          (= (fire-extinguish-time) 0)

          ;; FUNCIONES ;;
          (= (velocidad A) 5)
          (= (velocidad P) 5)
          (= (velocidad B) 5)
          
          (= (capacidad-agua) 50)
          (= (coste-apagado) 20)
          (= (agua B) 50)
          
          (= (distancia E1 E2) 25)(= (distancia E2 E1) 25)
          (= (distancia E2 E3) 45)(= (distancia E3 E2) 45)
          (= (distancia E3 E4) 25)(= (distancia E4 E3) 25)
          (= (distancia E4 E5) 35)(= (distancia E5 E4) 35)
          (= (distancia E5 E6) 25)(= (distancia E6 E5) 25)
          (= (distancia E6 E1) 15)(= (distancia E1 E6) 15)
          
          (= (distancia Hospital E1) 30)(= (distancia E1 Hospital) 30)
          (= (distancia Hospital E4) 30)(= (distancia E4 Hospital) 30)
          
          (= (distancia EstacionBomberos E4) 20)(= (distancia E4 EstacionBomberos) 20)
          (= (distancia EstacionBomberos E5) 15)(= (distancia E5 EstacionBomberos) 15)
          
          ;; PREDICADOS ;;
          (en B EstacionBomberos)
          (en P EstacionBomberos)
          (en A Hospital)(disponible A)

          (en V1 E3)
          (atrapado V1)

          (en V2 E5)
          (atrapado V2)
          
          (incendio E1)
          (incendio E2)
          (incendio E6)
          
        ;   (bloqueado E1 E2)(bloqueado E2 E1)
        ;   (bloqueado E2 E3)(bloqueado E3 E2)
          (bloqueado E3 E4)(bloqueado E4 E3)
        ;   (bloqueado E4 E5)(bloqueado E5 E4)
        ;   (bloqueado E5 E6)(bloqueado E6 E5)
        ;   (bloqueado E6 E1)(bloqueado E1 E6)
          (bloqueado Hospital E1)(bloqueado E1 Hospital)
        ;   (bloqueado Hospital E4)(bloqueado E4 Hospital)
        ;   (bloqueado EstacionBomberos E4)(bloqueado E4 EstacionBomberos)

          (libre E1 E2)(libre E2 E1)
          (libre E2 E3)(libre E3 E2)
        ;   (libre E3 E4)(libre E4 E3)
          (libre E4 E5)(libre E5 E4)
          (libre E5 E6)(libre E6 E5)
          (libre E6 E1)(libre E1 E6)
        ;   (libre Hospital E1)(libre E1 Hospital)
          (libre Hospital E4)(libre E4 Hospital)
          (libre EstacionBomberos E4)(libre E4 EstacionBomberos)
          (libre EstacionBomberos E5)(libre E5 EstacionBomberos)

          
          (carretera E1 E2)(carretera E2 E1)
          (carretera E2 E3)(carretera E3 E2)
          (carretera E3 E4)(carretera E4 E3)
          (carretera E4 E5)(carretera E5 E4)
          (carretera E5 E6)(carretera E6 E5)
          (carretera E6 E1)(carretera E1 E6)
          
          (carretera Hospital E1)(carretera E1 Hospital)
          (carretera Hospital E4)(carretera E4 Hospital)
          
          (carretera EstacionBomberos E4)(carretera E4 EstacionBomberos)
          (carretera EstacionBomberos E5)(carretera E5 EstacionBomberos)
)

(:goal

	( and
        ;; AMBULANCIA
        (en V1 Hospital)    
        (en V2 Hospital)  

        ;; POLICIA
        (libre E3 E4)(libre E4 E3)
        (libre Hospital E1)(libre E1 Hospital)

        ;; BOMBEROS
        (apagado E1)
        (apagado E2)
        (apagado E6)
	)
)

(:metric minimize (+ (total-time) (* (fire-extinguish-time) 10)))

)
