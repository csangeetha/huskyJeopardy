import React from "react";
import LinkItem from "./LinkItem";
import SessionInfo from "./SessionInfo";
import Logo from './Logo';
import { Navbar } from "reactstrap";

export default function Nav({ profile }) {
  return (
    <nav className="navbar navbar-dark bg-dark navbar-expand colorNav navUl">
      <Logo />
      <ul className="navbar-nav mr-auto">
        <LinkItem label="Home" />
        <LinkItem label="Games" to="games" />
        <LinkItem label="Privacy" to="privacy" />
      </ul>
      <ul className="navbar-nav ml-auto">
        <SessionInfo profile={profile} />
      </ul>
    </nav>
  );
}
