import React from "react";
import { Link } from "react-router-dom";

export default function PlayerLink({ id }) {
  return <Link to={`/users/${id}`}>Player {id}</Link>;
}
