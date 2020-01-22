import React from "react";
import oauthAPI from "../../utils/oauthAPI";
import Heading from "../../components/Heading";
import { connect } from "react-redux";
import { selectUserSessions, selectVerified } from "./selectors";
import { selectProfile } from "../App/selectors";
import { selectToken } from "../Login/selectors";
import { setVerified } from "./actions";

class User extends React.Component {
  componentDidMount = () => {
    const { props: { profile, userId, onVerify } } = this;
    if (!profile) return;

     oauthAPI.verifyUser(userId, profile.user_id, onVerify);
  };

  render() {
    const { props: { profile, userId, sessions, verified } } = this;

     if (!verified) {
       return <div>Must be logged in as this user to view their profile.</div>;
     }

    return (
      <div>
        <Heading text={`Sessions for ${profile.name}`} />

        <div className="row">
          {sessions.map(({ game: { id: gameId }, score }, index) => (
            <div
              className="card"
              style={{
                margin: "2%",
                marginLeft :'5%',
                border: "1px solid black",
                width: "40%"
              }} key={index}
              >
              <div
                className="card-header text-white text-center"
                style={{ background: "light-grey" }}
                >
                <h5 style={{ color: "black" }}>
                  Game {gameId}
                </h5>
              </div>

              <div className="card-body" style={{ width: "100%" }}>
                <div className="card-text">
                  <div className="row">
                    <div className="col"><h6>Score : </h6></div>
                    <div className="col">{score}</div>
                  </div>
                </div>
              </div>
            </div>
          )
        )}
      </div>
    </div>
  );
}
}

const mapStateToProps = (state, { userId }) => ({
  sessions: selectUserSessions(state, userId),
  profile: selectProfile(state),
  token: selectToken(state),
  verified: selectVerified(state)
});

const mapDispatchToProps = dispatch => ({
  onVerify: verified => dispatch(setVerified(verified))
});

export default connect(mapStateToProps, mapDispatchToProps)(User);
