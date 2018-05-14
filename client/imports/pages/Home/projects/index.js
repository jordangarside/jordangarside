import React from "react";
import famous from "famous";
import _ from "lodash";

import logger from "/client/imports/utils/logger";

const FamousEngine = famous.core.Engine;
const { Surface } = famous.core;
const { ContainerSurface } = famous.surfaces;
const { Modifier } = famous.core;
const { RenderController } = famous.views;
const { Transitionable } = famous.transitions;
const { Transform } = famous.core;

if (window.jordan == null) {
  window.jordan = {};
}

const eventSeparation = Math.PI / 2;
jordan.boxSize = [500, 750];
jordan.boxSizeMax = [500, 750];
jordan.boxMargins = [0, 0, 0, 0];
jordan.titleMargins = [30, 0, 0, 40];
jordan.titleSize = [70, 40];
jordan.backMargins = [30, 0, 0, 20];
jordan.backSize = [40, 40];

jordan.dateSize = [50, 20];
jordan.marginFour = 0;
jordan.headerSize = [150, 50];
jordan.marginThree = 15;
jordan.imageSize = [180, 120]; // [180, 120]
jordan.marginTwo = 10;
jordan.descriptionSize = [150, 50];
jordan.marginOne = 30;
jordan.worldHeightShowing = 200;

jordan.imageYOffset = 200 + jordan.marginOne;

export const projects = [
  {
    title: "about me",
    imageURL: "/images/animations/graduation.gif",
    URL: "/about-me"
  },
  {
    title: "electrochemistry",
    imageURL: "/images/animations/junction.gif",
    URL: "/electrochemistry"
  },
  {
    title: "inlet",
    imageURL: "/images/animations/inlet.gif",
    URL: "/inlet"
  },
  {
    title: "theoretical chemistry",
    imageURL: "/images/animations/demo.gif",
    URL: "/theoretical-chemistry"
  },
  {
    title: "atoms+bits",
    imageURL: "/images/animations/atomsandbits.gif",
    URL: "https://about.atomsandbits.ai/"
  }
];

const twoPi = 6.2832; // 2 * Math.PI
const piOverFour = 0.7853982; // Math.PI / 4
const piOverFive = 0.62832; // Math.PI / 5
const sevenPiOverFour = 5.497787; // 7 * Math.PI / 4
const ninePiOverFive = 5.6549; // 9 * Math.PI / 5

let rotationListener = null;

export const renderProjects = function({
  history,
  container,
  rotationAmountTransitionable,
  visibleWorldHeightTransitionable
}) {
  const _projects = _.cloneDeep(projects);
  _.each(_projects, function(project, index) {
    if (_projects[index].created == null) {
      _projects[index].created = true;
      _projects[index].enabled = false;
      const projectRenderController = new RenderController({
        inTrasition: {
          curve: "linear",
          duration: 0
        },
        outTransition: {
          curve: "linear",
          duration: 0
        },
        overlap: true
      });
      const pictureSize =
        _projects[index].size != null
          ? _projects[index].size
          : jordan.imageSize;

      const projectContainerModifier = new Modifier({
        size: [undefined, undefined]
      });
      const projectContainerSurface = new ContainerSurface({
        classes: ["life-event-container"]
      });
      projectContainerModifier.sizeFrom(() => jordan.boxSize);

      const imageModifier = new Modifier({
        // align: [0.5, 1]
        origin: [0.5, 1]
      });
      const imageSurface = new Surface({
        size: [180, 120],
        classes: ["image-container"],
        content: `\
<img src='${_projects[index].imageURL}' width='100%' height='100%' style=''>\
`,
        properties: {
          backfaceVisibility: "visible",
          textAlign: "center"
        }
      });

      const rotationXModifier = new Modifier();
      const rotationYModifier = new Modifier();

      const projectContainer = projectContainerSurface;
      projectContainer.add(imageModifier).add(imageSurface);

      //Enable LifeEvent
      _projects[index].enable = function(options) {
        if (!_projects[index].enabled) {
          _projects[index].enabled = true;
          //Start Transform and Show Surface
          this.topThetaValue = index * Math.PI / 2;
          this.currentThetaTransitionable = rotationAmountTransitionable;

          imageModifier.transformFrom(() => {
            const visibleWorldHeight = visibleWorldHeightTransitionable.get();
            if (visibleWorldHeight < 75) {
              imageSurface.setSize([120, 80]);
            } else {
              imageSurface.setSize([180, 120]);
            }
            return Transform.translate(
              0,
              -(visibleWorldHeight + jordan.marginOne),
              0
            );
          });

          rotationXModifier.transformFrom(() => {
            const thetaOffset =
              this.topThetaValue - this.currentThetaTransitionable.get();
            return Transform.rotateZ(thetaOffset);
          });
          rotationYModifier.transformFrom(() => {
            const thetaTransitionable = this.currentThetaTransitionable.get();
            const thetaOffset =
              Math.abs(this.topThetaValue - thetaTransitionable) -
              twoPi * Math.floor(thetaTransitionable / twoPi);
            //logger.log "Index: #{index}, thetaOffset: #{thetaOffset}"
            switch (false) {
              case -piOverFive >= thetaOffset || thetaOffset > 0:
                return Transform.rotateY(-thetaOffset);
              case ninePiOverFive >= thetaOffset || thetaOffset > twoPi:
                return Transform.rotateY(twoPi - thetaOffset);
              case 0 >= thetaOffset || thetaOffset >= piOverFive:
                return Transform.rotateY(thetaOffset);
              default:
                return Transform.rotateY(piOverFive);
            }
          });
          return projectRenderController.show(projectContainerSurface, {
            curve: "linear",
            duration: 0
          });
        }
      };

      _projects[index].enable();
      //Disable LifeEvent
      _projects[index].disable = function() {
        if (_projects[index].enabled) {
          logger.log(`project ${index}: Hiding...`);
          _projects[index].enabled = false;
          //Stop Transforms and Hide Surface
          rotationXModifier.transformFrom();
          rotationYModifier.transformFrom();
          return projectRenderController.hide();
        }
      };
      container
        .add(
          new Modifier({
            align: [0.5, 1]
          })
        )
        .add(rotationYModifier)
        .add(rotationXModifier)
        .add(projectContainerModifier)
        .add(projectRenderController);

      _projects[index].expand = function(callback) {
        jordan.showBackButton();
        _projects[index].expanded = true;
        jordan.disableDragEvents();
        const doExpand = () => {
          __guard__(_projects[index - 1], x => x.disable());
          __guard__(_projects[index + 1], x1 => x1.disable());

          projectContainerSurface.addClass("expanded");

          //Date
          const dateTranslationTransitionable = new Transitionable([
            0,
            jordan.dateYOffset,
            0
          ]);
          const dateOriginTransitionable = new Transitionable([0.5, 1]);

          dateModifier.transformFrom(function() {
            const dateTranslation = dateTranslationTransitionable.get();
            return Transform.translate(
              dateTranslation[0],
              dateTranslation[1],
              dateTranslation[2]
            );
          });
          dateModifier.originFrom(() => dateOriginTransitionable.get());
          dateModifier.alignFrom(() => dateOriginTransitionable.get());

          dateTranslationTransitionable.set(
            [jordan.expandedDateOffsets[0], jordan.expandedDateOffsets[1], 0],
            expandTransition
          );
          dateOriginTransitionable.set([0, 0], expandTransition);

          //Header
          const headerTranslationTransitionable = new Transitionable([
            0,
            jordan.headerYOffset,
            0
          ]);
          const headerOriginTransitionable = new Transitionable([0.5, 1]);
          const headerSizeTransitionable = new Transitionable(
            jordan.headerSize
          );

          headerModifier.transformFrom(function() {
            const headerTranslation = headerTranslationTransitionable.get();
            return Transform.translate(
              headerTranslation[0],
              headerTranslation[1],
              headerTranslation[2]
            );
          });
          headerModifier.originFrom(() => headerOriginTransitionable.get());
          headerModifier.alignFrom(() => headerOriginTransitionable.get());
          headerModifier.sizeFrom(() => headerSizeTransitionable.get());

          headerTranslationTransitionable.set(
            [
              jordan.expandedHeaderOffsets[0],
              jordan.expandedHeaderOffsets[1],
              0
            ],
            expandTransition
          );
          headerOriginTransitionable.set([0, 0], expandTransition);
          headerSizeTransitionable.set(
            [
              jordan.boxSize[0] - jordan.expandedHeaderOffsets[0] - 20,
              jordan.headerSize[1]
            ],
            expandTransition
          );

          //Image
          const imageTranslationTransitionable = new Transitionable([0, 0, 0]);
          const imageOriginTransitionable = new Transitionable([0.5, 1]);

          imageModifier.transformFrom(function() {
            const imageTranslation = imageTranslationTransitionable.get();
            return Transform.translate(
              imageTranslation[0],
              imageTranslation[1],
              0
            );
          });
          imageModifier.originFrom(() => imageOriginTransitionable.get());
          imageModifier.alignFrom(() => imageOriginTransitionable.get());

          imageTranslationTransitionable.set(
            [jordan.expandedImageOffsets[0], jordan.expandedImageOffsets[1], 0],
            expandTransition
          );
          imageOriginTransitionable.set([1, 1], expandTransition);

          //Description
          const descriptionTranslationTransitionable = new Transitionable([
            0,
            jordan.descriptionYOffset,
            0
          ]);
          const descriptionOriginTransitionable = new Transitionable([0.5, 1]);
          const descriptionSizeTransitionable = new Transitionable(
            jordan.descriptionSize
          );

          descriptionModifier.transformFrom(function() {
            const descriptionTranslation = descriptionTranslationTransitionable.get();
            return Transform.translate(
              descriptionTranslation[0],
              descriptionTranslation[1],
              0
            );
          });
          descriptionModifier.originFrom(() =>
            descriptionOriginTransitionable.get()
          );
          descriptionModifier.alignFrom(() =>
            descriptionOriginTransitionable.get()
          );
          descriptionModifier.sizeFrom(() =>
            descriptionSizeTransitionable.get()
          );

          descriptionTranslationTransitionable.set(
            [
              jordan.expandedDescriptionOffsets[0],
              jordan.expandedDescriptionOffsets[1],
              0
            ],
            expandTransition
          );
          descriptionOriginTransitionable.set([0, 0], expandTransition);
          let expandedDescriptionSize =
            jordan.boxSize[0] - 2 * jordan.expandedDescriptionOffsets[0];
          if (jordan.worldHeightShowing === 50) {
            expandedDescriptionSize = expandedDescriptionSize / 2;
          }
          descriptionSizeTransitionable.set(
            [expandedDescriptionSize, jordan.descriptionSize[1]],
            expandTransition
          );

          //Move stars down
          jordan.starsTranslation.set(
            [0, jordan.worldHeightShowing, 0],
            expandTransition
          );

          if (callback != null) {
            return callback();
          }
        };
        if (
          Math.abs(rotationAmountTransitionable.get() - index * Math.PI / 2) >
          Math.PI / 4
        ) {
          rotationAmountTransitionable.halt();
          return rotationAmountTransitionable.set(
            index * Math.PI / 2,
            {
              curve: "inOutCubic",
              duration: 1200
            },
            () => doExpand()
          );
        } else {
          return doExpand();
        }
      };

      _projects[index].close = function(callback) {
        projectContainerSurface.removeClass("expanded");

        //Date
        const dateTranslationTransitionable = new Transitionable([
          jordan.expandedDateOffsets[0],
          jordan.expandedDateOffsets[1],
          0
        ]);
        const dateOriginTransitionable = new Transitionable([0, 0]);

        dateModifier.transformFrom(function() {
          const dateTranslation = dateTranslationTransitionable.get();
          return Transform.translate(
            dateTranslation[0],
            dateTranslation[1],
            dateTranslation[2]
          );
        });
        dateModifier.originFrom(() => dateOriginTransitionable.get());
        dateModifier.alignFrom(() => dateOriginTransitionable.get());

        dateTranslationTransitionable.set(
          [0, jordan.dateYOffset, 0],
          expandTransition
        );
        dateOriginTransitionable.set([0.5, 1], expandTransition);

        //Header
        const headerTranslationTransitionable = new Transitionable([
          jordan.expandedHeaderOffsets[0],
          jordan.expandedHeaderOffsets[1],
          0
        ]);
        const headerOriginTransitionable = new Transitionable([0, 0]);
        const headerSizeTransitionable = new Transitionable([
          jordan.boxSize[0] - jordan.expandedHeaderOffsets[0] - 20,
          jordan.headerSize[1]
        ]);

        headerModifier.transformFrom(function() {
          const headerTranslation = headerTranslationTransitionable.get();
          return Transform.translate(
            headerTranslation[0],
            headerTranslation[1],
            headerTranslation[2]
          );
        });
        headerModifier.originFrom(() => headerOriginTransitionable.get());
        headerModifier.alignFrom(() => headerOriginTransitionable.get());
        headerModifier.sizeFrom(() => headerSizeTransitionable.get());

        headerTranslationTransitionable.set(
          [0, jordan.headerYOffset, 0],
          expandTransition
        );
        headerOriginTransitionable.set([0.5, 1], expandTransition);
        headerSizeTransitionable.set(jordan.headerSize, expandTransition);

        //Image
        const imageTranslationTransitionable = new Transitionable([
          jordan.expandedImageOffsets[0],
          jordan.expandedImageOffsets[1],
          0
        ]);
        const imageOriginTransitionable = new Transitionable([1, 1]);

        imageModifier.transformFrom(function() {
          const imageTranslation = imageTranslationTransitionable.get();
          return Transform.translate(
            imageTranslation[0],
            imageTranslation[1],
            imageTranslation[2]
          );
        });
        imageModifier.originFrom(() => imageOriginTransitionable.get());
        imageModifier.alignFrom(() => imageOriginTransitionable.get());

        imageTranslationTransitionable.set([0, 0, 0], expandTransition);
        imageOriginTransitionable.set([0.5, 1], expandTransition);

        //Description
        const descriptionTranslationTransitionable = new Transitionable([
          jordan.expandedDescriptionOffsets[0],
          jordan.expandedDescriptionOffsets[1],
          0
        ]);
        const descriptionOriginTransitionable = new Transitionable([0, 0]);
        const descriptionSizeTransitionable = new Transitionable([
          jordan.boxSize[0] - 2 * jordan.expandedDescriptionOffsets[0],
          jordan.descriptionSize[1]
        ]);

        descriptionModifier.transformFrom(function() {
          const descriptionTranslation = descriptionTranslationTransitionable.get();
          return Transform.translate(
            descriptionTranslation[0],
            descriptionTranslation[1],
            descriptionTranslation[2]
          );
        });
        descriptionModifier.originFrom(() =>
          descriptionOriginTransitionable.get()
        );
        descriptionModifier.alignFrom(() =>
          descriptionOriginTransitionable.get()
        );
        descriptionModifier.sizeFrom(() => descriptionSizeTransitionable.get());

        descriptionTranslationTransitionable.set(
          [0, jordan.descriptionYOffset, 0],
          expandTransition
        );
        descriptionOriginTransitionable.set([0.5, 1], expandTransition);
        return descriptionSizeTransitionable.set(
          jordan.descriptionSize,
          expandTransition
        );

        /*
				Move Stars/World down for event opening
				jordan.starsTranslation.set [0, -jordan.worldHeightShowing, 0], expandTransition, ->
					_projects[index - 1]?.enable()
					_projects[index + 1]?.enable()
					_projects[index].expanded = false
					jordan.enableDragEvents()
					jordan.hideBackButton()
				*/
      };

      // Events
      return imageSurface.on(
        "click",
        _.throttle(function(event) {
          logger.log(index);
          if (!_projects[index].expanded) {
            /*
					if index == 0
						page("/about")
					else
						page("/project/#{index}")
					*/
            if (_projects[index].URL.split("//")[1]) {
              return window.location.href = _projects[index].URL;
            }
            return history.push(_projects[index].URL);
          }
        }, 1000)
      );
    }
  });
  // Render Events on the Fly
  let lastRotationValue = null;
  let lastClosestProject = null;
  rotationListener = function() {
    const newRotationValue = rotationAmountTransitionable.get();
    if (newRotationValue !== lastRotationValue) {
      let closestProject;
      lastRotationValue = newRotationValue;
      //Find Closest Event
      const smallestCloseProject = Math.floor(
        newRotationValue / eventSeparation
      );
      const smallestCloseProjectTheta = smallestCloseProject * eventSeparation;
      const largestCloseProject = smallestCloseProject + 1;
      const largestCloseProjectTheta =
        smallestCloseProjectTheta + eventSeparation;
      if (
        Math.abs(newRotationValue - smallestCloseProjectTheta) >
        Math.abs(newRotationValue - largestCloseProjectTheta)
      ) {
        closestProject = largestCloseProject;
      } else {
        closestProject = smallestCloseProject;
      }
      // Hide events not +/- 1 from the closest event
      if (lastClosestProject !== closestProject) {
        lastClosestProject = closestProject;
        for (let index = 0; index < _projects.length; index++) {
          const project = _projects[index];
          if (index >= closestProject - 1 && index <= closestProject + 1) {
            if (_projects[index] != null) {
              _projects[index].enable({
                currentThetaTransitionable: rotationAmountTransitionable
              });
            }
          } else {
            if (_projects[index] != null) {
              _projects[index].disable();
            }
          }
        }
        // Set the hashbang to the closest event
        return history.replace(`/#index-${closestProject}`);
      }
    }
  };

  return FamousEngine.on("prerender", rotationListener);
};

export const cleanupProjects = function() {
  logger.log("Projects: Cleaning up...");
  return FamousEngine.removeListener("prerender", rotationListener);
};

jordan.closeEvent = function(callback) {
  jordan.hideBackButton();
  if (jordan.eventExpanded()) {
    const project = _.findWhere(_projects, { expanded: true });
    return project.close(callback);
  } else {
    return callback();
  }
};

jordan.eventExpanded = function() {
  const project = _.findWhere(_projects, { expanded: true });
  if (project != null) {
    return true;
  } else {
    return false;
  }
};
function __guard__(value, transform) {
  return typeof value !== "undefined" && value !== null
    ? transform(value)
    : undefined;
}
