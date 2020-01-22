import { createSelector } from "reselect";

// select the app section of the state
export const selectApp = state => state.app;

// create selectors for specific data within the app section of the state
export const selectSessions = createSelector(
  selectApp,
  appState => appState.sessions
);

export const selectProfile = createSelector(
  selectApp,
  appState => appState.profile
);
