import { createSelector } from "reselect";
import { selectSessions } from "../App/selectors";

export const selectGameSessions = createSelector(
  selectSessions,
  (_, gameId) => gameId,
  (sessions, gameId) =>
    sessions.filter(({ game: { id } }) => id == gameId)
);
