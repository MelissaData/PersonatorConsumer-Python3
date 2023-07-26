#!/bin/bash

# Name:    PersonatorConsumerCloudAPI
# Purpose: Execute the PersonatorConsumerCloudAPI program

######################### Constants ##########################

RED='\033[0;31m' #RED
NC='\033[0m' # No Color

######################### Parameters ##########################

fullname=""
addressline1=""
city=""
state=""
postal=""
country=""
email=""
phone="" 
license=""

while [ $# -gt 0 ] ; do
  case $1 in
    --fullname) 
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'fullname\'.${NC}\n"  
            exit 1
        fi 

        fullname="$2"
        shift
        ;;
    --addressline1)  
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'addressline1\'.${NC}\n"  
            exit 1
        fi 

        addressline1="$2"
        shift
        ;;
    --city) 
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'city\'.${NC}\n"  
            exit 1
        fi 

        city="$2"
        shift
        ;;
    --state)         
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'state\'.${NC}\n"  
            exit 1
        fi 
        
        state="$2"
        shift
        ;;
    --postal) 
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'postal\'.${NC}\n"  
            exit 1
        fi 

        postal="$2"
        shift
        ;;
    --country) 
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'country\'.${NC}\n"  
            exit 1
        fi 

        country="$2"
        shift
        ;;
    --email) 
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'email\'.${NC}\n"  
            exit 1
        fi 

        email="$2"
        shift
        ;;
    --phone) 
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'phone\'.${NC}\n"  
            exit 1
        fi 

        phone="$2"
        shift
        ;;
    --license) 
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'license\'.${NC}\n"  
            exit 1
        fi 

        license="$2"
        shift 
        ;;
  esac
  shift
done

########################## Main ############################
printf "\n==================== Melissa Personator Consumer Cloud API =====================\n"

# Get license (either from parameters or user input)
if [ -z "$license" ];
then
  printf "Please enter your license string: "
  read license
fi

# Check for License from Environment Variables 
if [ -z "$license" ];
then
  license=`echo $MD_LICENSE` 
fi

if [ -z "$license" ];
then
  printf "\nLicense String is invalid!\n"
  exit 1
fi

# Run project
if [ -z "$fullname" ] && [ -z "$addressline1" ] && [ -z "$city" ] && [ -z "$state" ] && [ -z "$postal" ] && [ -z "$country" ] && [ -z "$email" ] && [ -z "$phone" ];
then
    python3 PersonatorConsumerPython3.py --license $license 
else
    python3 PersonatorConsumerPython3.py \
		--license "$license" \
		--fullname "$fullname" \
		--addressline1 "$addressline1" \
		--city "$city" \
		--state "$state" \
		--postal "$postal" \
		--country "$country" \
		--email "$email" \
		--phone "$phone" 
fi
