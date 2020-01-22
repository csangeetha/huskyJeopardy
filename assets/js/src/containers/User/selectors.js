import { createSelector } from "reselect";
import { selectSessions } from "../App/selectors";

export const selectUserSessions = createSelector(
  selectSessions,
  (_, userId) => userId,
  (sessions, userId) =>
    sessions.filter(({ player: { id: playerId } }) => playerId == userId)
);

export const selectUserState = state => state.user;

export const selectVerified = createSelector(
  selectUserState,
  userState => userState.verified
);
