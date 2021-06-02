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
          ;; FUNCIONES ;;
          (= (velocidad A) 5)
          (= (velocidad P) 5)
          (= (velocidad B) 5)
          
          (= (capacidad-gasolina) 10000)
          (= (consumo A) 10)
          (= (consumo B) 10)
          (= (consumo P) 15)
          (= (gasolina A) 8500)
          (= (gasolina B) 9500)
          (= (gasolina P) 10000)
          
          (= (capacidad-agua) 50)
          (= (coste-apagado) 25)
          (= (agua B) 50)
	  
          (= (capacidadMax) 2)
          (= (carga-amb A) 0)
          
          (= (distancia E1 E2) 25)(= (distancia E2 E1) 25)
          (= (distancia E2 E3) 45)(= (distancia E3 E2) 45)
          (= (distancia E3 E4) 25)(= (distancia E4 E3) 25)
          (= (distancia E4 E5) 35)(= (distancia E5 E4) 35)
          (= (distancia E5 E6) 25)(= (distancia E6 E5) 25)
          (= (distancia E6 E1) 15)(= (distancia E1 E6) 15)
          
          (= (distancia Hospital E1) 30)(= (distancia E1 Hospital) 30)
          (= (distancia Hospital E4) 30)(= (distancia E4 Hospital) 30)
          
          (= (distancia EstacionBomberos E4) 20)(= (distancia E4 EstacionBomberos) 20)
          
          (= (incendio E1) 1)
          (= (incendio E2) 2)
          (= (incendio E3) 0)
          (= (incendio E4) 0)
          (= (incendio E5) 0)
          (= (incendio E6) 3)
          (= (incendio EstacionBomberos) 0)
          (= (incendio Hospital) 0)
          
          (= (nivel-bloqueo E3 E4) 1)(= (nivel-bloqueo E4 E3) 1)
          (= (nivel-bloqueo E1 Hospital) 2)(= (nivel-bloqueo Hospital E1) 2)
          
          ;; PREDICADOS ;;
          (en B EstacionBomberos)
          (en P EstacionBomberos)
          (repostar B EstacionBomberos)
	  (repostar P EstacionBomberos)
          (en A Hospital)(disponible A)
          (repostar A Hospital)

          (en V1 E3)
          (atrapado V1)

          (en V2 E5)
          (atrapado V2)

          (libre E1 E2)(libre E2 E1)
          (libre E2 E3)(libre E3 E2)
          (libre E4 E5)(libre E5 E4)
          (libre E5 E6)(libre E6 E5)
          (libre E6 E1)(libre E1 E6)
          (libre Hospital E4)(libre E4 Hospital)
          (libre EstacionBomberos E4)(libre E4 EstacionBomberos)
          
          (bloqueado E3 E4)(bloqueado E4 E3)
          (bloqueado E1 Hospital)(bloqueado Hospital E1)
          
          (carretera E1 E2)(carretera E2 E1)
          (carretera E2 E3)(carretera E3 E2)
          (carretera E3 E4)(carretera E4 E3)
          (carretera E4 E5)(carretera E5 E4)
          (carretera E5 E6)(carretera E6 E5)
          (carretera E6 E1)(carretera E1 E6)
          
          (carretera Hospital E1)(carretera E1 Hospital)
          (carretera Hospital E4)(carretera E4 Hospital)
          
          (carretera EstacionBomberos E4)(carretera E4 EstacionBomberos)
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
        (= (incendio E1) 0)
        (= (incendio E2) 0)
        (= (incendio E6) 0)
	)
)

(:metric minimize (total-time))

)