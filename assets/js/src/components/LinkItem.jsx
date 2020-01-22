import React from "react";
import { NavLink } from "react-router-dom";
import { NavItem } from "reactstrap";

export default function LinkItem({ label, className, to = "" }) {
  return (
    <NavItem>
      <NavLink exact to={`/${to}`} className={`nav-link ${className}`}>
        {label}
      </NavLink>
    </NavItem>
  );
}
