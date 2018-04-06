import React from "react";
import PropTypes from "prop-types";
import { withRouter, Redirect } from "react-router-dom";

import Header from "../Header";
import DrawerContent from "./DrawerContent";
import { Content, RootDiv, AppFrame, Drawer } from "./styles";
import "./styles/index.css";

class ResponsiveDrawerPure extends React.Component {
  state = {
    drawerOpen: false
  };
  componentWillMount() {
    const { history } = this.props;
    window.toggleDrawer = this.handleDrawerToggle;
    window.openDrawer = () =>
      setTimeout(() => this.setState({ drawerOpen: true }), 0);
    history.listen(() => {
      window.ga("set", "page", window.location.pathname);
      window.ga("send", "pageview");
    });
  }
  handleDrawerToggle = () => {
    this.setState({
      drawerOpen: !this.state.drawerOpen
    });
  };
  render() {
    const { content } = this.props;
    const { pathname } = this.props.location;
    return (
      <RootDiv>
        <AppFrame>
          <Drawer
            type="temporary"
            anchor="right"
            open={this.state.drawerOpen}
            onClose={this.handleDrawerToggle}
            ModalProps={{
              keepMounted: true /* Better open performance on mobile. */
            }}
            classes={{
              paper: "drawer-container"
            }}
          >
            <DrawerContent toggleDrawer={this.handleDrawerToggle} />
          </Drawer>
          <Content>
            <Header />
            {content}
          </Content>
        </AppFrame>
      </RootDiv>
    );
  }
}
ResponsiveDrawerPure.propTypes = {
  history: PropTypes.shape({ listen: PropTypes.func.isRequired }).isRequired,
  location: PropTypes.shape({ pathname: PropTypes.string.isRequired })
    .isRequired,
  content: PropTypes.element.isRequired
};

const ResponsiveDrawer = withRouter(ResponsiveDrawerPure);

export default ResponsiveDrawer;
