import pyhop

def select_new_road(state, veh, loc_dst):  #evaluation function
    loc_ini = state.location[veh]
    next_road = None
    avoid = visited[veh]
    flag = loc_dst in state.connection[loc_ini].keys() and not state.bloqueado[loc_ini][loc_dst]

    if not flag:
        for c in state.connection[loc_ini].keys():        
            if not state.bloqueado[loc_ini][c] and c not in avoid:
                next_road = c
                avoid.append(next_road)        
                visited[veh] = avoid
                break
    else:
        next_road = loc_dst

    return next_road            

#######################################################################
######      OPERADORES          #######################################

def mover_op(state,loc_dst,veh):
    loc_ini=state.location[veh]  
    if loc_dst in state.connection[loc_ini]:
        state.location[veh] = loc_dst
        distancia = state.connection[loc_ini][loc_dst]
        velocidad = state.velocidad[veh]
        state.cost[veh] += ( distancia / velocidad)
        return state
    else: return False


def extinguir_op(state, veh, loc_dst):
    loc_ini=state.location[veh]  

    if state.fire[loc_ini] and loc_ini == loc_dst:
        if state.water[veh] >= state.water_cost:
            state.water[veh] -= state.water_cost
            state.fire[loc_ini] = False
            state.cost[veh] += 10
            return state
    return False

def recargar_op(state, veh):
    loc_ini=state.location[veh] 

    if loc_ini == state.recharge_water[veh]:
        state.cost[veh] += (state.water_capacity - state.water[veh]) / 10
        state.water[veh] = state.water_capacity
        return state
    return False

def desbloquear_op(state, veh, loc_a, loc_b):
    loc_ini=state.location[veh]  

    if loc_ini == loc_a and state.bloqueado[loc_a][loc_b]:
        state.bloqueado[loc_a][loc_b] = False
        state.bloqueado[loc_b][loc_a] = False
        state.cost[veh] += 10
        return state
    else: return False

def rescatar_op(state, veh, vic):
    loc_amb = state.location[veh] 
    loc_vic = state.atrapado[vic]['location']
    if loc_amb == loc_vic and state.atrapado[vic]['atrapado']:
        state.atrapado[vic]['atrapado'] = False  
        state.cost[veh] += 10 
        return state   
    return False

def cargar_op(state, veh, vic):
    loc_amb = state.location[veh]
    loc_vic = state.atrapado[vic]['location']
    amb_is_free = len(state.ambulance_vic[veh]) == 0
    if loc_amb == loc_vic and not state.atrapado[vic]['atrapado'] and amb_is_free:
        state.atrapado[vic]['location'] = veh
        state.ambulance_vic[veh].append(vic)
        state.cost[veh] += 10
        return state   
    return False

def descargar_op(state, veh, vic):
    amb_patients = state.ambulance_vic[veh]
    loc_amb = state.location[veh]
    if loc_amb == 'Hospital' and vic in amb_patients:
        state.atrapado[vic]['location'] = 'Hospital'
        patient = state.ambulance_vic[veh].index(vic)
        state.ambulance_vic[veh].pop(patient)
        state.cost[veh] += 10
        return state   
    return False

pyhop.declare_operators(mover_op, extinguir_op, recargar_op, desbloquear_op, rescatar_op, cargar_op, descargar_op)
print('')
pyhop.print_operators()


########################################################################
####    METODOS   MOVER    #############################################
def mover_m(state,goal):
    veh, loc_dst = goal.final  
    loc_ini = state.location[veh]
    if loc_dst!=loc_ini:
        z=select_new_road(state, veh, loc_dst)     
        if z is not None:            
            g=pyhop.Goal('g')
            g.final=(veh,loc_dst)
            return [('mover_op',z, veh), ('mover',g)]    
    return False

def already_there(state, goal):    
    # Método para parrar la recursión
    veh, loc_dst = goal.final
    loc_ini = state.location[veh]
    if loc_dst==loc_ini:
        # Resetear los visitados una vez se ha llegado al destino
        visited[veh] = [loc_ini]        
        return []
    else:
        # Fase Backtracking para buscar otro camino alternativo que no se ha visitado aún
        z=select_new_road(state, veh, loc_dst)
        if z is not None:
            g=pyhop.Goal('g')
            g.final=(veh,loc_dst)
            return [('mover_op',z,veh), ('mover',g)] 
    return False

pyhop.declare_methods('mover',mover_m, already_there)
print('')
pyhop.print_methods()

########################################################################
####    METODOS   EXTINGUIR   ##########################################
def extinguish_m(state, goal):
    veh, loc_dst = goal.final  

    if state.fire[loc_dst]:        
        g=pyhop.Goal('g')
        g.final=(veh,loc_dst)
        # EXTINGUIR
        if state.water[veh] >= state.water_cost:
            return [('mover',g),('extinguir_op',veh, loc_dst)]            
    return False

def recharge_extinguish_m(state, goal):
    veh, loc_dst = goal.final  

    if state.fire[loc_dst]:        
        g=pyhop.Goal('g')
        g.final=(veh,loc_dst)
        # EXTINGUIR
        if state.water[veh] < state.water_cost:
            rechg = pyhop.Goal('recharge_water')
            loc_rechg = state.recharge_water[veh]
            rechg.final = (veh, loc_rechg)
            return [('mover',rechg),('recargar_op',veh),('mover',g),('extinguir',g)]
    return False

pyhop.declare_methods('extinguir', extinguish_m, recharge_extinguish_m)

########################################################################
####    METODOS   DESBLOQUEAR   ########################################
def desbloquear_m(state, goal):
    veh, loc_a, loc_b = goal.final 
    
    if state.bloqueado[loc_a][loc_b]:
        g=pyhop.Goal('g')
        g.final=(veh, loc_a)
        return [('mover',g),('desbloquear_op', veh, loc_a, loc_b)]
    return False

pyhop.declare_methods('desbloquear', desbloquear_m)

########################################################################
####    METODOS   RESCATAR      ########################################
def rescatar_m(state, goal):
    veh, loc_dst, vic = goal.final  
    loc_ini = state.location[veh]
    if loc_dst!=loc_ini:
        g=pyhop.Goal('go_rescue')
        g.final=(veh,loc_dst)
        hosp=pyhop.Goal('go_hospital')
        hosp.final=(veh,'Hospital')
        return [('mover',g),('rescatar_op', veh, vic),('cargar_op',veh,vic),('mover',hosp),('descargar_op',veh,vic)]
    return False


pyhop.declare_methods('rescatar', rescatar_m)
##########################################################################

#INITIAL STATE

state = pyhop.State('State')


state.connection = {'E1':{'E2':25,'E6':15, 'Hospital':30},
            'E2':{'E1':25,'E3':45}, 
            'E3':{'E2':45,'E4':25},
            'E4':{'E3':25,'E5':35, 'Hospital':30, 'EstacionBomberos':20},
            'E5':{'E4':35,'E6':25},#'EstacionBomberos':15},
            'E6':{'E1':15,'E5':25},
            'Hospital':{'E1':30, 'E4':30},
            'EstacionBomberos':{'E4':20},# 'E5':15},
            }

state.bloqueado = {'E1':{'E2':False,'E6':False, 'Hospital':True},
            'E2':{'E1':False,'E3':False}, 
            'E3':{'E2':False,'E4':True},
            'E4':{'E3':True,'E5':False, 'Hospital':False, 'EstacionBomberos':False},
            'E5':{'E4':False,'E6':False},#'EstacionBomberos':False},
            'E6':{'E1':False,'E5':False},
            'Hospital':{'E1':True, 'E4':False},
            'EstacionBomberos':{'E4':False}#,'E5':False},
            }
state.fire = {'E1':True,
            'E2':True, 
            'E3':False,
            'E4':False,
            'E5':False,
            'E6':True,
            'Hospital':False,
            'EstacionBomberos':False,
            }

state.atrapado = {'V1':{'location':"E3",'atrapado':True},
                  'V2':{'location':"E5",'atrapado':True},
                }

state.location = {'A':'Hospital', 'B': 'EstacionBomberos', 'P': 'EstacionBomberos'}
state.cost = {'A':0, 'B': 0, 'P': 0}    
state.velocidad = {'A': 5, 'B': 5, 'P': 5}
state.water = {'B':50}
state.water_cost = 20
state.water_capacity = 50
state.recharge_water = {'B':'EstacionBomberos'}
state.ambulance_vic = {'A':[]}
# state.type = {'A':'amb','B':'bom','P':'pol'}
# state.vehicles = {'A','P','B'}
visited = {'A':['Hospital'],'P':['EstacionBomberos'],'B':['EstacionBomberos']}

#GOALS
goal_rescue_v1 = pyhop.Goal('rescue V1')
goal_rescue_v1.final = ('A','E3','V1')

goal_rescue_v2 = pyhop.Goal('rescue V2')
goal_rescue_v2.final = ('A','E5','V2')

goal_desbloq_1 = pyhop.Goal('desbloquear E3-E4')
goal_desbloq_1.final = ('P','E3','E4')

goal_desbloq_2 = pyhop.Goal('desbloquear E1-Hospital')
goal_desbloq_2.final = ('P','E1','Hospital')

goal_ext_1 = pyhop.Goal('extinguir E1')
goal_ext_1.final = ('B','E1')

goal_ext_2 = pyhop.Goal('extinguir E2')
goal_ext_2.final = ('B','E2')

goal_ext_3 = pyhop.Goal('extinguir E6')
goal_ext_3.final = ('B','E6')

print('- If verbose=3, Pyhop also prints the intermediate states:')

pyhop.pyhop(state,[                      
                    ('extinguir', goal_ext_1),
                    ('extinguir', goal_ext_2),
                    ('extinguir', goal_ext_3), 
                    ('rescatar',goal_rescue_v1),
                    ('rescatar',goal_rescue_v2),                                        
                    ('desbloquear',goal_desbloq_1),
                    ('desbloquear',goal_desbloq_2),                    
                                        
                  ],verbose=3)
"""
Importante para depurar:

Necesitamos: import pdb

Ponemos la instruccion "pdb.set_trace()" donde queramos en nuestro codigo y se detendra la ejecucion
Luego simplemente escribimos la letra 'n' desde el shell que ejecutara la siguiente sentencia y podemos ir
viendo el valor de las variables
"""
