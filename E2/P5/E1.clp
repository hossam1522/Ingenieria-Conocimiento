;;;;;;;;;;;;;;;;;;Representación ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (ave ?x) representa “?x es un ave ”
; (animal ?x) representa “?x es un animal”
; (vuela ?x si|no seguro|por_defecto) representa
; “?x vuela si|no con esa certeza”


;;;;;;;;;;;;;;;;;;Hechos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Las aves y los mamíferos son animales
;Los gorriones, las palomas, las águilas y los pingüinos son aves
;La vaca, los perros y los caballos son mamíferos
;Los pingüinos no vuelan
(deffacts datos
(ave gorrion) (ave paloma) (ave aguila) (ave pinguino)
(mamifero vaca) (mamifero perro) (mamifero caballo)
(vuela pinguino no seguro) )


;;;;;;;;;;;;;;;;;;Reglas seguras ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Las aves son animales
(defrule aves_son_animales
(ave ?x)
=>
(assert (animal ?x))
(bind ?expl (str-cat "sabemos que un " ?x " es un animal porque las aves son un tipo de animal"))
(assert (explicacion animal ?x ?expl)) )
; añadimos un hecho que contiene la explicación de la deducción

; Los mamiferos son animales (A3)
(defrule mamiferos_son_animales
(mamifero ?x)
=>
(assert (animal ?x))
(bind ?expl (str-cat "sabemos que un " ?x " es un animal porque los mamiferos son un tipo de animal"))
(assert (explicacion animal ?x ?expl)) )
; añadimos un hecho que contiene la explicación de la deducción


;;;;;;;;;;;;;;;;;;Reglas por defecto ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Casi todos las aves vuela --> puedo asumir por defecto que las aves vuelan
; Asumimos por defecto
(defrule ave_vuela_por_defecto
(declare (salience -1)) ; para disminuir probabilidad de añadir erróneamente
(ave ?x)
=>
(assert (vuela ?x si por_defecto))
(bind ?expl (str-cat "asumo que un " ?x " vuela, porque casi todas las aves vuelan"))
(assert (explicacion vuela ?x ?expl))
)

; Retractamos cuando hay algo en contra
(defrule retracta_vuela_por_defecto
(declare (salience 1)) ; para retractar antes de inferir cosas erroneamente
?f<- (vuela ?x ?r por_defecto)
(vuela ?x ?s seguro)
=>
(retract ?f)
(bind ?expl (str-cat "retractamos que un " ?x " " ?r " vuela por defecto, porque sabemos seguro que " ?x " " ?s " vuela"))
(assert (explicacion retracta_vuela ?x ?expl)) )
;;; COMETARIO: esta regla también elimina los por defecto cuando ya esta seguro 

;;; La mayor parte de los animales no vuelan --> puede interesarme asumir por defecto
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;que un animal no va a volar
(defrule mayor_parte_animales_no_vuelan
(declare (salience -2)) ;;;; es mas arriesgado, mejor después de otros razonamientos
(animal ?x)
(not (vuela ?x ? ?))
=>
(assert (vuela ?x no por_defecto))
(bind ?expl (str-cat "asumo que " ?x " no vuela, porque la mayor parte de los animales no vuelan"))
(assert (explicacion vuela ?x ?expl)) )


;;;;;;;;;;;;;;;;;;Ejercicio ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Preguntar el aniaml
(defrule preguntar_animal
=>
(printout t "De que animal quieres saber si vuela? " crlf)
(assert (pregunta (read))) 
)

; Si no esta en la base de datos, preguntar si es ave o mamifero
(defrule preguntar_ave_o_mamifero
(declare (salience -3))
(pregunta ?x)
(not (ave ?x))
(not (mamifero ?x))
=>
(printout t "Es un ave o un mamifero? " crlf)
(assert (pregunta_ave_o_mamifero ?x (read))) 
)

; Guardamos el tipo de animal
(defrule guardar_ave
(declare (salience -3))
(pregunta_ave_o_mamifero ?x ave)
=>
(assert (ave ?x))
)

(defrule guardar_mamifero
(declare (salience -3))
(pregunta_ave_o_mamifero ?x mamifero)
=>
(assert (mamifero ?x))
)

; Si no se sabe si es ave o mamífero
(defrule no_se_sabe
(declare (salience -3))
(pregunta_ave_o_mamifero ?x ?y)
(not (eq ?y ave))
(not (eq ?y mamifero))
=>
(assert (animal ?x))
)


;;; Elimino las explicaciones sobrantes y solo dejo la importante
(defrule eliminar_explicaciones
(declare (salience -4))
(explicacion retracta_vuela ?x ?expl)
?f <- (explicacion vuela ?x ?)
=>
(retract ?f)
)

(defrule eliminar_explicaciones_animal
(declare (salience -4))
?f <- (explicacion animal ?x ?)
=>
(retract ?f)
)

;;; Mostrar los resultados

(defrule animal_es_ave
(declare (salience -100))
(pregunta ?x)
(ave ?x)
(explicacion ? ?x ?expl)
=>
(printout t ?x " es un ave y " ?expl crlf)
)

(defrule animal_es_mamifero
(declare (salience -100))
(pregunta ?x)
(mamifero ?x)
(explicacion ? ?x ?expl)
=>
(printout t ?x " es un mamifero y " ?expl crlf)
)

(defrule animal_es_otro
(declare (salience -100))
(pregunta ?x)
(animal ?x)
(explicacion ? ?x ?expl)
(not (ave ?x))
(not (mamifero ?x))
=>
(printout t ?x " es otro tipo de animal y " ?expl crlf)
)