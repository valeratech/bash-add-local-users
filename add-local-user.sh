#!/bin/bash

#Enforces that it be executed with superuser (root) privileges.  If the script is not executed with superuser privileges
#it will not attempt to create a user and returns an exit status of 1.
if [[ $(id -u) -ne 0 ]]
then
  echo "Not admin. Please log in with root privileges"
  exit 1
else
  echo "Welcome Admin"
fi

#Prompts the person who executed the script to enter the username (login), the name for person who will be using the -
#account, and the initial password for the account.
read -p "Username: " USER
read -p "Full Name or Description: " COMMENT
read -p "Password: " PASSWORD

echo "Username is: ${USER}"
echo "Password is: xxxxxxx"

#Creates a new user on the local system with the input provided by the user.
useradd -m -c "${COMMENT}"

#Informs the user if the username was not able to be created for some reason.
#If the user is not created, the script is to return an exit status of 1 with error message.
if [[ "${?}" -ne 0 ]]
then
  echo "Error: Username could not be created"
  exit 1
fi

#Create a password for the user from the input provided
echo "${USER}:${PASSWORD}" | chpasswd

#Informs the user if the password was not able to be created for some reason.
# If the password is not created, the script is to return an exit status of 1 with error message.
if [[ "${?}" -ne 0 ]]
then
  echo "Error: Adding Password"
  exit 1
fi

exit 0



#Displays the username, password, and host where the account was created.  This way the help desk staff can copy the
#output of the script in order to easily deliver the information to the new account holder.

