#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv| sed '1d' |while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#INSERT TEAM NAMES
INSERT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER'),('$OPPONENT') ON CONFLICT DO NOTHING;")

# GET WINNER_ID
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
# GET OPPONENT_ID
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
#INSERT ROWS INTO GAMES
INSERT_ROWS_INTO_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS);")
echo $INSERT_ROWS_INTO_GAMES
done
