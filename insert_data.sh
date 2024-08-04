#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE teams, games")

cat ./games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    # Add data to teams table
    GAME_WINNER=$($PSQL "SELECT name FROM teams WHERE name='$WINNER';")
    if [[ -z $GAME_WINNER ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      if [[ $INSERT_GAME_WINNER == "INSERT 0 1" ]]
      then
        echo Successfully inserted $WINNER into teams table
      fi
    fi

    GAME_OPPONENT=$($PSQL "SELECT name from teams WHERE name='$OPPONENT';")
    if [[ -z $GAME_OPPONENT ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Successfully inserted $OPPONENT into teams table
      fi
    fi
    WINNER_ID=$($PSQL "SELECT team_id from teams WHERE name='$WINNER';")
    OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT';")

    # Add data to games table
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Successfully inserted a row into games table
    fi
  fi
done