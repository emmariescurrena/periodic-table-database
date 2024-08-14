#!/bin/bash

PSQL="psql \
    --username=freecodecamp \
    --dbname=periodic_table \
    -t \
    --no-align \
    --field-separator ' ' \
    --quiet \
    -c" \

if [ -z $1 ]
then
echo "Please provide an element as an argument."
exit
fi

ELEMENT=$($PSQL "
      select
      p.atomic_number,
      e.name,
      e.symbol,
      t.type,
      p.atomic_mass,
      p.melting_point_celsius,
      p.boiling_point_celsius
      from properties p
      full join elements e
      on e.atomic_number = p.atomic_number
      full join types t
      on t.type_id = p.type_id
      where e.symbol = '$1'
      or e.name = '$1'")

if [ -z $ELEMENT ] 
then
ELEMENT=$($PSQL "
      select
      p.atomic_number,
      e.name,
      e.symbol,
      t.type,
      p.atomic_mass,
      p.melting_point_celsius,
      p.boiling_point_celsius
      from properties p
      full join elements e
      on e.atomic_number = p.atomic_number
      full join types t
      on t.type_id = p.type_id
      where e.name = '$1'")
fi

if [ -z $ELEMENT ] 
then
ELEMENT=$($PSQL "
      select
      p.atomic_number,
      e.name,
      e.symbol,
      t.type,
      p.atomic_mass,
      p.melting_point_celsius,
      p.boiling_point_celsius
      from properties p
      full join elements e
      on e.atomic_number = p.atomic_number
      full join types t
      on t.type_id = p.type_id
      where e.atomic_number = $1")
fi

if [ -z $ELEMENT ]  
then
echo "I could not find that element in the database."
exit
fi

IFS=\' read -r ATOMIC_NUMBER ELEMENT_NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $ELEMENT

echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
