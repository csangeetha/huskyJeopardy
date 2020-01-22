import { createSelector } from "reselect";

// select the login section of the state
const selectLogin = state => state.login;

// create selectors for specific data within the login section of the state
export const selectToken = createSelector(
  selectLogin,
  loginState => loginState.token
);
