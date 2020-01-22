import appReducer from "./containers/App/reducer";
import loginReducer from "./containers/Login/reducer";
import userReducer from "./containers/User/reducer";
import { createBrowserHistory } from "history";
import { applyMiddleware, combineReducers, compose, createStore } from "redux";
import { connectRouter, routerMiddleware } from "connected-react-router";

// get browser history
export const history = createBrowserHistory();

// combine reducers from all containers
const rootReducer = combineReducers({
  app: appReducer,
  login: loginReducer,
  user: userReducer
});

// connect routing to store to allow time-travel/etc. between routes
const reducerWithRouting = connectRouter(history)(rootReducer);

// supprt redux devtools extension
const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

// add middleware for syncing history with store
const middleware = composeEnhancers(applyMiddleware(routerMiddleware(history)));

// create store
export default createStore(reducerWithRouting, middleware);
