import { createSelector } from "reselect";
import { selectSessions } from "../App/selectors";

export const selectGames = createSelector(
  selectSessions,
  // transform sessions into { [game_id]: { highscore, players }} for each game
  sessions =>
    sessions.reduce((games, session) => {
      const { game: { id: gameId } } = session;
      games[gameId] = getGameFromSession(games[gameId], session);
      return games;
    }, {})
);

const getGameFromSession = (game, session) => {
  const { game: { id: gameId }, player, score } = session;

  if (!game) {
    return { highscore: score, players: [player] };
  }

  const { highscore, players } = game;
  const { id: playerId } = player;

  return {
    highscore: score > highscore ? score : highscore,
    players: players.find(({ id }) => id === playerId)
      ? players
      : [...players, player]
  };
};

// get the top highest scoring sessions from all games
const HIGH_SCORES_COUNT = 10; // how many high scores to show
export const selectHighscoreSessions = createSelector(
  selectSessions,
  sessions =>
    _.chain(sessions)
      .sortBy("score")
      .reverse()
      .first(HIGH_SCORES_COUNT)
      .value()
);
