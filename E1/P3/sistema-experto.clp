(deftemplate receta
(slot nombre)   ; necesario
(slot introducido_por) ; necesario
(slot numero_personas)  ; necesario
(multislot ingredientes)   ; necesario
(slot dificultad (allowed-symbols alta media baja muy_baja))  ; necesario
(slot duracion)  ; necesario
(slot enlace)  ; necesario
(multislot tipo_plato (allowed-symbols entrante primer_plato plato_principal postre desayuno_merienda acompanamiento)) ; necesario, introducido o deducido en este ejercicio
(slot coste)  ; opcional relevante
(slot tipo_copcion (allowed-symbols crudo cocido a_la_plancha frito al_horno al_vapor))   ; opcional
(multislot tipo_cocina)   ;opcional
(slot temporada)  ; opcional
;;;; Estos slot se calculan, se haria mediante un algoritmo que no vamos a implementar para este prototipo, lo usamos con la herramienta indicada y lo introducimos
(slot Calorias) ; calculado necesario
(slot Proteinas) ; calculado necesario
(slot Grasa) ; calculado necesario
(slot Carbohidratos) ; calculado necesario
(slot Fibra) ; calculado necesario
(slot Colesterol) ; calculado necesario
)

;;; Guardar todas las recetas en la base de hechos
(defrule carga_recetas
(declare (salience 1000))
=>
(load-facts "recetas.txt")
)

;;; Modulo de preguntas
(defmodule preguntas)

(deftemplate informacion
  (slot tipo-comida)
  (slot alimentos-disponibles)
  (slot alimentos-adquiribles)
  (slot para-cuando)
  (slot presupuesto)
  (slot numero-comensales)
  (slot dificultad)
  (slot duracion)
  (slot epoca-ano)
  (slot propiedades-nutricionales)
)


;; Carga el archivo recetas.clp donde están definidos los hechos de las recetas
(load "recetas.clp")

