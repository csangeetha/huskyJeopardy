import { makeActionCreator } from "../../utils/redux";

// action type names, qualified by container name to ensure uniqueness
export const UPDATE = "App/update";
export const SET_PROFILE = "App/setProfile";

// create actions with type and names for argument(s)
export const setProfile = makeActionCreator(SET_PROFILE, "profile");
export const update = makeActionCreator(UPDATE, "payload");
