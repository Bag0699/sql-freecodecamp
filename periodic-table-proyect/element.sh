#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

INPUT=$1

ELEMENT_INFO=$($PSQL "
SELECT e.atomic_number, e.name, e.symbol, t.type,
       p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
FROM elements e
JOIN properties p USING(atomic_number)
JOIN types t USING(type_id)
WHERE e.atomic_number::TEXT = '$INPUT'
   OR e.symbol = INITCAP('$INPUT')
   OR e.name = INITCAP('$INPUT');
")

if [[ -z $ELEMENT_INFO ]]
then
  echo "I could not find that element in the database."
  exit
fi

echo "$ELEMENT_INFO" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done
# test comment