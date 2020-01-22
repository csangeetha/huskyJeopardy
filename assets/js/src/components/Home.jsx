import React from "react";

import {
  Jumbotron,
  Card,
  CardBody,
  CardText,
  CardTitle,
  CardSubtitle,
  CardImg,
  ListGroup,
  ListGroupItem,
  Badge
} from "reactstrap";

// Icons from https://www.shareicon.net/
export default function Home() {
  return (
    <div className="center">
      <Jumbotron>
        <h1 className="display-3" id={"banner-txt"}>
          Alexa, play Husky Jeopardy...
        </h1>
        <hr />
        <p className="lead">
          Husky Jeopardy is an Amazon Alexa Jeopardy game created by
          Northeastern University students.
        </p>
      </Jumbotron>

      <div className="d-inline-flex jeo-instr-box">
        <Card className={"card flex-md-row mb-4 box-shadow jeo-instr"}>
          <CardBody
            className={
              "card-body d-flex flex-column align-items-start card-instr"
            }
          >
            <CardTitle className="d-inline-block mb-2 text-primary">
              Alexa
            </CardTitle>
            <CardSubtitle className="mb-0 font-weight-bold">
              <a
                className="text-dark"
                href="https://skills-store.amazon.com/deeplink/tvt/c88ad96e5e482
                          207bebcc41d275a32566379857febacff5dea9473eb1cf6e45b2497b3b867409ca4a2dfe26ac9e531ec6
                         bebdf3ecb9ea1579d79705ceec66b3d54e22ef6034b22ab91afd2311171255456465940024db2e3729948
                      2ae708bf650c97bee1443fb2cab46f75d06cff52"
                target="_blank"
              >
                <span className="jeo-link">Join the Beta</span>
              </a>
            </CardSubtitle>
            <CardText />
            <CardText className="mb-auto">
              Play jeopardy with thousands of possible trivia questions in
              various categories. Play on your way to work or at home with
              friends.
            </CardText>
          </CardBody>
          <div className="card-img-box">
            <CardImg
              className={"card-img-right flex-auto d-none d-lg-block"}
              src="/images/alexa_logo.png"
            />
          </div>
        </Card>

        <Card className={"card flex-md-row mb-4 box-shadow jeo-instr"}>
          <CardBody
            className={
              "card-body d-flex flex-column align-items-start card-instr"
            }
          >
            <CardTitle className="d-inline-block mb-2 text-primary">
              Compete
            </CardTitle>
            <CardSubtitle className="mb-0 font-weight-bold">
              <a className="text-dark" href="/login" target="_blank">
                <span className="jeo-link">Login</span>
              </a>
            </CardSubtitle>
            <CardText />
            <CardText className="mb-auto">
              Compete against other players for the top score and see your
              return player number on the board for all to see!
            </CardText>
          </CardBody>
          <div className="card-img-box">
            <CardImg
              className={"card-img-right flex-auto d-none d-lg-block"}
              src="/images/top_scores.png"
            />
          </div>
        </Card>

        <Card className={"card flex-md-row mb-4 box-shadow jeo-instr"}>
          <CardBody
            className={
              "card-body d-flex flex-column align-items-start card-instr"
            }
          >
            <CardTitle className="d-inline-block mb-2 text-primary">
              Learn
            </CardTitle>
            <CardSubtitle className="mb-0 font-weight-bold">
              <a
                className="text-dark"
                href="http://jservice.io/"
                target="_blank"
              >
                <span className="jeo-link">JService</span>
              </a>
            </CardSubtitle>
            <CardText />
            <CardText className="mb-auto">
              Try your knowledge and have fun in the process. Husky Jeopardy
              tells you the answers to questions you get wrong.
            </CardText>
          </CardBody>
          <div className="card-img-box">
            <CardImg
              className={"card-img-right flex-auto d-none d-lg-block"}
              src="/images/learn.png"
            />
          </div>
        </Card>

        <ListGroup className="instr-list jeo-instr">
          <ListGroupItem>
            1. Download the Alex app. &nbsp;
            <a href="https://itunes.apple.com/us/app/amazon-alexa/id944011620">
              <Badge pill color="secondary">
                <img
                  className="pill-img"
                  target="_blank"
                  src="/images/apple.svg"
                />
              </Badge>
            </a>
            &nbsp;
            <a href="https://play.google.com/store/apps/details?id=com.amazon.dee.app&hl=en_US">
              <Badge pill color="success">
                <img
                  className="pill-img"
                  target="_blank"
                  src="/images/android.svg"
                />
              </Badge>
            </a>
          </ListGroupItem>
          <ListGroupItem
            tag="a"
            href="https://skills-store.amazon.com/deeplink/tvt/c88ad96e5e482
                          207bebcc41d275a32566379857febacff5dea9473eb1cf6e45b2497b3b867409ca4a2dfe26ac9e531ec6
                         bebdf3ecb9ea1579d79705ceec66b3d54e22ef6034b22ab91afd2311171255456465940024db2e3729948
                      2ae708bf650c97bee1443fb2cab46f75d06cff52"
            target="_blank"
            action
          >
            2. Join our Beta
          </ListGroupItem>
          <ListGroupItem
            tag="a"
            href="#"
            onClick={() => speak("Alexa, play Husky Jeopardy!")}
            action
          >
            3. Tell Alexa to play Husky Jeopardy!
          </ListGroupItem>
          <ListGroupItem tag="a" href="/login" action>
            4. Login to our website with your Amazon credentials.
          </ListGroupItem>
          <ListGroupItem disabled tag="a" href="#" action>
            5. Review and compare your scores.
          </ListGroupItem>
        </ListGroup>
      </div>
    </div>
  );
}

// just for fun
// http://stephenwalther.com/archive/2015/01/05/using-html5-speech-recognition-and-text-to-speech
function speak(text, callback) {
  var u = new SpeechSynthesisUtterance();
  u.text = text;
  u.lang = "en-US";

  u.onend = function() {
    if (callback) {
      callback();
    }
  };

  u.onerror = function(e) {
    if (callback) {
      callback(e);
    }
  };

  speechSynthesis.speak(u);
}
