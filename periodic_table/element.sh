#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE"

INPUT=$1

MAIN() {
  # check if argument is given
  if [[ -z $INPUT ]]
  then
    echo "Please provide an element as an argument."
  else
    # check if $INPUT is atomic_number
    if [[ $INPUT =~ ^[0-9]+$ ]]
    then
      # get element by atomic_number
      ELEMENT=$($PSQL "$QUERY atomic_number=$INPUT")
      PRINT_RESULT $ELEMENT
    fi

    # check if input is not a number
    if [[ ! $INPUT =~ ^[0-9]+$ ]]
    then
      # check if $INPUT is symbol
      if [[ $(echo -n "$INPUT" | wc -m) -le 2 ]]
      then
        # get element by symbol
        ELEMENT=$($PSQL "$QUERY symbol='$INPUT'")
        PRINT_RESULT $ELEMENT
      
      else
        # get element by name
        ELEMENT=$($PSQL "$QUERY name='$INPUT'")
        PRINT_RESULT $ELEMENT
      fi
    fi
  fi
}

PRINT_RESULT() {

  ELEMENT=$1

  # if found
  if [[ $ELEMENT ]]
  then
    # print element info
    echo "$ELEMENT" | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done

  # if not found
  else
    echo "I could not find that element in the database."
  fi
}

MAIN