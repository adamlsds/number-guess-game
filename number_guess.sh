#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t -q --no-align -c"

echo  "Enter your username:"

read NAME

PLAYER=$($PSQL "SELECT * FROM player_record WHERE name='$NAME'")

if [[ -z $PLAYER ]]
then
echo -e "\nWelcome, $NAME! It looks like this is your first time here."

$PSQL "INSERT INTO player_record (name) VALUES ('$NAME')"
GAMES=1
BEST_GAME=99999

#if name enter to db
else 
#if exits


IFS='|' read ID NAME GAMES BEST_GAME <<<  $PLAYER 

echo -e "\nWelcome back, $NAME! You have played $GAMES games, and your best game took $BEST_GAME guesses."

((GAMES++))
fi

echo -e "\nGuess the secret number between 1 and 1000:"
RAND=$(($RANDOM % 1000 +1))
echo $RAND 
COUNT=1
read NUM

while true
do
    if [[ ! $NUM =~ ^[0-9]+$ ]]
    then
        echo -e "\nThat is not an integer, guess again:"
    elif (( NUM > RAND ))
    then
        echo -e "\nIt's lower than that, guess again:"
    elif (( NUM < RAND ))
    then
        echo -e "\nIt's higher than that, guess again:"
    else
        break
    fi

    read NUM
    ((COUNT++))
done



if [[ -z $BEST_GAME ]] || (( COUNT < BEST_GAME ))
then
$PSQL "UPDATE player_record SET best_game=$COUNT WHERE name='$NAME'"
$PSQL "UPDATE player_record SET games_played=$GAMES WHERE name='$NAME'"
else
$PSQL "UPDATE player_record SET games_played=$GAMES WHERE name='$NAME'"
fi

echo -e "\nYou guessed it in $COUNT tries. The secret number was $RAND. Nice job!"
