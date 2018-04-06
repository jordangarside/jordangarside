import React from "react";
import { Meteor } from "meteor/meteor";
import PropTypes from "prop-types";

import {
  aContainer,
  Button,
  DrawerContentContainer,
  FooterContainer,
  HeaderLogo,
  LinkContainer,
  LinkIcon,
  LinksContainer,
  LinkText
} from "./styles";

class DrawerContent extends React.Component {
  state = {};
  render() {
    const { toggleDrawer } = this.props;
    return (
      <DrawerContentContainer>
        <LinksContainer>
          <Button
            component={LinkContainer}
            onClick={toggleDrawer}
            to="/about-me"
          >
            <img
              src="/images/animations/graduation.gif"
              height="20px"
              width="30px"
            />
            <LinkText>about me</LinkText>
          </Button>
          <Button
            component={LinkContainer}
            onClick={toggleDrawer}
            to="/electrochemistry"
          >
            <img
              src="/images/animations/junction.gif"
              height="20px"
              width="30px"
            />
            <LinkText>electrochemistry</LinkText>
          </Button>
          <Button component={LinkContainer} onClick={toggleDrawer} to="/inlet">
            <img
              src="/images/animations/inlet.gif"
              height="20px"
              width="30px"
            />
            <LinkText>inlet</LinkText>
          </Button>
          <Button
            component={LinkContainer}
            onClick={toggleDrawer}
            to="/theoretical-chemistry"
          >
            <img src="/images/animations/demo.gif" height="20px" width="30px" />
            <LinkText>theoretical chemistry + ml</LinkText>
          </Button>
          <Button
            component={aContainer}
            onClick={toggleDrawer}
            href="https://about.cloudszi.com/"
          >
            <img
              src="/images/animations/cloudszi.gif"
              height="20px"
              width="30px"
            />
            <LinkText>cloudszi</LinkText>
          </Button>
        </LinksContainer>
        <ul className="bottom-drawer-list drawer-list">
          <h3> Contact </h3>
          <a href="mailto:jordangarside@gmail.com" target="_blank">
            {" "}
            jordangarside@gmail.com <paper-ripple />
          </a>
        </ul>
      </DrawerContentContainer>
    );
  }
}

DrawerContent.propTypes = {
  toggleDrawer: PropTypes.func.isRequired
};

export default DrawerContent;
