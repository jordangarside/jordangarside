import React from "react";
import { withRouter } from "react-router-dom";
import famous from "famous";

import { renderStars, cleanupStars } from "./stars";
import { registerListeners, cleanupListeners } from "./listeners";
import { renderProjects, cleanupProjects } from "./projects";

import isMobileDevice from "../../utils/is-mobile-device";

const FamousEngine = famous.core.Engine;
const { Surface } = famous.core;
const { ContainerSurface } = famous.surfaces;
const { Modifier } = famous.core;
const { Transform } = famous.core;
const { Transitionable } = famous.transitions;

FamousEngine.setOptions({
  appMode: false
});

if (isMobileDevice()) {
  FamousEngine.setOptions({
    fpsCap: 60
  });
}

const rotationAmountTransitionable = new Transitionable(0);
const translationAmountTransitionable = new Transitionable(0);
const visibleWorldHeightTransitionable = new Transitionable(200);

let context = null;
const render = function({ history }) {
  let renderInterval;
  const last_projectIndex = parseInt(window.location.hash.split("-")[1]);
  if (Number.isInteger(last_projectIndex)) {
    let left;
    const last_rotationAmount =
      (left = last_projectIndex * (Math.PI / 2)) != null ? left : 0;
    rotationAmountTransitionable.set(last_rotationAmount);
  }

  const contentContainerModifier = new Modifier();
  const contentContainer = new ContainerSurface({
    classes: ["famous-content-container"],
    size: [true, true]
  });
  const worldModifier = new Modifier({
    align: [0, 1]
  });
  worldModifier.transformFrom(() => {
    return Transform.translate(0, -visibleWorldHeightTransitionable.get(), 0);
  });
  const worldSurface = new Surface({
    classes: ["world-surface"],
    size: [true, undefined],
    content: `\
<div class="world-container">
	<div class="world-clip">
		<canvas id="stars-container"></canvas>
	</div>
</div>\
`
  });
  contentContainer.add(worldModifier).add(worldSurface);

  context = FamousEngine.createContext(document.getElementById("famous-root"));
  context.add(contentContainerModifier).add(contentContainer);

  const onResize = function() {
    const headerSize = document.getElementsByClassName("website-title")[0]
      .offsetHeight * 2;
    const pageSize = context.getSize();
    const contextHeight = pageSize[1] - headerSize;
    contentContainer.setSize();

    let visibleWorldHeight = 200;
    if (visibleWorldHeight > contextHeight * 0.5) {
      visibleWorldHeight = contextHeight * 0.5;
    }
    return visibleWorldHeightTransitionable.set(visibleWorldHeight);
  };
  FamousEngine.on("resize", onResize);
  onResize();

  //Lagometer
  // Lagometer = require("famous-lagometer/Lagometer")
  // lagometerModifier = new Modifier(
  // 	size: [100, 100]
  // 	align: [1.0, 0.0]
  // 	origin: [1.0, 0.0]
  // 	transform: Transform.translate(-30, 0, 100)
  // )
  // lagometer = new Lagometer(size: lagometerModifier.getSize())
  // context.add(lagometerModifier).add(lagometer)

  return (renderInterval = setInterval(function() {
    if (document.getElementById("stars-container") !== null) {
      clearInterval(renderInterval);
      renderStars({
        canvas: document.getElementById("stars-container"),
        rotationAmountTransitionable
        // visibleWorldHeightTransitionable: visibleWorldHeightTransitionable
      });
      registerListeners({
        rotationAmountTransitionable,
        translationAmountTransitionable
      });
      return renderProjects({
        history,
        container: contentContainer,
        rotationAmountTransitionable,
        visibleWorldHeightTransitionable
      });
    }
  }, 35));
};

const cleanup = function() {
  cleanupStars();
  cleanupListeners();
  cleanupProjects();
  FamousEngine.deregisterContext(context);
  return (context = null);
};

class HomePure extends React.Component {
  componentWillMount() {
    document.title = 'jordan garside';
  }
  componentDidMount() {
    const { history } = this.props;
    render({ history });
  }
  componentWillUnmount() {
    cleanup();
  }
  render() {
    return <div id="famous-root" />;
  }
}

const Home = withRouter(HomePure);

export { Home };
export default Home;
