import { makeActionCreator } from "../../utils/redux";

// action type names, qualified by container name to ensure uniqueness
export const LOGIN = "Login/login";
export const SET_TOKEN = "Login/SET_TOKEN";

// create actions with type and names for argument(s)
export const login = makeActionCreator(LOGIN, "onLogin");
export const setToken = makeActionCreator(SET_TOKEN, "token");
