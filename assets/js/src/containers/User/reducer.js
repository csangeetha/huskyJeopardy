import { createReducer } from "../../utils/redux";
import { SET_VERIFIED } from "./actions";

const initialState = {
  // whether the current logged-in user can view this user's profile
  // (verified server-side based on profile.user_id)
  verified: false
};

export default createReducer(initialState, {
  [SET_VERIFIED]: (state, { verified }) => ({ ...state, verified })
});
