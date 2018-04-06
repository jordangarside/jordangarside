import React from "react";
import { Meteor } from "meteor/meteor";
import { render } from "react-dom";
import { BrowserRouter as Router } from "react-router-dom";
import { MuiThemeProvider } from "material-ui/styles";
import famous from "famous";

import Routes from "/client/imports/routes";
import ResponsiveDrawer from "/client/imports/components/ResponsiveDrawer";
import { MuiTheme } from "/client/imports/theme";

window.FamousEngine = famous.core.Engine;
window.Surface = famous.core.Surface;
window.ContainerSurface = famous.surfaces.ContainerSurface;
window.Modifier = famous.core.Modifier;
window.Transform = famous.core.Transform;
window.Transitionable = famous.transitions.Transitionable;

window.TweenTransition = famous.transitions.TweenTransition;
window.EasingTransitions = famous.transitions.Easing;
window.SpringTransition = famous.transitions.SpringTransition;
window.WallTransition = famous.transitions.WallTransition;
window.SnapTransition = famous.transitions.SnapTransition;

// Register Tween Transitions
window.TweenTransition.registerCurve(
  "inOutCubic",
  EasingTransitions.inOutCubic
);

// Register Physics Methods
window.Transitionable.registerMethod("spring", SpringTransition);
window.Transitionable.registerMethod("wall", WallTransition);
window.Transitionable.registerMethod("snap", SnapTransition);

const App = () => (
  <Router>
    <MuiThemeProvider theme={MuiTheme}>
      <ResponsiveDrawer content={<Routes />} />
    </MuiThemeProvider>
  </Router>
);

Meteor.startup(() => {
  render(<App />, document.getElementById("react-root"));
});
