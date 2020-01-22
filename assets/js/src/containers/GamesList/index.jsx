import React from "react";
import Heading from "../../components/Heading";
import GameCard from "../../components/GameCard";
import HighscoreCard from "../../components/HighscoreCard";
import { createStructuredSelector } from "reselect";
import { connect } from "react-redux";
import { selectGames, selectHighscoreSessions } from "./selectors";

class GamesList extends React.Component {
  renderGames = () => {
    const { games } = this.props;
    const gameEntries = Object.entries(games);

    let renderedGames = <h2 style={{ textAlign: "center" }}>The Games List</h2>;
    if (gameEntries.length) {
      renderedGames = gameEntries.map(([id, game], index) => (
        <GameCard key={index} gameId={id} game={game} />
      ));
    }

    return (
      <div className="col" style={{ width: "120%", marginLeft:'2%' , marginRight: '2%' }}>
        <div className="row">
          <div className="card games-card">{renderedGames}</div>
        </div>
      </div>
    );
  };

  renderHighscores = () => {
    const { highscoreSessions } = this.props;

    let renderedHighscores = (
      <h5 style={{ textAlign: "center" }}>Highscore List</h5>
    );
    if (highscoreSessions.length) {
      renderedHighscores = highscoreSessions.map((session, index) => (
        <HighscoreCard key={index} {...session} />
      ));
    }

    return (
      <div className="col" style={{ marginTop: "1%", marginLeft: "3%" }}>
        <div className="card" style={{ width: "100%", height: "auto" }}>
          <div
            className="card-header text-white text-center"
            style={{ background: "grey" }}
          >
            <h5>Highscores</h5>
          </div>
          <div className="card-body">{renderedHighscores}</div>
        </div>
      </div>
    );
  };

  render() {
    const { renderGames, renderHighscores } = this;
    return (
      <div style={{ margin: "1em" }}>
        <Heading text="Games" />
        <div className="row">
          {renderGames()}
          {renderHighscores()}
        </div>
      </div>
    );
  }
}

const mapStateToProps = createStructuredSelector({
  games: selectGames,
  highscoreSessions: selectHighscoreSessions
});

export default connect(mapStateToProps)(GamesList);
