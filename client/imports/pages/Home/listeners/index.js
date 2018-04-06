import famous from "famous";

import { projects } from "../projects";
import logger from "/client/imports/utils/logger";

const { GenericSync } = famous.inputs;
const { MouseSync } = famous.inputs;
const { TouchSync } = famous.inputs;
const { ScrollSync } = famous.inputs;
GenericSync.register({
  mouse: MouseSync,
  scroll: ScrollSync,
  touch: TouchSync
});

const updateBetweenTransition = {
  curve: "linear",
  duration: 0
};
const updateStopTransition = {
  method: "snap",
  dampingRatio: 1,
  period: 500
};
const updateSnapTransition = {
  curve: "inOutCubic",
  duration: 1200
};

const eventSeparation = Math.PI / 2;
const lastEventRotationValue = (projects.length - 1) * (Math.PI / 2);

let horizontalGenericInputs = null;
let verticalGenericInputs = null;

export const registerListeners = function({
  rotationAmountTransitionable,
  translationAmountTransitionable
}) {
  horizontalGenericInputs = new GenericSync(["mouse", "touch", "scroll"], {
    direction: GenericSync.DIRECTION_X
  });
  verticalGenericInputs = new GenericSync(["mouse", "touch", "scroll"], {
    direction: GenericSync.DIRECTION_Y
  });

  famous.core.Engine.pipe(horizontalGenericInputs);
  famous.core.Engine.pipe(verticalGenericInputs);

  const findClosestSnap = function(theta) {
    const snapValue = eventSeparation;
    const smallestTick = Math.floor(theta / snapValue);
    const smallestSnap = smallestTick * snapValue;
    const largestSnap = smallestSnap + snapValue;
    let snapToValue = 0;
    if (Math.abs(theta - smallestSnap) > Math.abs(theta - largestSnap)) {
      snapToValue = largestSnap;
    } else {
      snapToValue = smallestSnap;
    }
    return snapToValue;
  };

  const updateContentRotation = function(delta) {
    translationAmountTransitionable.halt();
    rotationAmountTransitionable.halt();
    const current_translationAmount = translationAmountTransitionable.get();
    const current_rotationAmount = rotationAmountTransitionable.get();

    const new_translationAmount = current_translationAmount + delta;
    const delta_rotationAmount = -1 * delta * 0.0087; //Math.PI / 360
    const new_rotationAmount = current_rotationAmount + delta_rotationAmount;
    translationAmountTransitionable.set(
      new_translationAmount,
      updateBetweenTransition
    );
    switch (false) {
      case new_rotationAmount > 0:
        return rotationAmountTransitionable.set(0, updateBetweenTransition);
      case new_rotationAmount < lastEventRotationValue:
        return rotationAmountTransitionable.set(
          lastEventRotationValue,
          updateStopTransition
        );
      default:
        return rotationAmountTransitionable.set(
          new_rotationAmount,
          updateBetweenTransition
        );
    }
  };

  const endContentRotation = function(velocity) {
    translationAmountTransitionable.halt();
    rotationAmountTransitionable.halt();
    const current_translationAmount = translationAmountTransitionable.get();
    const current_rotationAmount = rotationAmountTransitionable.get();
    const delta_translationAmount = velocity * 180;
    const delta_rotationAmount = -1 * velocity * Math.PI / 2;
    const new_translationAmount =
      current_translationAmount + delta_translationAmount;
    const new_rotationAmount = current_rotationAmount + delta_rotationAmount;
    translationAmountTransitionable.set(
      new_translationAmount,
      updateStopTransition
    );
    switch (false) {
      case new_rotationAmount > 0:
        return rotationAmountTransitionable.set(0, updateStopTransition);
      case new_rotationAmount < lastEventRotationValue:
        return rotationAmountTransitionable.set(
          lastEventRotationValue,
          updateStopTransition
        );
      default:
        var closestSnap = findClosestSnap(new_rotationAmount);
        return rotationAmountTransitionable.set(
          new_rotationAmount,
          updateStopTransition,
          () =>
            rotationAmountTransitionable.set(closestSnap, updateSnapTransition)
        );
    }
  };

  let scrollDirection = "";
  horizontalGenericInputs.on("update", function(event) {
    if (scrollDirection === "" && Math.abs(event.position) > 15) {
      scrollDirection = "horizontal";
    }
    if (scrollDirection === "horizontal") {
      // If slip is true then it's scroll and needs a ratio
      let delta;
      if (event.slip == null || event.slip === false) {
        ({ delta } = event);
      } else {
        delta = event.delta / 14;
      }
      return updateContentRotation(delta);
    }
  });
  horizontalGenericInputs.on("end", function(event) {
    if (scrollDirection === "horizontal") {
      scrollDirection = "";
      return endContentRotation(event.velocity);
    }
  });

  verticalGenericInputs.on("update", function(event) {
    if (scrollDirection === "" && Math.abs(event.position) > 15) {
      scrollDirection = "vertical";
    }
    if (scrollDirection === "vertical") {
      let delta;
      logger.log("event - verticalGenericInputs: update");
      // If slip is true then it's scroll and needs a ratio
      if (event.slip == null || event.slip === false) {
        ({ delta } = event);
      } else {
        delta = event.delta / 14;
      }
      return updateContentRotation(delta);
    }
  });
  return verticalGenericInputs.on("end", function(event) {
    if (scrollDirection === "vertical") {
      logger.log("event - verticalGenericInputs: end");
      scrollDirection = "";
      return endContentRotation(event.velocity);
    }
  });
};

export const cleanupListeners = function() {
  logger.log("Listeners: Cleaning up....");
  horizontalGenericInputs.removeListener("update");
  horizontalGenericInputs.removeListener("end");
  verticalGenericInputs.removeListener("update");
  verticalGenericInputs.removeListener("end");
  famous.core.Engine.unpipe(horizontalGenericInputs);
  famous.core.Engine.unpipe(verticalGenericInputs);
  horizontalGenericInputs = null;
  return (verticalGenericInputs = null);
};
