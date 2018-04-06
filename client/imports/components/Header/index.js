import React from "react";
import PropTypes from "prop-types";
import { withRouter } from "react-router-dom";
import Toolbar from "material-ui/Toolbar";
import MenuIcon from "material-ui-icons/Menu";

import { AppBar, AppBarContainer, MenuButtonContainer, Title } from "./styles";

class Header extends React.PureComponent {
  render() {
    const { history, content, location, title } = this.props;
    const path = location.pathname.split("/")[1];
    let routeName = "";
    switch (path) {
      case "":
      case "my-calculations":
        routeName = "My Calculations";
        break;
      case "new-calculation":
        routeName = "New Calculation";
        break;
      case "geometry-database":
        routeName = "Geometry Database";
        break;
      case "calculation-database":
        routeName = "Calculation Database";
        break;
      case "about":
        routeName = "About";
        break;
      default:
        routeName = "cloudszi";
        break;
    }
    return (
      <AppBarContainer>
        <AppBar elevation={0} position="fixed">
          <Toolbar>
            <div className="website-title">
              <a
                onClick={event => {
                  event.stopPropagation();
                  event.nativeEvent.stopImmediatePropagation()
                  history.push("/");
                }}
              >
                jordan
              </a>
            </div>
            <MenuButtonContainer
              color="inherit"
              aria-label="open drawer"
              onClick={window.openDrawer}
            >
              <MenuIcon />
            </MenuButtonContainer>
            <Title>{title}</Title>
            {content}
          </Toolbar>
        </AppBar>
      </AppBarContainer>
    );
  }
}

Header.propTypes = {
  // content: PropTypes.element.isRequired,
  location: PropTypes.shape({ pathname: PropTypes.string.isRequired })
    .isRequired
};

export default withRouter(Header);
