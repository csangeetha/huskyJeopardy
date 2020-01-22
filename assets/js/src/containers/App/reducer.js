import { createReducer } from "../../utils/redux";
import { SET_PROFILE, UPDATE } from "./actions";

const initialState = {
  sessions: []
};

export default createReducer(initialState, {
  [SET_PROFILE]: (state, { profile }) => ({ ...state, profile }),
  [UPDATE]: (state, { payload: { sessions = [] } }) => ({ ...state, sessions })
});
