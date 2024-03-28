;;;;; SISTEMA BASADO EN EL CONOCIMIENTO PARA RECOMENDAR LA CANTIDAD A TOMAR DE UN ALIMENTO  ;;;;;
                  ;;;;; PARA MANTENER UNA DIETA CARDIOSALUDABLE ;;;;;;;;;
				
;;; Fuente de conocimiento: https://fundaciondelcorazon.com/nutricion/piramide-de-alimentacion.html				
				  

;;;ENTRADAS;;;
;;;; (alimento ?a) representará ?a es el alimento sobre el que se pide información
; por ejemplo cuando esté (alimento pan) representará que el usuario desea información sobre el pan

;;; HECHOS DE CONOCIMIENTO
;;;; (es_un_tipo_de ?x ?y) representará ?x es un tipo de ?y
; por ejemplo "los macarrones son un tipo de pasta" se representará (es_un_tipo_de macarrones pasta)
; se introducen de forma explícita algunos, otros se deducen

;;;; (nivel_piramide_alimentaria ?a ?n) representará ?a es un tipo de alimento del nivel ?n de la pirámide alimentaria
; todos se introducen de forma explícita

;;;; (propiedad ?p ?a ?v) representará el valor de la propiedad ?p para ?a es ?v 
; por ejemplo, "la pasta en un alimento rico en hidratos de carbono" se representará (propiedad rico_en_hidratos pasta si)
; se introducen algunos, otros se deducen

(deffacts piramide_alimentaria
(nivel_piramide_alimentaria verdura 1)
(nivel_piramide_alimentaria hortalizas 1)
(nivel_piramide_alimentaria fruta 2)
(nivel_piramide_alimentaria cereales 3)
(nivel_piramide_alimentaria lacteos 4)
(nivel_piramide_alimentaria aceite_de_oliva 5)
(nivel_piramide_alimentaria frutos_secos 6)
(nivel_piramide_alimentaria especies 6)
(nivel_piramide_alimentaria hierbas_aromaticas 6)
(nivel_piramide_alimentaria legumbres 7)
(nivel_piramide_alimentaria carne_blanca 8)
(nivel_piramide_alimentaria pescado 8)
(nivel_piramide_alimentaria huevos 8)
(nivel_piramide_alimentaria carne_roja 9)
(nivel_piramide_alimentaria embutidos 9)
(nivel_piramide_alimentaria fiambres 9)
(nivel_piramide_alimentaria dulces 9)
)


(deffacts subtipos
(es_un_tipo_de carne_roja carne)
(es_un_tipo_de ternera carne_roja)
(es_un_tipo_de cerdo carne_roja)
(es_un_tipo_de cordero carne_roja)
(es_un_tipo_de carne_blanca carne)
(es_un_tipo_de pollo carne_blanca)
(es_un_tipo_de conejo carne_blanca)
(es_un_tipo_de leche lacteos)
(es_un_tipo_de queso lacteos)
(es_un_tipo_de yogur lacteos)
(es_un_tipo_de atun pescado)   
(es_un_tipo_de boquerones pescado)
(es_un_tipo_de sardinas pescado)
(es_un_tipo_de salchichon embutidos)
(es_un_tipo_de chorizo embutidos)
(es_un_tipo_de judias_blancas legumbres)
(es_un_tipo_de garbanzos legumbres)
(es_un_tipo_de guisantes legumbres)
(es_un_tipo_de nueces frutos_secos)
(es_un_tipo_de almendra frutos_secos)
(es_un_tipo_de perejil hierbas_aromaticas)
(es_un_tipo_de pimienta especies)
(es_un_tipo_de pimenton especies)
(es_un_tipo_de cereales_integrales cereales)
(es_un_tipo_de trigo cereales)
(es_un_tipo_de harina cereales)
(es_un_tipo_de maiz cereales)
(es_un_tipo_de sandia fruta)
(es_un_tipo_de pinia fruta)
(es_un_tipo_de platano fruta)
(es_un_tipo_de pera fruta)
(es_un_tipo_de manzana fruta)
(es_un_tipo_de naranja fruta)
(es_un_tipo_de lechuga verdura)
(es_un_tipo_de coliflor verdura)
(es_un_tipo_de brocoli verdura)
(es_un_tipo_de ajo verdura)
(es_un_tipo_de pimiento verdura)
(es_un_tipo_de zanahoria verdura)
(es_un_tipo_de cebolla verdura)
(es_un_tipo_de tomate verdura)
(es_un_tipo_de pimiento_rojo pimiento)
(es_un_tipo_de pimiento_verde pimiento)
(es_un_tipo_de pastel dulces)
(es_un_tipo_de caramelos dulces)
(es_un_tipo_de azucar dulces)
)


(deffacts cantidad_recomendada
(cantidad_recomendada nivel 1 "en raciones de 120-150 gramos" "3-4 veces al dia")
(cantidad_recomendada nivel 2 "en raciones de 150-200 gramos" "2-3 veces al dia")
(cantidad_recomendada nivel 3 "en raciones de 50 gramos" "3 veces al dia")
(cantidad_recomendada nivel 4 "en raciones de 120-150 gramos" "1-2 veces al dia")
(cantidad_recomendada nivel 5 "" "4 cucharadas al dia")
(cantidad_recomendada nivel 6 "en raciones de 25-30 gramos" "1 vez al dia")
(cantidad_recomendada nivel 7 "" "3 veces a la semana")
(cantidad_recomendada nivel 8 "" "3-5 dias a la semana")
(cantidad_recomendada nivel 9 "" "de forma esporadica")
)

(deffacts hecho_de
(compuesto_fundamentalmente_por pan harina)
(compuesto_fundamentalmente_por pasta harina)
(compuesto_fundamentalmente_por pizza harina)
)

(defrule componiendo_es_un_tipo_de
(es_un_tipo_de ?x ?y)
(es_un_tipo_de ?y ?z)
=>
(assert (es_un_tipo_de ?x ?z))
)

(defrule compuesto_fundamentalmente_por_entonces_es_un_tipo_de
(compuesto_fundamentalmente_por ?x ?y)
=>
(assert (es_un_tipo_de ?x ?y))
)


(defrule indicar_nivel_grupo
(alimento ?a)
(nivel_piramide_alimentaria ?a ?n)
=>
(printout t crlf "Pertence al nivel " ?n " de la cadena alimentaria, compuesto por: ")
(assert (nivel ?n))
)

(defrule indicar_nivel_por_tipo
(alimento ?a)
(es_un_tipo_de ?a ?x)
(nivel_piramide_alimentaria ?x ?n)
=>
(printout t crlf "Pertence al nivel " ?n " de la cadena alimentaria, compuesto por: ")
(assert (nivel ?n))
)

(defrule indicar_compuesto_fundamentalmente_por
(declare (salience 2))
(alimento ?a)
(compuesto_fundamentalmente_por ?a ?b)
=>
(printout t crlf "Esta compuesto fundamentalmente por " ?b ", asi que lo clasificaremos como este alimento" crlf)
)

(defrule recomendar_cereales_siempre_integrales
(alimento ?a)
(es_un_tipo_de ?a cereales)
=>
(printout t crlf crlf "Se recomienda que los cereales se tomen siempre integrales")
)

(defrule recomendar_cereales_siempre_integrales2
(alimento cereales)
=>
(printout t crlf crlf "Se recomienda que los cereales se tomen siempre integrales")
)

(defrule recomendar_lacteos_desnatados_o_semidenatados
(alimento ?a)
(es_un_tipo_de ?a lacteos)
=>
(printout t crlf crlf "Se recomienda que los lacteos se tomen desnatados o semidesnatados")
)

(defrule recomendar_lacteos_desnatados_o_semidenatados2
(alimento lacteos)
=>
(printout t crlf crlf "Se recomienda que los lacteos se tomen desnatados o semidesnatados")
)

(defrule describir_nivel
(nivel ?n)
(nivel_piramide_alimentaria ?a ?n)
=>
(printout t "- " ?a "   ")
)


(defrule indicar_cantidad_recomendada
(declare (salience -1))
(nivel ?n)
(cantidad_recomendada nivel ?n ?t1 ?t2)
=>
(printout t crlf crlf "Para el conjunto de los alimentos de este nivel se recomienda consumirlos " ?t1 " " ?t2 crlf crlf)
)

;;;;;; EJERCICIO PARTE 1:  AÑADIR REGLAS PARA LISTAR LOS ALIMENTOS DE LOS QUE SE DISPONE DE INFORMACION ANTES DE PREGUNTAR
;;; Indicaciones: 1) deduce hechos (es_alimento ?x) representando que algo es un alimento a partir de la relacion "es_un_tipo_de", "piramide_alimentaria"
;;;               2) Imprime por pantalla los es_alimento

;;; Deducción de hechos
(defrule deducir_alimento
(es_un_tipo_de ?x ?)
(nivel_piramide_alimentaria ?y ?)
=>
(assert (es_alimento ?x))
(assert (es_alimento ?y))
)

;;; Imprimir por pantalla los es_alimento
(defrule mostrar_alimentos
(declare (salience 6))
=>
(printout t crlf "A continuacion se muestran los alimentos de los que se dispone de informacion: " crlf)
)

(defrule indicar_alimentos
(declare (salience 5))
(es_alimento ?x)
=>
(printout t crlf "- " ?x "   ")
)

;;;;;;;; FIN EJERCICIO PARTE 1 ;;;;;;;;


(defrule preguntar_alimento
=>
(printout t crlf "")
(printout t crlf "Indica el alimento del que deseas saber la cantidad recomendada: " )
(assert (alimento (read)))
)


;;;;;;;; AMPLIANDO EL SISTEMA ;;;;;;;
(deffacts rico_en_proteinas
(propiedad rico_en_proteinas carne si)
(propiedad rico_en_proteinas pescado si)
(propiedad rico_en_proteinas huevos si)
(propiedad rico_en_proteinas lacteos si)
)

(deffacts rico_en_hidratos_de_carbono
(propiedad rico_en_hidratos cereales si)
(propiedad rico_en_hidratos frutos_secos si)
(propiedad rico_en_hidratos legumbres si)
)

(deffacts rico_en_fibras
(propiedad rico_en_fibras fruta si)
(propiedad rico_en_fibras verdura si)
(propiedad rico_en fibras hortalizas si)
(propiedad rico_en_fibras hortalizas si)
)

(deffacts rico_en_grasas
(propiedad rico_en_grasas carne_roja si)
(propiedad rico_en_grasas embutidos si)
(propiedad rico_en_grasas aceite_de_oliva si)
(propiedad rico_en_grasas queso si)  
)

(deffacts rico_en_azucares
(propiedad rico_en_azucares dulces si)
(propiedad rico_en_azucares fruta si)
)

(defrule herencia_propiedades
(propiedad ?p ?a ?v)
(es_un_tipo_de ?x ?a)
=>
(assert (propiedad ?p ?x ?v))
)

(defrule indicar_propiedad_por_tipo
(declare (salience 1))
(alimento ?a)
(es_un_tipo_de ?a ?x)
(nivel_piramide_alimentaria ?x ?)
(propiedad ?p ?x si)
=>
(printout t crlf "Este es un alimento " ?p " porque es un tipo de " ?x crlf)
)


;;;;;; EJERCICIO PARTE 2:  AÑADIR REGLAS PARA INDICAR AL FINAL OTROS ALIMENTOS DEL MISMO NIVEL  DE LA PIRÁMIDE Y CON LAS MISMAS PROPIEDADES
;;; Indicaciones: 1) deduce (alimento_parecido ?x)  para los alimentos pertenezcan del mismo nivel que el alimento sobre el que se pregunta
;;;               2) retracta los alimento_parecido que tengan una propiedad con valor distinto al preguntado, y los que no tengan una propiedad que si 
;;;                  tenga el preguntado, y los que tengan una propiedad que no tenga el preguntado
;;;               3) Imprime por pantalla los alimento_parecido que queden 

;;; Deducción de hechos
; Cuando el alimento introducido es de nivel_piramide_alimentaria
(defrule deducir_alimento_parecido_grupo
(alimento ?a)
; Para filtrar el nivel
(nivel_piramide_alimentaria ?a ?n)
; Para filtrar los alimentos del mismo nivel en nivel_piramide_alimentaria
(nivel_piramide_alimentaria ?x ?n)
; Para filtrar los alimentos del mismo nivel en es_un_tipo_de a partir de los alimentos del mismo nivel en nivel_piramide_alimentaria
(nivel_piramide_alimentaria ?m ?n)
(es_un_tipo_de ?y ?m)
=>
(assert (alimento_parecido ?x))
(assert (alimento_parecido ?y))
)

; Cuando el alimento introducido es de es_un_tipo_de
(defrule deducir_alimento_parecido_tipo
(alimento ?a)
(es_un_tipo_de ?a ?j)
; Para filtrar el nivel
(nivel_piramide_alimentaria ?j ?n)
; Para filtrar los alimentos del mismo nivel en nivel_piramide_alimentaria
(nivel_piramide_alimentaria ?x ?n)
; Para filtrar los alimentos del mismo nivel en es_un_tipo_de a partir de los alimentos del mismo nivel en nivel_piramide_alimentaria
(nivel_piramide_alimentaria ?m ?n)
(es_un_tipo_de ?y ?m)
=>
(assert (alimento_parecido ?x))
(assert (alimento_parecido ?y))
)

;;; Retracción de hechos

; Retractar los alimento_parecido que tengan una propiedad con valor distinto al preguntado o que no tengan una propiedad que si tenga el preguntado
(defrule retractar_alimentos_parecidos
(alimento ?a)
(propiedad ?p ?a ?v)
; Buscar los alimento_parecido que no tengan una propiedad que si tenga el preguntado o que la propiedad tenga un valor distinto 
?NoPropiedad <- (alimento_parecido ?x) (not(propiedad ?p ?x ?v))
=>
(retract ?NoPropiedad)
)

; Retractar los alimento_parecido que tengan tengan distintas propiedades al preguntado
(defrule retractar_alimentos_parecidos2
(alimento ?a)
; Buscar los alimento_parecido que tengan tengan distintas propiedades al preguntado
?NoPropiedad <- (alimento_parecido ?x) (propiedad ?p2 ?x ?v) (not(propiedad ?p2 ?a ?v))
=>
(retract ?NoPropiedad)
)

; Borrar de la lista de alimentos_parecido el alimento sobre el que se pregunta
(defrule borrar_propio_alimento
(alimento ?a)
?x <- (alimento_parecido ?a)
=>
(retract ?x)
)

; Borrar los alimentos_parecido que sí tengan alguna propiedad cuando el preguntado no tenga ninguna
(defrule borrar_si_no_propiedades
(declare (salience -2))
(alimento ?a)
; Comprobar si el preguntado no tiene ninguna propiedad
(not (exists (propiedad ? ?a ?)))
; Buscar los alimento_parecido que sí tengan alguna propiedad
?Borrar <- (alimento_parecido ?x) (propiedad ? ?x ?)
=>
(retract ?Borrar)
)

;;; Imprimir por pantalla los alimento_parecido
(defrule mostrar_alimentos_parecidos
(declare (salience -3))
(exists (alimento_parecido ?))
=>
(printout t "Alimentos pertenecientes al mismo nivel de la piramide y con las mismas propiedades son:" crlf)
)

; Por si no existe ningun alimento_parecido
(defrule no_existe_alimento_parecido
(declare (salience -3))
(alimento ?a)
(or (nivel_piramide_alimentaria ?a ?) (es_un_tipo_de ?a ?))
(not(exists (alimento_parecido ?)))
=>
(printout t "No existe ningun alimento del mismo nivel de la piramide con las mismas propiedades" crlf crlf)
)

(defrule indicar_alimentos_parecidos
(declare (salience -4))
(alimento_parecido ?x)
=>
(printout t "- " ?x "   " crlf)
)

;;;;;;;; FIN EJERCICIO PARTE 2 ;;;;;;;;