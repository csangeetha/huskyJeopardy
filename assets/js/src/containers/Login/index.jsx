import React from "react";
import AmazonButton from "../../components/AmazonButton";
import Heading from "../../components/Heading";
import { Button } from "reactstrap";
import { connect } from "react-redux";
import { createStructuredSelector } from "reselect";
import { login, setToken } from "./actions";
import { selectToken } from "./selectors";
import { selectProfile } from "../App/selectors";

class Login extends React.Component {
  handleLoginClick = () => {
    const { handleLogin, onLogin } = this.props;
    handleLogin(onLogin);
  };

  render() {
    const { handleLoginClick, props: { token, profile } } = this;

    if (token) {
      if (profile) {
        return <h3>You are logged in as {profile.name}.</h3>;
      }
      return <h3>Logging in...</h3>;
    }

    return (
      <div style={{ textAlign: "center" }}>
        <Heading text="Login" />
        <AmazonButton onClick={this.handleLoginClick} />
      </div>
    );
  }
}

const mapStateToProps = createStructuredSelector({
  token: selectToken,
  profile: selectProfile
});


const mapDispatchToProps = dispatch => ({
  handleLogin: onLogin => dispatch(login(onLogin)),
  onLogin: token => dispatch(setToken(token))
});

export default connect(mapStateToProps, mapDispatchToProps)(Login);
