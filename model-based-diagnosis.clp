						;;;;; THE PROGRAM RUNS IN CLIPS 6.3 ;;;;;;

;DEFINE ALL CLASSES
(defclass systemEntity
	(is-a USER)
	(role abstract)
	(slot suspect
		(type SYMBOL)
		(allowed-values yes no)
		(default no)
		;(cardinality 0 1)
		(create-accessor read-write))
	(slot out
		(type INTEGER)
		(range 0 31)
		;(cardinality 0 1)
		(create-accessor read-write)))

(defclass command
	(is-a systemEntity)
	(role concrete)
	(pattern-match reactive))

(defclass component
	(is-a systemEntity)
	(role abstract))

(defclass sensor
	(is-a component)
	(role concrete)
	(pattern-match reactive)
	(slot theoretical
		(type INTEGER)
		(range 0 31)
		;(cardinality 0 1)
		(create-accessor read-write))
	(slot out
		(type INTEGER)
		(range 0 31)
		;(cardinality 0 0)
		(create-accessor read-write))
	(slot reading
		(type INTEGER)
		(range 0 31)
		;(cardinality 0 1)
		(create-accessor read-write))
	(slot input
		(type INSTANCE)
		(allowed-classes internal-component)
		;(cardinality 0 1)
		(create-accessor read-write)))

(defclass internal-component
	(is-a component)
	(role concrete)
	(pattern-match reactive)
	(slot short-out
		(type INTEGER)
		(range 0 0)
		(default 0)
		;(cardinality 0 1)
		(create-accessor read-write))
	(multislot output
		(type INSTANCE)
		(allowed-classes component)
		(create-accessor read-write))
	(slot msb-out
		(type INTEGER)
		(range 0 15)
		;(cardinality 0 1)
		(create-accessor read-write))
	(slot input2
		(type INSTANCE)
		(allowed-classes systemEntity)
		;(cardinality 0 1)
		(create-accessor read-write))
	(slot input1
		(type INSTANCE)
		(allowed-classes systemEntity)
		;(cardinality 0 1)
		(create-accessor read-write)))

(defclass adder
	(is-a internal-component)
	(pattern-match reactive)
	(role concrete))

;message-handler function for calculate the sum of 2 numbers,then module them
(defmessage-handler adder calculate-add primary (?inp1 ?inp2 ?flag)
	(if (= ?flag 1)
	then
		(return (mod (+ ?inp1 ?inp2) 32))
	else
		(return (mod (+ ?inp1 ?inp2) 16))	
	)
)

(defclass multiplier
	(is-a internal-component)
	(pattern-match reactive)
	(role concrete))

;message-handler function for calculate the multiplication of 2 numbers
(defmessage-handler multiplier calculate-multiply primary (?inp1 ?inp2 ?flag)
	(if (= ?flag 1)
	then
		(return (mod (* ?inp1 ?inp2) 32));for regular output
	else
		(return (mod (* ?inp1 ?inp2) 16)) ;for msb output	
	)
)
(defclass circuit
	(is-a systemEntity)
	(role concrete)
	(multislot outputs
		(type INSTANCE)
		(allowed-classes sensor)
		(create-accessor read-write))
	(multislot has-components
		(type INSTANCE)
		(allowed-classes component)
		(create-accessor read-write))
	(multislot inputs
		(type INSTANCE)
		(allowed-classes command)
		(create-accessor read-write)))

(defclass data
	(is-a USER)
	(role abstract)
	(slot clock
		(type INTEGER)
		(range 1 ?VARIABLE)
		;(cardinality 0 1)
		(create-accessor read-write))
	(slot object
		(type INSTANCE)
		(allowed-classes systemEntity)
		;(cardinality 0 1)
		(create-accessor read-write))
	(slot value
		(type INTEGER)
		;(cardinality 0 1)
		(create-accessor read-write)))

(defclass command_data
	(is-a data)
	(role concrete)
	(pattern-match reactive)
	(slot object
		(type INSTANCE)
		(allowed-classes command)
		;(cardinality 0 1)
		(create-accessor read-write)))

(defclass reading_data
	(is-a data)
	(role concrete)
	(pattern-match reactive)
	(slot object
		(type INSTANCE)
		(allowed-classes sensor)
		;(cardinality 0 1)
		(create-accessor read-write)))

;DEFINE ALL INSTANCES		
(definstances facts
([a1] of  adder

	(input1 [input_1])
	(input2 [input_1])
	(output
		[m1]
		[p1])
	(short-out 0)
	(suspect no))

([a2] of  adder

	(input1 [p1])
	(input2 [p2])
	(output [out1])
	(short-out 0)
	(suspect no))

([circuit_1] of  circuit

	(has-components
		[m1]
		[m2]
		[m3]
		[out1]
		[a1]
		[a2]
		[p1]
		[p2])
	(inputs
		[input_1]
		[input_2]
		[input_3]
		[input_4])
	(outputs [out1])
	(suspect no))

([command_10_inp1] of  command_data

	(clock 10)
	(object [input_1])
	(value 6))

([command_10_inp2] of  command_data

	(clock 10)
	(object [input_2])
	(value 4))

([command_10_inp3] of  command_data

	(clock 10)
	(object [input_3])
	(value 25))

([command_10_inp4] of  command_data

	(clock 10)
	(object [input_4])
	(value 12))

([command_1_inp1] of  command_data

	(clock 1)
	(object [input_1])
	(value 21))

([command_1_inp2] of  command_data

	(clock 1)
	(object [input_2])
	(value 28))

([command_1_inp3] of  command_data

	(clock 1)
	(object [input_3])
	(value 10))

([command_1_inp4] of  command_data

	(clock 1)
	(object [input_4])
	(value 25))

([command_2_inp1] of  command_data

	(clock 2)
	(object [input_1])
	(value 7))

([command_2_inp2] of  command_data

	(clock 2)
	(object [input_2])
	(value 25))

([command_2_inp3] of  command_data

	(clock 2)
	(object [input_3])
	(value 13))

([command_2_inp4] of  command_data

	(clock 2)
	(object [input_4])
	(value 15))

([command_3_inp1] of  command_data

	(clock 3)
	(object [input_1])
	(value 11))

([command_3_inp2] of  command_data

	(clock 3)
	(object [input_2])
	(value 17))

([command_3_inp3] of  command_data

	(clock 3)
	(object [input_3])
	(value 24))

([command_3_inp4] of  command_data

	(clock 3)
	(object [input_4])
	(value 31))

([command_4_inp1] of  command_data

	(clock 4)
	(object [input_1])
	(value 18))

([command_4_inp2] of  command_data

	(clock 4)
	(object [input_2])
	(value 11))

([command_4_inp3] of  command_data

	(clock 4)
	(object [input_3])
	(value 28))

([command_4_inp4] of  command_data

	(clock 4)
	(object [input_4])
	(value 21))

([command_5_inp1] of  command_data

	(clock 5)
	(object [input_1])
	(value 25))

([command_5_inp2] of  command_data

	(clock 5)
	(object [input_2])
	(value 24))

([command_5_inp3] of  command_data

	(clock 5)
	(object [input_3])
	(value 30))

([command_5_inp4] of  command_data

	(clock 5)
	(object [input_4])
	(value 10))

([command_6_inp1] of  command_data

	(clock 6)
	(object [input_1])
	(value 12))

([command_6_inp2] of  command_data

	(clock 6)
	(object [input_2])
	(value 19))

([command_6_inp3] of  command_data

	(clock 6)
	(object [input_3])
	(value 11))

([command_6_inp4] of  command_data

	(clock 6)
	(object [input_4])
	(value 19))

([command_7_inp1] of  command_data

	(clock 7)
	(object [input_1])
	(value 1))

([command_7_inp2] of  command_data

	(clock 7)
	(object [input_2])
	(value 31))

([command_7_inp3] of  command_data

	(clock 7)
	(object [input_3])
	(value 7))

([command_7_inp4] of  command_data

	(clock 7)
	(object [input_4])
	(value 22))

([command_8_inp1] of  command_data

	(clock 8)
	(object [input_1])
	(value 0))

([command_8_inp2] of  command_data

	(clock 8)
	(object [input_2])
	(value 31))

([command_8_inp3] of  command_data

	(clock 8)
	(object [input_3])
	(value 3))

([command_8_inp4] of  command_data

	(clock 8)
	(object [input_4])
	(value 23))

([command_9_inp1] of  command_data

	(clock 9)
	(object [input_1])
	(value 31))

([command_9_inp2] of  command_data

	(clock 9)
	(object [input_2])
	(value 1))

([command_9_inp3] of  command_data

	(clock 9)
	(object [input_3])
	(value 6))

([command_9_inp4] of  command_data

	(clock 9)
	(object [input_4])
	(value 8))

([input_1] of  command

	(suspect no))

([input_2] of  command

	(suspect no))

([input_3] of  command

	(suspect no))

([input_4] of  command

	(suspect no))

([m1] of  sensor

	(input [a1])
	(suspect no))

([m2] of  sensor

	(input [p1])
	(suspect no))

([m3] of  sensor

	(input [p2])
	(suspect no))

([out1] of  sensor

	(input [a2])
	(suspect no))

([p1] of  multiplier

	(input1 [input_2])
	(input2 [a1])
	(output
		[m2]
		[a2])
	(short-out 0)
	(suspect no))

([p2] of  multiplier

	(input1 [input_3])
	(input2 [input_4])
	(output
		[m3]
		[a2])
	(short-out 0)
	(suspect no))

([reading_10_m1] of  reading_data

	(clock 10)
	(object [m1])
	(value 12))

([reading_10_m2] of  reading_data

	(clock 10)
	(object [m2])
	(value 31))

([reading_10_m3] of  reading_data

	(clock 10)
	(object [m3])
	(value 12))

([reading_10_out] of  reading_data

	(clock 10)
	(object [out1])
	(value 28))

([reading_1_m1] of  reading_data

	(clock 1)
	(object [m1])
	(value 10))

([reading_1_m2] of  reading_data

	(clock 1)
	(object [m2])
	(value 24))

([reading_1_m3] of  reading_data

	(clock 1)
	(object [m3])
	(value 26))

([reading_1_out] of  reading_data

	(clock 1)
	(object [out1])
	(value 18))

([reading_2_m1] of  reading_data

	(clock 2)
	(object [m1])
	(value 0))

([reading_2_m2] of  reading_data

	(clock 2)
	(object [m2])
	(value 0))

([reading_2_m3] of  reading_data

	(clock 2)
	(object [m3])
	(value 3))

([reading_2_out] of  reading_data

	(clock 2)
	(object [out1])
	(value 3))

([reading_3_m1] of  reading_data

	(clock 3)
	(object [m1])
	(value 22))

([reading_3_m2] of  reading_data

	(clock 3)
	(object [m2])
	(value 6))

([reading_3_m3] of  reading_data

	(clock 3)
	(object [m3])
	(value 8))

([reading_3_out] of  reading_data

	(clock 3)
	(object [out1])
	(value 14))

([reading_4_m1] of  reading_data

	(clock 4)
	(object [m1])
	(value 4))

([reading_4_m2] of  reading_data

	(clock 4)
	(object [m2])
	(value 12))

([reading_4_m3] of  reading_data

	(clock 4)
	(object [m3])
	(value 12))

([reading_4_out] of  reading_data

	(clock 4)
	(object [out1])
	(value 0))

([reading_5_m1] of  reading_data

	(clock 5)
	(object [m1])
	(value 18))

([reading_5_m2] of  reading_data

	(clock 5)
	(object [m2])
	(value 16))

([reading_5_m3] of  reading_data

	(clock 5)
	(object [m3])
	(value 12))

([reading_5_out] of  reading_data

	(clock 5)
	(object [out1])
	(value 12))

([reading_6_m1] of  reading_data

	(clock 6)
	(object [m1])
	(value 8))

([reading_6_m2] of  reading_data

	(clock 6)
	(object [m2])
	(value 24))

([reading_6_m3] of  reading_data

	(clock 6)
	(object [m3])
	(value 17))

([reading_6_out] of  reading_data

	(clock 6)
	(object [out1])
	(value 9))

([reading_7_m1] of  reading_data

	(clock 7)
	(object [m1])
	(value 2))

([reading_7_m2] of  reading_data

	(clock 7)
	(object [m2])
	(value 0))

([reading_7_m3] of  reading_data

	(clock 7)
	(object [m3])
	(value 26))

([reading_7_out] of  reading_data

	(clock 7)
	(object [out1])
	(value 26))

([reading_8_m1] of  reading_data

	(clock 8)
	(object [m1])
	(value 0))

([reading_8_m2] of  reading_data

	(clock 8)
	(object [m2])
	(value 0))

([reading_8_m3] of  reading_data

	(clock 8)
	(object [m3])
	(value 0))

([reading_8_out] of  reading_data

	(clock 8)
	(object [out1])
	(value 0))

([reading_9_m1] of  reading_data

	(clock 9)
	(object [m1])
	(value 30))

([reading_9_m2] of  reading_data

	(clock 9)
	(object [m2])
	(value 30))

([reading_9_m3] of  reading_data

	(clock 9)
	(object [m3])
	(value 0))

([reading_9_out] of  reading_data

	(clock 9)
	(object [out1])
	(value 30))

)
;RULES BEGINNING
(defrule begin
	?x <- (initial-fact)

  =>
  	(retract ?x)
  	(set-strategy mea)
  	(assert (print clock-time))  
  	(assert (time 1)) ;fact that defines the current cycle after every execution 
)
(defrule print-clock-time
	?x <- (print clock-time)
	(time ?t)

=>
	(retract ?x)
	(printout t "------ CLOCK: " ?t " ------" crlf)
	(assert (goal bind-values))
)
;rule for binding the values from the data to the sensors and inputs
(defrule bind-values
	?x <- (goal bind-values)
	(time ?t)
	(object (is-a command_data) (clock ?t) (value ?v) (object ?input))
	(object (is-a reading_data) (clock ?t) (value ?v1) (object ?sensor))
=>
	(modify-instance ?input (out ?v))
	(modify-instance ?sensor (reading ?v1))

	(printout t "Binding values..." crlf)

)

;rule changer after successfully binding the values to sensors and inputs
(defrule change-goal-to-calc-a1-output
	?x <- (goal bind-values)
	(time ?t)
  =>
  	(retract ?x)
  	(assert (goal calc-a1-output))
)

;rule for calculating the adder [a1] out and msb-out slots
;SLOT out: declares the output of : (in1+in2) mod 32
;SLOT msb-out: declares the output of : (in1+in2) mod 16
(defrule calc-a1-output
   ?x <- (goal calc-a1-output)

=>
	(printout t "Calculating the output values of A1" crlf)
   	(retract ?x)

	;bind the 2 inputs of [a1] to 2 variables 
	(bind ?input1 (send [a1] get-input1))
    	(bind ?input2 (send [a1] get-input2))

   	;bind the result of the inputs to 2 variables
	(bind ?value1 (send ?input1 get-out))
    	(bind ?value2 (send ?input2 get-out))


	;calculate the sum of 2 numbers MOD 32
    	(modify-instance [a1] (out (send [a1] calculate-add ?value1 ?value2 1)))

	;calculate the sum of 2 numbers MOD 16
	(modify-instance [a1] (msb-out (send [a1] calculate-add ?value1 ?value2 0)))
	   
 	(assert (goal calc-p1-output))
)

;rule for calculating the multiplier [p1] out and msb-out slots
;SLOT out: declares the output of : (in1*in2) mod 32
;SLOT msb-out: declares the output of : (in1*in2) mod 16

(defrule calc-p1-output
   ?x <- (goal calc-p1-output)

=>
   (printout t "Calculating the output values of P1" crlf)
   (retract ?x)

   ;bind the 2 inputs of [p1] to 2 variables 
   (bind ?input1 (send [p1] get-input1))
   (bind ?input2 (send [p1] get-input2))

   ;bind the result of the inputs to 2 variables
   (bind ?value1 (send ?input1 get-out))
   (bind ?value2 (send ?input2 get-out))

   ;calculate the multiplication of 2 numbers MOD 32
   (modify-instance [p1] (out (send [p1] calculate-multiply ?value1 ?value2 1)))

   ;calculate the multiplication of 2 numbers MOD 16
   (modify-instance [p1] (msb-out (send [p1] calculate-multiply ?value1 ?value2 0)))

   (assert (goal calc-p2-output))
   
)
;rule for calculating the multiplier [p2] out and msb-out slots
;SLOT out: declares the output of : (in1*in2) mod 32
;SLOT msb-out: declares the output of : (in1*in2) mod 16
(defrule calc-p2-output
   ?x <- (goal calc-p2-output)

=>
   (printout t "Calculating the output values of P2" crlf)
   (retract ?x)
   ;bind the 2 inputs of [p2] to 2 variables 
   (bind ?input1 (send [p2] get-input1))
   (bind ?input2 (send [p2] get-input2))

   ;bind the result of the inputs to 2 variables
   (bind ?value1 (send ?input1 get-out))
   (bind ?value2 (send ?input2 get-out))

   ;calculate the multiplication of 2 numbers MOD 32
   (modify-instance [p2] (out (send [p2] calculate-multiply ?value1 ?value2 1)))

   ;calculate the multiplication of 2 numbers MOD 16
   (modify-instance [p2] (msb-out (send [p2] calculate-multiply ?value1 ?value2 0)))

   (assert (goal calc-a2-output))

)

;rule for calculating the adder [a2] out and msb-out slots
;SLOT out: declares the output of : (in1+in2) mod 32
;SLOT msb-out: declares the output of : (in1+in2) mod 16
(defrule calc-a2-output
   ?x <- (goal calc-a2-output)

=>
   (printout t "Calculating the output values of A2" crlf)
   (retract ?x)

   ;bind the 2 inputs of [a2] to 2 variables 
   (bind ?input1 (send [a2] get-input1))
   (bind ?input2 (send [a2] get-input2))

   ;bind the result of the inputs to 2 variables
   (bind ?value1 (send ?input1 get-out))
   (bind ?value2 (send ?input2 get-out))

   ;calculate the sum of 2 numbers MOD 32
   (modify-instance [a2] (out (send [a2] calculate-add ?value1 ?value2 1)))

   ;calculate the sum of 2 numbers MOD 16
   (modify-instance [a2] (msb-out (send [a2] calculate-add ?value1 ?value2 0)))

   (assert (goal assign-sensor-out-values))
)
;Calculating the outputs of all the internal components (adder,multiplier) is DONE.
;The next rule is responsible for assigning the sensors` out slot with
;the values of the internal component`s out slot that are connected with
;For example 
;1) the (slot:out)  of sensor [m1] in (time 1) will have the value of 10
;2) the (slot:out)  of sensor [m1] in (time 2) will have the value of 14
(defrule assign-sensor-out-values
	?x <- (goal assign-sensor-out-values)
	(object (is-a sensor) (name ?sensor) (input ?internal_component))
	(object (is-a internal-component) (name ?internal_component) (out ?v))
=>
	(modify-instance ?sensor (out ?v))
)

;rule changer 
(defrule change-goal-to-check-discrepancy
	?x <- (goal assign-sensor-out-values)

=>
	(retract ?x)
	(assert (check-discrepancy))
	(assert (discrepancy no)) ;default value of discrepancy
)

;rules that checks if there is an discrepancy in the system
;Discrepancy exists when the sensor`s (slot:reading) is not equal to the (slot:output) 
(defrule check-discrepancy
	?x <- (check-discrepancy)
	?y <- (discrepancy no)
	(time ?t)
	(object (is-a sensor) (name ?sensor) (reading ?read) (out ?output) (input ?internal_component))

=>
	(printout t "Checking if there is a discrepancy in clock: " ?t crlf)
	(if (<> ?read ?output)
	then
		(retract ?x)
		(retract ?y)
		(assert (discrepancy yes)) 
		(assert (suspects ?sensor ?internal_component)) ;2 possible suspects for the malfunction
	)
)
;if there is no discrepancy the system operated normally and it is ready to advance to the next cycle
(defrule discrepancy-no
	?x <- (check-discrepancy)
	?y <- (discrepancy no)
	(time ?t)

=>
	(printout t "No discrepancy in clock : " ?t crlf)
	(retract ?x)
	(retract ?y)

	(printout t "Time: " ?t " --> Normal Operation!" crlf)
	(assert (goal change-time))
)

;if there is a discrepancy there is a malfunction in the circuit
(defrule discrepancy-yes
	?x <- (discrepancy yes)
	(suspects ?sensor ?internal_component)
	(time ?t)

=>
	(printout t "There is a discrepancy in clock: " ?t crlf)
	(retract ?x)
	(assert (goal init-suspects))
)
;rule for changing the component`s slot suspect from no to yes
(defrule init-suspects
	?x <- (goal init-suspects)
	(suspects ?sensor ?internal_component)

	(object (is-a sensor) (name ?sensor) (suspect no))
	(object (is-a internal-component) (name ?internal_component) (suspect no))
=>
	(printout t "Suspects of the discrepancy are: " crlf)
	(printout t "1) Sensor: " ?sensor crlf)
	(printout t "2) " (class ?internal_component) ": " ?internal_component crlf)

	(retract ?x)
	(modify-instance ?sensor (suspect yes))
	(modify-instance ?internal_component (suspect yes))
	(assert (goal decide-type-of-malfunction))
)

;rule for printing the type of the malfunction
;There are 2 types of malfunction: 
;1: cutting of the most significant bit 
;2: the output is zero regardless of input

(defrule decide-type-of-malfunction
	?x <- (goal decide-type-of-malfunction)
	(time ?t)
	(suspects ?sensor ?internal_component)

=>
	(retract ?x)

	(bind ?sensor_reading (send ?sensor get-reading)) ;bind the sensor`s reading slot to a variable
	(bind ?component_msb_out (send ?internal_component get-msb-out)) ;bind the internal component`s msb-out slot to a variable 
	(bind ?component_out (send ?internal_component get-out));bind the internal component`s out slot to a variable 

	;if the (slot:reading) of the sensor is equal to the (slot:msb-out) of the intenal component value that means we have cutting of the most significant bit
	(if (= ?sensor_reading ?component_msb_out)
	then (printout t "Time: " ?t " --> " (class ?internal_component) " " ?internal_component " error: Most Significant Bit is off!" crlf)
	else
		;if the (slot:reading) of the sensor is equal to zero then there is a malfunction to the internal component
		(if (= ?sensor_reading 0)
		then (printout t "Time: " ?t " --> " (class ?internal_component) " " ?internal_component " error: Short-cirquit!" crlf)
		;Otherwise, there is a malfunction to the sensor
		else (printout t "Time: " ?t " --> " (class ?sensor) " " ?sensor " error: Short-cirquit!" crlf)
		)
	)

	(assert (goal exonerate-suspects))
)
;Rule that retracts the suspects and changes the suspect slot from yes to no in order to advance to the next cycle
(defrule reset-suspects
	?x <- (goal exonerate-suspects)
	?y <- (suspects ?sensor ?internal_component)

=>
	(printout t "exonerating the suspects for the next cycle... " crlf)
	(retract ?x)
	(retract ?y)
	(modify-instance ?sensor (suspect no))
	(modify-instance ?internal_component (suspect no))
	(assert (goal change-time))
)
;Rule that advances to the next cycle
(defrule change-time
	?x <- (goal change-time)
	?y <- (time ?t)

=>

	(retract ?x)
	(retract ?y)
	;The program works for 10 cycles
	(if (= ?t 10) 
	then
		(assert (end program))
	else
		;Advance to the next cycle
		(bind ?new_timer (+ ?t 1))
		(assert (time ?new_timer))
		(assert (print clock-time))
		(printout t "Advance to the next cycle: " ?t " --> " ?new_timer crlf crlf))
)

;End Rule
(defrule end-program
	?x <- (end program)
=>	
	(printout t "...THE END..." crlf)
)