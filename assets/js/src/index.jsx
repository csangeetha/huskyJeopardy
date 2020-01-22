import React from "react";
import App from "./containers/App/index";
import store, { history } from "./store";
import { Provider } from "react-redux";
import { render } from "react-dom";
import { ConnectedRouter as Router } from "connected-react-router";

export default function(root, channel) {
  render(
    <Provider store={store}>
      <Router history={history}>
        <App channel={channel} />
      </Router>
    </Provider>,
    root
  );
}
