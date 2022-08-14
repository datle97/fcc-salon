#!/bin/bash

# PSQL='psql --username=freecodecamp --dbname=salon -t -c'
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


function MAIN_MENU() {
  echo -e "\nPick a service:\n"

  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  SERVICE_INDEX=1

  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_INDEX) $NAME"
    (( SERVICE_INDEX++ ))
  done

  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) BOOK_MENU $SERVICE_ID_SELECTED;;
    2) echo 2 ;;
    3) echo 3 ;;
    *) MAIN_MENU ;;
  esac
}

function BOOK_MENU() {
  echo -e "\nEnter your phone number"

  read CUSTOMER_PHONE
  QUERY_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo $QUERY_CUSTOMER_ID
  if [[ -z $QUERY_CUSTOMER_ID ]]
  then
    echo -e "\nEnter your name"
    read CUSTOMER_NAME

    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")

    echo -e "\nEnter time"
    read SERVICE_TIME
    
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ $1 ]]
    then
      SERVICE_ID=$1
    fi
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID', '$SERVICE_TIME')")

    QUERY_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID")
    echo -e "I have put you down for a $(echo $QUERY_SERVICE_NAME | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $CUSTOMER_NAME."
  else
    echo 'co roi nha'
  fi
  # read CUSTOMER_NAME;
  # read SERVICE_TIME;
}

MAIN_MENU