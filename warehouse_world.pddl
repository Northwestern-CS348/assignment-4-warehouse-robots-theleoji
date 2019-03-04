(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?start - location ?dest - location ?r - robot)
      :precondition (and (at ?r ?start) (no-robot ?dest) (not (at ?r ?dest)) (connected ?start ?dest))
      :effect (and (at ?r ?dest) (not (no-robot ?dest)) (no-robot ?start))
   )
   
   (:action robotMoveWithPallette
      :parameters (?start - location ?dest - location ?r - robot ?p - pallette)
      :precondition (and (at ?r ?start) (not (at ?r ?dest)) (at ?p ?start) (not (at ?p ?dest)) (connected ?start ?dest))
      :effect (and (not (at ?r ?start)) (at ?r ?dest) (not (at ?p ?start)) (at ?p ?dest))
   )
   
   (:action moveItemFromPalletteToShipment
     :parameters (?l - location ?shipment - shipment ?saleitem - saleitem ?p - pallette ?o - order)
     :precondition (and (at ?p ?l) (contains ?p ?saleitem) (packing-at ?shipment ?l) (packing-location ?l) (orders ?o ?saleitem) (ships ?shipment ?o) (not (complete ?shipment)) (not (includes ?shipment ?saleitem)))
     :effect (and (not (contains ?p ?saleitem)) (includes ?shipment ?saleitem))
   )
   
   (:action completeShipment
     :parameters (?s - shipment ?o - order ?l - location)
     :precondition (and (not (complete ?s)) (packing-at ?s ?l) (started ?s) (ships ?s ?o))
     :effect (and (complete ?s))
   )

)
