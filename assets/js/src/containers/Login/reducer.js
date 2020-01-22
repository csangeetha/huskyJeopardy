import { createReducer } from "../../utils/redux";
import oauthAPI from "../../utils/oauthAPI";
import { LOGIN, SET_TOKEN } from "./actions";

const initialState = {};

export default createReducer(initialState, {
  [LOGIN]: (state, { onLogin }) => {
    oauthAPI.getAccessToken(onLogin);
    return state;
  },
  [SET_TOKEN]: (state, { token }) => ({ ...state, token })
});
