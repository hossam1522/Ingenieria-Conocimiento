;;;;;;;;;;;;;;;;;;Representación ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (FactorCerteza ?h si|no ?f) representa que ?h se ha deducido con factor de certeza ?f
;?h podrá_ser:
; - problema_starter
; - problema_bujias
; - problema_batería
; - motor_llega_gasolina
; (Evidencia ?e si|no) representa el hecho de si evidencia ?e se da
; ?e podrá ser:
; - hace_intentos_arrancar
; - hay_gasolina_en_deposito
; - encienden_las_luces
; - gira_motor


;;;;;;;;;;;;;;;;;;Reglas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; convertimos cada evidencia en una afirmación sobre su factor de certeza
(defrule certeza_evidencias
(Evidencia ?e ?r)
=>
(assert (FactorCerteza ?e ?r 1)) )
;; También podríamos considerar evidencias con una cierta
;;incertidumbre: al preguntar por la evidencia, pedir y recoger
;;directamente el grado de certeza


(deffunction encadenado (?fc_antecedente ?fc_regla)
(if (> ?fc_antecedente 0)
then
(bind ?rv (* ?fc_antecedente ?fc_regla))
else
(bind ?rv 0) )
?rv)


(deffunction combinacion (?fc1 ?fc2)
(if (and (> ?fc1 0) (> ?fc2 0) )
then
(bind ?rv (- (+ ?fc1 ?fc2) (* ?fc1 ?fc2) ) )
else
(if (and (< ?fc1 0) (< ?fc2 0) )
then
(bind ?rv (+ (+ ?fc1 ?fc2) (* ?fc1 ?fc2) ) )
else
(bind ?rv (/ (+ ?fc1 ?fc2) (- 1 (min (abs ?fc1) (abs ?fc2))) ))
)
)
?rv)


;;;;;; Combinar misma deduccion por distintos caminos
(defrule combinar
(declare (salience 1))
?f <- (FactorCerteza ?h ?r ?fc1)
?g <- (FactorCerteza ?h ?r ?fc2)
(test (neq ?fc1 ?fc2))
=>
(retract ?f ?g)
(assert (FactorCerteza ?h ?r (combinacion ?fc1 ?fc2))) )



; Aunque en este ejemplo no se da, puede ocurrir que tengamos
; deducciones de hipótesis en positivo y negativo que hay que
; combinar para compararlas
(defrule combinar_signo
(declare (salience 2))
(FactorCerteza ?h si ?fc1)
(FactorCerteza ?h no ?fc2)
=>
(assert (Certeza ?h (- ?fc1 ?fc2))) )


;R1: SI el motor obtiene gasolina Y el motor gira ENTONCES problemas con las bujías con certeza 0,7
(defrule R1
(FactorCerteza motor_llega_gasolina si ?f1)
(FactorCerteza gira_motor si ?f2)
(test (and (> ?f1 0) (> ?f2 0)))
=>
(assert (FartorCerteza problema_bujias si (encadenado (* ?f1 ?f2) 0,7))))

;R2: SI NO gira el motor ENTONCES problema con el starter con certeza 0,8 con las bujías con certeza 0,7
(defrule R2
(FactorCerteza gira_motor no ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza problema_starter si (encadenado ?f1 0.8))))

;R3: SI NO encienden las luces ENTONCES problemas con la bateria con certeza 0.9
(defrule R3
(FactorCerteza encienden_las_luces no ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza problema_bateria si (encadenado ?f1 0.9))))

;R4: SI hay gasolina en el deposito ENTONCES el motor obtiene gasolina con certeza 0,9
(defrule R4
(FactorCerteza hay_gasolina_en_deposito si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza motor_llega_gasolina si (encadenado ?f1 0.9))))

;R5: SI hace intentos de arrancar ENTONCES problema con el starter con certeza -0,6
(defrule R5
(FactorCerteza hace_intentos_arrancar si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza problema_starter si (encadenado ?f1 -0.6))))

;R6: SI hace intentos de arrancar ENTONCES problema con la batería 0,5
(defrule R6
(FactorCerteza hace_intentos_arrancar si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza problema_bateria si (encadenado ?f1 0.5))))



;;;;;;;;;;;;;;;;;;Ejercicio ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Preguntar qué ocurre con el coche
(defrule pregunta_hace_intentos_arrancar
(declare (salience 100))
=>
(printout t "Hace intentos de arrancar? (Responda si o no)" crlf)
(bind ?r (read))
(while (not (or (eq ?r si) (eq ?r no)))
  (printout t "Por favor, responda si o no" crlf)
  (bind ?r (read)))
(assert (Evidencia hace_intentos_arrancar ?r))
)

(defrule pregunta_hay_gasolina_en_deposito
(declare (salience 100))
=>
(printout t "Hay gasolina en el deposito? (Responda si o no)" crlf)
(bind ?r (read))
(while (not (or (eq ?r si) (eq ?r no)))
  (printout t "Por favor, responda si o no" crlf)
  (bind ?r (read)))
(assert (Evidencia hay_gasolina_en_deposito ?r))
)

(defrule pregunta_encienden_las_luces
(declare (salience 100))
=>
(printout t "Encienden las luces? (Responda si o no)" crlf)
(bind ?r (read))
(while (not (or (eq ?r si) (eq ?r no)))
  (printout t "Por favor, responda si o no" crlf)
  (bind ?r (read)))
(assert (Evidencia encienden_las_luces ?r))
)

(defrule pregunta_gira_motor
(declare (salience 100))
=>
(printout t "El motor gira? (Responda si o no)" crlf)
(bind ?r (read))
(while (not (or (eq ?r si) (eq ?r no)))
  (printout t "Por favor, responda si o no" crlf)
  (bind ?r (read)))
(assert (Evidencia gira_motor ?r))
)


;;; Sacar hipotesis con mayor factor de certeza

; Eliminar factores de certeza introducidos para solo dejar los deducidos
(defrule eliminar_factores
(declare (salience -1))
(Evidencia ?h ?)
?f <- (FactorCerteza ?h ? ?)
=>
(retract ?f)
)

; Hipotesis inicial
(defrule hipotesis_inicial
=>
(assert (hipotesis problema 0))
)

; Sacar hipotesis con mayor factor de certeza
(defrule sacar_hipotesis
(declare (salience -2))
(FactorCerteza ?h si ?fc)
?f <- (hipotesis ? ?d)
=>
(if (> ?fc ?d)
then
(retract ?f)
(assert (hipotesis ?h ?fc))
)
)

;;; Mostrar hipotesis con mayor factor de certeza y por qué
(defrule mostrar_hipotesis
(declare (salience -3))
(hipotesis ?h ?fc)
=>
(printout t "Con un " (* ?fc 100) "% de certeza, el problema es " ?h " ya que es el que mas porcentaje de certeza tiene y, por lo tanto, el mas seguro." crlf)
)