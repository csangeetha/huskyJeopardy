import React from "react";
import LinkItem from "./LinkItem";

export default function SessionInfo({ profile }) {
  if (profile) {
    return <h5 style={{ color: "white" }}>Welcome, {profile.name}</h5>;
  }

  return <LinkItem to="login" label="Login" className="rightLink" />;
}
