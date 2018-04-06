import famous from "famous";
import THREE from "three";
import _ from "lodash";

import logger from "/client/imports/utils/logger";

const FamousEngine = famous.core.Engine;

let render = null;

export const renderStars = ({ canvas, rotationAmountTransitionable }) => {
  let i, index, largerScreenDimension, smallerScreenDimension;
  let asc, end;
  let j;
  if (window.screen.width > window.screen.height) {
    largerScreenDimension = window.screen.width;
    smallerScreenDimension = window.screen.height;
  } else {
    largerScreenDimension = window.screen.height;
    smallerScreenDimension = window.screen.width;
  }
  if (largerScreenDimension > 1800) {
    largerScreenDimension = 1800;
  }
  const canvasWidth = largerScreenDimension;
  let canvasHeight = 210;

  if (canvasHeight > largerScreenDimension * 0.4) {
    canvasHeight = largerScreenDimension * 0.4;
  }

  const threeCanvas = canvas;

  const VIEW_ANGLE = 75;
  const ASPECT = largerScreenDimension / 300;
  const NEAR = 1;
  const FAR = 3000;
  const camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR);
  camera.position.z = 250;
  const numberOfStars = largerScreenDimension;

  const scene = new THREE.Scene();
  scene.fog = new THREE.FogExp2(0x000000, 0.0007);

  const geometry = new THREE.Geometry();

  for (
    i = 0, end = numberOfStars, asc = 0 <= end;
    asc ? i <= end : i >= end;
    asc ? i++ : i--
  ) {
    const vertex = new THREE.Vector3();
    vertex.x = _.random(0, 500) - 250;
    vertex.y = _.random(0, 500) - 250;
    vertex.z = _.random(0, 500) - 250;
    geometry.vertices.push(vertex);
  }

  const parameters = [
    [[1, 1, 0.5], 5],
    [[0.95, 1, 0.5], 4],
    [[0.9, 1, 0.5], 3],
    [[0.85, 1, 0.5], 2],
    [[0.8, 1, 0.5], 1]
  ];
  const materials = [];
  let particles = {};
  i = 0;
  let h = 0;
  let color = [];
  let size = 1;

  for (j = 0, index = j; j < parameters.length; j++, index = j) {
    const parameter = parameters[index];
    color = parameter[0];
    size = parameter[1];

    materials[index] = new THREE.PointsMaterial({
      size
    });

    particles = new THREE.Points(geometry, materials[index]);

    particles.rotation.x = Math.random() * 6;
    particles.rotation.y = Math.random() * 6;
    particles.rotation.z = Math.random() * 6;

    scene.add(particles);
  }

  const renderer = new THREE.WebGLRenderer({
    alpha: true,
    canvas: threeCanvas,
    devicePixelRatio: window.devicePixelRatio
  });
  renderer.setSize(canvasWidth, canvasHeight);
  renderer.setClearColor(0x000000, 0);

  const temp = true;
  render = function() {
    const time = Date.now() * 0.00005;
    for (index = 0; index < scene.children.length; index++) {
      const object = scene.children[index];
      if (object instanceof THREE.Points) {
        object.rotation.y = time * (index < 4 ? index + 1 : -(index + 1));
        //Appear to rotate world by rotating stars
        object.rotation.x = -rotationAmountTransitionable.get();
      }
    }

    for (index = 0; index < materials.length; index++) {
      const material = materials[index];
      color = parameters[index][0];
      h = ((360 * (color[0] + time)) % 360) / 360;
      material.color.setHSL(h, color[1], color[2]);
    }

    return renderer.render(scene, camera);
  };
  return FamousEngine.on("prerender", render);
};

export const cleanupStars = function() {
  logger.log("Stars: Cleaning up...");
  return FamousEngine.removeListener("prerender", render);
};
