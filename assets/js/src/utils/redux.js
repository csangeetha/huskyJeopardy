// adapted from https://redux.js.org/recipes/reducing-boilerplate

export const makeActionCreator = (type, ...argNames) => (...args) =>
  argNames.reduce(
    (action, argName, index) => {
      action[argName] = args[index];
      return action;
    },
    { type }
  );

export const createReducer = (initialState, handlers) => (
  state = initialState,
  action
) =>
  handlers.hasOwnProperty(action.type)
    ? handlers[action.type](state, action)
    : state;
