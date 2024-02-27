#! /bin/bash

# #!/bin/bash
# PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

# echo -e "\n~~~~~ MY SALON ~~~~~\n"
# echo -e "\nWelcome to My Salon, how can I help you?\n"

# MAIN_MENU() {
#   if [[ $1 ]]
#   then
#     echo -e "\n$1"
#   fi
# # show available services
#   SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
#   # if there is no service available
#   if [[ -z $SERVICES ]]
#   then
#     echo "Sorry, we don't have any service right now"
#   # case there it is, show them formated
#   else
#     echo -e "$SERVICES" | while read SERVICE_ID BAR NAME
#     do
#       echo "$SERVICE_ID) $NAME"
#     done
#   # get customer choice
#   read SERVICE_ID_SELECTED
#   # if the choice is not a number
#     if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
#     then
#     # send to main menu
#       MAIN_MENU "Sorry, that is not a valid number! Please, choose again."
#     else
#       VALID_SERVICE=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
#       # if it is a number but not the valid ones
#       if [[ -z $VALID_SERVICE ]]
#       then
#       # send to main menu
#         MAIN_MENU "I could not find that service. What would you like today?"
#       else
#       # get customer phone number
#         echo -e "\nWhat's your phone number?"
#         read CUSTOMER_PHONE
#         # check if is a new customer or not
#         CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
#         # if is a new customer
#           if [[ -z $CUSTOMER_NAME ]]
#           then
#           # get the name, phone and incluid it to the table with the selected service
#           echo -e "\nI don't have a record for that phone number, what's your name?"
#           read CUSTOMER_NAME
#           CUSTOMER_INFO_INCLUSION=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
#           SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
#           # get the time the customer wants to appoint
#           echo "What time would you like your $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
#           read SERVICE_TIME
#           # update the appointment table 
#           CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
#           APPOINTMENT_INCLUSION=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
#           echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
#         # case is an old customer
#         else
#         # get the service name and ask for the time the customer wants to appoint
#         SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
#         echo "What time would you like your $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
#         read SERVICE_TIME
#         # update the appointment table 
#         CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
#         APPOINTMENT_INCLUSION=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
#         echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
#         fi
#       fi
#     fi
#   fi
# }

# MAIN_MENU
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c "
 echo -e "\nWelcome to Salon, how can I help you?"

 SHOW_MENU () {
  # echo -e "\nHere's our list of services\n"
  if [[ $1 ]]
  then 
    echo -e "\n$1"
  fi
  SERVICES=$($PSQL "SELECT * from services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do 
    echo "$SERVICE_ID) $NAME"
  done

 }
 MAIN_MENU (){

  SHOW_MENU
  read SERVICE_ID_SELECTED
  SERVICE_INFO=$($PSQL "SELECT * FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  while [[ -z $SERVICE_INFO ]]
  do 
    SHOW_MENU "I could not find that service. What would you like today?"
    read SERVICE_ID_SELECTED
    SERVICE_INFO=$($PSQL "SELECT * FROM services WHERE service_id=$SERVICE_ID_SELECTED ORDER BY service_id")
  done

  echo -e "\nEnter your phone number:"
  read CUSTOMER_PHONE
  
  CUSTOMER_INFO=$($PSQL "SELECT customer_id, name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # echo $CUSTOMER_INFO
  read CUSTOMER_ID BAR CUSTOMER_NAME < <(echo $CUSTOMER_INFO)
  # echo $CUSTOMER_ID

  if [[ -z $CUSTOMER_INFO ]]
  then
    echo -e "\nYou are not registered"
    echo -e "\nPlease enter your name"
    read CUSTOMER_NAME

    INSERT_CUST_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo -e "\nWelcome to our salon, $CUSTOMER_NAME!"
  else
    echo -e "\nWelcome back to our salon, $CUSTOMER_NAME!"
  fi
  echo -e "\nWhen would you like to book your appointment, $CUSTOMER_NAME?"
  read SERVICE_TIME

  echo $SERVICE_TIME_FORMATTED
  INSERT_APPT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  SERVICE_NAME_FORMATTED=$(echo "$SERVICE_NAME" | sed 's/^ //')
  echo "I have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME."

 }
  MAIN_MENU


