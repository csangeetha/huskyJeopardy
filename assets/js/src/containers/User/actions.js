import { makeActionCreator } from "../../utils/redux";

export const SET_VERIFIED = "User/set_verified";
export const setVerified = makeActionCreator(SET_VERIFIED, "verified");
