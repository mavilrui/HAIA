(define (problem probEmergencia)
(:domain EMERGENCIAS)
(:objects
          Hospital - hos
          EstacionBomberos - est
          Comisaria - com
          E1 E2 E3 E4 E5 E6 E7 E8 E9 E10 E11 - edi
          A1 A2 - amb
          P1 P2 P3 - pol
          B1 B2 - bom
          V1 V2 V3 V4 V5 V6 V7 V8 V9 V10 - vic
)

(:init
          ;; FUNCIONES ;;
          (= (velocidad A1) 10)
          (= (velocidad A2) 15)
          (= (velocidad P1) 10)
          (= (velocidad P2) 15)
          (= (velocidad P3) 20)
          (= (velocidad B1) 15)
          (= (velocidad B2) 20)
          
          (= (capacidad-agua) 50)
          (= (capacidad-gasolina) 10000)
          (= (coste-apagado) 25)
          (= (consumo A1) 10)
          (= (consumo A2) 10)
          (= (consumo B1) 15)
          (= (consumo B2) 15)
          (= (consumo P1) 10)
          (= (consumo P2) 10)
          (= (consumo P3) 15)
          (= (agua B1) 50)
          (= (agua B2) 0)
          (= (gasolina A1) 8500)
          (= (gasolina A2) 9500)
          (= (gasolina B1) 10000)
          (= (gasolina B2) 10000)
          (= (gasolina P1) 9500)
          (= (gasolina P2) 8000)
          (= (gasolina P3) 10000)
	  
          (= (capacidadMax) 2)
          (= (carga-amb A1) 0)
          (= (carga-amb A2) 0)
	  
          (= (distancia E1 E2) 25)(= (distancia E2 E1) 25)
          (= (distancia E2 E3) 35)(= (distancia E3 E2) 35)
          (= (distancia E1 E4) 25)(= (distancia E4 E1) 25)
          (= (distancia E2 E5) 35)(= (distancia E5 E2) 35)
          (= (distancia E3 E6) 25)(= (distancia E6 E3) 25)
          (= (distancia Comisaria E4) 35)(= (distancia E4 Comisaria) 35)
          (= (distancia E4 E5) 25)(= (distancia E5 E4) 25)
          (= (distancia E5 E6) 35)(= (distancia E6 E5) 35)
          (= (distancia E6 EstacionBomberos) 25)(= (distancia EstacionBomberos E6) 25)
          (= (distancia E4 E7) 35)(= (distancia E7 E4) 35)
          (= (distancia E5 E8) 45)(= (distancia E8 E5) 45)
          (= (distancia E6 E9) 35)(= (distancia E9 E6) 35)
          (= (distancia E7 E8) 25)(= (distancia E8 E7) 25)
          (= (distancia E8 E9) 35)(= (distancia E9 E8) 35)
          (= (distancia E7 E10) 45)(= (distancia E10 E7) 45)
          (= (distancia E8 Hospital) 35)(= (distancia Hospital E8) 35)
          (= (distancia E9 E11) 25)(= (distancia E11 E9) 25)
          (= (distancia E10 Hospital) 35)(= (distancia Hospital E10) 35)
          (= (distancia Hospital E11) 45)(= (distancia E11 Hospital) 45)
          
          (= (nivel-bloqueo E1 E4) 1)(= (nivel-bloqueo E4 E1) 1)
          (= (nivel-bloqueo E2 E3) 2)(= (nivel-bloqueo E3 E2) 2)
          (= (nivel-bloqueo E4 E5) 3)(= (nivel-bloqueo E5 E4) 3)
          (= (nivel-bloqueo E5 E6) 1)(= (nivel-bloqueo E6 E5) 1)
          (= (nivel-bloqueo E5 E8) 2)(= (nivel-bloqueo E8 E5) 2)
          (= (nivel-bloqueo E7 E8) 3)(= (nivel-bloqueo E8 E7) 3)
          (= (nivel-bloqueo E9 E11) 1)(= (nivel-bloqueo E11 E9) 1)
          (= (nivel-bloqueo E10 Hospital) 2)(= (nivel-bloqueo Hospital E10) 2)
          
          (= (incendio E1) 1)
          (= (incendio E2) 2)
          (= (incendio E3) 0)
          (= (incendio E4) 0)
          (= (incendio E5) 3)
          (= (incendio E6) 0)
          (= (incendio E7) 0)
          (= (incendio E8) 0)
          (= (incendio E9) 1)
          (= (incendio E10) 1)
          (= (incendio E11) 0)
          (= (incendio Hospital) 0)
          (= (incendio EstacionBomberos) 0)
          (= (incendio Comisaria) 0)

          (boca-incendios E1)
          (boca-incendios E2)
          (boca-incendios E3)
          (boca-incendios E4)
        ;   (boca-incendios E5)
        ;   (boca-incendios E6)
        ;   (boca-incendios E7)
        ;   (boca-incendios E8)
        ;   (boca-incendios E9)
        ;   (boca-incendios E10)
        ;   (boca-incendios E11)
        ;   (boca-incendios Hospital)
        ;   (boca-incendios EstacionBomberos)
        ;   (boca-incendios Comisaria)

        ;   (sin-boca-incendios E1)
        ;   (sin-boca-incendios E2)
        ;   (sin-boca-incendios E3)
        ;   (sin-boca-incendios E4)
          (sin-boca-incendios E5)
          (sin-boca-incendios E6)
          (sin-boca-incendios E7)
          (sin-boca-incendios E8)
          (sin-boca-incendios E9)
          (sin-boca-incendios E10)
          (sin-boca-incendios E11)
          (sin-boca-incendios Comisaria)
          (sin-boca-incendios Hospital)
          (sin-boca-incendios EstacionBomberos)

          
          ;; PREDICADOS ;;
          (en B1 EstacionBomberos)
          (en B2 EstacionBomberos)
          (en P1 Comisaria)
          (en P2 Comisaria)
          (en P3 Comisaria)
          (en A1 Hospital)
          (en A2 Hospital)
	  
          (repostar B1 EstacionBomberos)
          (repostar B2 EstacionBomberos)
          (repostar A1 Hospital)
          (repostar A2 Hospital)
          (repostar P1 Comisaria)
          (repostar P2 Comisaria)
          (repostar P3 Comisaria)

          (en V1 E1)(atrapado V1)
          (en V2 E2)(atrapado V2)
          (en V3 E5)(atrapado V3)
          (en V4 E5)(atrapado V4)
          (en V5 E6)(atrapado V5)
          (en V6 E6)(atrapado V6)
          (en V7 E8)(atrapado V7)
          (en V8 E10)(atrapado V8)
          (en V9 E11)(atrapado V9)
          (en V10 E11)(atrapado V10)
          
          (bloqueado E1 E4)(bloqueado E4 E1)
          (bloqueado E2 E3)(bloqueado E3 E2)
          (bloqueado E4 E5)(bloqueado E5 E4)
          (bloqueado E5 E6)(bloqueado E6 E5)
          (bloqueado E5 E8)(bloqueado E8 E5)
          (bloqueado E7 E8)(bloqueado E8 E7)
          (bloqueado E9 E11)(bloqueado E11 E9)
          (bloqueado E10 Hospital)(bloqueado Hospital E10)
          
          (libre E1 E2)(libre E2 E1)
          (libre E2 E5)(libre E5 E2)
          (libre E3 E6)(libre E6 E3)
          (libre Comisaria E4)(libre E4 Comisaria)
          (libre E6 EstacionBomberos)(libre EstacionBomberos E6)
          (libre E4 E7)(libre E7 E4)
          (libre E6 E9)(libre E9 E6)
          (libre E8 E9)(libre E9 E8)
          (libre E7 E10)(libre E10 E7)
          (libre E8 Hospital)(libre Hospital E8)
          (libre Hospital E11)(libre E11 Hospital)
          
          (carretera E1 E2)(carretera E2 E1)
          (carretera E2 E3)(carretera E3 E2)
          (carretera E1 E4)(carretera E4 E1)
          (carretera E2 E5)(carretera E5 E2)
          (carretera E3 E6)(carretera E6 E3)
          (carretera Comisaria E4)(carretera E4 Comisaria)
          (carretera E4 E5)(carretera E5 E4)
          (carretera E5 E6)(carretera E6 E5)
          (carretera E6 EstacionBomberos)(carretera EstacionBomberos E6)
          (carretera E4 E7)(carretera E7 E4)
          (carretera E5 E8)(carretera E8 E5)
          (carretera E6 E9)(carretera E9 E6)
          (carretera E7 E8)(carretera E8 E7)
          (carretera E8 E9)(carretera E9 E8)
          (carretera E7 E10)(carretera E10 E7)
          (carretera E8 Hospital)(carretera Hospital E8)
          (carretera E9 E11)(carretera E11 E9)
          (carretera E10 Hospital)(carretera Hospital E10)
          (carretera Hospital E11)(carretera E11 Hospital)
)

(:goal

	( and
        ;; AMBULANCIA
        (en V1 Hospital)
        (en V2 Hospital)
        (en V3 Hospital)
        (en V4 Hospital)
        (en V5 Hospital)
        (en V6 Hospital)
        (en V7 Hospital)
        (en V8 Hospital)
        (en V9 Hospital)
        (en V10 Hospital)

        ; ; ;; POLICIA
        (libre E1 E4)(libre E4 E1)
        (libre E2 E3)(libre E3 E2)
        (libre E4 E5)(libre E5 E4)
        (libre E5 E6)(libre E6 E5)
        (libre E5 E8)(libre E8 E5)
        (libre E7 E8)(libre E8 E7)
        (libre E9 E11)(libre E11 E9)
        (libre E10 Hospital)(libre Hospital E10)

        ; ;; BOMBEROS
        (> 1 (incendio E5))
        (> 1 (incendio E2))
        (> 1 (incendio E5))
        (> 1 (incendio E9))
        (> 1 (incendio E10))
        
	)
)

(:metric minimize (total-time))

)
