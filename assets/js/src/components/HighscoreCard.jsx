import React from "react";
import PlayerLink from "./PlayerLink";
import GameLink from "./GameLink";

export default function HighscoreCard({ game, player, score }) {
  return (
    <div className="card-body">
      <h5 className="card-title"><PlayerLink id={player.id} /></h5>
      <p style={{ float: "right" }}><GameLink id={game.id} /></p>
      <h4>{score}</h4>
      <hr />
    </div>
  );
}
