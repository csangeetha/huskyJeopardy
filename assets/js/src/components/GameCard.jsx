import React from "react";
import PlayerLink from "./PlayerLink";
import GameLink from "./GameLink";
import { ListGroup, ListGroupItem  } from 'reactstrap';

export default function GameCard({ gameId, game: { highscore, players } }) {
  const renderedPlayers = (
    <ListGroup>
        <ListGroupItem active>Players</ListGroupItem>
      {players.map(({ id: playerId }, index) => (
        <ListGroupItem  key={index}>
          <PlayerLink id={playerId} />
        </ListGroupItem >
      ))}
    </ListGroup>
  );

  const header = (
    <div
      className="card-header text-white text-center"
      style={{ background: "light-grey" }}
    >
      <h5 style={{ color: "black" }}>
        <GameLink id={gameId} />
      </h5>
    </div>
  );

  return (
    <div
      className="card"
      style={{
        margin: "1em",
        border: "1px solid black",
        width: "90%"

      }}
    >
      {header}
      <div className="card-body" style={{ width: "90%" }}>
        <div className="card-text">
          {renderedPlayers}
          with high score {highscore}
        </div>
      </div>
    </div>
  );
}
