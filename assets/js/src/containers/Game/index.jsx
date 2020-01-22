import React from "react";
import Heading from "../../components/Heading";
import PlayerLink from "../../components/PlayerLink";
import { connect } from "react-redux";
import { selectGameSessions } from "./selectors";
import { Table } from 'reactstrap';

class Game extends React.Component {
  renderList = (list, getData = x => x) => {
    if (!list) return "None";
    return <ol>{list.map((item, i) => <li key={i}>{getData(item)}</li>)}</ol>;
    };

    renderCluesField = (clues, field) =>
    this.renderList(clues, ({ [field]: data }) => data);
    renderAnswers = clues => this.renderCluesField(clues, "answer");
    renderQuestions = clues => this.renderCluesField(clues, "question");

    render() {
      const {
        props: { gameId, sessions },
        renderAnswers,
        renderList,
        renderQuestions
      } = this;

      return (
        <div>
          <Heading text={`Sessions for Game ${gameId}`} />

          <div className="row">
            {sessions.map(
              ({ answers, clues, player: { id: playerId }, score }, index) => (
                <div
                  className="card"
                  style={{
                    margin: "2%",
                    marginLeft :'5%',
                    border: "1px solid black",
                    width: "90%"

                  }} key={index}
                  >
                  <div
                    className="card-header text-white text-center"
                    style={{ background: "light-grey" }}
                    >
                    <h5 style={{ color: "black" }}>
                      Player {playerId}
                    </h5>
                  </div>

                  <div className="card-body" style={{ width: "90%" }}>
                    <div className="card-text">
                      <div className="row">
                        <div className="col"><h6>Questions : </h6></div>
                        <div className="col">{renderQuestions(clues)}</div>
                      </div>
                      <div className="row">
                        <div className="col"><h6>Correct Answer : </h6></div>
                        <div className="col">{renderAnswers(clues)}</div>
                      </div>
                      <div className="row">
                        <div className="col"><h6>Player Answer : </h6></div>
                        <div className="col">{renderList(answers)}</div>
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

  const mapStateToProps = (state, { gameId }) => ({
    sessions: selectGameSessions(state, gameId)
  });

  export default connect(mapStateToProps)(Game);
