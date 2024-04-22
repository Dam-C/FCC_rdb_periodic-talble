#! /bin/bash

# psql var for connecting to DB
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# check if an argument is passed and exit the program if no argument is given
if [[ -z $1 ]]; then
  echo Please provide an element as an argument.
else

# Check if the user inputs a number then do the specifi query
if [[ $1 =~ ^[0-9]+$ ]]; then
  GET_INFOS=$($PSQL "SELECT elements.atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements LEFT JOIN properties ON elements.atomic_number=properties.atomic_number LEFT JOIN types ON properties.type_id=types.type_id WHERE elements.atomic_number=$1")
else
  GET_INFOS=$($PSQL "SELECT elements.atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements LEFT JOIN properties ON elements.atomic_number=properties.atomic_number LEFT JOIN types ON properties.type_id=types.type_id WHERE symbol='$1' OR name='$1'")
fi

if [[ $? -ne 0 ]]; then
  echo I could not find that element in the database.
elif [[ -z $GET_INFOS ]]; then
  echo I could not find that element in the database.
else
# base variables
ATOMIC_NUMBER=""
ATOMIC_SYMBOL=""
ATOMIC_NAME=""
ATOMIC_MASS=""
ATOMIC_MELT=""
ATOMIC_BOIL=""
ATOMIC_METAL=""

# Loop that will read the GET_INFOS var and save the datas into specific variables
while IFS='|' read -r ATOMIC_NUMBER ATOMIC_SYMBOL ATOMIC_NAME ATOMIC_MASS ATOMIC_MELT ATOMIC_BOIL ATOMIC_METAL;
do
# final output message
echo -e "The element with atomic number $ATOMIC_NUMBER is $ATOMIC_NAME ($ATOMIC_SYMBOL). It's a $ATOMIC_METAL, with a mass of $ATOMIC_MASS amu. $ATOMIC_NAME has a melting point of $ATOMIC_MELT celsius and a boiling point of $ATOMIC_BOIL celsius."
done <<< $GET_INFOS #send the $GET_INFOS var to the whilee loop
fi
fi