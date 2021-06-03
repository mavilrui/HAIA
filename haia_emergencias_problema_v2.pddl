(define (problem probEmergencia)
(:domain EMERGENCIAS)
(:objects
          Hospital - hos
          EstacionBomberos - est
          E1 E2 E3 E4 E5 E6 - edi
          A - amb
          P - pol
          B - bom
          V1 V2 V3 - vic
)

(:init
          ;; FUNCIONES ;;
          (= (velocidad A) 5)
          (= (velocidad P) 5)
          (= (velocidad B) 5)
          
          (= (capacidad-agua) 50)
          (= (capacidad-gasolina) 10000)
          (= (coste-apagado) 20)
          (= (agua B) 50)
          (= (consumo A) 10)
          (= (consumo B) 15)
          (= (consumo P) 10)
          (= (gasolina A) 8500)
          (= (gasolina B) 10000)
          (= (gasolina P) 9500)

          ;;;;;;;;;;;;;;;;;;;;;;
          ;; CONTADORES CARGA ;;
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
          
          
          ;; PREDICADOS ;;
          (en B EstacionBomberos)
          (en P EstacionBomberos)
          (en A Hospital)

          (repostar B EstacionBomberos)
          (repostar P EstacionBomberos)
          (repostar A Hospital)
          
          ;(disponible A)

          (en V1 E3)
          (atrapado V1)

          (en V2 E5)
          (atrapado V2)

          (en V3 E3)
          (rescatado V3)
          
          (= (incendio E1) 1)
          (= (incendio E2) 2)
          (= (incendio E3) 0)
          (= (incendio E4) 0)
          (= (incendio E5) 0)
          (= (incendio E6) 1)
          (= (incendio Hospital) 0)
          (= (incendio EstacionBomberos) 0)

          (boca-incendios E1)
          (boca-incendios E2)
          ; (boca-incendios E3)
          ; (boca-incendios E4)
          ; (boca-incendios E5)
          ; (boca-incendios E6)
          ; (boca-incendios Hospital)
          ; (boca-incendios EstacionBomberos)

          ; (sin-boca-incendios E1)
          ; (sin-boca-incendios E2)
          (sin-boca-incendios E3)
          (sin-boca-incendios E4)
          (sin-boca-incendios E5)
          (sin-boca-incendios E6)
          (sin-boca-incendios Hospital)
          (sin-boca-incendios EstacionBomberos)
          
        ;   (bloqueado E1 E2)(bloqueado E2 E1)
        ;   (bloqueado E2 E3)(bloqueado E3 E2)
          (bloqueado E3 E4)(bloqueado E4 E3)
        ;   (bloqueado E4 E5)(bloqueado E5 E4)
        ;   (bloqueado E5 E6)(bloqueado E6 E5)
        ;   (bloqueado E6 E1)(bloqueado E1 E6)
          (bloqueado Hospital E1)(bloqueado E1 Hospital)
        ;   (bloqueado Hospital E4)(bloqueado E4 Hospital)
        ;   (bloqueado EstacionBomberos E4)(bloqueado E4 EstacionBomberos)

          (= (nivel-bloqueo E3 E4) 1)(= (nivel-bloqueo E4 E3) 1)
          (= (nivel-bloqueo Hospital E1) 2)(= (nivel-bloqueo E1 Hospital) 2)


          (libre E1 E2)(libre E2 E1)
          (libre E2 E3)(libre E3 E2)
        ;   (libre E3 E4)(libre E4 E3)
          (libre E4 E5)(libre E5 E4)
          (libre E5 E6)(libre E6 E5)
          (libre E6 E1)(libre E1 E6)
        ;   (libre Hospital E1)(libre E1 Hospital)
          (libre Hospital E4)(libre E4 Hospital)
          (libre EstacionBomberos E4)(libre E4 EstacionBomberos)

          
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
        (en V3 Hospital)  

        ; POLICIA
        (libre E3 E4)(libre E4 E3)
        (libre Hospital E1)(libre E1 Hospital)

        ;; BOMBEROS
        (> 1 (incendio E1))
        (> 1 (incendio E2))
        (> 1 (incendio E6))
	)
)

(:metric minimize (total-time))

)
