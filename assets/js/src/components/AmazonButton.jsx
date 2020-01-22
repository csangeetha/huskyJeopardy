import React from "react";
import { Card, CardImg } from 'reactstrap';

export default function AmazonButton({ onClick }) {
    return (
        <a href="#">
            <CardImg
                onClick={onClick}
                className="amzn-btn"
                alt="Login with Amazon"
                src="https://images-na.ssl-images-amazon.com/images/G/01/lwa/btnLWA_gold_312x64.png"
            />
        </a>
    );
}
