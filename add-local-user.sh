#!/bin/bash

#Create a log function to log to syslog/journald upon account creation success or failure
usage()
{
  echo "USAGE: ${0} [USERNAME] [COMMENT]"
  echo "EXAMPLE:  ${0} Optimus 'Optimus Prime'"
  exit 1
}

#Enforces that it be executed with superuser (root) privileges.  If the script is not executed with superuser privileges
#it will not attempt to create a user and returns an exit status of 1.
if [[ $(id -u) -ne 0 ]]
then
  echo "Not admin. Please log in with root privileges"
  exit 1
else
  echo "Welcome Admin"
fi

#If no arguments pass display a "usage" message

if [[ -z "${@}" ]]
then
    usage
fi

#Uses positional arguments to enter the username (login)
# And a Full name or description for the comments
USER="${1}"
COMMENT="${2}"


#Randomly generate a password using /dev/urandom
#Remove specific characters using the -d option and the -c option to complement the characters in SET1.
#All characters not in the specified set using -dc (in this case, everything except digits) are removed.
#PASSWORD=$(head /dev/urandom | tr -dc 'a-zA-Z0-9!@#$%&' | head -c 10; echo '') 1> /dev/null
PASSWORD=$(head /dev/urandom | tr -dc 'a-zA-Z0-9!@#$%&' | head -c 8); echo ' ' 1> /dev/null

#Creates a new user on the local system with the input provided by the user.
useradd -m -c "${COMMENT}" "${USER}"

#Informs the user if the username was not able to be created for some reason.
#If the user is not created, the script is to return an exit status of 1 with error message.
if [[ "${?}" -ne 0 ]]
then
  echo "Error: Username could not be created"
  exit 1
fi

#Create a password for the user from the input provided (Ubuntu)
echo "${USER}:${PASSWORD}" | chpasswd

#Informs the user if the password was not able to be created for some reason.
# If the password is not created, the script is to return an exit status of 1 with error message.
if [[ "${?}" -ne 0 ]]
then
  echo "Error: Could not create or add password"
  exit 1
fi

#Force password change on first login.
passwd -e "${USER}"
echo "${PASSWORD}"
echo "${0}"
#Return message of user that was successful added and the HOSTNAME

#Displays the username, password, and host where the account was created.  This way the help desk staff can copy the
#output of the script in order to easily deliver the information to the new account holder.

exit 0



